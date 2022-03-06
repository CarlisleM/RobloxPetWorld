local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerDebugMenuGui = Roact.Component:extend("App")

local menuOpen = false

function PlayerDebugMenuGui:init()
	self.state = {
		toolsGiven = false,
	}
end

function PlayerDebugMenuGui:render()
	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		DebugButton = Roact.createElement("TextButton", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 55, 255),
			BackgroundTransparency = 0.35,
			Position = UDim2.fromScale(0.99, 0.77),
			Size = UDim2.fromScale(0.08, 0.08),
			Text = "Debug",
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			[Roact.Event.Activated] = function(object)
				if menuOpen then
					menuOpen = false
					object.Parent.DebugMenu.Visible = false
				else
					menuOpen = true
					object.Parent.DebugMenu.Visible = true
				end
			end,
		}),
		DebugMenu = Roact.createElement("ScrollingFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(64, 240, 255),
			BackgroundTransparency = 0.25,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.5, 0.5),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.new(0, 0, 1, 0),
			BorderSizePixel = 0,
			Visible = false,
		}, {
			UIGridLayout = Roact.createElement("UIGridLayout", {
				CellPadding = UDim2.new(0.04, 0, 0.04, 0),
				CellSize = UDim2.new(0.2, 0, 0, 100),
				FillDirectionMaxCells = 5,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, {
				UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {}),
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0.05, 0),
				PaddingBottom = UDim.new(0.05, 0),
			}),
			GiveCoins = Roact.createElement("TextButton", {
				Text = "+100 Coins",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 0,
				[Roact.Event.Activated] = function()
					print("Give 100 Coins")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Coins", 50)
				end,
			}),
			TakeCoins = Roact.createElement("TextButton", {
				Text = "-100 Coins",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 1,
				[Roact.Event.Activated] = function()
					print("Take 100 Coins")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Coins", -50)
				end,
			}),
			GiveWheat = Roact.createElement("TextButton", {
				Text = "+100 Wheat",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 0,
				[Roact.Event.Activated] = function()
					print("Give 100 wheat")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Wheat", 50)
				end,
			}),
			TakeWheat = Roact.createElement("TextButton", {
				Text = "-100 Wheat",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 1,
				[Roact.Event.Activated] = function()
					print("Take 100 wheat")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Wheat", -50)
				end,
			}),
			GiveWood = Roact.createElement("TextButton", {
				Text = "+100 Wood",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 2,
				[Roact.Event.Activated] = function()
					print("Give 100 Wood")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Wood", 50)
				end,
			}),
			TakeWood = Roact.createElement("TextButton", {
				Text = "-100 Wood",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 3,
				[Roact.Event.Activated] = function()
					print("Take 100 Wood")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Wood", -50)
				end,
			}),
			GiveCarrots = Roact.createElement("TextButton", {
				Text = "+100 Carrots",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 4,
				[Roact.Event.Activated] = function()
					print("Give 100 Carrots")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Carrots", 50)
				end,
			}),
			TakeCarrots = Roact.createElement("TextButton", {
				Text = "-100 Carrots",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 5,
				[Roact.Event.Activated] = function()
					print("Take 100 Carrots")
					game.ReplicatedStorage.DebugChangeStatEvent:FireServer("Carrots", -50)
				end,
			}),
			ClearResources = Roact.createElement("TextButton", {
				Text = "Reset Resources",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 6,
				[Roact.Event.Activated] = function()
					print("Reset Resources")
					game.ReplicatedStorage.DebugClearStatsEvent:FireServer()
				end,
			}),
			GiveAllTools = Roact.createElement("TextButton", {
				Text = "All Tools",
				BackgroundColor3 = Color3.fromRGB(0, 123, 255),
				BackgroundTransparency = 0.25,
				LayoutOrder = 7,
				Visible = not self.state.toolsGiven,
				[Roact.Event.Activated] = function()
					print("Give All Tools")
					self:setState({
						toolsGiven = true,
					})

					local createTool = game.ReplicatedStorage:WaitForChild("CreateToolEvent")
					createTool:FireServer("Axe")
					task.wait(0.1)
					createTool:FireServer("Pickaxe")
					task.wait(0.1)
					createTool:FireServer("Sickle")
					task.wait(0.1)
					createTool:FireServer("Shovel")
					task.wait(0.1)
					createTool:FireServer("WheatHoe")
				end,
			}),
		}),
	})
end

return PlayerDebugMenuGui
