--!strict
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

local WheatHoe = {}
WheatHoe.__index = WheatHoe

function WheatHoe.new(model)
	local self = {}
	setmetatable(self, WheatHoe)
	self.model = model

	return self
end

function WheatHoe:start()
	print("Start WheatHoe in ServerScriptService")
end

function WheatHoe:finish() end

local WheatHoeService = {}
WheatHoeService.__index = WheatHoeService

function WheatHoeService.new()
	local output = {}
	setmetatable(output, WheatHoeService)
	return output
end

function WheatHoeService:start(ToolServerManager, catalog)
	print("Start WheatHoeService in ServerScriptService")
	self.ToolServerManager = ToolServerManager
	self.catalog = catalog

	self.activeModels = {}

	local wheatHoeSwingEvent = Instance.new("RemoteEvent")
	wheatHoeSwingEvent.Name = "WheatHoeSwingEvent"
	wheatHoeSwingEvent.Parent = game.ReplicatedStorage
	wheatHoeSwingEvent.OnServerEvent:Connect(function(player, tool)
		self:swing(player, tool)
	end)
end

function WheatHoeService:addItem(model)
	if self.activeModels[model] then
		warn("Already have an active model for " .. model.Name)
		return
	end

	local wheatHoe = WheatHoe.new(model)
	self.activeModels[model] = wheatHoe
	wheatHoe:start()
end

function WheatHoeService:removeItem(model)
	if not self.activeModels[model] then
		warn("No active model for " .. model.Name)
		return
	end

	local wheatHoe = self.activeModels[model]
	self.activeModels[model] = nil
	wheatHoe:finish()
	wheatHoe = nil
end

local pollen = 0
local MAX_POLLEN = 100

local hitPart = game.ReplicatedStorage:WaitForChild("Stamp")

function WheatHoeService:swing(player, tool)
	print("Player: " .. player.Name .. " swung")

	if pollen < MAX_POLLEN then -- if player pollen < player pollen max
		local collisionCheck = hitPart:Clone() -- clone the stamp belonging to that tool
		collisionCheck.Parent = tool
		collisionCheck.Name = "CollisionCheck"
		collisionCheck.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)

		collisionCheck.Transparency = 0

		collisionCheck.Touched:Connect(function(part)
			if part:FindFirstChild("Resource") then
				if part.Resource.Value == "Wheat" and part.Position.Magnitude > 4 then
					-- if part.Name == "WheatFarm" and part.Position.Magnitude > 4 then

					PlayerStatManager:ChangeStat(player, "Wheat", 1)
				end
			end
		end)

		task.wait(0.10)
		collisionCheck:Destroy()
	end
end

return WheatHoeService
