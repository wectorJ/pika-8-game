local VFDecorators = {}

function VFDecorators.log(fn_stream)
    return function(...)
        local co, unsubscribe = fn_stream(...)
        local iter = function(...)
            local ok, chunk = coroutine.resume(co, ...)
            if not ok then error(chunk) end
            return chunk
        end

        local wrapped = coroutine.create(function()
            while true do
                local chunk = iter()
                if chunk == nil then return end
                print(("[stream] vec=(%s,%s)"):format(
                    tostring(chunk.data.vec.x), tostring(chunk.data.vec.y)
                ))
                coroutine.yield(chunk)
            end
        end)

        return wrapped, unsubscribe
    end
end

function VFDecorators.filter(fn_stream, pr)
    return function(...)
        local co, unsubscribe = fn_stream(...)
        local iter = function(...)
            local ok, chunk = coroutine.resume(co, ...)
            if not ok then error(chunk) end
            return chunk
        end

        local wrapped = coroutine.create(function()
            while true do
                local chunk = iter()
                if chunk == nil then return end
                if pr(chunk) then
                    coroutine.yield(chunk)
                end
            end
        end)

        return wrapped, unsubscribe
    end
end

return VFDecorators