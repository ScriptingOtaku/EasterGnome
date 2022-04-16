local Modules = script.Parent.Modules

local GameManager = require(Modules.GameManager)

task.wait(1)

GameManager:start_game(nil)