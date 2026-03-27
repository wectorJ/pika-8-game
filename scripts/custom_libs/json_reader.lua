local json = require("lua_modules.json")
local Reader = {}

local function read(_path)
    local file = io.open(_path, "r")
    if not file then return nil end

    local res = file:read("*a")
    file:close()
    return res
end

--- Bind to JSON
---@param path string string path
function Reader.bind(path)
    if not path then error("Reader.bind error: missing argument") end
    
    ---Search
    ---@param field string string field
    ---@param default any default value, if field not found
    ---@return any
    local function get_field(field, default)
        local content = read(path)
        if content then
            local data = json.decode(content)
            if data and data[field] ~= nil then
                return data[field]
            end
            return default
        else return default end
    end

    return get_field
end

return Reader