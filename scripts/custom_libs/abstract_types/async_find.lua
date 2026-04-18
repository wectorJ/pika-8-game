local function async_find(deque, predicate, callback, max_itrs_in_stp)
    max_itrs_in_stp = max_itrs_in_stp or 50
    local aborted = false

    local co = coroutine.create(function()
        local index = 1
        local current = deque.head
        local iterations = 0

        while current do
            if aborted then
                if callback then callback(nil, nil, nil, "AbortError") end
                return nil, nil
            end

            local success, result_or_err = pcall(predicate, current.value)
            
            if not success then
                if callback then callback(nil, nil, nil, result_or_err) end
                return nil, nil
            end

            if result_or_err then
                if callback then callback(current.value, current, index, nil) end
                return index, current.value
            end

            index = index + 1
            current = current.next
            iterations = iterations + 1

            if iterations >= max_itrs_in_stp then
                iterations = 0
                coroutine.yield()
            end
        end

        if callback then callback(nil, nil, nil, nil) end
        return nil, nil
    end)

    local controller = {
        abort = function()
            aborted = true
        end,
        is_aborted = function()
            return aborted
        end
    }

    return co, controller
end

deq = require("scripts.custom_libs.abstract_types.deque").new()

deq:push_back(1)
deq:push_back(2)
deq:push_back(3)
deq:push_back(4)

local collback = function(value, node, index, err)
    if err then
        print("Error: "..err)
        return
    end
    if value then
        print("Found value: "..value)
    else
        print("Value not found")
    end
end

local find_co, controller = async_find(deq, function(x) return x == 3 end, collback, 1)
local steps = 1
while coroutine.status(find_co) ~= "dead" do
    if steps == 2 then
        controller.abort()
    end
    print("Step: "..steps)
    coroutine.resume(find_co)
    steps = steps + 1
end