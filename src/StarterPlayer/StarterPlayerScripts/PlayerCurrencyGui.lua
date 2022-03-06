local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerCurrencyGui = Roact.Component:extend("App")

function PlayerCurrencyGui:init()
	local player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()

	-- TODO: sometimes fails here on load
	local coins = player:WaitForChild("Coins")
	self.coinAmountChangedConn = nil

	local wheat = player:WaitForChild("Wheat")
	self.wheatAmountChangedConn = nil

	local carrots = player:WaitForChild("Carrots")
	self.carrotAmountChangedConn = nil

	local wood = player:WaitForChild("Wood")
	self.woodAmountChangedConn = nil

	self.state = {
		coinAmount = coins.Value or 0,
		wheatAmount = wheat.Value or 0,
		carrotAmount = carrots.Value or 0,
		woodAmount = wood.Value or 0,
	}
end

function PlayerCurrencyGui:didMount()
	local player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()

	local coins = player:WaitForChild("Coins")

	self.coinAmountChangedConn = coins:GetPropertyChangedSignal("Value"):Connect(function()
		self:setState({
			coinAmount = coins.Value,
		})
	end)

	local wheat = player:WaitForChild("Wheat")

	self.wheatAmountChangedConn = wheat:GetPropertyChangedSignal("Value"):Connect(function()
		self:setState({
			wheatAmount = wheat.Value,
		})
	end)

	local carrots = player:WaitForChild("Carrots")

	self.carrotAmountChangedConn = carrots:GetPropertyChangedSignal("Value"):Connect(function()
		self:setState({
			carrotAmount = carrots.Value,
		})
	end)

	local wood = player:WaitForChild("Wood")

	self.woodAmountChangedConn = wood:GetPropertyChangedSignal("Value"):Connect(function()
		self:setState({
			woodAmount = wood.Value,
		})
	end)
end

function PlayerCurrencyGui:willUnmount()
	-- TODO: probably convert this into a for loop
	self.coinAmountChangedConn:Disconnect()
	self.coinAmountChangedConn = nil

	self.wheatAmountChangedConn:Disconnect()
	self.wheatAmountChangedConn = nil

	self.carrotAmountChangedConn:Disconnect()
	self.carrotAmountChangedConn = nil

	self.woodAmountChangedConn:Disconnect()
	self.woodAmountChangedConn = nil
end

function PlayerCurrencyGui:render()
	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		CurrencyFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.99, 0.9),
			Size = UDim2.fromScale(0.525, 0.07),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
		}, {
			-- Wheat
			WheatFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.3, 1),
			}, {
				ImageLabel = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://8458939712",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
				}),
				TextLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextScaled = true,
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.fromScale(0.5, 1),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSansBold,
					Text = tostring(self.state.wheatAmount),
				}),
			}),
			-- Wood
			WoodFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.3, 1),
				Position = UDim2.fromScale(0.5, 0),
			}, {
				ImageLabel = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://8492853161",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
				}),
				TextLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextScaled = true,
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.fromScale(0.5, 1),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSansBold,
					Text = tostring(self.state.woodAmount),
				}),
			}),
			-- Carrots
			CarrotFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.3, 1),
				Position = UDim2.fromScale(1, 0),
			}, {
				ImageLabel = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://8458939415",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
				}),
				TextLabel = Roact.createElement("TextLabel", {
					[Roact.Ref] = self.carrotAmount,
					BackgroundTransparency = 1,
					TextScaled = true,
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.fromScale(0.5, 1),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSansBold,
					Text = tostring(self.state.carrotAmount),
				}),
			}),
		}),
		CoinFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.99, 0.8),
			Size = UDim2.fromScale(0.175, 0.07),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
		}, {
			ImageLabel = Roact.createElement("ImageLabel", {
				Image = "rbxassetid://8969225593", -- rbxassetid://8969225279
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ImageColor3 = Color3.fromRGB(255, 238, 0),
			}),
			TextLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(0.5, 1),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.SourceSansBold,
				Text = tostring(self.state.coinAmount),
			}),
		}),
	})
end

return PlayerCurrencyGui
