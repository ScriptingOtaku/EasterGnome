--[[
    @ScriptingOtaku

    @PlacementHandler.lua
    Responsible for handling the placement and any input on the game board.
]]

--[[
    On hover over player unit, give info
    On click on player unit, select unit to do action
        * Move
        * Attack
        * Collect resources
]]

--[[
    x - When mouse is over a tile with a player unit, show the unit's info
    x - When mouse selected a tile with a player unit, highlight tiles where the unit can reach
    
    When clicked on a tile, move the unit to that tile
    When clicked on a unit, attack the unit
    When clicked on a resource, collect the resource
]]

local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Roact = require(Packages:WaitForChild("Roact"))

local placement_handler = {}

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GetMap = Remotes:WaitForChild("Function_GetMap")
local MoveUnit = Remotes:WaitForChild("Function_MoveUnit")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()

local Over_Tile = false
local Selected_Tile = nil
local Selected_Unit = nil
local Selected_Unit_Range_Boxes = {}
local map = nil
local unit_info = nil

local Selection_Box = Instance.new("SelectionBox")
Selection_Box.Color3 = Color3.fromRGB(0, 0, 0)
Selection_Box.LineThickness = 0.1
Selection_Box.Parent = workspace
local Selected_Unit_Box = Instance.new("SelectionBox")
Selected_Unit_Box.Color3 = Color3.fromRGB(0, 0, 0)
Selected_Unit_Box.LineThickness = 0.1
Selected_Unit_Box.Parent = workspace

function get_tile(x, z)
    for _, tile in pairs(map.tiles) do
        if tile.x == x and tile.z == z then
            return tile
        end
    end
end

function tile_unit(position: Vector3) --> Unit
    return get_tile(position.X, position.Z).Unit
end

function show_unit_range(unit: table, position: Vector3) --> [Tile], [SelectionBox]
    Selected_Unit_Box.Adornee = Selected_Tile
    local range = unit.Model:FindFirstChild("Unit States").Range.Value
    local tiles_in_range = {}
    local tiles_in_range_boxes = {}
    
    for x = position.X - range, position.X + range do
        for z = position.Z - range, position.Z + range do
            local tile = get_tile(x, z)
            if tile then
                local box = Instance.new("SelectionBox")
                box.SurfaceColor3 = Color3.fromRGB(70, 78, 186)
                box.SurfaceTransparency = 0.5
                box.Transparency = 1
                box.Adornee = tile.Instance
                box.Parent = workspace
                table.insert(tiles_in_range, tile)
                table.insert(tiles_in_range_boxes, box)
            end
        end
    end
    return tiles_in_range, tiles_in_range_boxes
end

function hide_unit_range()
    Selected_Unit_Box.Adornee = nil
    for _, box in pairs(Selected_Unit_Range_Boxes) do
        box:Destroy()
    end
    Selected_Unit_Range_Boxes = {}
end

function move_unit(unit: table, pos: Vector3)
    MoveUnit:InvokeServer(unit, pos)
    map = GetMap:InvokeServer()
end

function show_unit_info(unit: Unit)
    if unit_info ~= unit and unit.Owner == "Player" then
        print("Show unit info")
        unit_info = unit
    end
end

function hide_unit_info()
    print("Hide unit info")
    unit_info = nil
end

function Raycast()
    -- Raycast to the mouse
    local raycast_parameters = RaycastParams.new()
    raycast_parameters.FilterDescendantsInstances = { workspace.Map }
    raycast_parameters.FilterType = Enum.RaycastFilterType.Whitelist
    local unit_ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
    local raycast_result = workspace:Raycast(unit_ray.Origin, unit_ray.Direction * 500, raycast_parameters)
    if raycast_result then
        if CollectionService:HasTag(raycast_result.Instance, "Tile") then
            Over_Tile = true
            Selected_Tile = raycast_result.Instance
            Selection_Box.Adornee = Selected_Tile
            if tile_unit(Selected_Tile.Position) then
                show_unit_info(tile_unit(Selected_Tile.Position))
            end
        else
            Over_Tile = false
            Selected_Tile = nil
        end
    else
        hide_unit_info()
        Over_Tile = false
        Selected_Tile = nil
    end
end

function Click(_name: string, state: Enum.UserInputState, _input: Enum.UserInputType)
    if state == Enum.UserInputState.Begin then
        if Over_Tile then
            if Selected_Tile then
                -- Move
                if Selected_Unit == nil then
                    local pos = Selected_Tile.Position
                    if tile_unit(pos) then
                        if tile_unit(pos).Owner == "Player" then
                            Selected_Unit = tile_unit(pos)
                            local _
                            _, Selected_Unit_Range_Boxes = show_unit_range(Selected_Unit, pos)
                        end
                    end
                else
                    local pos = Selected_Tile.Position
                    if tile_unit(pos) then
                        if tile_unit(pos).Owner == "Enemy" then
                            --print("attack")
                            if move_unit(Selected_Unit, pos) then
                                hide_unit_range()
                                Selected_Unit = nil
                            end
                        end
                    else
                        --print("move")
                        if move_unit(Selected_Unit, pos) then
                            hide_unit_range()
                            Selected_Unit = nil
                        end
                    end
                    hide_unit_range()
                    Selected_Unit = nil
                end
            end
        end
    end 
end

function placement_handler:start()
    map = GetMap:InvokeServer()
    RunService:BindToRenderStep("Raycast", Enum.RenderPriority.Camera.Value, Raycast)
    ContextActionService:BindAction("Click", Click, false, Enum.UserInputType.MouseButton1)
end

function placement_handler:stop()
end

return placement_handler