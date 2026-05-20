local EventProxy = {}

function EventProxy.event_throttling(emitter, min_interval_sec)
    if type(emitter) ~= "table" or type(emitter.on) ~= "function" then
        error("EventProxy.event_throttling expects emitter")
    end

    min_interval_sec = min_interval_sec or 1

    if type(min_interval_sec) ~= "number" or min_interval_sec < 0 then
        error("EventProxy.event_throttling expects non-negative interval")
    end

    
    local proxy = {}

    function proxy:on(event_name, handler)
        local last_time = -math.huge
        return emitter:on(event_name, function(...)
            local current = os.clock()
            if current - last_time >= min_interval_sec then
                last_time = current
                return handler(...)
            end
        end)
    end

    function proxy:off(event_name, handler)
        return emitter:off(event_name, handler)
    end

    function proxy:emit(event_name, payload)
        return emitter:emit(event_name, payload)
    end

    return proxy
end

return EventProxy
