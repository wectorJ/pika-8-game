local IdleState = require("scripts._src.enemy.states.idle")
local ChaseState = require("scripts._src.enemy.states.chase")
local StunnedState = require("scripts._src.enemy.states.stunned")
local DeathState = require("scripts._src.enemy.states.death")
local PatrolState = require("scripts._src.enemy.states.patrol")
local Vec2 = require("scripts.custom_libs.vec2")

-- Class Enemy
local Enemy = {}
Enemy.__index = Enemy

--- Class constructor
--- @param x number starting position X
--- @param y number starting position Y
--- @param sprite number ID of the sprite to draw
--- @param width number width of the sprite (default 32)
--- @param height number height of the sprite (default 32)
--- @param speed number movement speed (default 50)
--- @return table new Enemy object
function Enemy:new(x, y, sprite, width, height, speed)
    local self = setmetatable({}, Enemy)

    self.x = x
    self.y = y

    self.target = nil
    self.protect = nil

    -- sprite params
    self.width = width or 32
    self.height = height or 32

    self.speed = speed or 70
    self.sprite_obj = GFX.spr(sprite, self.x, self.y, self.width, self.height)
    self.alive = true
    self.health = 2

    self.states = {
        idle = IdleState:new(),
        chase = ChaseState:new(),
        stunned = StunnedState:new(),
        death = DeathState:new(),
        patrol = PatrolState:new()
    }

    -- State machine
    self.state = self.states.idle         -- current state (State object)
    self:set_state(self.state)

    return self
end

--- switch state
function Enemy:set_state(new_state)
    if self.state then
        self.state:exit(self)
    end

    self.state = new_state

    self.state:enter(self)
end

function Enemy:update(dt)
    if not self.alive then return end

    self.state:update(self, dt)
end

--- draw enemy
function Enemy:draw()
    if not self.alive then return end
    self.sprite_obj:pos(self.x, self.y)
    self.sprite_obj:draw()
end

--- for debug
function Enemy:get_state_name()
    if self.state then
        return self.state.name
    end
    return "none"
end

return Enemy
