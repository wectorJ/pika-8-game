function extend(parent)
    local child = {}
    setmetatable(child,{__index = parent})
    return child
end


local State = require("scripts._src.enemy.states._state")
local Vec2 = require("scripts.custom_libs.vec2")

local StunnedState = extend(State)
StunnedState.__index = StunnedState

-- constructor
function StunnedState:new()
    local self = State.new(self, "stunned")
    setmetatable(self, StunnedState)
    return self
end


function StunnedState:enter(enemy)
    print("[StunnedState] Enemy STUNNED")

    self.stunned_timer = 0
    
    self.push_speed = enemy.speed * 1.5
    self.deceleration = self.push_speed * 1.2
    self.rand_force = math.random(1, 4)

    self.dir = (-Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y):normalize())
end

function StunnedState:update(enemy, dt)
    if self.push_speed > 0 then
        enemy.x = enemy.x + self.dir.x * self.push_speed * dt * self.rand_force
        enemy.y = enemy.y + self.dir.y * self.push_speed * dt * self.rand_force
        
        -- deceleration
        self.push_speed = self.push_speed - self.deceleration * dt
        if self.push_speed < 0 then 
            self.push_speed = 0 
        end
    end

    self.stunned_timer = self.stunned_timer + dt
    if self.stunned_timer > 3 then
        enemy:set_state(require("scripts._src.enemy.states.idle"):new())
    end
end

function StunnedState:exit(enemy)
    -- enemy.speed = enemy.speed / enemy.self.speed_modify
    print("[StunnedState] The enemy woke up")
end

return StunnedState