local RunService = game:GetService("RunService")

if RunService:IsServer() then
    return require(script.server)
else
    if script:FindFirstChild("server") then
        script.server:Destroy()
    end
    return require(script.client)
end