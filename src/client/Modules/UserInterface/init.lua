local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Roact = require(Packages:WaitForChild("Roact"))

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local UserInterface = {}

UserInterface.StartPlacement = Instance.new("BindableEvent")

local unit_info_mount = nil
local menu_mount = nil

local button = require(script.Menu.Button)

function UserInterface.show_menu()
    if menu_mount then
        UserInterface.hide_menu()
    end
    menu_mount = Roact.mount(
        Roact.createElement("ScreenGui", {
            IgnoreGuiInset = true,
        }, {
            Roact.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1.777,
                AspectType = Enum.AspectType.FitWithinMaxSize,
                DominantAxis = Enum.DominantAxis.Width,
            }),
            BattleMenu = Roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(.3, 0, .3, 0),
            }, {
                Roact.createElement("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(255, 56, 56),
                    Thickness = 5,
                }),
                Roact.createElement("Folder", {}, {
                    Roact.createElement("UIListLayout", {
                        Padding = UDim.new(0, 0),
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                    }),
                    Roact.createElement(button, {
                        Use = "CAMPAIGN",
                        Color = Color3.fromRGB(64, 64, 248),
                        Interface = UserInterface,
                        StartPlacement = UserInterface.StartPlacement,
                    }),
                    Roact.createElement(button, {
                        Use = "COMBAT",
                        Color = Color3.fromRGB(248, 40, 40),
                    }),
                    Roact.createElement(button, {
                        Use = "TRAINING",
                        Color = Color3.fromRGB(80, 160, 120),
                    }),
                }),
                Roact.createElement("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 56, 56),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(1.024, 0, 0.15, 0),
                    Text = "BATTLE MENU",
                    BorderSizePixel = 0,
                    Font = Enum.Font.ArialBold,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextScaled = true,
                    ZIndex = 2
                }, {
                    Roact.createElement("UICorner", {
                        CornerRadius = UDim.new(0, 8),
                    }),
                    Roact.createElement("UITextSizeConstraint", {
                        MaxTextSize = 34,
                        MinTextSize = 1,
                    }),
                    Roact.createElement("Frame", {
                        AnchorPoint = Vector2.new(0.5, 1),
                        BackgroundColor3 = Color3.fromRGB(255, 56, 56),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.5, 0, 1, 0),
                        Size = UDim2.new(1, 0, 0.5, 0),
                    })
                })
            })
        }),
        PlayerGui
    )
end

function UserInterface.hide_menu()
    Roact.unmount(menu_mount)
end

function UserInterface.show_unit_info(unit: table)
    if unit_info_mount then
        UserInterface.hide_unit_info()
    end
    unit_info_mount = Roact.mount(
        Roact.createElement("ScreenGui", {}, {
            Roact.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1.777,
                AspectType = Enum.AspectType.FitWithinMaxSize,
                DominantAxis = Enum.DominantAxis.Width,
            }),
            Roact.createElement("Frame", {
                Position = UDim2.new(0, -100, 0.7, 0),
                Size = UDim2.new(0.35, 0, 0.275, 0),
                BackgroundTransparency = .6,
                BackgroundColor3 = Color3.new(0, 0, 0),
            }, {
                Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                }),
                Roact.createElement("TextLabel", {
                    Text = unit.UnitName,
                    TextScaled = true,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                    TextStrokeTransparency = 0,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Size = UDim2.new(0.419, 0, 0.473, 0),
                    BackgroundTransparency = 1,
                }, {
                    Roact.createElement("UITextSizeConstraint", {
                        MaxTextSize = 83,
                        MinTextSize = 1,
                    })
                }),
                Roact.createElement("TextLabel", {
                    Text = "Range: " .. unit.Model:FindFirstChild("Unit States").Range.Value,
                    TextScaled = true,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                    TextStrokeTransparency = 0,
                    Position = UDim2.new(0.5, 0, 0.473, 0),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Size = UDim2.new(0.419, 0, 0.237, 0),
                    BackgroundTransparency = 1,
                }, {
                    Roact.createElement("UITextSizeConstraint", {
                        MaxTextSize = 50,
                        MinTextSize = 1,
                    })
                }),
            })
        }),
        PlayerGui
    )
end

function UserInterface.hide_unit_info()
    if unit_info_mount then
        Roact.unmount(unit_info_mount)
        unit_info_mount = nil
    end
end


return UserInterface