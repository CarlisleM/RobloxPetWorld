local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerInventoryGui = Roact.Component:extend("App")

-- local PRIMARY_THEME_COLOR = "255, 51, 252"

local SCROLL_BAR_THICKNESS = 20
local TOTAL_ITEM_SLOTS = 52
local EXPANSION_TAB_TWEEN_SPEED = 0.5

-- TODO: Expansion Tab Idea (could also turn this info into an on hover)
-- 	Original owner
-- 	Date originally obtainted by original owner
-- 	Date obtained by you
-- 	Amount of time owned

-- TODO: Add in theme colour. Set a colour and the darker/ighter tones are auto set for you

function PlayerInventoryGui:init()
	self.hoverGuiRef = Roact.createRef()

	self:setState({
		expansionTabOpen = false,
	})
end

function PlayerInventoryGui:render()
	local Player = game.Players.LocalPlayer
	local Mouse = Player:GetMouse()

	local function hoverDisplay()
		local hoverScreenGui = Roact.createElement("ScreenGui", {
			[Roact.Ref] = self.hoverGuiRef,
			IgnoreGuiInset = true,
			DisplayOrder = 1,
		}, {
			hoverFrame = Roact.createElement("Frame", {
				Visible = false,
				Size = UDim2.new(0.1, 0, 0.1, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundColor3 = Color3.fromRGB(255, 51, 252),
				BackgroundTransparency = 0.25,
			}, {
				TextLabel = Roact.createElement("TextLabel", {
					Text = "",
					Size = UDim2.new(1, 0, 1, 0),
					TextScaled = true,
					BackgroundTransparency = 1,
				}),
			}),
		})

		return Roact.createFragment(hoverScreenGui)
	end

	local function inventoryItemSlots()
		local playersInventory = {
			{
				Name = "Item1",
				Description = "Description1",
			},
			{
				Name = "Item2",
				Description = "Description2",
			},
			{
				Name = "Item3",
				Description = "Description3",
			},
		}

		local inventoryItems = {}
		local currentItem

		for index = 1, TOTAL_ITEM_SLOTS do
			if playersInventory[index] then
				currentItem = playersInventory[index].Name
			else
				currentItem = ""
			end

			inventoryItems[index] = Roact.createElement("ImageButton", {
				LayoutOrder = index,
				BackgroundColor3 = Color3.fromRGB(223, 152, 217),
				ImageTransparency = 1,
				[Roact.Event.MouseEnter] = function()
					if playersInventory[index] then
						self.hoverGuiRef:getValue().hoverFrame.Visible = true
						self.hoverGuiRef:getValue().hoverFrame.TextLabel.Text = playersInventory[index].Name
					end
				end,
				[Roact.Event.MouseMoved] = function()
					if playersInventory[index] then
						self.hoverGuiRef:getValue().hoverFrame.Visible = true -- temp fix
						self.hoverGuiRef:getValue().hoverFrame.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
					end
				end,
				[Roact.Event.MouseLeave] = function()
					self.hoverGuiRef:getValue().hoverFrame.Visible = false
				end,
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
				UIStroke = Roact.createElement("UIStroke", {
					Color = Color3.fromRGB(235, 101, 166),
					Thickness = 2,
				}),
				ImageLabel = Roact.createElement("ImageLabel", {
					-- Image = "rbxassetid://4458901886", -- Image of item goes here
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.85, 0.85),
					BackgroundTransparency = 1,
				}),
				TextLabel = Roact.createElement("TextLabel", {
					Text = currentItem,
					Size = UDim2.fromScale(0.75, 0.75),
					BackgroundTransparency = 1,
					TextScaled = true,
					Position = UDim2.fromScale(0.125, 0.125),
				}),
			})
		end

		return Roact.createFragment(inventoryItems)
	end

	local function inventoryCategories()
		local categories = {
			{ Text = "Pets", Icon = "rbxassetid://8391336435" },
			{ Text = "Food", Icon = "rbxassetid://8391654227" },
			{ Text = "Toys", Icon = "rbxassetid://8391368794" },
			{ Text = "Tools", Icon = "rbxassetid://8391346280" },
			{ Text = "Accessories", Icon = "rbxassetid://8391368974" },
			{ Text = "Gifts", Icon = "rbxassetid://8391368512" },
		}

		local categoryButtons = {}

		for index, category in pairs(categories) do
			categoryButtons[index] = Roact.createElement("ImageButton", {
				ImageTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(221, 0, 221),
				Size = UDim2.fromScale(0.944, 0.143),
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 10),
				}),
				UIStroke = Roact.createElement("UIStroke", {
					Color = Color3.fromRGB(149, 0, 149),
					Thickness = 2,
				}),
				ImageLabel = Roact.createElement("ImageButton", {
					Size = UDim2.fromScale(1, 0.9),
					ImageTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(240, 0, 240),
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
					ImageLabel = Roact.createElement("ImageLabel", {
						Image = category["Icon"],
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.05, 0.5),
						Size = UDim2.fromScale(0.65, 0.65),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
					}),
					TextLabel = Roact.createElement("TextLabel", {
						Text = category["Text"],
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.3, 0.5),
						Size = UDim2.fromScale(0.7, 0.75),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						Font = Enum.Font.SourceSansBold,
					}),
				}),
			})
		end

		return Roact.createFragment(categoryButtons)
	end

	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
	}, {
		HoverScreen = Roact.createElement(hoverDisplay),
		InventoryFrame = Roact.createElement("Frame", {
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
			InventoryHeader = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 0.145),
			}, {
				InventoryIcon = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://8382711727",
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0.02, 0.5),
					Size = UDim2.fromScale(0.8, 0.8),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					ImageColor3 = Color3.fromRGB(255, 20, 244),
					BackgroundTransparency = 1,
				}),
				InventoryTextHeader = Roact.createElement("TextLabel", {
					Position = UDim2.fromScale(0.1, 0),
					Size = UDim2.fromScale(0.3, 1),
					BackgroundTransparency = 1,
					Font = Enum.Font.SourceSansBold,
					TextScaled = true,
					TextColor3 = Color3.fromRGB(255, 20, 244),
					Text = "INVENTORY",
				}),
				SearchBar = Roact.createElement("ImageButton", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0.46, 0.5),
					Size = UDim2.fromScale(0.365, 0.61),
					BackgroundColor3 = Color3.fromRGB(252, 55, 252),
					[Roact.Event.Activated] = function(object)
						object.TextBox:CaptureFocus()
					end,
				}, {
					UIStroke = Roact.createElement("UIStroke", {
						Color = Color3.fromRGB(182, 39, 182),
						Thickness = 2,
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
					SearchIcon = Roact.createElement("ImageLabel", {
						Image = "rbxassetid://8382732855",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.05, 0.5),
						Size = UDim2.fromScale(0.75, 0.75),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
					}),
					TextBox = Roact.createElement("TextBox", {
						Position = UDim2.fromScale(0.2, 0.5),
						AnchorPoint = Vector2.new(0, 0.5),
						Size = UDim2.fromScale(0.62, 0.75),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						ClearTextOnFocus = false,
						Text = "",
						PlaceholderText = "search...",
						PlaceholderColor3 = Color3.fromRGB(234, 234, 234),
						[Roact.Change.Text] = function(object)
							object.Text = object.Text:sub(1, 15)
						end,
						[Roact.Event.Focused] = function(object)
							object.Parent.UIStroke.Color = Color3.fromRGB(150, 31, 150) -- TODO: Figure out how to outline this better
						end,
						[Roact.Event.FocusLost] = function(object)
							object.Parent.UIStroke.Color = Color3.fromRGB(182, 39, 182)
						end,
					}),
					ClearButton = Roact.createElement("ImageButton", {
						Image = "rbxassetid://8382897935",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.85, 0.5),
						Size = UDim2.fromScale(0.75, 0.75),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						BackgroundTransparency = 1,
						[Roact.Event.Activated] = function(object)
							object.Parent.TextBox.Text = ""
						end,
					}),
				}),
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
			CategoryItemFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 6, 0.145, 6),
				Size = UDim2.new(1, -12, 0.855, -12),
			}, {
				InventoryCategories = Roact.createElement("Frame", {
					BackgroundColor3 = Color3.fromRGB(232, 231, 231),
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.new(0.28, -3, 1, 0),
				}, {
					UIStroke = Roact.createElement("UIStroke", {
						Color = Color3.fromRGB(212, 211, 211),
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
					UIListLayout = Roact.createElement("UIListLayout", {
						Padding = UDim.new(0.02, 0),
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					categoryButtons = Roact.createElement(inventoryCategories),
				}),
				InventoryScrollFrame = Roact.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					ScrollBarImageColor3 = Color3.fromRGB(118, 91, 167),
					Position = UDim2.new(0.28, 3, 0.014, 0),
					Size = UDim2.new(0.72, 0, 0.972, 0),
					ScrollBarThickness = SCROLL_BAR_THICKNESS,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					BorderSizePixel = 0,
				}, {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 2),
						PaddingBottom = UDim.new(0, 3),
					}),
					InventoryItemFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, -SCROLL_BAR_THICKNESS - 3, 1, 0),
					}, {
						UIGridLayout = Roact.createElement("UIGridLayout", {
							CellPadding = UDim2.new(0.04, 0, 0.04, 0),
							CellSize = UDim2.new(0.2, 0, 0, 100),
							FillDirectionMaxCells = 4,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
						}, {
							UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {}),
						}),
						buttons = Roact.createElement(inventoryItemSlots),
					}),
				}),
				ScrollBarBackground = Roact.createElement("ImageLabel", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 0.9,
					ImageTransparency = 1,
					Position = UDim2.new(1, 3, 0, 10),
					Size = UDim2.new(0, SCROLL_BAR_THICKNESS, 1, -20),
					BackgroundColor3 = Color3.fromRGB(217, 0, 255),
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
				}),
			}),
			-- TODO: Make this expansion tab optional
			ExpansionTab = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1.01, 0),
				Size = UDim2.new(0.5, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(246, 241, 248),
				ZIndex = 0,
			}, {
				UIStroke = Roact.createElement("UIStroke", {
					Color = Color3.fromRGB(229, 225, 231),
					Thickness = 2,
				}),
				ExpansionTabButton = Roact.createElement("ImageButton", {
					AnchorPoint = Vector2.new(1, 0),
					ImageTransparency = 1,
					Position = UDim2.fromScale(1.02, 0),
					Size = UDim2.fromScale(0.06, 1),
					BackgroundColor3 = Color3.fromRGB(246, 241, 248),
					ZIndex = 0,
					[Roact.Event.Activated] = function(object)
						if not self.state.expansionTabOpen then
							object.Parent:TweenSizeAndPosition(
								UDim2.fromScale(0.5, 1),
								UDim2.fromScale(1.48, 0),
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quad,
								EXPANSION_TAB_TWEEN_SPEED,
								false,
								function()
									self:setState(function()
										return {
											expansionTabOpen = true,
										}
									end)
								end
							)
						else
							object.Parent:TweenSizeAndPosition(
								UDim2.fromScale(0.5, 1),
								UDim2.fromScale(1.01, 0),
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quad,
								EXPANSION_TAB_TWEEN_SPEED,
								false,
								function()
									self:setState(function()
										return {
											expansionTabOpen = false,
										}
									end)
								end
							)
						end
					end,
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10),
					}),
					UIStroke = Roact.createElement("UIStroke", {
						Color = Color3.fromRGB(229, 225, 231),
						Thickness = 2,
					}),
				}),
				ItemImage = Roact.createElement("ImageLabel", {
					Image = "rbxassetid://8391336435",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.25),
					Size = UDim2.fromScale(0.3, 0.3),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					BackgroundTransparency = 1,
					ZIndex = 0,
				}),
				TextLabel1 = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					TextScaled = true,
					Font = Enum.Font.SourceSansBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(0.75, 0, 0, 50),
					ZIndex = 0,
				}),
				TextLabel2 = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					TextScaled = true,
					Font = Enum.Font.SourceSansBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.65),
					Size = UDim2.new(0.75, 0, 0, 50),
					ZIndex = 0,
				}),
				TextLabel3 = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					TextScaled = true,
					Font = Enum.Font.SourceSansBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.8),
					Size = UDim2.new(0.75, 0, 0, 50),
					ZIndex = 0,
				}),
			}),
		}),
	})
end

return PlayerInventoryGui
