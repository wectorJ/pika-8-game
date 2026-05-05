local Vec2 = require("scripts.custom_libs.abstract_types.vec2")

local Script = {}

function Script:_init(node)
    self.owner = node
    self.width = 64
    self.height = 64
    self.speed = 250.0

    self.pos = Vec2:new(window_width/2, window_height/2)

    self.texture_res = GFX.load("assets/sprites/player/player.png")
    self.sprite_node = nil
end

function Script:_update(delta)
    if not self.sprite_node then
        if self.texture_res.ready then
            self.sprite_node = NodeFactory.create("sprite", "", self.texture_res.id, 0, 0, self.width, self.height)
            self.owner:add_child(self.sprite_node)
        end
        return
    end

    local dir = Vec2.ZERO:copy()
    if Input.btnp(79) or Input.btnp(7) then
        dir = dir + Vec2.RIGHT
    end
    if Input.btnp(80) or Input.btnp(4) then
        dir = dir + Vec2.LEFT
    end
    if Input.btnp(81) or Input.btnp(22) then
        dir = dir + Vec2.DOWN
    end
    if Input.btnp(82) or Input.btnp(26) then
        dir = dir + Vec2.UP
    end
    dir:normalize()
    
    self.pos = self.pos + dir * self.speed * delta
end

return Script