local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = script.Parent.Modules
local Packages = ReplicatedStorage:WaitForChild("Packages")

local GameManager = require(Modules.GameManager)
local Janitor = require(Packages.Janitor)

function separate_string(string: string, separator: string) --> Table
   local result: table = {}
   
   if separator == nil then
      separator = "%s"
   end
   for match in string.gmatch(string, "([^" .. separator .. "]+)") do
      table.insert(result, match)
   end
    return result
end

Players.PlayerAdded:Connect(function(player: Player)
    player.Chatted:Connect(function(message: string)
        local sep: table = separate_string(message, " ")
        local command: string = sep[1]
        local _args: table = table.remove(sep, 1)

        if command == "!start" then
            GameManager:start_game(player)
        end
    end)
end)

task.wait(1)

GameManager:start_game(nil)