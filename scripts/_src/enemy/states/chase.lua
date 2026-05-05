local State = require("scripts._src.enemy.states._state")
local Collision = require("scripts.custom_libs.collisions")
local Vec2 = require("scripts.custom_libs.abstract_types.vec2")
local OOP = require("scripts.custom_libs.oop")

local ChaseState = OOP.extend(State)
ChaseState.__index = ChaseState

local MAX_CHASE_DISTANCE = 300
local ROTATION_OFFSET = 90

function ChaseState:new()
    local inst = State:new("chase")
    setmetatable(inst, self)
    self.__index = self
    return inst
end


--- calling once when enemy enters this state
function ChaseState:enter(enemy)
    print("[ChaseState] Enemy entered chase")
end

--- calling every frame
function ChaseState:update(enemy, dt)
    local dir = Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y)
    local angle = dir:angle()
    local length = dir:length()

    if length > 0 and length < MAX_CHASE_DISTANCE then
        dir:normalize()
        enemy.sprite_obj:rotation(math.deg(angle) + ROTATION_OFFSET)
        enemy.x = enemy.x + dir.x * enemy.speed * dt
        enemy.y = enemy.y + dir.y * enemy.speed * dt
    else
        enemy.fsm:set_state(enemy.states.idle)
    end
end

--- calling once when enemy enters this state
function ChaseState:exit(enemy)
    print("[ChaseState] Enemy left chase")
end

return ChaseState