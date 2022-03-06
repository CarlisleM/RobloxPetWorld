--!strict
local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ShopManager = {}
ShopManager.__index = ShopManager

function ShopManager.new()
	local self = setmetatable({}, ShopManager)
	return self
end

function ShopManager:start()
	self.ShopGui = require(script.Parent:WaitForChild("ShopGui"))

	-- self.CurrencyGui = require(script.Parent:WaitForChild("PlayerCurrencyGui"))

	local menuOpen = false

	local function unmountShopGui()
		if self.shopGuiTree then
			Roact.unmount(self.shopGuiTree)
			self.shopGuiTree = nil

			menuOpen = false
		end
	end

	for _, item in pairs(game.Workspace:WaitForChild("Shop"):GetDescendants()) do
		if item.Name == "ShopClickDetector" and item:IsA("ClickDetector") then
			item.MouseClick:Connect(function()
				if not menuOpen then
					menuOpen = true

					-- TODO: Move this
					------------------------------------------------------------------------
					local addPlayer = game.ReplicatedStorage:WaitForChild("AddPlayerToGroup")
					addPlayer:FireServer()
					------------------------------------------------------------------------

					self.shopGuiTree = Roact.mount(
						Roact.createElement(self.ShopGui, {
							closeButton = unmountShopGui,
						}),
						PlayerGui,
						"Shop"
					)

					-- self.currencyGuiTree = Roact.mount(
					-- 	Roact.createElement(self.CurrencyGui, {
					-- 		closeButton = unmountShopGui,
					-- 	}),
					-- 	PlayerGui,
					-- 	"CurrencyGui"
					-- )

					local Players = game:GetService("Players")
					local player = Players.LocalPlayer

					local character = player.Character

					if not character or not character.Parent then
						character = player.CharacterAdded:Wait()
					end

					while menuOpen do
						if character ~= nil then
							local partPosition = item.Parent.Position

							if partPosition ~= nil then
								local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									local playerPosition = humanoidRootPart.Position
									local playerDistance = (playerPosition - partPosition).Magnitude

									if playerDistance > 15 then
										unmountShopGui()
										menuOpen = false
									end
								end
							end

							task.wait(0.5)
						end
					end
				end
			end)
		end
	end
end

return ShopManager
