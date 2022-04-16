--[[
    @ScriptingOtaku

    @PlacementHandler.lua
    Responsible for handling the placement and any input on the game board.
]]

local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local placement_handler = {}

local Player = Players.LocalPlayer

local Placement = nil
local Placing = false
local Targeted_Tile = nil
local CanPlace = false

function UnAssign()
    Targeted_Tile = nil
    Placement.Adornee = nil
    CanPlace = false
end

function Click(_name: string, state: Enum.UserInputState, _input: Enum.UserInputType)
    if CanPlace then
        if state == Enum.UserInputState.Begin then
            -- Open the menu
            print("Clicked")
        end
    end
end

function Run()
    if Placing then
        local mouse = Player:GetMouse()

        if mouse.Target then
            if CollectionService:HasTag(mouse.Target, "Tile") then
                Targeted_Tile = mouse.Target
                Placement.Adornee = Targeted_Tile
                CanPlace = true
            else
                UnAssign()
            end
        else
            UnAssign()
        end
    end
end

function placement_handler:start()
    if Placing then
        return
    end
    ContextActionService:BindAction("Click", Click, false, Enum.UserInputType.MouseButton1)
    Placing = true

    Placement = Instance.new("SelectionBox")
    Placement.Color3 = Color3.new(0, 0, 0)
    Placement.LineThickness = 0.1
    Placement.Parent = workspace

    RunService:BindToRenderStep("Placement", Enum.RenderPriority.Camera.Value, Run)
end

function placement_handler:stop()
    Placing = false
    RunService:UnbindFromRenderStep("Placement")
    Placement:Destroy()
    ContextActionService:UnbindAction("Click")
end

return placement_handler