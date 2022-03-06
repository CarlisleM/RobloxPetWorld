local PlayerStatManager = {}

local DataStoreService = game:GetService("DataStoreService")
local dataStores = {}

local luaUtils = require(game.ReplicatedStorage:WaitForChild("LuaUtils"))
local SetupPlayerDataFinished = game.ServerStorage:WaitForChild("SetupPlayerDataFinished")
local PlayerDataUtil = require(script:WaitForChild("PlayerDataUtil"))

-- Table to hold player information for the current session
local sessionData = {}
local prevSessionData = {}
local playersWithFailedSaves = {}

PlayerStatManager.sessionData = sessionData

local AUTOSAVE_INTERVAL = 60

dataStores.playerData = DataStoreService:GetDataStore("PlayerData")

function PlayerStatManager:setupCharacter(player)
	local character = player.Character or player.CharacterAdded:wait()

	local humanoid = character:WaitForChild("Humanoid")
	humanoid.RequiresNeck = false
end

local function setupPlayerData(player)
	local playerUserId = "Player_" .. player.UserId

	local success, data = pcall(function()
		return dataStores.playerData:GetAsync(playerUserId)
	end)

	if not success then
		player:Kick("Roblox datastore is unavailable. Please try again later.")
		warn("Player kicked due to datastore being unavailable")
		return false
	end

	data = PlayerDataUtil.PreparePlayerData(player, data)

	local userId = player.UserId
	if not game.Players:GetPlayerByUserId(userId) then
		warn("Player " .. tostring(userId) .. " has left the game. Not adding data to persist loop.")
		return
	end

	local currentDay = os.date("!*t", os.time()).yday
	data["LastLoginDate"] = currentDay

	sessionData[playerUserId] = data
	prevSessionData[playerUserId] = luaUtils:copyTable(data)

	SetupPlayerDataFinished:Fire(player)

	local PlayerDataSetup = Instance.new("BoolValue")
	PlayerDataSetup.Name = "PlayerDataSetup"
	PlayerDataSetup.Value = true
	PlayerDataSetup.Parent = player

	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = player

	-- local isDev = Developers[player.UserId]

	-- 	ClubLeaderboard:load(playerUserId, 'Stars')
	-- 	ClubLeaderboard:load(playerUserId, 'Fame')

	-- 		local fame = Instance.new("IntValue")
	-- 		fame.Name = "Fame"
	-- 		fame.Value = data.Fame
	-- 		fame.Parent = folder

	player.CharacterAdded:Connect(function()
		PlayerStatManager:setupCharacter(player)
	end)

	PlayerStatManager:setupCharacter(player) -- TODO: Find out why we have this twice
end

local function setDataRetryWrapper(playerUserId, updateFunc, datastore, retries)
	local backoffExponent = 2 -- cubed exponential backoff. 1 second, 4 seconds, 8 seconds
	local tries = 0
	local success, result
	repeat
		tries = tries + 1
		success, result = pcall(function()
			datastore:UpdateAsync(playerUserId, updateFunc)
		end)

		if not success and tries < retries then
			local waitTime = math.pow(tries, backoffExponent)
			warn(
				"Failed to save player data for "
					.. playerUserId
					.. ' error: "'
					.. tostring(result)
					.. '". We will wait '
					.. tostring(waitTime)
					.. " seconds"
			)
			task.wait(waitTime)
		end
	until tries >= retries or success

	if not success then
		return false, result
	end

	return true, nil
end

local function persistPlayerData(player, retries)
	local playerUserId = "Player_" .. player.UserId

	if sessionData[playerUserId] then
		local data = sessionData[playerUserId]

		-- Check if data has changed from the previous session or not
		if not luaUtils:tablesEqual(data, prevSessionData[playerUserId]) then
			print("Data has changed for " .. playerUserId .. " persisting")

			-- print("data: ", data)
			-- data:   ▼  {
			-- 	["Items"] = {},
			-- 	["LastLoginDate"] = 8,
			-- 	["TotalTimePlayed"] = 0,
			-- 	["Wheat"] = 176,
			-- 	["playerName"] = "QuestioningCarl",
			-- 	["totalWheatEarned"] = 176
			--  }

			-- print("data.NoValidate: ", data.NoValidate)
			-- data.NoValidate:  nil

			-- local shouldValidate = data and not data.NoValidate

			local updateFunc = function(oldData)
				-- print("oldData: ", oldData)
				-- oldData:   ▼  {
				--     ["LastLoginDate"] = 7,
				--     ["TotalTimePlayed"] = 0,
				--     ["Wheat"] = 175,
				--     ["totalWheatEarned"] = 175
				--  }

				-- print("shouldValidate: ", shouldValidate)
				-- shouldValidate:  true

				-- if oldData ~= nil and shouldValidate then
				-- 	warn("Player data validation failed for " .. playerUserId .. " NOT SAVING DATA.")
				-- 	return nil
				-- end

				return data
			end

			local result, err = setDataRetryWrapper(playerUserId, updateFunc, dataStores.playerData, retries)

			if not result then
				warn("Failed to persist to PlayerData " .. playerUserId .. ". Error: " .. tostring(err))
				playersWithFailedSaves[playerUserId] = os.time()
			end

			-- if prevSessionData[playerUserId] == nil or data.Fame > prevSessionData[playerUserId].Fame then
			-- 	local updateFuncFame = function(fameValue)
			-- 		if fameValue ~= nil and shouldValidate and fameValue > data.Fame then
			-- 			warn(
			-- 				"Player data fame validation failed for "
			-- 					.. playerUserId
			-- 					.. ": fame has decreased. NOT SAVING DATA."
			-- 			)
			-- 			return nil
			-- 		end

			-- 		return data.Fame
			-- 	end
			-- 	local resultFame, errorFame = setDataRetryWrapper(
			-- 		playerUserId,
			-- 		updateFuncFame,
			-- 		dataStores.playerDataFame,
			-- 		1
			-- 	)
			-- 	if not resultFame then
			-- 		warn("Failed to persist to PlayerFame " .. playerUserId .. ". Error: " .. tostring(errorFame))
			-- 	end
			-- end

			data["NoValidate"] = nil

			if result then
				-- Set previous persist data.
				prevSessionData[playerUserId] = luaUtils:copyTable(data)

				if playersWithFailedSaves[playerUserId] then
					playersWithFailedSaves[playerUserId] = nil
				end
			end
		else
			print("Data has not changed for " .. playerUserId)
		end
	end
end

function PlayerStatManager:calculateTotalPlayTime(player, timeType)
	local playerUserId = "Player_" .. player.UserId

	if not sessionData[playerUserId] then
		return
	end

	if not sessionData[playerUserId][timeType] or not sessionData[playerUserId]["CurrentSessionStartTime"] then
		return
	end
	local sessionTime = math.max(0, os.time() - sessionData[playerUserId]["CurrentSessionStartTime"])

	local totalPlaytime = sessionData[playerUserId][timeType] + sessionTime

	return totalPlaytime
end

local function saveOnExit(player)
	local playerUserId = "Player_" .. player.UserId

	local retries = 2

	local suc, res = pcall(function()
		--add to total time
		local totalPlaytime = PlayerStatManager:calculateTotalPlayTime(player, "TotalTimePlayed")

		if totalPlaytime then
			local sessionPlayTime = totalPlaytime - sessionData[playerUserId]["TotalTimePlayed"]

			sessionData[playerUserId]["TotalTimePlayed"] = totalPlaytime
			sessionData[playerUserId]["DailyPlayTime"] = sessionData[playerUserId]["DailyPlayTime"] + sessionPlayTime
		end

		persistPlayerData(player, retries)
	end)

	-- Ensure we remove their data.
	sessionData[playerUserId] = nil

	playersWithFailedSaves[playerUserId] = nil

	-- ClubLeaderboard:clear(playerUserId, "Fame")
	-- ClubLeaderboard:clear(playerUserId, "Stars")

	if not suc then
		warn("Failed to save player data " .. player.Name .. " error: " .. tostring(res))
		return
	end

	print("Saved player data on exit for " .. player.Name)
end

local function persistAllData(retries)
	for _, player in pairs(game.Players:GetPlayers()) do
		local playerUserId = "Player_" .. player.UserId

		local suc, result = pcall(function()
			persistPlayerData(player, retries)
		end)

		if not suc then
			print("Failed to persist data for " .. playerUserId .. " reason: " .. result)
		end
	end
end

-- Function to periodically save player data
local function autoSave()
	-- We don't retry in the autosave loop. If it fails the first time, hope we
	-- get it in the next loop. We aggresively retry on player remove.
	local retries = 0

	while task.wait(AUTOSAVE_INTERVAL) do
		persistAllData(retries)
	end
end

function PlayerStatManager:GetPlayerHistory(player)
	local playerUserId = "Player_" .. player.UserId

	local historyData = {}

	historyData.CoinsValue = sessionData[playerUserId]["totalCoinsEarned"] or 0
	historyData.WheatValue = sessionData[playerUserId]["totalWheatEarned"] or 0
	historyData.WoodValue = sessionData[playerUserId]["totalWoodEarned"] or 0
	historyData.CarrotsValue = sessionData[playerUserId]["totalCarrotsEarned"] or 0
	historyData.TotalTimePlayed = self:calculateTotalPlayTime(player, "TotalTimePlayed") or 0

	return historyData
end

function PlayerStatManager:GetStat(player, statName)
	local playerUserId = "Player_" .. player.UserId
	if sessionData[playerUserId] then
		return sessionData[playerUserId][statName]
	end
end

-- Function that other scripts can call to change a player's stats
function PlayerStatManager:ChangeStat(player, statName, value)
	local playerUserId = "Player_" .. player.UserId

	if not luaUtils:checkDsFriendlyTypes(value) then
		warn("ChangeStat: Invalid type for value: " .. tostring(statName))
		return
	end

	if sessionData then
		print("sessionData: ", sessionData)
	end

	if playerUserId then
		print("playerUserId: ", playerUserId)
	end

	if statName then
		print("statName: ", statName)
	end

	if value then
		print("Value: ", value)
		print('typeof(value) == "number": ', typeof(value) == "number")
	end

	print("sessionData[playerUserId]: ", sessionData[playerUserId])

	if not sessionData[playerUserId][statName] and typeof(value) == "number" then
		sessionData[playerUserId][statName] = 0
	end

	-- assert(typeof(sessionData[playerUserId][statName]) == typeof(value), "ChangeStat error: types do not match")

	if typeof(sessionData[playerUserId][statName]) == "number" then
		sessionData[playerUserId][statName] = sessionData[playerUserId][statName] + value
	else
		sessionData[playerUserId][statName] = value
	end

	if statName == "Coins" then
		print("stat name is coins")
		player:WaitForChild("Coins").Value = sessionData[playerUserId][statName]

		if value > 0 then
			if not sessionData[playerUserId].totalCoinsEarned then
				sessionData[playerUserId].totalCoinsEarned = 0
			end

			sessionData[playerUserId].totalCoinsEarned = sessionData[playerUserId].totalCoinsEarned + value
		end
	end

	if statName == "Wheat" then
		player:WaitForChild("Wheat").Value = sessionData[playerUserId][statName]

		if value > 0 then
			if not sessionData[playerUserId].totalWheatEarned then
				sessionData[playerUserId].totalWheatEarned = 0
			end

			sessionData[playerUserId].totalWheatEarned = sessionData[playerUserId].totalWheatEarned + value
		end
	end

	if statName == "Wood" then
		player:WaitForChild("Wood").Value = sessionData[playerUserId][statName]

		if value > 0 then
			if not sessionData[playerUserId].totalWoodEarned then
				sessionData[playerUserId].totalWoodEarned = 0
			end

			sessionData[playerUserId].totalWoodEarned = sessionData[playerUserId].totalWoodEarned + value
		end
	end

	if statName == "Carrots" then
		player:WaitForChild("Carrots").Value = sessionData[playerUserId][statName]

		if value > 0 then
			if not sessionData[playerUserId].totalCarrotsEarned then
				sessionData[playerUserId].totalCarrotsEarned = 0
			end

			sessionData[playerUserId].totalCarrotsEarned = sessionData[playerUserId].totalCarrotsEarned + value
		end
	end
end

-- Start running "autoSave()" function in the background
task.spawn(autoSave)

game.Players.PlayerRemoving:Connect(saveOnExit)

-- Set up the players data on join
game.Players.PlayerAdded:Connect(function(player)
	setupPlayerData(player)
end)

return PlayerStatManager
