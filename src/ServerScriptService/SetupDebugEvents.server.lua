local RunService = game:GetService("RunService")
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

if RunService:IsStudio() then
	local DebugChangeStatEvent = Instance.new("RemoteEvent")
	DebugChangeStatEvent.Name = "DebugChangeStatEvent"
	DebugChangeStatEvent.Parent = game.ReplicatedStorage

	local DebugClearStatsEvent = Instance.new("RemoteEvent")
	DebugClearStatsEvent.Name = "DebugClearStatsEvent"
	DebugClearStatsEvent.Parent = game.ReplicatedStorage

	local DebugGiveAllToolsEvent = Instance.new("RemoteEvent")
	DebugGiveAllToolsEvent.Name = "DebugGiveAllToolsEvent"
	DebugGiveAllToolsEvent.Parent = game.ReplicatedStorage

	DebugChangeStatEvent.OnServerEvent:Connect(function(player, statName, amount)
		if statName == "Coins" then
			PlayerStatManager:ChangeStat(player, "Coins", amount)
		end

		if statName == "Wheat" then
			PlayerStatManager:ChangeStat(player, "Wheat", amount)
		end

		if statName == "Wood" then
			PlayerStatManager:ChangeStat(player, "Wood", amount)
		end

		if statName == "Carrots" then
			PlayerStatManager:ChangeStat(player, "Carrots", amount)
		end

		PlayerStatManager:ChangeStat(player, statName, amount)
	end)

	DebugClearStatsEvent.OnServerEvent:Connect(function(player)
		local amount

		amount = PlayerStatManager:GetStat(player, "Coins")
		PlayerStatManager:ChangeStat(player, "Coins", 0 - amount)

		amount = PlayerStatManager:GetStat(player, "Wheat")
		PlayerStatManager:ChangeStat(player, "Wheat", 0 - amount)

		amount = PlayerStatManager:GetStat(player, "Wood")
		PlayerStatManager:ChangeStat(player, "Wood", 0 - amount)

		amount = PlayerStatManager:GetStat(player, "Carrots")
		PlayerStatManager:ChangeStat(player, "Carrots", 0 - amount)
	end)
end
