local Vec2 = require("scripts.libs.vec2")

Collision = {}

--- Check collision between two rectangles
---@param pos1 Vec2 - position of the first rectangle (top-left corner)
---@param w1 number - width of the first rectangle
---@param h1 number - height of the first rectangle
---@param pos2 Vec2 - position of the second rectangle (top-left corner)
---@param w2 number - width of the second rectangle
---@param h2 number - height of the second rectangle
---@return boolean - true if the rectangles collide, false otherwise
function Collision.rect_collis(pos1, w1, h1, pos2, w2, h2)
    if getmetatable(pos1) ~= Vec2 or getmetatable(pos2) ~= Vec2 then
        error("Attempt to check collision with non-Vec2 position")
    end
    if type(w1) ~= "number" or type(h1) ~= "number" or type(w2) ~= "number" or type(h2) ~= "number" then
        error("Attempt to check collision with non-number width/height")
    end
    return pos1.x < pos2.x + w2 and pos1.x + w1 > pos2.x
        and pos1.y < pos2.y + h2 and pos1.y + h1 > pos2.y
end

return Collision