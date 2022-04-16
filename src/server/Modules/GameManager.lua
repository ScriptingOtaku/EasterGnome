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

local game_manager = {}

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GetMap = Remotes:WaitForChild("Function_GetMap")

local map_folder = workspace:FindFirstChild("Map") or Instance.new("Folder")
map_folder.Name = "Map"
map_folder.Parent = workspace

local map = nil

function game_manager:start_game(_player: Player) 
    -- start single player game
    map = MapGeneration:create_map()
    map.place_tiles(map_folder)
    MapDecoration:place(map)

    UnitGeneration:add_to_generation(UnitGeneration.Units.Soldier, 50)
    UnitGeneration:add_to_generation(UnitGeneration.Units.Tank, 25)
    UnitGeneration:add_to_generation(UnitGeneration.Units.Ambulance, 25)
    UnitGeneration:generate(map)
end

GetMap.OnServerInvoke = function(_player)
    return map or nil
end

return game_manager