local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
    @ScriptingOtaku

    @GameManager
    Responsible for managing the game.
]]

local Modules = script.Parent
local MapGeneration = require(Modules.MapGeneration)
local MapDecoration = require(Modules.MapDecoration)
local UnitGeneration = require(Modules.UnitGeneration)
local UnitMovement = require(Modules.UnitMovement)
local EnemyMovement = require(Modules.EnemyMovement)

local game_manager = {}

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Get_Map = Remotes:WaitForChild("Function_GetMap")
local Move_Unit = Remotes:WaitForChild("Function_MoveUnit")

local map_folder = workspace:FindFirstChild("Map") or Instance.new("Folder")
map_folder.Name = "Map"
map_folder.Parent = workspace

local turn_value = Instance.new("BoolValue")
turn_value.Name = "Turn"
turn_value.Parent = ReplicatedStorage
turn_value.Value = true

local map = nil

game_manager.Playing = false
game_manager.Turn = true -- false = enemy, true = player

game_manager.End = Instance.new("BindableEvent")

function check_for_win() --> (bool)
    local Units = workspace.Units
    local enemy_count = #Units.Enemy:GetChildren()
    local player_count = #Units.Player:GetChildren()
    if enemy_count == 0 or player_count == 0 then
        return true
    end
    return false
end

function enemy_move()
    task.wait(math.random(1, 5))
    if check_for_win() then
        game_manager:end_game()
        return
    end
    EnemyMovement:Run(map)
    game_manager:change_turn(true)
end

function game_manager:start_game() 
    -- start single player game
    map = MapGeneration:create_map({
        seed = Random.new():NextNumber(0, 10e6)
    })
    map.place_tiles(map_folder)
    MapDecoration:place(map)

    UnitGeneration:add_to_generation(UnitGeneration.Units.Twig, 50)
    UnitGeneration:add_to_generation(UnitGeneration.Units.Sprout, 25)
    UnitGeneration:add_to_generation(UnitGeneration.Units.Flower, 10)
    UnitGeneration:generate(map)

    UnitMovement.map = map
    self.Playing = true
    self.Turn = true
    turn_value.Value = true

    check_for_win()
end

function game_manager:end_game()
    self.Playing = false
    self.Turn = true
    self.End:Fire()
    map.Destroy()
    map = nil
end

function game_manager:change_turn(value: boolean)
    self.Turn = value or not self.Turn
    turn_value.Value = self.Turn
    if check_for_win() then
        game_manager:end_game()
        return
    end
end

Get_Map.OnServerInvoke = function(_player)
    return map or nil
end

Move_Unit.OnServerInvoke = function(_player, unit, position)
    if game_manager.Turn == true then
        game_manager:change_turn()
        local success = UnitMovement:move_unit(unit, position)
        enemy_move()
        return success
    else
        --Not player's turn
        return false
    end
end

return game_manager