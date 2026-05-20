--BY_AI

local EventEmitter = {
    _listeners = {} -- {"event_name": [list of handlers], ...}
}

function EventEmitter.on(event_name, handler)
    if type(event_name) ~= "string" then
        error("EventEmitter.on expects event_name string")
    end
    if type(handler) ~= "function" then
        error("EventEmitter.on expects handler function")
    end

    local list = EventEmitter._listeners[event_name]
    if not list then
        list = {}
        EventEmitter._listeners[event_name] = list
    end

    table.insert(list, handler)

    local removed = false
    return function()
        if removed then
            return
        end
        removed = true
        EventEmitter.off(event_name, handler)
    end
end

function EventEmitter.off(event_name, handler)
    local list = EventEmitter._listeners[event_name]
    if not list then
        return
    end

    for i = #list, 1, -1 do
        if list[i] == handler then
            table.remove(list, i)
            break
        end
    end

    if #list == 0 then
        EventEmitter._listeners[event_name] = nil
    end
end

function EventEmitter.emit(event_name, payload)
    local list = EventEmitter._listeners[event_name]
    if not list then
        return 0
    end

    local snapshot = {}
    for i = 1, #list do
        snapshot[i] = list[i]
    end

    for i = 1, #snapshot do
        local ok, err = pcall(snapshot[i], payload)
        if not ok then
            print("[EventEmitter] handler error: " .. tostring(err))
        end
    end

    return #snapshot
end

return EventEmitter
