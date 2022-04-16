local RunService = game:GetService("RunService")

local generation = {}

local SEA_LEVEL: number = 5 -- Sea level in studs
local _FOREST_LEVEL: number = SEA_LEVEL + 10 -- Forest level in studs
local _MOUNTAIN_LEVEL: number = SEA_LEVEL + 20 -- Mountain level in studs

local TILE_SIZE: number = 4
local RESOLUTION: number = 50
local FREQUENCY: number = 3
local _AMPLITUDE: number = 25

local TERRAIN_SEED: number = Random.new():NextNumber(-math.huge, math.huge)

type Terrain_Type = {
    TerrainType: table
}
local Terrain_Type = -- Terrain Type Enum
{
    Sea = 0,
    Forest = 1,
    Mountain = 2,
}
type Map = { -- Map; the actual map
    width: number,
    height: number,
    terrain_types: Terrain_Type,
    seed: number,
    tiles: table,
    wall_instances: table,
    tile_instances: table,
    place_tiles: BindableEvent,
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

function generate_noise(x: number, y: number, seed: number) --> Number
    return math.noise(
        x / RESOLUTION * FREQUENCY,
        y / RESOLUTION * FREQUENCY,
        seed
    )
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

function generate_tiles(terrain_map: table) --> Table
    local tiles: table = {}

    for x in pairs(terrain_map) do
        for z in pairs(terrain_map[x]) do
            local height: number = terrain_map[x][z]

            local tile = {
                x = (x - 1) * TILE_SIZE,
                y = 0,
                z = (z - 1) * TILE_SIZE,
                height = height,
            }
            table.insert(tiles, tile)
        end
        RunService.Heartbeat:Wait()
    end
    return tiles
end

function generate_walls(map: Map) --> Table
    -- TODO: Implement
    local walls = {}

    local _y = 0
    local _z = 0
    local size = Vector2.new(map.width * TILE_SIZE, map.height * TILE_SIZE)
    local _offset = Vector2.new(
        (size.X / 2) - (TILE_SIZE / 2),
        (size.Y / 2) - (TILE_SIZE / 2)
    )

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
    map.place_tiles = Instance.new("BindableEvent")
    map.place_tiles.Event:Connect(function(parent: Instance)
        local tile_instances: table = {}
        for _, tile in pairs(tileMap) do
            local tile_instance = Instance.new("Part") --TODO: Change to model or something
            tile_instance.Size = Vector3.new(TILE_SIZE, TILE_SIZE, TILE_SIZE)
            tile_instance.Position = Vector3.new(tile.x, tile.y, tile.z)
            tile_instance.Anchored = true
            tile_instance.Parent = parent

            tile_instances[tile] = tile_instance
        end
        map.wall_instances = generate_walls(map)
        map.tile_instances = tile_instances
    end)

    return map
end

return generation