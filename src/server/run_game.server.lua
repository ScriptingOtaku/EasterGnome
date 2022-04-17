local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = script.Parent.Modules

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Start_Game = Remotes:WaitForChild("Function_StartGame")

local GameManager = require(Modules.GameManager)

Start_Game.OnServerInvoke = function(player: Player)
    GameManager:start_game(player)
end