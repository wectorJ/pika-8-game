local Enemy = require("scripts.enemy.enemy")
local EnemySpawner = require("scripts.enemy.enemy_spawner")
local Vec2 = require("scripts.libs.vec2")

function _init()
    spr = GFX.load("assets/sprites/player/player.png")

    enemy_spr = {
        GFX.load("assets/sprites/enemies/enemy1.png"),
        GFX.load("assets/sprites/enemies/enemy2.png"),
    }

    generator = EnemySpawner.create_generator(512, 512, enemy_spr)
    spawn_state = EnemySpawner.create_state(8, 1)  -- spawn for X seconds, 1 enemy per N seconds
    enemies_counter = 0

    --TODO too loud
    --sound playing example
    --sound = SFX.load("assets/sounds/pipe.mp3");
    --SFX.play(sound);
    
    player_pos = Vec2:new(64, 64)
    player_speed = 250.0
    enemies = {}
    score = 0

    player = GFX.spr(spr, player_pos.x, player_pos.y, 64,64)
end

function _update(delta)
    GFX.cls()

    GFX.text("Score: "..score, 10, 30, 2, "default", 0.4)
    player:pos(player_pos.x, player_pos.y)
    player:draw()

    local x, y, sprite = EnemySpawner.spawn_for_duration(generator, spawn_state, delta)
    if x then
        local e = Enemy:new(x, y, sprite)
        table.insert(enemies, e)
        enemies_counter = enemies_counter + 1
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:update(delta)
        enemy:draw()

        --TODO change death condition
        if enemy.y > 512 then
            enemy.alive = false
        end

        -- collision whith player
        if player_pos.x < enemy.x + enemy.width and player_pos.x + 64 > enemy.x
            and player_pos.y < enemy.y + enemy.height and player_pos.y + 64 > enemy.y then
            print("Hit!")
            score = score + 1
            enemy.alive = false
        end

        if not enemy.alive then
            table.remove(enemies, i)
        end
    end

    if #enemies > 0 then
        GFX.text("enemies: " .. #enemies, 10, 10, 2, "default", 0.4)
    else 
        GFX.text("enemies: 0", 10, 10, 2, "default", 0.4)
    end
    GFX.text("enemies spawned: "..enemies_counter, 10, 50, 2, "default", 0.4)



    -- player movement
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
    dir = dir:normalize()

    player_pos = player_pos + dir * player_speed * delta
end