-- local RHM = require(game.ReplicatedStorage:WaitForChild("RobloxHelperModule"))

local swing_animation

local axeConnect = nil
local Axe = {}
Axe.__index = Axe

function Axe.new(model)
	print("Called Axe.new")
	local output = {}
	setmetatable(output, Axe)
	output.model = model
	output.event = game.ReplicatedStorage:WaitForChild("AxeSwingEvent")

	return output
end

function Axe:start()
	print("Axe:start in Client")
	self.callbacks = {}

	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	if axeConnect == nil then
		axeConnect = character.ChildAdded:Connect(function(child)
			if child.Name == "Axe" then
				self.axe = child
				self:setupAxe()
			end
		end)
	end
end

function Axe:setupAxe()
	print("Axe:setupAxe in Client")

	if self.callbacks then
		-- RHM.clearCallbacks(self.callbacks)
	end

	self.callbacks = {}

	if not self.axe then
		return
	end

	local callback = self.axe.Activated:connect(function()
		self:onActivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.axe.Deactivated:connect(function()
		self:onDeactivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.axe.Equipped:connect(function()
		self:onEquipped()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.axe.Unequipped:connect(function()
		self:onUnequipped()
	end)
	table.insert(self.callbacks, callback)
end

local active = false
local cooldown = 0.5

function Axe:onActivated()
	active = true
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

	while active do
		if not self.AnimationTrack.IsPlaying then
			if humanoid then
				self.AnimationTrack.Looped = false
				self.AnimationTrack.Priority = "Action"
				self.AnimationTrack:Play()
				self.event:FireServer(self.axe) -- pass tool here
			end
		end

		task.wait(cooldown)
	end
end

function Axe:onDeactivated()
	active = false
end

function Axe:onEquipped()
	if self.isEquipped then
		return
	end

	self.isEquipped = true

	self.character = self.axe.Parent
	self.hrp = self.character:WaitForChild("HumanoidRootPart")

	self.humanoid = self.character:WaitForChild("Humanoid")
	if self.humanoid then
		self.AnimationTrack = self.humanoid:LoadAnimation(swing_animation)
	end
end

function Axe:onUnequipped()
	active = false
end

--//////////////////////////////////////////////
local AxeClientService = {}
AxeClientService.__index = AxeClientService

function AxeClientService.new()
	local output = {}
	setmetatable(output, AxeClientService)
	output.activeItems = {}

	swing_animation = Instance.new("Animation")
	swing_animation.Name = "SwingToolAnim"
	swing_animation.AnimationId = "rbxassetid://522635514"

	return output
end

function AxeClientService:addItem(model)
	if self.activeItems[model] then
		print("AxeClientService: item already managed.")
		return
	end

	local axe = Axe.new(model)
	self.activeItems[model] = axe
	axe:start()
end

function AxeClientService:removeItem(model)
	if not self.activeItems[model] then
		print("AxeClientService: item not already managed.")
		return
	end

	self.activeItems[model] = nil
end

return AxeClientService
