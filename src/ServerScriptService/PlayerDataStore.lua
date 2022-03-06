local DataStoreService = game:GetService("DataStoreService")
local myDataStore = DataStoreService:GetDataStore("myDataStore")

game.Players.PlayerAdded:Connect(function(player)
	-- local leaderstats = Instance.new("Folder")
	-- leaderstats.Name = "leaderstats"
	-- leaderstats.Parent = player

	-- local cash = Instance.new("IntValue")
	-- cash.Name = "Cash"
	-- cash.Parent = leaderstats

	-- local data

	-- local success, err = pcall(function()
	--     myDataStore:GetAsync(player.UserId .. "-cash")
	-- end)

	-- if success then
	--     cash.Balue = data
	-- else
	--     print("Error while loading data")
	--     warn(err)
	-- end
end)

game.Players.PlayerRemoving:Connect(function(player)
	-- local success, err = pcall(function()
	--     myDataStore:SetAsync(player.UserId .. "-cash", player.leaderstats.Cash.Value)
	-- end)

	-- if success then
	--     print("Data successfully saved")
	-- else
	--     print("Error while saving data")
	--     warn(err)
	-- end
end)
