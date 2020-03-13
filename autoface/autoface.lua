-- local shared = require('core.shared')
local command = require('core.command')
local ui = require('core.ui')
local coroutine = require('coroutine')

local shared_target = require('shared_target')
local player_control = require('player_control')

local enabled = false
local window_state = {
    title = 'Auto Face Target',
    style = 'chromeless',
    width = 100,
    height = 30,
    resizable = false,
    color = ui.color.rgb(0,0,0,0)
}
local bit = require('bit')

local function face_target()
    if enabled then
        local target_entity = shared_target.get()

        -- test if target_entity exists and is not a player
        if target_entity and bit.band(target_entity.id, 0xFF000000) ~= 0 then

            -- Now, just turn the player towards the target
            player_control.face_position(target_entity.position.x,
                                         target_entity.position.y)

        end
        coroutine.schedule(face_target, .1)
    end
end

local function handle_command(arg)
    local command = arg:lower()
    if command == 'on' or command == 'enable' then
        enabled = true
        face_target()
    elseif command == 'off' or command == 'disable' then
        enabled = false
    elseif command == 'float' then
        window_state.style = 'layout'
    elseif command == 'anchor' then
        window_state.style = 'chromeless'
    end
end

-- TODO: Add a config option for whether autoface is on or off when the addon loads

local window_closed
ui.display(function()
    window_state, window_closed = ui.window('auto_face_target_window',
                                            window_state, function()
        ui.location(0, 0)
        if ui.button('button1', 'Auto Face ' .. (enabled and 'On' or 'Off'),
                     {checked = enabled}) then
            enabled = not enabled
            face_target()
        end
    end)
end)

local auto_face_target_command = command.new('autoface')
auto_face_target_command:register(handle_command, '<command:string>')
