local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerShopGui = Roact.Component:extend("App")

function PlayerShopGui:init() end

function PlayerShopGui:render()
	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		ShopFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(246, 241, 248),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.42, 0.46),
		}, {
			UIStroke = Roact.createElement("UIStroke", {
				Color = Color3.fromRGB(229, 225, 231),
				Thickness = 2,
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10),
			}),
			ShopHeader = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 0.145),
			}, {
				ExitButton = Roact.createElement("ImageButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.fromRGB(226, 0, 0),
					ImageTransparency = 1,
					Position = UDim2.fromScale(0.99, 0.5),
					Size = UDim2.fromScale(0.75, 0.75),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					[Roact.Event.Activated] = function()
						self.props.closeButton()
					end,
				}, {
					ImageButton = Roact.createElement("ImageButton", {
						Size = UDim2.fromScale(1, 0.9),
						BackgroundColor3 = Color3.fromRGB(255, 0, 0),
						ImageTransparency = 1,
						[Roact.Event.Activated] = function()
							self.props.closeButton()
						end,
					}, {
						UICorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 10),
						}),
						TextLabel = Roact.createElement("ImageLabel", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							BackgroundTransparency = 1,
							Image = "rbxassetid://8382884510",
							Size = UDim2.fromScale(0.65, 0.65),
						}),
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
				}),
			}),
			Item1 = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, 100, 0, 100),
				Position = UDim2.fromScale(0.1, 0.1),
				BackgroundColor3 = Color3.fromRGB(245, 205, 48),
				ImageTransparency = 1,
				[Roact.Event.Activated] = function()
					local playerMoney = 0
					local itemPrice = 0

					-- Also grey out in GUI when shop is opened things that cannot be purchased and display max limit warning on them
					if playerMoney >= itemPrice then
						print("Player just bought WheatHoe")
						-- if slots are full, put it in inventory instead of calling create tool event maybe?
						local event = game.ReplicatedStorage:WaitForChild("CreateToolEvent")
						event:FireServer("WheatHoe")
					end
				end,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
			Item2 = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, 100, 0, 100),
				Position = UDim2.fromScale(0.3, 0.1),
				BackgroundColor3 = Color3.fromRGB(106, 57, 9),
				ImageTransparency = 1,
				[Roact.Event.Activated] = function()
					local playerMoney = 0
					local itemPrice = 0

					-- Also grey out in GUI when shop is opened things that cannot be purchased and display max limit warning on them
					if playerMoney >= itemPrice then
						print("Player just bought Sickle")
						-- if slots are full, put it in inventory instead of calling create tool event maybe?
						local event = game.ReplicatedStorage:WaitForChild("CreateToolEvent")
						event:FireServer("Sickle")
					end
				end,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
			Item3 = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, 100, 0, 100),
				Position = UDim2.fromScale(0.5, 0.1),
				BackgroundColor3 = Color3.fromRGB(0, 0, 255),
				ImageTransparency = 1,
				[Roact.Event.Activated] = function()
					local playerMoney = 0
					local itemPrice = 0

					-- Also grey out in GUI when shop is opened things that cannot be purchased and display max limit warning on them
					if playerMoney >= itemPrice then
						print("Player just bought Axe")
						-- if slots are full, put it in inventory instead of calling create tool event maybe?
						local event = game.ReplicatedStorage:WaitForChild("CreateToolEvent")
						event:FireServer("Axe")
					end
				end,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
			Item4 = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, 100, 0, 100),
				Position = UDim2.fromScale(0.7, 0.1),
				BackgroundColor3 = Color3.fromRGB(0, 255, 0),
				ImageTransparency = 1,
				[Roact.Event.Activated] = function()
					local playerMoney = 0
					local itemPrice = 0

					-- Also grey out in GUI when shop is opened things that cannot be purchased and display max limit warning on them
					if playerMoney >= itemPrice then
						print("Player just bought Shovel")
						-- if slots are full, put it in inventory instead of calling create tool event maybe?
						local event = game.ReplicatedStorage:WaitForChild("CreateToolEvent")
						event:FireServer("Shovel")
					end
				end,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
			Item5 = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, 100, 0, 100),
				Position = UDim2.fromScale(0.9, 0.1),
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				ImageTransparency = 1,
				[Roact.Event.Activated] = function()
					local playerMoney = 0
					local itemPrice = 0

					-- Also grey out in GUI when shop is opened things that cannot be purchased and display max limit warning on them
					if playerMoney >= itemPrice then
						print("Player just bought Pickaxe")
						-- if slots are full, put it in inventory instead of calling create tool event maybe?
						local event = game.ReplicatedStorage:WaitForChild("CreateToolEvent")
						event:FireServer("Pickaxe")
					end
				end,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
			}),
		}),
	})
end

return PlayerShopGui
