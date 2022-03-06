local StartClientEvent = game.ReplicatedStorage:WaitForChild("StartClientEvent")

local Server = {}

-- local module=require(script:WaitForChild('MyVenue')),
-- module:start()

function Server:sendPlayerAddedRemovingEvents()
	game.Players.PlayerRemoving:Connect(function(player)
		-- MyVenueExitEvent:Fire(player)
	end)

	game.Players.PlayerAdded:Connect(function(player)
		print("Player Added")
		StartClientEvent:FireClient(player)
	end)
end

function Server:start()
	print("Starting server...")

	task.spawn(function()
		print("Attempting to start ToolServerManager")
		local ToolServerManager = require(script.Parent:WaitForChild("ToolServerManager")).new()
		ToolServerManager:start()
	end)

	task.spawn(function()
		print("Attempting to start gamble manager")
		local GambleManager = require(script.Parent:WaitForChild("GambleManager")) -- Should this be replicated storage?
		local gambleManager = GambleManager.new()
		gambleManager:run()
	end)

	task.spawn(function()
		self:sendPlayerAddedRemovingEvents()
	end)
end

function Server:finish()
	-- game.Workspace.Env_Club.Parent = ServerStorage.ClubThemeModels.MyVenue
	-- game.Workspace.Env_Boundaries.Parent = ServerStorage.ClubThemeModels.MyVenue
	-- game.Workspace.Env_GamePlay.Parent = ServerStorage.ClubThemeModels.MyVenue
	-- game.Workspace.SpawnPoints.Parent = ServerStorage.ClubThemeModels.MyVenue

	print("Finished Server")
end

Server:start()

-- game:GetService("Players").PlayerAdded:Connect(function(player)
-- 	print("Start")
-- 	-- player:SetAttribute("ZoneLocation", "Default")
-- 	-- player:SetAttribute("CurrentTool", "None")
-- 	StartClientEvent:FireClient(player)
-- end)

return Server
