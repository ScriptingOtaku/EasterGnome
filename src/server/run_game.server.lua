local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = script.Parent.Modules

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Start_Game = Remotes:WaitForChild("Event_StartGame")
local End_Game = Remotes:WaitForChild("Event_EndGame")

local GameManager = require(Modules.GameManager)

local function run()
    while task.wait() do
        GameManager:start_game()
        GameManager.End.Event:Wait()
    end
end

Start_Game.OnServerEvent:Connect(function(_player: Player)
    run()
end)
End_Game.OnServerEvent:Connect(function(_player: Player)
    GameManager:end_game()
end)