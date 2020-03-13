local target = require('target')
local coroutine = require('coroutine')
local event = require('core.event')
local math = require('math')

local distance_tolerance_squared = .2

local messaging = event.new()

local function face(x, y)
    local heading = math.atan2(y - target.me.position.y,
                               x - target.me.position.x)
    target.me.display.heading = - heading
end

local function move_to_factory(x, y, timeout)
    local callback
    local message
    local message_handler = function(msg) message = msg end
    messaging:register(message_handler)
    callback = function()
        local distance_squared = x ^ 2 + y ^ 2

        timeout = timeout - .1
        if distance_squared > distance_tolerance_squared and timeout and message ~=
            'stop' then
            face(x, y)
            target.me.display.moving = true

            coroutine.schedule(callback, .1)
        else
            target.me.display.moving = false
            messaging:unregister(message_handler)
        end
    end
end

return {
    turn = function(heading) target.me.display.heading = heading end,

    move = function(direction)
        if direction then target.me.display.heading = direction end
        target.me.display.moving = true
    end,

    move_to = function(x, y)
        local distance = math.sqrt(x ^ 2 + y ^ 2)

        -- Stop any move_to commands in progress
        messaging:trigger('stop')

        -- Allow one second per yalm
        move_to_factory(x, y, math.max(distance, 1))()
    end,

    stop = function()
        target.me.display.moving = false
        messaging:trigger('stop')
    end,

    face_position = face,

    set_distance_tolerance = function(distance)
        distance_tolerance_squared = distance ^ 2
    end
}
