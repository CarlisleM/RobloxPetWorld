local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)
local HttpService = game:GetService("HttpService")

local GambleVariable = ReplicatedStorage:WaitForChild("GambleVariable")
local GambleTimeLeftVariable = ReplicatedStorage:WaitForChild("GambleTimeLeftVariable")
local GambleTotalVariable = ReplicatedStorage:WaitForChild("GambleTotalVariable")

local InvestedPlayerGui = Roact.Component:extend("App")

function InvestedPlayerGui:init()
	self.winningOddsRef = Roact.createRef()
	self.timeRemainingRef = Roact.createRef()
	self.potAmountRef = Roact.createRef()
	self.numberOfEntrantsRef = Roact.createRef()

	self.callbacks = {}

	self.gambleTimeLeftListener = GambleTimeLeftVariable.Changed:Connect(function()
		self.decodedGambleTimeLeftVariable = HttpService:JSONDecode(GambleTimeLeftVariable.Value)
		if self.decodedGambleTimeLeftVariable > 0 then
			self.timeRemainingRef:getValue().Text = self.decodedGambleTimeLeftVariable
		else
			self:teardown()
		end
	end)
	table.insert(self.callbacks, self.gambleTimeLeftListener)

	self.potAmountListener = GambleTotalVariable.Changed:Connect(function()
		self.potAmountRef:getValue().Text = GambleTotalVariable.Value
		self.winningOddsRef:getValue().Text = (self.props.amountInvested / GambleTotalVariable.Value) * 100
	end)
	table.insert(self.callbacks, self.potAmountListener)

	self.gambleDataListener = GambleVariable.Changed:Connect(function()
		self.decodedGambleVariable = HttpService:JSONDecode(GambleVariable.Value)
		self.numberOfEntrantsRef:getValue().Text = #self.decodedGambleVariable
	end)
	table.insert(self.callbacks, self.gambleDataListener)
end

function InvestedPlayerGui:render()
	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		Frame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 10),
			Size = UDim2.fromScale(0.25, 0.1),
			BackgroundTransparency = 0.5,
		}, {
			TopFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(1, 0.5),
				BackgroundTransparency = 1,
			}, {
				AmountInvestedFrame = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromScale(0.65, 1),
					BackgroundTransparency = 1,
				}, {
					AmountInvestedIcon = Roact.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.1, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = "rbxassetid://9023623327",
					}),
					AmountInvested = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.3, 0.5),
						Size = UDim2.fromScale(0.7, 0.8),
						BackgroundTransparency = 1,
						Text = self.props.amountInvested,
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Enum.Font.SourceSansSemibold,
					}),
				}),
				WinningOddsFrame = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromScale(0.35, 1),
					BackgroundTransparency = 1,
				}, {
					WinningOddsIcon = Roact.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = "rbxassetid://9023710384",
					}),
					WinningOdds = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(0.9, 0.5),
						Size = UDim2.fromScale(0.75, 0.8),
						BackgroundTransparency = 1,
						Text = "",
						TextScaled = true,
						Font = Enum.Font.SourceSansSemibold,
						TextXAlignment = Enum.TextXAlignment.Right,
						[Roact.Ref] = self.winningOddsRef,
					}),
				}),
			}),
			BottomFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.5),
				BackgroundTransparency = 1,
			}, {
				TotalPotFrame = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromScale(0.65, 1),
					BackgroundTransparency = 1,
				}, {
					TotalPotIcon = Roact.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.1, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = "rbxassetid://9023623487",
					}),
					TotalPot = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.3, 0.5),
						Size = UDim2.fromScale(0.5, 0.8),
						BackgroundTransparency = 1,
						TextScaled = true,
						Font = Enum.Font.SourceSansSemibold,
						Text = "",
						TextXAlignment = Enum.TextXAlignment.Left,
						[Roact.Ref] = self.potAmountRef,
					}),
				}),
				EntrantNumbersFrame = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.333, 1),
					BackgroundTransparency = 1,
				}, {
					EntrantNumbersIcon = Roact.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.35, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = "rbxassetid://9023623156",
					}),
					EntrantNumbers = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.65, 0.5),
						Size = UDim2.fromScale(0.25, 0.8),
						BackgroundTransparency = 1,
						TextScaled = true,
						Font = Enum.Font.SourceSansSemibold,
						Text = "",
						[Roact.Ref] = self.numberOfEntrantsRef,
					}),
				}),
				TimeRemainingFrame = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromScale(0.333, 1),
					BackgroundTransparency = 1,
				}, {
					TimeRemainingIcon = Roact.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.15, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						Image = "rbxassetid://9023622935",
					}),
					TimeRemaining = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(0.9, 0.5),
						Size = UDim2.fromScale(0.75, 0.8),
						BackgroundTransparency = 1,
						TextScaled = true,
						Font = Enum.Font.SourceSansSemibold,
						Text = "",
						TextXAlignment = Enum.TextXAlignment.Right,
						[Roact.Ref] = self.timeRemainingRef,
					}),
				}),
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.25, 0),
			}),
		}),
	})
end

function InvestedPlayerGui:teardown()
	for _, callback in ipairs(self.callbacks) do
		if callback then
			callback:Disconnect()
		end
	end
end

return InvestedPlayerGui
