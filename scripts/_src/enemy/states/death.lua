--TODO refactoring

function extend(parent)
    local child = {}
    setmetatable(child,{__index = parent})
    return child
end

local State = require("scripts._src.enemy.states._state")
local Vec2 = require("scripts.custom_libs.vec2")

local DeathState = extend(State)
DeathState.__index = DeathState

function DeathState:new()
    local self = State.new(self, "death")
    setmetatable(self, DeathState)
    return self
end

function DeathState:enter(enemy)
    self.i = 255

    self.push_speed = enemy.speed * 1.5
    self.deceleration = self.push_speed * 1.2
    self.rand_force = math.random(1, 4)

    self.dir = (-Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y):normalize())
end

function DeathState:update(enemy, dt)
    if self.i < 1 then
        enemy.alive = false
        print("[DeathState] enemy is death")
        enemy:set_state(require("scripts._src.enemy.states.idle"):new())
    end
    enemy.sprite_obj:color({self.i, self.i, self.i, self.i})
    self.i = self.i - 1
    enemy.y = enemy.y + enemy.speed * dt * (255-self.i) * 0.3

    enemy.x = enemy.x + self.dir.x * self.push_speed * dt * self.rand_force
    enemy.y = enemy.y + self.dir.y * self.push_speed * dt * self.rand_force
end

function DeathState:exit(enemy)

end

return DeathState