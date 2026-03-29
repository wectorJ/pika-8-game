local OOP = {}

function OOP.extend(parent)
    local child = {}
    setmetatable(child,{__index = parent})
    return child
end

return OOP