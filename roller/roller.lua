local queue = require('queue')
local table = require('table')
local ui = require('ui')
local action = require('action')

local mode = require('mode')

local defaults = {
    roll1 = 'Chaos Roll',
    roll2 = 'Samurai Roll',
    ui_x = 1200,
    ui_y = 800
}

local settings = defaults -- TODO: load these from config file

local roll_names = {
    'Warlock\'s Roll', 'Fighter\'s Roll', 'Monk\'s Roll', 'Healer\'s Roll',
    'Wizard\'s Roll', 'Rogue\'s Roll', 'Gallant\'s Roll', 'Chaos Roll',
    'Beast Roll', 'Choral Roll', 'Hunter\'s Roll', 'Samurai Roll', 'Ninja Roll',
    'Drachen Roll', 'Magus\'s Roll', 'Corsair\'s Roll', 'Puppet Roll',
    'Dancer\'s Roll', 'Scholar\'s Roll', 'Bolter\'s Roll', 'Courser\'s Roll',
    'Blitzer\'s Roll', 'Tactician\'s Roll', 'Allies\' Roll', 'Miser\'s Roll',
    'Companion\'s Roll', 'Avenger\'s Roll', 'Naturalist\'s Roll',
    'Runeist\'s Roll'
}

local rolls = {
    mode({['description'] = 'Roll 1', unpack(roll_names)}),
    mode({['description'] = 'Roll 2', unpack(roll_names)})
}

rolls[1]:set(settings.roll1)
rolls[2]:set(settings.roll2)

local current_roll = ''
local ignore_ids = table({177, 178, 96, 133})


action.post_action:register(function(packet)
  if packet.category == 6 then
    if table.with(actions, 'param', packet.param) then

    end
  end
end)

