local shared = require('core.shared')
local entities = require('entities')
local player = require('player')
local target = require('target')

local target_index
local target_index_lock_on

local shared_target = shared.new('shared_target', {
    get = function()
        if player.target_index ~= target_index then
            target_index = player.target_index
        end

        local target

        if target_index_lock_on then
            target = entities[target_index_lock_on]
            if not target then target_index_lock_on = nil end
        end

        if not target and target_index then
            target = entities[target_index]
        end

        return target
    end,
    set = function(entity_index)
        target_index = entity_index
        target.set(entity_index)
    end,
    lock_on = function(entity_index) target_index_lock_on = entity_index end,
    unlock = function() target_index_lock_on = nil end
})
