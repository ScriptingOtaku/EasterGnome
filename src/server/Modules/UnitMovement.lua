
local unit_movement = {}

unit_movement.map = nil

function get_tile(x, z)
    for _, tile in pairs(unit_movement.map.tiles) do
        if tile.x == x and tile.z == z then
            return tile
        end
    end
end

function check_range(unit: table, position: Vector3)
    local range = unit.Model:FindFirstChild("Unit States").Range.Value

    print("Run")
    
    for x = position.X - range, position.X + range do
        for z = position.Z - range, position.Z + range do
            if x == position.X and z == position.Z then
                local new_tile = get_tile(x, z)
                local old_pos = unit.Position
                local old_tile = get_tile(old_pos.X, old_pos.Z)
                if new_tile.Unit then
                    if new_tile.Unit.Owner ~= unit.Owner then
                        --print("Attack")
                        local destroy = new_tile.Unit.Model
                        new_tile.Unit = unit
                        return true, destroy
                    elseif new_tile.Unit.Owner == unit.Owner then
                        -- unit can't attack own units
                        --print("Can't attack own units")
                        return false
                    end
                else
                    --print("Move")
                    old_tile.Unit = nil
                    new_tile.Unit = unit
                    return true
                end
            end
        end
    end
    return false
end

function unit_movement:move_unit(unit: table, position: Vector3)
    local success, destroy = check_range(unit, position)

    if success then
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