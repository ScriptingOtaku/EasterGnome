local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
    @ScriptingOtaku

    @UnitGeneration
    Takes a map, then generates units.
]]

local unit_generation = {}

local Units: Unit = {
    Soldier = "Soldier",
    Tank = "Tank",
    Ambulance = "Ambulance",
}
unit_generation.Units = Units
type Unit = {
    UnitName: string,
    Owner: Player,
    Model: Instance,
    Position: Vector2,
}type Terrain_Type = {
    TerrainType: table
}
local Terrain_Type = { -- Terrain Type Enum
    Sea = 0,
    Forest = 1,
    Mountain = 2,
    GrassLand = 3,
}
type Tile = {
    x: number,
    y: number,
    z: number,
    height: number,
    TerrainType: Terrain_Type,
    Unit: Unit,
}
type Map = { -- Map; the actual map
width: number,
height: number,
terrain_types: Terrain_Type,
seed: number,
tiles: table,
wall_instances: table,
tile_instances: table,
place_tiles: () -> Tile,
get_tile: (x: number, y: number) -> Tile,
}

local Units_to_Spawn: Unit = {}
local Unit_Colours = {
    Enemy = Color3.fromRGB(123, 0, 0),
    Player = Color3.fromRGB(0, 123, 0),
}

local unit_folder = workspace:FindFirstChild("Units") or Instance.new("Folder")
unit_folder.Name = "Units"
unit_folder.Parent = workspace
local player_folder = unit_folder:FindFirstChild("Player") or Instance.new("Folder")
player_folder.Name = "Player"
player_folder.Parent = unit_folder
local enemy_folder = unit_folder:FindFirstChild("Enemy") or Instance.new("Folder")
enemy_folder.Name = "Enemy"
enemy_folder.Parent = unit_folder

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Unit_Assets = Assets:WaitForChild("Units")

local UNIT_SPAWN_CHANCE = 10

function get_random(table: table) --> Item
    -- Returns a random item from a weighted table
    local total = 0
    for _, v in pairs(table) do
        total = total + v
    end
    local rand = math.random(1, total)
    for i, v in pairs(table) do
        if rand <= v then
            return i
        end
        rand = rand - v
    end

    return "Soldier"
end

function create_states(_unit_type: string) --> Folder
    local Folder = Instance.new("Folder")
    Folder.Name = "Unit States"
    local Health = Instance.new("NumberValue")
    Health.Name = "Health"
    Health.Value = 100
    Health.Parent = Folder
    local Energy = Instance.new("NumberValue")
    Energy.Name = "Energy"
    Energy.Value = 100
    Energy.Parent = Folder
    local Range = Instance.new("NumberValue")
    Range.Name = "Range"
    Range.Value = 4
    Range.Parent = Folder
    return Folder
end

function colour_unit(unit_model: Instance, owner: string) --> Void
    local unit_colour = Unit_Colours[owner]
    local config = unit_model:FindFirstChild("Colours")
    if config then
        for _, value in pairs(config:GetChildren()) do
            if value.Value then
                value.Value.Color = unit_colour
            end
        end
    end
end

function spawn_unit(tile_instance: Instance, owner: string) --> Unit
    local unit_choice = get_random(Units_to_Spawn)
    local unit = {}
    unit.UnitName = unit_choice
    unit.Owner = owner

    local unit_model = Unit_Assets:FindFirstChild(unit_choice):Clone()
    unit_model.Parent = (owner == "Player" and player_folder) or enemy_folder
    unit_model:PivotTo(tile_instance:GetPivot() * CFrame.new(0, tile_instance.size.Y * 2, 0))

    colour_unit(unit_model, owner)
    create_states(unit_choice).Parent = unit_model

    CollectionService:AddTag(unit_model, owner)
    unit.Model = unit_model

    return unit
end

function unit_generation:add_to_generation(unit: Unit, chance: number) --> Void
    if not Units_to_Spawn[unit] then
        Units_to_Spawn[unit] = chance
    end
end

function unit_generation:generate(map: Map) --> [Unit]
    -- Loops through all the tiles and spawns units randomly
    -- TODO: Have units spawn with the map seed **backlog**
    local units_added = {}
    local tiles: Tile = map.tiles
    local tile_instances: Instance = map.tile_instances

    for _, tile in pairs(tiles) do
        local tile_instance: Instance = tile_instances[tile]
        if tile.TerrainType ~= Terrain_Type.Sea then 
            if math.random(100) <= UNIT_SPAWN_CHANCE then
                local unit
                if math.random(2) == 1 then
                    unit = spawn_unit(tile_instance, "Player")
                else
                    unit = spawn_unit(tile_instance, "Enemy")
                end
                tile.Unit = unit
                table.insert(units_added, unit)
            end
        end
    end

    return units_added
end

return unit_generation