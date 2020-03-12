local client = require('shared.client')
local player = require('player')
local entities = require('entities')
local target = require('target')

local data = client.new('shared_target_service')

return {
    get = function()
        if player.target_index ~= data.target_index then
            data.set:trigger(player.target_index)
        end

        local target_entity

        if data.target_index_lock then -- ? should this be > 0?  is nil 0 with structs?
            target_entity = entities[data.target_index_lock]
            if not target_entity then
                data.unlock:trigger()
            end
        end

        if not target_entity and data.target_index then -- ? again, will nil be converted to 0?
            target_entity = entities[data.target_index]
        end

        return target_entity
    end,
    set = function(target_index)
        data.set:trigger(target_index)
        target.set(target_index)
    end,
    lock = function(target_index)
        data.lock:trigger(target_index)
    end,
    unlock = function()
        data.unlock:trigger()
    end
}
