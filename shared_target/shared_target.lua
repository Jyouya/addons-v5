local client = require('shared.client')
-- local player = require('player')
local entities = require('entities')
local target = require('target')

local data = client.new('shared_target_service')

return {
    get = function()
        if target.t and target.t.index ~= data.target_index then
            data.target_index = target.t.index
        elseif data.target_index > 0 then
            data.target_index = 0
        end

        local target_entity

        if data.target_index_lock > 0 then
            target_entity = entities[data.target_index_lock]
            if not target_entity then data.target_index_lock = 0 end
        end

        if not target_entity and data.target_index > 0 then
            target_entity = entities[data.target_index]
        end

        return target_entity
    end,
    set = function(target_index)
        data.target_index = target_index
        target.set(target_index)
    end,
    lock = function(target_index) data.target_index_lock = target_index end,
    unlock = function() data.target_index_lock = 0 end
}
