local Client = require(script.Parent:WaitForChild("Client"))

local function stopClient()
	-- Client:finish()
end

local function startClient()
	-- stopClient()
	Client:start()
end

game.ReplicatedStorage:WaitForChild("StartClientEvent").OnClientEvent:Connect(startClient)
game.ReplicatedStorage:WaitForChild("StopClientEvent").OnClientEvent:Connect(stopClient)
