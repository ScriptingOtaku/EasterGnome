
local unit_movement = {}

unit_movement.map = nil

function get_tile(x, z)
    for _, tile in pairs(unit_movement.map.tiles) do
        if tile.x == x and tile.z == z then
            return tile
        end
    end
end

function get_tiles_in_range(unit: table) --> [Tile]
    local range = unit.Model:FindFirstChild("Unit States").Range.Value
    local tiles_in_range = {}
    local position = unit.Position
    
    for x = position.X - range, position.X + range do
        for z = position.Z - range, position.Z + range do
            local tile = get_tile(x, z)
            if tile then
                table.insert(tiles_in_range, tile)
            end
        end
    end
    return tiles_in_range
end

function check_range(unit: table, position: Vector3)

    local tiles = get_tiles_in_range(unit)

    for _, tile in pairs(tiles) do
        if tile.x == position.X and tile.z == position.Z then
            local old_pos = unit.Position
            local new_tile = get_tile(position.X, position.Z)
            local old_tile = get_tile(old_pos.X, old_pos.Z)
            if new_tile.Unit then
                    if new_tile.Unit.Owner ~= unit.Owner then
                        print("Attack")
                        local destroy = new_tile.Unit.Model
                        new_tile.Unit = unit
                        task.spawn(function()
                            local explosion = Instance.new("Explosion")
                            explosion.Position = destroy:GetPivot().Position
                            explosion.BlastRadius = .5
                            explosion.Parent = workspace
                            task.wait(1)
                            explosion:Destroy()
                        end)
                        return true, destroy
                    elseif new_tile.Unit.Owner == unit.Owner then
                        -- unit can't attack own units
                        print("Can't attack own units")
                        return false
                    end
                else
                    print("Move")
                    old_tile.Unit = nil
                    new_tile.Unit = unit
                return true
            end
        end
    end
    return false
end

function unit_movement:move_unit(unit: table, position: Vector3)
    local success, destroy = check_range(unit, position)

    if success == true then
        local model = unit.Model
        local humanoid = model:FindFirstChild("Humanoid")
        unit.Position = position
        humanoid:MoveTo(position)
        humanoid.MoveToFinished:Connect(function()
            if destroy then
                destroy:Destroy()
            end
        end)
        --humanoid.MoveToFinished:Wait()
    end

    return success
end

return unit_movement