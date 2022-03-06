local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerHotbarSlot = Roact.Component:extend("App")

function PlayerHotbarSlot:init() end

function PlayerHotbarSlot:render()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
	}, {
		ImageButton = Roact.createElement("ImageButton", {
			BackgroundColor3 = Color3.fromRGB(223, 152, 217),
			Size = UDim2.fromScale(1, 1),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			ImageTransparency = 1,
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10),
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Color = Color3.fromRGB(235, 101, 166),
				Thickness = 2,
			}),
			Icon = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.85, 0.85),
				BackgroundTransparency = 1,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
			HotkeyNumber = Roact.createElement("TextLabel", {}),
		}),
	})
end

return PlayerHotbarSlot
