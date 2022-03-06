local logOutput = false

local PlayerData = {}

function PlayerData.PreparePlayerData(player, data)
	local now = os.time()

	if data then
		print("Data for player found: ", data)
		if data["BannedUntil"] ~= nil and data["BannedUntil"] > now then
			player:Kick("Player banned for another " .. data["BannedUntil"] - now .. " seconds.")
			return
		end

		data.playerName = player.Name

		if logOutput then
			print(
				"PlayerStatManager: found data for player ",
				player.Name,
				"Coins=" .. data.Coins,
				"Wheat=" .. data.Wheat,
				"Wood=" .. data.Wood,
				"Carrots=" .. data.Carrots
				-- "Fame=" .. data.Fame
			)
		end

		if not data.Items then
			if logOutput then
				print("PlayerStatManager: no items data found, adding it now...")
			end
			data.Items = {}
		end

		for key, _ in pairs(data.Items) do
			data.Items[key] = math.max(data.Items[key], 0)
		end

		if data.Coins then
			if data.Coins < 10 then
				if logOutput then
					print("PlayerStatManager: give this poor player some more starting coins")
				end
				data.Coins = 10
			end
		else
			data.Coins = 10
		end

		if data.Wheat then
			if data.Wheat < 10 then
				if logOutput then
					print("PlayerStatManager: give this poor player some more starting wheat")
				end
				data.Wheat = 10
			end
		else
			data.Wheat = 10
		end

		if data.Wood then
			if data.Wood < 10 then
				if logOutput then
					print("PlayerStatManager: give this poor player some more starting Wood")
				end
				data.Wood = 10
			end
		else
			data.Wood = 10
		end

		if data.Carrots then
			if data.Carrots < 10 then
				if logOutput then
					print("PlayerStatManager: give this poor player some more starting Carrots")
				end
				data.Carrots = 10
			end
		else
			data.Carrots = 10
		end
	else
		-- Data store is working, but no current data for this player
		data = {
			Coins = 10,
			totalCoinsEarned = 10,
			Wheat = 10,
			totalWheatEarned = 10,
			Wood = 10,
			totalWoodEarned = 10,
			Carrots = 10,
			totalCarrotsEarned = 10,
		}
		print("PlayerStatManager: new player", player.Name)
	end

	if not data["TotalTimePlayed"] then
		data["TotalTimePlayed"] = 0
	end

	local Coins = Instance.new("IntValue")
	Coins.Name = "Coins"
	Coins.Value = data["Coins"]
	Coins.Parent = player

	local Wheat = Instance.new("IntValue")
	Wheat.Name = "Wheat"
	Wheat.Value = data["Wheat"]
	Wheat.Parent = player

	local Wood = Instance.new("IntValue")
	Wood.Name = "Wood"
	Wood.Value = data["Wood"]
	Wood.Parent = player

	local Carrots = Instance.new("IntValue")
	Carrots.Name = "Carrots"
	Carrots.Value = data["Carrots"]
	Carrots.Parent = player

	return data
end

return PlayerData
