local shared = require('core.shared')
local target_index
local target_index_lock_on
local player = require('player')
local entities = require('entities')
local target = require('target')

shared_target = shared.new('shared_target')

shared.data = {
    target_index = target_index,
    target_index_lock_on = target_index_lock_on,
    get = function(self)
        print(self.target_index)
        if player.target_index ~= self.target_index then
            self.target_index = player.target_index
        end

        local target

        if self.target_index_lock_on then
            target = entities[self.target_index_lock_on]
            if not target then
                self.target_index_lock_on = nil
            end
        end

        if not target and self.target_index then
            target = entities[self.target_index]
        end

        return target
    end,
    set = function(self, entity_index)
        self.target_index = entity_index
        target.set(entity_index)
    end,
    lock_on = function(self, entity_index)
        self.target_index_lock_on = entity_index
    end,
    unlock = function(self)
        self.target_index_lock_on = nil
    end
}
shared.env = {}

