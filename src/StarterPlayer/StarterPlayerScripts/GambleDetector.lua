local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local GambleDetector = {}
GambleDetector.__index = GambleDetector

function GambleDetector.new()
	local self = setmetatable({}, GambleDetector)
	return self
end

function GambleDetector:start()
	self.GambleGui = require(script.Parent:WaitForChild("GambleGui"))

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local parts = {}
	local gamble = game.Workspace:WaitForChild("Gamble")
	local isMenuOpen = false

	table.insert(parts, gamble)

	local function unmountGambleGui()
		if self.gambleGuiTree then
			Roact.unmount(self.gambleGuiTree)
			self.gambleGuiTree = nil
		end
	end

	local function watchPart(boundary)
		local character = player.Character

		if not character or not character.Parent then
			character = player.CharacterAdded:Wait()
		end

		while character do
			if character ~= nil then
				local closestPart = nil
				if parts == nil then
					return
				end
				for _, part in pairs(parts) do
					local partPosition = part.Position

					if partPosition ~= nil then
						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
						if humanoidRootPart then
							local playerPosition = humanoidRootPart.Position
							local playerDistance = (playerPosition - partPosition).Magnitude

							if playerDistance < boundary then
								closestPart = part
							end
						end
					else
						print("Warning: FameTowerTeleport Triggerwall not found!")
					end
				end

				if closestPart ~= nil then
					if isMenuOpen == false then
						isMenuOpen = true

						print("Open menu")
						self.gambleGuiTree = Roact.mount(
							Roact.createElement(self.GambleGui, {
								closeHandler = function()
									unmountGambleGui()
								end,
							}),
							PlayerGui,
							"GambleGui"
						)
					end
				else
					if isMenuOpen == true then
						print("Close Menu")
						unmountGambleGui()
						isMenuOpen = false
					end
				end
			end

			task.wait(0.5)
		end
	end

	task.spawn(function()
		watchPart(5)
	end)
end

return GambleDetector
