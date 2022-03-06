local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerHotbarGui = Roact.Component:extend("App")

function PlayerHotbarGui:init() end

function PlayerHotbarGui:render()
	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		Hotbar = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.95),
			Size = UDim2.fromScale(0.75, 0.1),
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0.01, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		}),
	})
end

return PlayerHotbarGui
