--!strict
local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local PlayerInventoryManager = {}
PlayerInventoryManager.__index = PlayerInventoryManager

function PlayerInventoryManager.new()
	local self = setmetatable({}, PlayerInventoryManager)
	return self
end

function PlayerInventoryManager:start()
	self.PlayerInventoryGui = require(script.Parent:WaitForChild("PlayerInventoryGui"))

	local menuOpen = false

	local function unmountPlayerPortrait()
		if self.playerInventoryGuiTree then
			Roact.unmount(self.playerInventoryGuiTree)
			self.playerInventoryGuiTree = nil

			menuOpen = false
		end
	end

	for _, item in pairs(game.Workspace:WaitForChild("Chest"):GetDescendants()) do
		if item.Name == "ChestClickDetector" and item:IsA("ClickDetector") then
			item.MouseClick:Connect(function()
				if not menuOpen then
					menuOpen = true

					self.playerInventoryGuiTree = Roact.mount(
						Roact.createElement(self.PlayerInventoryGui, {
							closeButton = unmountPlayerPortrait,
						}),
						PlayerGui,
						"PlayerInventory"
					)

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
										unmountPlayerPortrait()
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

return PlayerInventoryManager
