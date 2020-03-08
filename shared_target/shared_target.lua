local shared = require('core.shared')

local client = shared.get('shared_target_service', 'shared_target')

return setmetatable({}, {
    __index = function(_, k)
        return function(...)
            local data = setmetatable({}, {
                __index = function(_, i)
                    return client:read(i)
                end
            })

            return client:read(k)(data, ...)
        end
    end
})
