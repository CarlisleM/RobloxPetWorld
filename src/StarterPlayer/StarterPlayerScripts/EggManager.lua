--!strict
game.ReplicatedStorage:WaitForChild("ConfigModules"):WaitForChild("Eggs")
local Eggs = require(game.ReplicatedStorage.ConfigModules.Eggs)

local EggManager = {}
EggManager.__index = EggManager

function EggManager.new()
	local self = setmetatable({}, EggManager)
	return self
end

-- game.ReplicatedStorage:WaitForChild('ConfigModules'):WaitForChild('HOFThumbnails')
-- local Thumbnails = require(game.ReplicatedStorage.ConfigModules.HOFThumbnails)

-- local allThumbnails = {}
-- 	for i, thumbnailId in pairs(Thumbnails.Celebs) do
-- 		table.insert(allThumbnails, thumbnailId)
-- 	end

-- 	for i, thumbnailId in pairs(Thumbnails.Legends) do
-- 		table.insert(allThumbnails, thumbnailId)
-- 	end

function EggManager:RandomPet(EggCategory)
	local value = math.random(1, 100) / 100

	print("Got a value of: " .. value)

	local counter = 0

	for index, pet in pairs(EggCategory) do
		if index == 0 then
			if value >= counter and value <= (counter + pet.rarity) then
				print("Reward is: ", pet.name)
				-- Add egg to your inventory (maybe this should get randomised when the egg hatches rather than when getting the egg)
			end
		else
			if value >= (counter + 0.01) and value <= (counter + pet.rarity) then
				print("Reward is: ", pet.name)
				-- Add egg to your inventory (maybe this should get randomised when the egg hatches rather than when getting the egg)
			end
		end

		counter = counter + pet.rarity
	end
end

function EggManager:start()
	print("Started egg")

	for _, egg in pairs(game.Workspace:WaitForChild("Eggs"):GetChildren()) do
		for _, item in pairs(egg:GetChildren()) do
			if item.name == "ClickDetector" and item:IsA("ClickDetector") then
				item.MouseClick:Connect(function()
					if item.Parent.Name == "Common" then
						self:RandomPet(Eggs.Common)
					elseif item.Parent.Name == "Rare" then
						self:RandomPet(Eggs.Rare)
					elseif item.Parent.Name == "Legendary" then
						self:RandomPet(Eggs.Legendary)
					else
						print("Unique Egg has no pets")
					end
				end)
			end
		end
	end
end

return EggManager
