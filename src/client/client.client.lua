local Modules = script.Parent:WaitForChild("Modules")

local PlacementHandler = require(Modules.PlacementHandler)
local CameraHandler = require(Modules.CameraHandler)

PlacementHandler:start()
CameraHandler:center()