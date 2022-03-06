local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local GambleGui = Roact.Component:extend("App")

local AddPlayerToGroupEvent = game.ReplicatedStorage:WaitForChild("AddPlayerToGroup")

function GambleGui:init()
	self.amountTextBox = Roact.createRef()
end

function GambleGui:submit(amount)
	AddPlayerToGroupEvent:FireServer(amount)
	self.props.closeHandler()
end

function GambleGui:render()
	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		Frame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0.25),
			Size = UDim2.fromScale(0.35, 0.4),
			BackgroundColor3 = Color3.fromRGB(98, 0, 255),
		}, {
			TextBox = Roact.createElement("TextBox", {
				[Roact.Ref] = self.amountTextBox,
				AnchorPoint = Vector2.new(0.25, 0.4),
				Position = UDim2.fromScale(0.25, 0.4),
				Size = UDim2.fromScale(0.35, 0.4),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				Text = "",
			}),
			TextButton = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.8, 0),
				BackgroundColor3 = Color3.fromRGB(170, 85, 255),
				Position = UDim2.fromScale(0.8, 0.25),
				Size = UDim2.fromScale(0.3, 0.4),
				Text = "Submit",
				[Roact.Event.Activated] = function()
					self:submit(self.amountTextBox:getValue().Text)
				end,
			}),
			CloseButton = Roact.createElement("TextButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = Color3.fromRGB(170, 85, 255),
				Position = UDim2.fromScale(0.9, 0.1),
				Size = UDim2.fromScale(0.1, 0.1),
				Text = "Close",
				[Roact.Event.Activated] = self.props.closeHandler,
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10),
			}),
		}),
	})
end

return GambleGui
