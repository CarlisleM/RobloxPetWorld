--!strict
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

local Axe = {}
Axe.__index = Axe

function Axe.new(model)
	local self = {}
	setmetatable(self, Axe)
	self.model = model

	return self
end

function Axe:start()
	print("Start Axe in ServerScriptService")
end

function Axe:finish() end

local AxeService = {}
AxeService.__index = AxeService

function AxeService.new()
	local output = {}
	setmetatable(output, AxeService)
	return output
end

function AxeService:start(ToolServerManager, catalog)
	print("Start AxeService in ServerScriptService")
	self.ToolServerManager = ToolServerManager
	self.catalog = catalog

	self.activeModels = {}

	local axeSwingEvent = Instance.new("RemoteEvent")
	axeSwingEvent.Name = "AxeSwingEvent"
	axeSwingEvent.Parent = game.ReplicatedStorage
	axeSwingEvent.OnServerEvent:Connect(function(player, tool)
		self:swing(player, tool)
	end)
end

function AxeService:addItem(model)
	if self.activeModels[model] then
		warn("Already have an active model for " .. model.Name)
		return
	end

	local axe = Axe.new(model)
	self.activeModels[model] = axe
	axe:start()
end

function AxeService:removeItem(model)
	if not self.activeModels[model] then
		warn("No active model for " .. model.Name)
		return
	end

	local axe = self.activeModels[model]
	self.activeModels[model] = nil
	axe:finish()
	axe = nil
end

local pollen = 0
local MAX_POLLEN = 100

local hitPart = game.ReplicatedStorage:WaitForChild("Stamp")

function AxeService:swing(player, tool)
	if pollen < MAX_POLLEN then -- if player pollen < player pollen max
		local collisionCheck = hitPart:Clone() -- clone the stamp belonging to that tool
		collisionCheck.Parent = tool
		collisionCheck.Name = "CollisionCheck"
		collisionCheck.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)

		collisionCheck.Transparency = 0

		local debounce = false

		collisionCheck.Touched:Connect(function(part)
			if part:FindFirstChild("Resource") then
				if part.Resource.Value == "Wood" and part.Position.Magnitude > 4 then
					print("Hit wood with magnitude > 4")

					part.Health.Value = part.Health.Value - 1

					if part.Health.Value <= 0 and not debounce then
						debounce = true

						for _, treePart in pairs(part.Parent:GetChildren()) do
							treePart.Transparency = 1
							treePart.CanCollide = false
						end

						print("Change wood stat")

						PlayerStatManager:ChangeStat(player, "Wood", part.Worth.Value)

						task.wait(part.RespawnTime.Value)

						part.Health.Value = 5

						for _, treePart in pairs(part.Parent:GetChildren()) do
							treePart.Transparency = 0
							treePart.CanCollide = true
						end

						debounce = false
					end
				end
			end
		end)

		task.wait(0.10)
		collisionCheck:Destroy()
	end
end

return AxeService
