--TODO refactoring after Copilot changes (if enemy.protect then ... end)

local State = require("scripts._src.enemy.states._state")
local Collision = require("scripts.custom_libs.collisions")
local Vec2 = require("scripts.custom_libs.abstract_types.vec2")
local OOP = require("scripts.custom_libs.oop")

local PatrolState = OOP.extend(State)
PatrolState.__index = PatrolState


function PatrolState:new()
    local inst = State:new("patrol")
    setmetatable(inst, self)
    self.__index = self
    return inst
end

local TARGET_RADIUS = 100
local CORRECTION_FACTOR = 2.0 -- how fast the enemy corrects its position

--- calling once when enemy enters this state
function PatrolState:enter(enemy)
    print("[PatrolState] Enemy entered patrol")
end

--- calling every frame
function PatrolState:update(enemy, dt)
    if enemy.target then
        local dir = Vec2:new(enemy.target.x - enemy.x, enemy.target.y - enemy.y)
        if dir:length() < enemy.aggro_dist then
            enemy:set_state(enemy.states.chase)
        end
    end

    if enemy.protect then
        local move_x, move_y = 0, 0
        
        local to_target = Vec2:new(enemy.protect.x - enemy.x, enemy.protect.y - enemy.y)
        local dist = to_target:length()

        if dist == 0 then
            move_x = enemy.speed
        else
            -- outer radius
            if dist > TARGET_RADIUS then
                to_target:normalize()
                move_x = to_target.x * enemy.speed
                move_y = to_target.y * enemy.speed
            else
                local radius_dir = Vec2:new(-to_target.x, -to_target.y)
                radius_dir:normalize()
                
                local tangent_dir = Vec2:new(-radius_dir.y, radius_dir.x) 
                
                -- inner radius
                if dist < TARGET_RADIUS then 
                    local correction_speed = (TARGET_RADIUS - dist) * CORRECTION_FACTOR
                    move_x = tangent_dir.x * enemy.speed + radius_dir.x * correction_speed
                    move_y = tangent_dir.y * enemy.speed + radius_dir.y * correction_speed
                -- orbit 
                else 
                    move_x = tangent_dir.x * enemy.speed
                    move_y = tangent_dir.y * enemy.speed
                end
            end
        end
            
        enemy.x = enemy.x + move_x * dt
        enemy.y = enemy.y + move_y * dt

        --TODO move the enemies methods to a separate module
        local move_vec = Vec2:new(move_x, move_y)
        if move_vec:length() > 0 then
            enemy.sprite_obj:rotation(math.deg(move_vec:angle()) + 90)
        end
    end
end

--- calling once when enemy enters this state
function PatrolState:exit(enemy)
    print("[PatrolState] Enemy left patrol")
end


return PatrolState