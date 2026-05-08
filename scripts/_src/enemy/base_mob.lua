--BY_AI needs to be reviewed

local BaseMob = {}
BaseMob.__index = BaseMob

--- @param x number starting position X
--- @param y number starting position Y
--- @param sprite number ID of the sprite to draw
--- @param width number width of the sprite
--- @param height number height of the sprite
--- @param speed number movement speed
--- @param health number base health
function BaseMob:new(x, y, sprite, width, height, speed, health)
    local self = setmetatable({}, self)

    self.x = x
    self.y = y

    self.target = nil
    self.protect = nil
    self.aggro_dist = 200

    -- sprite params
    self.width = width or 32
    self.height = height or 32

    self.speed = speed or 70
    self.health = health or 3
    self.alive = true

    self.sprite_obj = GFX.spr(sprite, self.x, self.y, self.width, self.height)

    self.states = {}
    self.fsm = nil

    return self
end

function BaseMob:update(dt)
    if not self.alive then return end

    if self.fsm then
        self.fsm:update(dt)
    end
end

function BaseMob:draw()
    if not self.alive then return end
    if self.sprite_obj then
        self.sprite_obj:pos(self.x, self.y)
        self.sprite_obj:draw()
    end
end

--- for debug
function BaseMob:get_state_name()
    if self.fsm then
        return self.fsm:get_state_name()
    end
    return "None"
end

return BaseMob
