local server = require('shared.server')
local struct = require('struct')

local data = server.new(struct.struct({
    target_index = {struct.int32},
    target_index_lock = {struct.int32},
}))
