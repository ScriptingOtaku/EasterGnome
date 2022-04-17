local Modules = script.Parent:WaitForChild("Modules")

local PlacementHandler = require(Modules.PlacementHandler)
local CameraHandler = require(Modules.CameraHandler)
local UserInterface = require(Modules.UserInterface)
--[[
    12x8 = 22,50,14
]]
CameraHandler:start(
    Vector2.new(12, 8),
    4,
    Vector3.new(-60, 0, 0)
)

UserInterface.show_menu()
UserInterface.StartPlacement.Event:Connect(function()
    PlacementHandler:start()
end)