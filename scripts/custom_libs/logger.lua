--TODO 

local Logger = {}
Logger.__index = Logger

Logger.levels = {
    ERROR = 1,
    INFO = 2,
    DEBUG = 3
}

local function format_message(level, tag, message)
    if tag then
        return "[" .. level .. "][" .. tag .. "] " .. message
    end
    return "[" .. level .. "] " .. message
end

function Logger:new(options)
    options = options or {}

    local self = setmetatable({}, Logger)
    local level = options.level or "INFO"
    self.level = Logger.levels[level]
    self.tag = options.tag

    return self
end

function Logger:log(level, message)
    if Logger.levels[level] and Logger.levels[level] <= self.level then
        print(format_message(level, self.tag, tostring(message)))
    end
end

function Logger:error(message)
    self:log("ERROR", message)
end

function Logger:info(message)
    self:log("INFO", message)
end

function Logger:debug(message)
    self:log("DEBUG", message)
end

function Logger:wrap_handler(context, handler)
    if type(handler) ~= "function" then
        error("Logger.wrap_handler expects handler function")
    end

    local label = context or "handler"
    return function(...)
        local ok, err = pcall(handler, ...)
        if not ok then
            self:error(label .. " error: " .. tostring(err))
        end
    end
end

return Logger
