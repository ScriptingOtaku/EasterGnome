local Modules = script.Parent:WaitForChild("Modules")

local PlacementHandler = require(Modules.PlacementHandler)
local CameraHandler = require(Modules.CameraHandler)

PlacementHandler:start()

--[[
    12x8 = 22,50,14
]]
CameraHandler:start(
    Vector2.new(12, 8),
    4,
    Vector3.new(-60, 0, 0)
)