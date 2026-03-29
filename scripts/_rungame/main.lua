local Libs = require("scripts.custom_libs.custom_libs")
local Vec2, Collision, Enemy, EnemySpawner = Libs.Vec2, Libs.Collision, Libs.Enemy, Libs.EnemySpawner

local config = Libs.JsonReader.bind("config.json")
window_width = config("window_width", 0)
window_height = config("window_height", 0)

function _init()
    spr = GFX.load("assets/sprites/player/player.png")

    enemy_spr = {
        GFX.load("assets/sprites/enemies/enemy1.png"),
        GFX.load("assets/sprites/enemies/enemy2.png"),
    }

    generator = EnemySpawner.create_generator(window_width, window_height, enemy_spr)
    spawn_state = EnemySpawner.create_state(8, 1)  -- spawn for X seconds, 1 enemy per N seconds
    enemies_counter = 0

    --TODO too loud
    --sound playing example
    --sound = SFX.load("assets/sounds/pipe.mp3");
    --SFX.play(sound);
    
    player_pos = Vec2:new(window_width/2, window_height/2)
    player_width = 64
    player_height = 64
    player_speed = 250.0
    enemies = {}
    score = 0

    player = GFX.spr(spr, player_pos.x, player_pos.y, player_width, player_height)
end

function _update(delta)
    GFX.cls()

    GFX.text("Score: "..score, 10, 30, 2, "default", 0.4)
    player:pos(player_pos.x, player_pos.y)
    player:draw()

    local x, y, sprite = EnemySpawner.spawn_for_duration(generator, spawn_state, delta)
    if x then
        local e = Enemy:new(x, y, sprite)
        e.target = player_pos
        table.insert(enemies, e)
        enemies_counter = enemies_counter + 1
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy.target = player_pos
        enemy:update(delta)
        enemy:draw()

        -- collision with player
        if Collision.rect_collis(player_pos, player_width, player_height, 
        Vec2:new(enemy.x, enemy.y), enemy.width, enemy.height) and
        enemy.state.name ~= "stunned" and enemy.health>=1 then
            print("Hit!")
            score = score + 1
            enemy:set_state(enemy.states.stunned)
            print("State name: " .. enemy.state.name)
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
    dir:normalize()

    player_pos = player_pos + dir * player_speed * delta
end