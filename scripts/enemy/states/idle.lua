function extend(parent)
    local child = {}
    setmetatable(child,{__index = parent})
    return child
end


local State = require("scripts.enemy.states._state")
local Vec2 = require("scripts.libs.vec2")

local IdleState = extend(State)
IdleState.__index = IdleState

-- constructor
function IdleState:new()
    local self = State.new(self, "idle")
    setmetatable(self, IdleState)
    return self
end


function IdleState:enter(enemy)
    -- print("[IdleState] Enemy entered idle")
    enemy.idle_timer = 0
    enemy.base_y = enemy.y -- base_y and timer are bound to an object
    enemy.base_x = enemy.x
    enemy.rand_direction = math.random() < 0.5 and -1 or 1
    amplitude = 3
end

function IdleState:update(enemy, dt)
    enemy.idle_timer = enemy.idle_timer + dt
    enemy.x = enemy.base_x + math.cos(enemy.idle_timer * 2) * amplitude * enemy.rand_direction
    enemy.y = enemy.base_y + math.sin(enemy.idle_timer * 4) * amplitude

    if enemy.target then
        local dir = Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y)
        if dir:length() < 200 then
            enemy:set_state(require("scripts.enemy.states.chase"):new())
        end
    end
    -- Здесь позже можно добавить:
    --   таймер перехода в patrol
    --   проверку "вижу ли игрока" → переход в chase
end

function IdleState:exit(enemy)
    -- enemy.y = enemy.base_y
    -- enemy.x = enemy.base_x
    print("[IdleState] Enemy left idle")
end

return IdleState
