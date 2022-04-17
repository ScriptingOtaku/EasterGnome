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

function game_manager:start_game(_player: Player) 
    -- start single player game
    map = MapGeneration:create_map()
    map.place_tiles(map_folder)
    MapDecoration:place(map)

    UnitGeneration:add_to_generation(UnitGeneration.Units.Soldier, 50)
    UnitGeneration:add_to_generation(UnitGeneration.Units.Tank, 25)
    UnitGeneration:add_to_generation(UnitGeneration.Units.Ambulance, 25)
    UnitGeneration:generate(map)

    UnitMovement.map = map
    self.Playing = true
end

function game_manager:change_turn()
    self.Turn = not self.Turn
    turn_value.Value = self.Turn
end

Get_Map.OnServerInvoke = function(_player)
    return map or nil
end

Move_Unit.OnServerInvoke = function(_player, unit, position)
    if game_manager.Turn == true then
        game_manager:change_turn()
        local success = UnitMovement:move_unit(unit, position)
        return success
    else
        --Not player's turn
        return false
    end
end

return game_manager