-- local RHM = require(game.ReplicatedStorage:WaitForChild("RobloxHelperModule"))

local swing_animation

local sickleConnect = nil
local Sickle = {}
Sickle.__index = Sickle

function Sickle.new(model)
	print("Called Sickle.new")
	local output = {}
	setmetatable(output, Sickle)
	output.model = model
	output.event = game.ReplicatedStorage:WaitForChild("SickleSwingEvent")

	return output
end

function Sickle:start()
	print("Sickle:start in Client")
	self.callbacks = {}

	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	if sickleConnect == nil then
		sickleConnect = character.ChildAdded:Connect(function(child)
			if child.Name == "Sickle" then
				self.sickle = child
				self:setupSickle()
			end
		end)
	end
end

function Sickle:setupSickle()
	print("Sickle:setupSickle in Client")

	if self.callbacks then
		-- RHM.clearCallbacks(self.callbacks)
	end

	self.callbacks = {}

	if not self.sickle then
		return
	end

	local callback = self.sickle.Activated:connect(function()
		self:onActivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.sickle.Deactivated:connect(function()
		self:onDeactivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.sickle.Equipped:connect(function()
		self:onEquipped()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.sickle.Unequipped:connect(function()
		self:onUnequipped()
	end)
	table.insert(self.callbacks, callback)
end

local active = false
local cooldown = 0.5

function Sickle:onActivated()
	active = true
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

	while active do
		if not self.AnimationTrack.IsPlaying then
			if humanoid then
				self.AnimationTrack.Looped = false
				self.AnimationTrack.Priority = "Action"
				self.AnimationTrack:Play()
				self.event:FireServer(self.sickle)
			end
		end

		task.wait(cooldown)
	end
end

function Sickle:onDeactivated()
	active = false
end

function Sickle:onEquipped()
	if self.isEquipped then
		return
	end

	self.isEquipped = true

	self.character = self.sickle.Parent
	self.hrp = self.character:WaitForChild("HumanoidRootPart")

	self.humanoid = self.character:WaitForChild("Humanoid")
	if self.humanoid then
		self.AnimationTrack = self.humanoid:LoadAnimation(swing_animation)
	end
end

function Sickle:onUnequipped()
	active = false
end

--//////////////////////////////////////////////
local SickleClientService = {}
SickleClientService.__index = SickleClientService

function SickleClientService.new()
	local output = {}
	setmetatable(output, SickleClientService)
	output.activeItems = {}

	swing_animation = Instance.new("Animation")
	swing_animation.Name = "SwingToolAnim"
	swing_animation.AnimationId = "rbxassetid://522635514"

	return output
end

function SickleClientService:addItem(model)
	if self.activeItems[model] then
		print("SickleClientService: item already managed.")
		return
	end

	local sickle = Sickle.new(model)
	self.activeItems[model] = sickle
	sickle:start()
end

function SickleClientService:removeItem(model)
	if not self.activeItems[model] then
		print("SickleClientService: item not already managed.")
		return
	end

	self.activeItems[model] = nil
end

return SickleClientService
