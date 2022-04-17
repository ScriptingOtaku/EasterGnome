local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Roact = require(Packages.Roact)

local Modules = script.Parent:WaitForChild("Modules")

local PlacementHandler = require(Modules.PlacementHandler)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local End_Game = Remotes:WaitForChild("Event_EndGame")

Roact.mount(
    Roact.createElement("ScreenGui", {}, {
        Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1.777,
            AspectType = Enum.AspectType.FitWithinMaxSize,
            DominantAxis = Enum.DominantAxis.Width,
        }),
        Roact.createElement("TextButton", {
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(1, -50, 1, -50),
            Size = UDim2.new(0.147, 0, 0.065, 0),
            Font = Enum.Font.ArialBold,
            Text = "FORCE END",
            TextColor3 = Color3.fromRGB(255, 56, 56),
            TextScaled = true,
            [Roact.Event.Activated] = function()
                End_Game:FireServer()
                PlacementHandler:stop()
                PlacementHandler:start()
            end,
        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }),
            Roact.createElement("UIStroke", {
                Color = Color3.fromRGB(255, 56, 56),
                Thickness = 4,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }),
            Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 36,
                MinTextSize = 1,
            }),
        })
    }),
    PlayerGui
)