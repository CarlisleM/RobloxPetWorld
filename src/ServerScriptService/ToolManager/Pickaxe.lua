--!strict
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

local Pickaxe = {}
Pickaxe.__index = Pickaxe

function Pickaxe.new(model)
	local self = {}
	setmetatable(self, Pickaxe)
	self.model = model

	return self
end

function Pickaxe:start()
	print("Start Pickaxe in ServerScriptService")
end

function Pickaxe:finish() end

local PickaxeService = {}
PickaxeService.__index = PickaxeService

function PickaxeService.new()
	local output = {}
	setmetatable(output, PickaxeService)
	return output
end

function PickaxeService:start(ToolServerManager, catalog)
	print("Start PickaxeService in ServerScriptService")
	self.ToolServerManager = ToolServerManager
	self.catalog = catalog

	self.activeModels = {}

	local pickaxeSwingEvent = Instance.new("RemoteEvent")
	pickaxeSwingEvent.Name = "PickaxeSwingEvent"
	pickaxeSwingEvent.Parent = game.ReplicatedStorage
	pickaxeSwingEvent.OnServerEvent:Connect(function(player, tool)
		self:swing(player, tool)
	end)
end

function PickaxeService:addItem(model)
	if self.activeModels[model] then
		warn("Already have an active model for " .. model.Name)
		return
	end

	local pickaxe = Pickaxe.new(model)
	self.activeModels[model] = pickaxe
	pickaxe:start()
end

function PickaxeService:removeItem(model)
	if not self.activeModels[model] then
		warn("No active model for " .. model.Name)
		return
	end

	local pickaxe = self.activeModels[model]
	self.activeModels[model] = nil
	pickaxe:finish()
	pickaxe = nil
end

local pollen = 0
local MAX_POLLEN = 100

local hitPart = game.ReplicatedStorage:WaitForChild("Stamp")

function PickaxeService:swing(player, tool)
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

return PickaxeService
