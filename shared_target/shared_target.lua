local player = require('player')
local entities = require('entities')
local shared = require('core.shared')
local target = require('target')

local client = shared.get('shared_target')

return {
    get = function()
        return client:call(function(data)
            if player.target_index ~= data.target_index then
                data.target_index = player.target_index
            end

            local target

            if data.target_index_lock_on then
                target = entities[data.target_index_lock_on]
                if not target then
                    data.target_index_lock_on = nil
                end
            end

            if not target and data.target_index then
                target = entities[data.target_index]
            end

            return target
        end)
    end,
    set = function(entity_index)
        return client:call(function(data)
            data.target_index = entity_index
            target.set(entity_index)
        end)
    end,
    lock_on = function(entity_index)
        return client:call(function(data)
            data.target_index_lock_on = entity_index
        end)
    end,
    unlock = function()
        return client:call(function(data)
            data.target_index_lock_on = nil
        end)
    end
}
