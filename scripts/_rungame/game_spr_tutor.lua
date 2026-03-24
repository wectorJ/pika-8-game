function _init()
    -- Load assets, initialize game state, etc.
    spr = GFX.load("assets/sprites/player/player.png")
    player = GFX.spr(spr, 50, 50, 48, 48)
end

function _update(delta)
    GFX.cls()
    
    GFX.text("ABC", 60, 60, 6, "ascii", 1)
    player:draw()
end


-- 0123456789abcdef
-- **************** 0
-- **************** 1
-- **************** 2
-- **************** 3
-- **************** 4
-- **************** 5
-- **************** 6
-- **************** 7

--  GFX.spr(spr, pos_x, post_y, width, height, {x1, x2, y1, y2})
-- x1 - start of the width cut (ex: 3)
-- x2 - end   of the width cut (ex: b)
-- y1 - start of the height cut (ex: 2)
-- y2 - end   of the height cut (ex: 5)

-- if we apply those
-- * - unused
-- # - displayed

-- 0123456789abcdef
-- **************** 0
-- **************** 1
-- ***#########**** 2
-- ***#########**** 3
-- ***#########**** 4
-- ***#########**** 5
-- **************** 6
-- **************** 7