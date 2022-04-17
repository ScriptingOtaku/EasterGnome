local Modules = script.Parent
local UnitMovement = require(Modules.UnitMovement)

local enemy_movement = {}

local function get_random_unit(tiles: table)
    local units = {}
    for _, tile in pairs(tiles) do
        if tile.Unit then
            if tile.Unit.Owner == "Enemy" then
                table.insert(units, tile.Unit)
            end
        end
    end
    return units[math.random(1, #units)]
end

function get_tile(map, x, z)
    for _, tile in pairs(map.tiles) do
        if tile.x == x and tile.z == z then
            return tile
        end
    end
end

local function get_tiles_in_range(map: table, unit: table) --> [Tile]
    local range = unit.Model:FindFirstChild("Unit States").Range.Value
    local tiles_in_range = {}
    local position = unit.Position
    
    for x = position.X - range, position.X + range do
        for z = position.Z - range, position.Z + range do
            local tile = get_tile(map, x, z)
            if tile then
                table.insert(tiles_in_range, tile)
            end
        end
    end
    return tiles_in_range
end

function enemy_movement:Run(map: table)
    local Unit = get_random_unit(map.tiles)
    local Tiles = get_tiles_in_range(map, Unit)
    local Target = Tiles[math.random(1, #Tiles)]
    UnitMovement:move_unit(Unit, Vector3.new(
        Target.x,
        Unit.Position.Y,
        Target.z
    ))
end

return enemy_movement