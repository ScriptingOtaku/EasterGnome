local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)

local Remotes = ReplicatedStorage.Remotes
local start_game = Remotes:WaitForChild("Event_StartGame")

local Button = Roact.Component:extend("Button")

function Button:init()
    self:setState({
        Use = self.props.Use,
    })
end

function Button:render()
    return Roact.createElement("TextButton", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = self.state.Use,
        TextColor3 = self.props.Color,
        RichText = true,
        Size = UDim2.new(1, 0, 0.333, 0),
        TextScaled = true,
        [Roact.Event.Activated] = function()
            if self.props.Use ~= "CAMPAIGN" then
                self:setState({
                    Use = "UNIMPLEMENTED",
                })
                task.wait(1)
                self:setState({
                    Use = self.props.Use,
                })
            else
                start_game:FireServer(self.props.Use)
                self.props.Interface.hide_menu()
                self.props.StartPlacement:Fire()
            end
        end
    }, {
        Roact.createElement("UITextSizeConstraint", {
            MaxTextSize = 34,
            MinTextSize = 1,
        }),
        Roact.createElement("Frame", {
            BackgroundColor3 = self.props.Color,
            BorderSizePixel = 0,
            Size = UDim2.new(.95, 0, 0.1, 0),
            Position = UDim2.new(0.5, 0, .975, 0),
            AnchorPoint = Vector2.new(.5, 1),
        })
    })
end

return Button