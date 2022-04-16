
local Modules = script.Parent
local MapGeneration = require(Modules.MapGeneration)

local game_manager = {}

local map_folder = workspace:FindFirstChild("Map") or Instance.new("Folder")
map_folder.Name = "Map"
map_folder.Parent = workspace

function game_manager:start_game(player: Player) 
    -- start single player game
    local map = MapGeneration:create_map()
    map.place_tiles:Fire(map_folder)
end

return game_manager