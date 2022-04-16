--[[
    @ScriptingOtaku

    @CameraHandler.lua
    Responsible for handling the camera.
    Fits the camera to the game board.
]]

local camera_handler = {}

local Camera = workspace.CurrentCamera
local Changed = nil

function set_scriptable() --> void
    Camera.CameraType = Enum.CameraType.Scriptable
    repeat
        Camera.CameraType = Enum.CameraType.Scriptable
    until Camera.CameraType == Enum.CameraType.Scriptable
end

function getVerticalFov(camera)
    -- by ThanksRoBama: https://devforum.roblox.com/t/forcing-a-certain-aspect-ratio-for-the-camera-on-all-clients/390845/2
	return camera.FieldOfView
	
	--Equivalent calculation:
	--local z = camera.NearPlaneZ
	--local viewSize = camera.ViewportSize
	--
	--local r0, r1 = 
	--	camera:ViewportPointToRay(viewSize.X/2, viewSize.Y*0, z), 
	--	camera:ViewportPointToRay(viewSize.X/2, viewSize.Y*1, z)
	--	
	--return math.deg(math.acos(r0.Direction.Unit:Dot(r1.Direction.Unit)))
end

function getHorizontalFov(camera)
    -- by ThanksRoBama: https://devforum.roblox.com/t/forcing-a-certain-aspect-ratio-for-the-camera-on-all-clients/390845/2
    local z = camera.NearPlaneZ
    local viewSize = camera.ViewportSize
    
    local r0, r1 = 
        camera:ViewportPointToRay(viewSize.X*0, viewSize.Y/2, z), 
        camera:ViewportPointToRay(viewSize.X*1, viewSize.Y/2, z)
        
    return math.deg(math.acos(r0.Direction.Unit:Dot(r1.Direction.Unit)))
end

function setHorizontalFov(camera, fov)
    -- by ThanksRoBama: https://devforum.roblox.com/t/forcing-a-certain-aspect-ratio-for-the-camera-on-all-clients/390845/2
    local aspectRatio = getHorizontalFov(camera)/getVerticalFov(camera)
    
    camera.FieldOfView = fov / aspectRatio
end

function camera_handler:start(size: Vector2, tile_size: number, rotation: Vector3) --> void

    set_scriptable()
    setHorizontalFov(Camera, 80)

    local position = Vector3.new(
        (size.X * tile_size / 2 - 2),
        30,
        (size.Y * tile_size / 2 - 2) - (rotation.X / 3)
    )
    Camera.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
    
    Changed = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        Camera.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
        setHorizontalFov(Camera, 80)
    end)
end

function camera_handler:stop()
    Changed:Disconnect()
end

return camera_handler