--[[
    @ScriptingOtaku

    @MapGeneration
    Responsible for generating the map.
]]

--[[ TODO: 
 * Add Terrain (e.g. mountains, hills, plains, desert, tundra, etc.)
    * Add Resources (e.g. ores, herbs, metals, etc.)
    * Add Features (e.g. rivers, lakes, roads, etc.)
    * Add Cities (e.g. small, medium, large, etc.)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local generation = {}

local SEA_LEVEL: number = 5 -- Sea level in studs
local FOREST_LEVEL: number = SEA_LEVEL + 10 -- Forest level in studs
local MOUNTAIN_LEVEL: number = SEA_LEVEL + 20 -- Mountain level in studs

local TILE_SIZE: number = 4
local RESOLUTION: number = 50
local FREQUENCY: number = 3
local AMPLITUDE: number = 50

local TERRAIN_SEED: number = Random.new():NextNumber(0, 10e6)

local Assets = ReplicatedStorage:WaitForChild("Assets")

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
type Map_Def = { -- Map Definition; used in function parameters
    width: number,
    height: number,
    terrain_types: Terrain_Type,
    seed: number,
}
local Default_Map_Def: Map_Def = { -- Default Map Definition
    width = 12,
    height = 8,
    terrain_types = {
        Sea = Terrain_Type.Sea,
        Forest = Terrain_Type.Forest,
        Mountain = Terrain_Type.Mountain,
    },
    seed = TERRAIN_SEED
}

function get_terrain_type(height: number) --> Terrain_Type
    height = height * AMPLITUDE
    if height > SEA_LEVEL then
		if height > FOREST_LEVEL then
			if height > MOUNTAIN_LEVEL then
				--mountain
				return Terrain_Type.Mountain
			end
			--forest
			return Terrain_Type.Forest
		end
		--grass
		return Terrain_Type.GrassLand
	else
		--sea
		return Terrain_Type.Sea
	end
end

function generate_noise(x: number, y: number, seed: number) --> Number
    local noiseHeight = math.noise(x / RESOLUTION * FREQUENCY, y / RESOLUTION * FREQUENCY, seed)
	noiseHeight = math.clamp(noiseHeight, -0.5, 0.5) + 0.5
	return noiseHeight
end

function generate_terrain(map: Map) --> Table
	local terrain: table = {}

    local size: Vector2 = Vector2.new(map.width, map.height)

	for x = 1, size.X do
		terrain[x] = {}
		for z = 1, size.Y do
			local noise: number = generate_noise(x, z, map.seed)
			terrain[x][z] = noise
		end
	end
	return terrain
end

function generate_tiles(terrain_map: table) --> Tile[]
    local tiles: table = {}

    for x in pairs(terrain_map) do
        for z in pairs(terrain_map[x]) do
            local height: number = terrain_map[x][z]

            local tile = {
                x = (x - 1) * TILE_SIZE,
                y = 0,
                z = (z - 1) * TILE_SIZE,
                height = height,
                TerrainType = get_terrain_type(height)
            }
            table.insert(tiles, tile)
        end
    end
    return tiles
end

function generate_walls(map: Map, parent: Instance) --> Table
    -- TODO: Implement
    local walls = {}

    local y = 0
    local z = 0
    local size = Vector2.new(map.width * TILE_SIZE, map.height * TILE_SIZE)
    local offset = Vector3.new(
        (size.X / 2) - (TILE_SIZE / 2),
        y,
        (size.Y / 2) - (TILE_SIZE / 2)
    )

    for _ = 1, 4 do
		local part = Instance.new("Part")
		part.Parent = parent
		part.Anchored = true
		part.Material = Enum.Material.Wood
        part.BrickColor = BrickColor.new("Pine Cone")

		table.insert(walls, part)
    end

    walls[1].Size = Vector3.new(size.X + z, TILE_SIZE + 1, 1)
    walls[1].CFrame = CFrame.new(0, y, size.Y / 2 + 0.5) + offset

    walls[2].Size = Vector3.new(size.X + z, TILE_SIZE + 1, 1)
    walls[2].CFrame = CFrame.new(0, y, (size.Y / 2 + 0.5) * -1) + offset

    walls[3].Size = Vector3.new(1, TILE_SIZE + 1, size.Y + z)
    walls[3].CFrame = CFrame.new(Vector3.new(size.X / 2 + 0.5, y, 0)) + offset

    walls[4].Size = Vector3.new(1, TILE_SIZE + 1, size.Y + z)
    walls[4].CFrame = CFrame.new(Vector3.new((size.X / 2 + 0.5) * -1, y, 0)) + offset

    return walls
end

function set_map_defaults(map: Map) --> Map
    map = map or {}

    map.width = map.width or Default_Map_Def.width
    map.height = map.height or Default_Map_Def.height
    map.terrain_types = map.terrain_types or Default_Map_Def.terrain_types
    map.seed = map.seed or Default_Map_Def.seed

    return map
end

function generation:create_map(map_def: Map_Def) --> Map
    local map: Map = map_def :: Map
    map = set_map_defaults(map)
    local terrain_map: table = generate_terrain(map)
    local tileMap: table = generate_tiles(terrain_map)

    map.tiles = tileMap
    map.place_tiles = function(parent: Instance)
        local tile_instances: table = {}
        for _, tile in pairs(tileMap) do
            local tile_instance = Assets.Tile:Clone()
            CollectionService:AddTag(tile_instance, "Tile")
            tile_instance.Size = Vector3.new(TILE_SIZE, TILE_SIZE, TILE_SIZE)
            tile_instance.Position = Vector3.new(tile.x, tile.y, tile.z)
            tile_instance.Anchored = true
            tile_instance.Parent = parent

            tile_instances[tile] = tile_instance
        end
        map.wall_instances = generate_walls(map, parent)
        map.tile_instances = tile_instances
    end
    map.get_tile = function(x: number, y: number)
        return map.tiles[x][y]
    end

    return map
end

return generation