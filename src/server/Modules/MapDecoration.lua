local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
    @ScriptingOtaku

    @MapDecoration
    Takes the tiles and adds decorations in accordance with their terrain type.
]]

local map_decoration = {}

type Terrain_Type = {
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
    TerrainType: Terrain_Type
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

local FOREST_CHANCE = 50
local MOUNTAIN_CHANCE = 50

local Assets = ReplicatedStorage:WaitForChild("Assets")

function map_decoration:place(map: Map)
    local tiles: Tile = map.tiles
    local tile_instances: Instance = map.tile_instances

    for _, tile in pairs(tiles) do
        local tile_instance: Instance = tile_instances[tile]
        local terrain_type: Terrain_Type = tile.TerrainType
        local decoration: Instance = nil

        if terrain_type == Terrain_Type.Sea then
            -- Change the tile to a sea tile
            tile_instance.BrickColor = BrickColor.new("Bright blue")
            tile_instance.Size = Vector3.new(
                tile_instance.Size.X,
                tile_instance.Size.Y / 2,
                tile_instance.Size.Z
            )
            CollectionService:AddTag(tile_instance, "Sea")
            tile_instance:FindFirstChildOfClass("Texture"):Destroy()
        elseif terrain_type == Terrain_Type.Forest then
            -- Add forest decoration
            tile_instance.BrickColor = BrickColor.new("Earth green")
            if math.random(1, 100) <= FOREST_CHANCE then
                decoration = Assets:FindFirstChild("Forest_Decoration"):Clone()
            end
        elseif terrain_type == Terrain_Type.Mountain then
            -- Add mountain decoration
            tile_instance.BrickColor = BrickColor.new("Dark stone grey")
            if math.random(1, 100) <= MOUNTAIN_CHANCE then
                decoration = Assets:FindFirstChild("Mountain_Decoration"):Clone()
            end
        elseif terrain_type == Terrain_Type.GrassLand then
            tile_instance.BrickColor = BrickColor.new("Sea green")
        end
        if decoration then
            decoration:PivotTo(tile_instance:GetPivot() * CFrame.Angles(
                0, math.rad(math.random(0, 360)), 0
            ))
            decoration.Parent = tile_instance
        end
    end
end

return map_decoration