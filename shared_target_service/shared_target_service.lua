local shared = require('core.shared')
local target_index
local target_index_lock_on

shared_target = shared.new('shared_target')

shared.data = {
  target_index = target_index,
  target_index_lock_on = target_index_lock_on
}
shared.env = {
  
}


