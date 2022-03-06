--!strict
local Zone = require(game:GetService("ReplicatedStorage").Zone)

local wheatContainer = game.Workspace:WaitForChild("Wheat"):WaitForChild("Zone")
local wheatZone = Zone.new(wheatContainer)

local carrotContainer = game.Workspace:WaitForChild("Carrot"):WaitForChild("Zone")
local carrotZone = Zone.new(carrotContainer)

local ZoneManager = {}
ZoneManager.__index = ZoneManager

function ZoneManager.new()
	local self = setmetatable({}, ZoneManager)
	return self
end

function ZoneManager:start()
	print("Started zone")

	-- Wheat
	-- wheatZone.playerEntered:Connect(function(player)
	-- 	print(("%s entered the wheat zone!"):format(player.Name))
	-- 	player:SetAttribute("ZoneLocation", "Wheat")
	-- end)

	-- wheatZone.playerExited:Connect(function(player)
	-- 	print(("%s exited the wheat zone!"):format(player.Name))
	-- 	player:SetAttribute("ZoneLocation", "Default")
	-- end)

	-- -- Carrot
	-- carrotZone.playerEntered:Connect(function(player)
	-- 	print(("%s entered the carrot zone!"):format(player.Name))
	-- 	player:SetAttribute("ZoneLocation", "Carrot")
	-- end)

	-- carrotZone.playerExited:Connect(function(player)
	-- 	print(("%s exited the carrot zone!"):format(player.Name))
	-- 	player:SetAttribute("ZoneLocation", "Default")
	-- end)
end

return ZoneManager
