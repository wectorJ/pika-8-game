local State = require("scripts._src.enemy.states._state")
local Vec2 = require("scripts.custom_libs.vec2")
local OOP = require("scripts.custom_libs.oop")

local DeathState = OOP.extend(State)
DeathState.__index = DeathState

local STARTING_ALPHA = 255
local FADE_OUT_SPEED = 140
local PUSH_SPEED_MULT = 1.5
local DECELERATION_MULT = 1.2
local RANDOM_FORCE_MIN = 1
local RANDOM_FORCE_MAX = 4

function DeathState:new()
    local inst = State:new("death")
    setmetatable(inst, self)
    self.__index = self
    return inst
end

function DeathState:enter(enemy)
    self.i = STARTING_ALPHA
    self.fade_speed = FADE_OUT_SPEED

    self.push_speed = enemy.speed * PUSH_SPEED_MULT
    self.deceleration = self.push_speed * DECELERATION_MULT
    self.rand_force = math.random(RANDOM_FORCE_MIN, RANDOM_FORCE_MAX)

    self.dir = (-Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y):normalize())
end

function DeathState:update(enemy, dt)
    if self.i < 1 then
        enemy.alive = false
        print("[DeathState] enemy is death")
    end
    enemy.sprite_obj:color({self.i, self.i, self.i, self.i})
    self.i = self.i - dt * self.fade_speed

    enemy.y = enemy.y + enemy.speed * dt * (STARTING_ALPHA-self.i) * 0.3

    enemy.x = enemy.x + self.dir.x * self.push_speed * dt * self.rand_force
    enemy.y = enemy.y + self.dir.y * self.push_speed * dt * self.rand_force
end

function DeathState:exit(enemy)

end

return DeathState