local server = require('shared.server')
local struct = require('struct')
local event = require('core.event')

local data = server.new(struct.struct({
    target_index = {struct.int32},
    target_index_lock = {struct.int32},
    set = {data = event.new()},
    lock = {data = event.new()},
    unlock = {data = event.new()}
}))

data.set:register(function(target_index)
    data.target_index = target_index
end)

data.lock:register(function(target_index)
    data.target_index_lock = target_index
end)

data.unlock:register(function()
    data.target_index_lock = nil
end)
