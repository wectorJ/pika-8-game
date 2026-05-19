--BY_AI

local EventBus = {
    _listeners = {}
}

function EventBus.on(event_name, handler)
    if type(event_name) ~= "string" then
        error("EventBus.on expects event_name string")
    end
    if type(handler) ~= "function" then
        error("EventBus.on expects handler function")
    end

    local list = EventBus._listeners[event_name]
    if not list then
        list = {}
        EventBus._listeners[event_name] = list
    end

    table.insert(list, handler)

    local removed = false
    return function()
        if removed then
            return
        end
        removed = true
        EventBus.off(event_name, handler)
    end
end

function EventBus.off(event_name, handler)
    local list = EventBus._listeners[event_name]
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
        EventBus._listeners[event_name] = nil
    end
end

function EventBus.emit(event_name, payload)
    local list = EventBus._listeners[event_name]
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
            print("[EventBus] handler error: " .. tostring(err))
        end
    end

    return #snapshot
end

return EventBus
