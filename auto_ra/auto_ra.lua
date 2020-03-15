-- local queue = require('queue')
local mode = require('mode')
local equipment = require('equipment')
local player = require('player')
local action = require('action')
local shared_target = require('shared_target')
local packets = require('packets')
local command = require('command')
local statics = require('statics') -- ? ./statics
local res = require('resources')
local buffs = require('status_effects')
local ui = require('ui')

local settings = {enabled = false, stop_on_tp = false}

local get_usable_weaponskills
do
    local weaponskills = require('weaponskills') -- ? should it be ./weaponskills

    get_usable_weaponskills = function(skill, main, sub)
        return weaponskills[skill]:filter(
                   function(el)
                return el.jobs:contains(main) and
                           (not el.requirements or
                               el.requirements:contains(main) or
                               el.requirements:contains(sub))
            end):keys()
    end
end

local function ranged_skill()
    return 'marksmanship' -- TODO: actually get the type
end

-- TODO: Make a favorites table, so I can have a dropdown with only the skills I actually use

local weapon_skill = mode({
    ['description'] = 'Weapon Skill',
    unpack(get_usable_weaponskills(ranged_skill(), player.main_job,
                                   player.sub_job)),
    'None'
})

-- TODO: set this to client language
local language = 'english'

-- returns a function that will attempt to do action when executed
local function do_action_factory(action)
    local category_name = statics.action_category[action.category]
    local action_info = res[category_name][action.param]

    return function()
        if action.category == 3 then
            command.input('/range ' .. action.target_id)
        else
            command.input(action_info.prefix .. ' ' .. action_info[language] ..
                              ' ' .. action.target_id)
        end
    end
end

local current_action = nil
local next_action = nil

do
    local ra_engaged = false
    local post_action
    local timeout

    local function action_eq_action(action1, action2)
        return action1.target_id == action2.target_id and action1.category ==
                   action2.category and action1.id == action2.id
    end

    local function action_eq_packet(action, packet)
        return player.id == packet.actor_id and action.target_id ==
                   packet.targets[1].id and
                   statics.action_category[action.category] ==
                   statics.packet_category[packet.category] and action.id ==
                   packet.param
    end

    local function stop_shooting()
        ra_engaged = false
        next_action = nil
        current_action = nil
        shared_target.unlock()
        coroutine.close(timeout) -- ? can we close this if it's not open?
    end

    local function apply_aftermath()
        if settings.use_AM then

            local am_table = statics.aftermath_weaponskills[equipment.range]

            if not am_table then
                return
            end

            if buffs.player[am_table.buff] then
                return
            end

            if player.tp >= am_table.tp then
                return {
                    target_id = shared_target.get().id,
                    category = 2,
                    id = res.weapon_skill[am_table.ws].id
                }
            else
                return nil, true
            end
        end
    end

    local function do_next_action()
        if next_action then
            current_action = next_action
            next_action = nil
        elseif player.tp >= 1000 then
            -- We need to populate current_action with the next action we want to do

            if settings.stop_on_tp then
                return stop_shooting()
            end

            local current_action, build_tp = apply_aftermath()
            if current_action then

            elseif not build_tp and weapon_skill.value ~= 'None' then
                -- WS
                current_action = {
                    target_id = shared_target.get().id,
                    category = 2,
                    id = res.weapon_skill[weapon_skill.value].id
                }
            else
                -- RA
                current_action = {
                    target_id = shared_target.get().id,
                    category = 3
                }
            end

            -- We want to retry our action if it gets filtered ( say we're out of range or something )
            timeout = coroutine.schedule(do_action_factory(current_action), 2)
        end

        coroutine.schedule(do_action_factory(current_action), 1) -- TODO: Figure out the right value
        -- The value may depend on what action just completed
    end

    local function filter_action(action)
        if next_action or current_action then
            if not action_eq_action(action, current_action) then
                next_action = action
                action.blocked = true
                return
            end
        end
    end

    local function pre_action(action)
        -- If we're doing an RA, we want to start doing autoRAs
        if settings.enabled and action.category ==
            statics.action_categories.ranged_attack then
            ra_engaged = true
            shared_target.lock(action.target_id)
        end
        coroutine.close(timeout) -- ? again, do we need to do a check before this?
        timeout = coroutine.schedule(do_action_factory(action), 1)
    end

    -- ? this function also gets called on spell interruption, maybe detect it
    local function ready_action(packet)
        -- If an action that we sent readies, cancel the retry timer
        local packet_category = packet.category
        if packet_category == 6 or packet_category == 7 or packet_category == 8 or
            packet_category == 9 or packet_category == 12 then
            if action_eq_packet(current_action, packet) then
                coroutine.close(timeout)
                timeout = coroutine.schedule(
                              function()
                        post_action(current_action)
                    end, 3)
            end
        end
    end

    -- TODO: still need to look at packets to see if we readied a skill

    post_action = function(action)
        -- if there's an action queued, we want to do it now (or on some delay)
        -- if there isn't, and we're ra_engaged, we want to weaponskill or shoot

        -- Also, check if our target is valid maybe
        coroutine.close(timeout)
        if ra_engaged then
            do_next_action()
        end
    end

    local function check_target_alive(packet)
        if packet.status == 3 then
            local target = shared_target.get()
            if target and target.index == packet.index then
                stop_shooting()
            end
        end
    end

    action.filter_action:register(filter_action)
    action.pre_action:register(pre_action)
    packets.incoming[0x028]:register(ready_action) -- Incoming action packet
    action.post_action:register(post_action)

    packets.incoming[0x00E]:register(check_target_alive) -- Enemy update packet


    local window_state = {
        title = 'AutoRA',
        style = 'chromeless',
        width = 100,
        height = 100,
        resizable = false,
        color = ui.color.rgb(0, 0, 0, 0)
    }
    ui.display(function()
        window_state = ui.window('AutoRA', window_state,
                                                function()
            ui.location(0, 0)
            if ui.button('button1',
                         'AutoRA ' .. (settings.enabled and 'On' or 'Off'),
                         {checked = settings.enabled}) then
                if settings.enabled then
                    stop_shooting()
                end
                settings.enabled = not settings.enabled
            end
        end)
    end)

    do
        local function handle_command(command)
            local cmd = command:lower()
            if cmd == 'on' or cmd == 'enable' then
                settings.enabled = true
            elseif cmd == 'off' or cmd == 'disable' then
                stop_shooting()
                settings.enabled = false
            end
        end
    
        local auto_ra = command.new('autora')
        auto_ra:register(handle_command, '<command:string>')
    end

end


