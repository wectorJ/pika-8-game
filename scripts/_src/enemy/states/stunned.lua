local State = require("scripts._src.enemy.states._state")
local Vec2 = require("scripts.custom_libs.vec2")
local OOP = require("scripts.custom_libs.oop")

local StunnedState = OOP.extend(State)
StunnedState.__index = StunnedState

local PUSH_SPEED_MULT = 1.5
local DECELERATION_MULT = 1.2
local RANDOM_FORCE_MIN = 1
local RANDOM_FORCE_MAX = 4
local DAMAGE_AMOUNT = 1
local DEATH_HEALTH_THRESHOLD = 1
local STUN_DURATION = 3

-- constructor
function StunnedState:new()
    local inst = State:new("stunned")
    setmetatable(inst, self)
    self.__index = self
    return inst
end


function StunnedState:enter(enemy)
    print("[StunnedState] Enemy STUNNED")

    self.stunned_timer = 0
    
    self.push_speed = enemy.speed * PUSH_SPEED_MULT
    self.deceleration = self.push_speed * DECELERATION_MULT
    self.rand_force = math.random(RANDOM_FORCE_MIN, RANDOM_FORCE_MAX)

    self.dir = (-Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y):normalize())

    enemy.health = enemy.health - DAMAGE_AMOUNT
end

function StunnedState:update(enemy, dt)
    if enemy.health < DEATH_HEALTH_THRESHOLD then
        enemy:set_state(enemy.states.death)
    end
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
    
    if self.stunned_timer > STUN_DURATION then
        enemy:set_state(enemy.states.idle)
    end
end

function StunnedState:exit(enemy)
    print("Enemy health: " .. enemy.health)
    print("[StunnedState] The enemy woke up")
end

return StunnedState