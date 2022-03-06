--!strict
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

local Sickle = {}
Sickle.__index = Sickle

function Sickle.new(model)
	local self = {}
	setmetatable(self, Sickle)
	self.model = model

	return self
end

function Sickle:start()
	print("Start Sickle in ServerScriptService")
end

function Sickle:finish() end

local SickleService = {}
SickleService.__index = SickleService

function SickleService.new()
	local output = {}
	setmetatable(output, SickleService)
	return output
end

function SickleService:start(ToolServerManager, catalog)
	print("Start SickleService in ServerScriptService")
	self.ToolServerManager = ToolServerManager
	self.catalog = catalog

	self.activeModels = {}

	local sickleSwingEvent = Instance.new("RemoteEvent")
	sickleSwingEvent.Name = "SickleSwingEvent"
	sickleSwingEvent.Parent = game.ReplicatedStorage
	sickleSwingEvent.OnServerEvent:Connect(function(player, tool)
		self:swing(player, tool)
	end)
end

function SickleService:addItem(model)
	if self.activeModels[model] then
		warn("Already have an active model for " .. model.Name)
		return
	end

	local sickle = Sickle.new(model)
	self.activeModels[model] = sickle
	sickle:start()
end

function SickleService:removeItem(model)
	if not self.activeModels[model] then
		warn("No active model for " .. model.Name)
		return
	end

	local sickle = self.activeModels[model]
	self.activeModels[model] = nil
	sickle:finish()
	sickle = nil
end

local pollen = 0
local MAX_POLLEN = 100

local hitPart = game.ReplicatedStorage:WaitForChild("Stamp")

function SickleService:swing(player, tool)
	print("Player: " .. player.Name .. " swung")

	if pollen < MAX_POLLEN then -- if player pollen < player pollen max
		local collisionCheck = hitPart:Clone() -- clone the stamp belonging to that tool
		collisionCheck.Parent = tool
		collisionCheck.Name = "CollisionCheck"
		collisionCheck.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)

		collisionCheck.Transparency = 0

		collisionCheck.Touched:Connect(function(part)
			-- if part.Name == "WheatFarm" and part.Position.Magnitude > 4 then

			-- 	PlayerStatManager:ChangeStat(player, "Wheat", 1)

			-- 	print("Player wheat amount: ", PlayerStatManager:GetStat(player, "Wheat"))
			-- end
		end)

		task.wait(0.10)
		collisionCheck:Destroy()
	end
end

return SickleService
