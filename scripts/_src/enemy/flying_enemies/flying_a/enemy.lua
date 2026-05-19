local FlyingMob = require("scripts._src.enemy.flying_enemies.flying_mob")
local IdleState = require("scripts._src.enemy.flying_enemies.flying_a.states.idle")
local ChaseState = require("scripts._src.enemy.flying_enemies.flying_a.states.chase")
local StunnedState = require("scripts._src.enemy.flying_enemies.flying_a.states.stunned")
local DeathState = require("scripts._src.enemy.flying_enemies.flying_a.states.death")
local PatrolState = require("scripts._src.enemy.flying_enemies.flying_a.states.patrol")
local State = require("scripts._src.ai._state")
local Vec2 = require("scripts.custom_libs.abstract_types.vec2")

local Enemy = setmetatable({}, {__index = FlyingMob})
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
    -- Calls the FlyingMob/BaseMob constructor to initialize standard fields
    local health = 3
    local self = FlyingMob.new(self, x, y, sprite, width, height, speed, health)

    -- Enemy 'flying_a' specific states
    self.states = {
        idle = IdleState:new(),
        chase = ChaseState:new(),
        stunned = StunnedState:new(),
        death = DeathState:new(),
        patrol = PatrolState:new()
    }

    -- Set up State machine
    self.fsm = State.FSM:new(self, self.states.idle)

    return self
end

return Enemy
