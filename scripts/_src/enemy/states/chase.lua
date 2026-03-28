local State = require("scripts._src.enemy.states._state")
local Collision = require("scripts.custom_libs.collisions")
local Vec2 = require("scripts.custom_libs.vec2")

function extend(parent)
    local child = {}
    setmetatable(child,{__index = parent})
    return child
end

local ChaseState = extend(State)
ChaseState.__index = ChaseState



function ChaseState:new()
    local self = State.new(self, "chase")
    setmetatable(self, ChaseState)
    return self
end

--- calling once when enemy enters this state
function ChaseState:enter(enemy)
    print("[ChaseState] Enemy entered chase")
end

--- calling every frame
function ChaseState:update(enemy, dt)
    local dir = Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y)
    length = dir:length()

    if length > 0 and length < 300 then
        dir:normalize()
        enemy.x = enemy.x + dir.x * enemy.speed * dt
        enemy.y = enemy.y + dir.y * enemy.speed * dt
    -- else
    --     enemy:set_state(require("scripts._src.enemy.states.idle"):new())
    end
end

--- calling once when enemy enters this state
function ChaseState:exit(enemy)
    print("[ChaseState] Enemy left chase")
end

return ChaseState