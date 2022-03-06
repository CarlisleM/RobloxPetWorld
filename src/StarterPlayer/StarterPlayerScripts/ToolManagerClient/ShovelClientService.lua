-- local RHM = require(game.ReplicatedStorage:WaitForChild("RobloxHelperModule"))

local swing_animation

local shovelConnect = nil
local Shovel = {}
Shovel.__index = Shovel

function Shovel.new(model)
	print("Called Shovel.new")
	local output = {}
	setmetatable(output, Shovel)
	output.model = model
	output.event = game.ReplicatedStorage:WaitForChild("ShovelSwingEvent")

	return output
end

function Shovel:start()
	print("Shovel:start in Client")
	self.callbacks = {}

	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	if shovelConnect == nil then
		shovelConnect = character.ChildAdded:Connect(function(child)
			if child.Name == "Shovel" then
				self.shovel = child
				self:setupShovel()
			end
		end)
	end
end

function Shovel:setupShovel()
	print("Shovel:setupShovel in Client")

	if self.callbacks then
		-- RHM.clearCallbacks(self.callbacks)
	end

	self.callbacks = {}

	if not self.shovel then
		return
	end

	local callback = self.shovel.Activated:connect(function()
		self:onActivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.shovel.Deactivated:connect(function()
		self:onDeactivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.shovel.Equipped:connect(function()
		self:onEquipped()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.shovel.Unequipped:connect(function()
		self:onUnequipped()
	end)
	table.insert(self.callbacks, callback)
end

local active = false
local cooldown = 0.5

function Shovel:onActivated()
	print("Shovel activated")
	active = true
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

	while active do
		if not self.AnimationTrack.IsPlaying then
			if humanoid then
				self.AnimationTrack.Looped = false
				self.AnimationTrack.Priority = "Action"
				self.AnimationTrack:Play()
				self.event:FireServer(self.shovel) -- pass tool here
			end
		end

		task.wait(cooldown)
	end
end

function Shovel:onDeactivated()
	active = false
end

function Shovel:onEquipped()
	print("Shovel equipped")

	if self.isEquipped then
		return
	end

	self.isEquipped = true

	self.character = self.shovel.Parent
	self.hrp = self.character:WaitForChild("HumanoidRootPart")

	self.humanoid = self.character:WaitForChild("Humanoid")
	if self.humanoid then
		self.AnimationTrack = self.humanoid:LoadAnimation(swing_animation)
	end
end

function Shovel:onUnequipped()
	active = false
end

--//////////////////////////////////////////////
local ShovelClientService = {}
ShovelClientService.__index = ShovelClientService

function ShovelClientService.new()
	local output = {}
	setmetatable(output, ShovelClientService)
	output.activeItems = {}

	swing_animation = Instance.new("Animation")
	swing_animation.Name = "SwingToolAnim"
	swing_animation.AnimationId = "rbxassetid://522635514"

	return output
end

function ShovelClientService:addItem(model)
	if self.activeItems[model] then
		print("ShovelClientService: item already managed.")
		return
	end

	local shovel = Shovel.new(model)
	self.activeItems[model] = shovel
	shovel:start()
end

function ShovelClientService:removeItem(model)
	if not self.activeItems[model] then
		print("ShovelClientService: item not already managed.")
		return
	end

	self.activeItems[model] = nil
end

return ShovelClientService
