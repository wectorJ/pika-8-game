local State = require("scripts._src.enemy.states._state")
local Vec2 = require("scripts.custom_libs.vec2")
local OOP = require("scripts.custom_libs.oop")

local IdleState = OOP.extend(State)
IdleState.__index = IdleState

local SWAY_AMPLITUDE = 3
local DIRECTION_CHANCE_THRESHOLD = 0.5
local WAVE_FREQ_X = 2
local WAVE_FREQ_Y = 4
local AGGRO_DISTANCE = 200

-- constructor
function IdleState:new()
    local inst = State:new("idle")
    setmetatable(inst, self)
    self.__index = self
    return inst
end


function IdleState:enter(enemy)
    -- print("[IdleState] Enemy entered idle")
    enemy.idle_timer = 0
    enemy.base_y = enemy.y -- base_y and timer are bound to an object
    enemy.base_x = enemy.x
    enemy.rand_direction = math.random() < DIRECTION_CHANCE_THRESHOLD and -1 or 1
    self.amplitude = SWAY_AMPLITUDE
end

function IdleState:update(enemy, dt)
    enemy.idle_timer = enemy.idle_timer + dt
    enemy.x = enemy.base_x + math.cos(enemy.idle_timer * WAVE_FREQ_X) * self.amplitude * enemy.rand_direction
    enemy.y = enemy.base_y + math.sin(enemy.idle_timer * WAVE_FREQ_Y) * self.amplitude

    if enemy.target then
        local dir = Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y)
        if dir:length() < AGGRO_DISTANCE then
            enemy:set_state(enemy.states.chase)
        end
    end

    if enemy.idle_timer > 2 then enemy:set_state(enemy.states.patrol) end
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
