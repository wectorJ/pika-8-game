local State = require("scripts._src.enemy.states._state")
local Collision = require("scripts.custom_libs.collisions")
local Vec2 = require("scripts.custom_libs.vec2")
local OOP = require("scripts.custom_libs.oop")

local PatrolState = OOP.extend(State)
PatrolState.__index = PatrolState

function PatrolState:new()
    local inst = State:new("patrol")
    setmetatable(inst, self)
    self.__index = self
    return inst
end


--- calling once when enemy enters this state
function PatrolState:enter(enemy)
    print("[PatrolState] Enemy entered patrol")
end

local function within(enemy, target, dist)
    local enemy_pos = Vec2:new(enemy.x, enemy.y)
    local target_pos = Vec2:new(target.x, target.y)
    if enemy_pos:distance(target_pos) <= dist then return true end
    return false
end

--- calling every frame
function PatrolState:update(enemy, dt)
    if enemy.protect then
        if within(enemy, enemy.protect, 100) then enemy:set_state(enemy.states.idle) end
        local dir = Vec2:new(enemy.protect.x - enemy.x, enemy.protect.y - enemy.y)
        dir:normalize()
        enemy.x = enemy.x + dir.x * enemy.speed * dt
        enemy.y = enemy.y + dir.y * enemy.speed * dt
    end
end

--- calling once when enemy enters this state
function PatrolState:exit(enemy)
    print("[PatrolState] Enemy left patrol")
end





local function go_to(enemy, target)
    local dir = Vec2:new(target.x - enemy.x, target.y - enemy.y)

end


return PatrolState