--!strict
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

local Shovel = {}
Shovel.__index = Shovel

function Shovel.new(model)
	local self = {}
	setmetatable(self, Shovel)
	self.model = model

	return self
end

function Shovel:start()
	print("Start Shovel in ServerScriptService")
end

function Shovel:finish() end

local ShovelService = {}
ShovelService.__index = ShovelService

function ShovelService.new()
	local output = {}
	setmetatable(output, ShovelService)
	return output
end

function ShovelService:start(ToolServerManager, catalog)
	print("Start ShovelService in ServerScriptService")
	self.ToolServerManager = ToolServerManager
	self.catalog = catalog

	self.activeModels = {}

	local shovelSwingEvent = Instance.new("RemoteEvent")
	shovelSwingEvent.Name = "ShovelSwingEvent"
	shovelSwingEvent.Parent = game.ReplicatedStorage
	shovelSwingEvent.OnServerEvent:Connect(function(player, tool)
		self:swing(player, tool)
	end)
end

function ShovelService:addItem(model)
	if self.activeModels[model] then
		warn("Already have an active model for " .. model.Name)
		return
	end

	local shovel = Shovel.new(model)
	self.activeModels[model] = shovel
	shovel:start()
end

function ShovelService:removeItem(model)
	if not self.activeModels[model] then
		warn("No active model for " .. model.Name)
		return
	end

	local shovel = self.activeModels[model]
	self.activeModels[model] = nil
	shovel:finish()
	shovel = nil
end

local pollen = 0
local MAX_POLLEN = 100

local hitPart = game.ReplicatedStorage:WaitForChild("Stamp")

function ShovelService:swing(player, tool)
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

return ShovelService
