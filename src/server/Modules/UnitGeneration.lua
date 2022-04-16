--[[
    @ScriptingOtaku

    @UnitGeneration
    Takes a map, then generates units.
]]

local unit_generation = {}

local Units: Unit = {
    Soldier = 1,
    Tank = 2,
    Ambulance = 3,
}
unit_generation.Units = Units
type Unit = {
    UnitName: string,
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
    Friendly = Color3.fromRGB(0, 123, 0),
}

function get_random(table: table) --> Item
    local rand = math.random(1, 100)
    local total = 0
    for index, value in ipairs(table) do
        total = total + value
        if rand <= total then
            return index
        end
    end
    return table[math.random(1, #table)]
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

    return units_added
end

return unit_generation