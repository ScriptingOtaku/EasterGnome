local RunService = game:GetService("RunService")
--[[
    @ScriptingOtaku

    @CameraHandler.lua
    Responsible for handling the camera.
    Fits the camera to the game board.
]]

local camera_handler = {}

local Camera = workspace.CurrentCamera

function set_scriptable() --> void
    Camera.CameraType = Enum.CameraType.Scriptable
    repeat
        Camera.CameraType = Enum.CameraType.Scriptable
    until Camera.CameraType == Enum.CameraType.Scriptable
end

function calculate(size: Vector2, offset: Vector3, rotation: Vector3) --> CFrame
    -- Make the camera fit the entire game board
    --TODO: 
end

function camera_handler:start(size: Vector2, offset: Vector3, rotation: Vector3) --> void

    set_scriptable()

    RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, function()
        Camera.CFrame = calculate(size, offset, rotation)
    end)
end

function camera_handler:stop()
    RunService:UnbindFromRenderStep("Camera")
end

return camera_handler