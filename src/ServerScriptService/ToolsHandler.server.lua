local Players = game:GetService("Players")
--!strict
game.ReplicatedStorage:WaitForChild("ConfigModules"):WaitForChild("Tools")
local Tools = require(game.ReplicatedStorage.ConfigModules.Tools)

local MAX_POLLEN = 100
local hitPart = game.ReplicatedStorage:WaitForChild("Stamp")

local pollen = 0

game.ReplicatedStorage.usetool.OnServerEvent:Connect(function(player, tool)
	-- local tool = Players.Stats.Tool
	-- local tool = "" -- Tool assigned to the player
	-- max?
	-- min?

	-- print("Player tool: ", player:GetAttribute("CurrentTool"))

	if tool == "Tool" then -- if tool == tool.Value
		if pollen < MAX_POLLEN then -- if player pollen < player pollen max
			local toolObj = player.Character:WaitForChild("Tool") -- player.Character[tool.Value]

			local collisionCheck = hitPart:Clone() -- clone the stamp belonging to that tool
			collisionCheck.Parent = toolObj
			collisionCheck.Name = "CollisionCheck"
			collisionCheck.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)

			collisionCheck.Transparency = 0

			collisionCheck.Touched:Connect(function(part)
				if part.Name == "WheatFarm" and part.Position.Magnitude > 4 then
					pollen = pollen + 1

					print("Pollen: ", pollen)
				end
			end)

			task.wait(0.10)
			collisionCheck:Destroy()
		end
	end
end)
