--WITH_AI needs to be reviewed

local BaseMob = require("scripts._src.enemy.base_mob")

local FlyingMob = setmetatable({}, {__index = BaseMob})
FlyingMob.__index = FlyingMob

--- @param x number starting position X
--- @param y number starting position Y
--- @param sprite number ID of the sprite to draw
--- @param width number width of the sprite
--- @param height number height of the sprite
--- @param speed number movement speed
--- @param health number base health
function FlyingMob:new(x, y, sprite, width, height, speed, health)
    local ob = BaseMob.new(self, x, y, sprite, width, height, speed, health)

    -- For example: a flying altitude, obstacle-avoidance flags, etc.
    
    return ob
end

return FlyingMob
