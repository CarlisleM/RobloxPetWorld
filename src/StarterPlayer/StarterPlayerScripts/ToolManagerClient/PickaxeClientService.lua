-- local RHM = require(game.ReplicatedStorage:WaitForChild("RobloxHelperModule"))

local swing_animation

local pickaxeConnect = nil
local Pickaxe = {}
Pickaxe.__index = Pickaxe

function Pickaxe.new(model)
	print("Called Pickaxe.new")
	local output = {}
	setmetatable(output, Pickaxe)
	output.model = model
	output.event = game.ReplicatedStorage:WaitForChild("PickaxeSwingEvent")

	return output
end

function Pickaxe:start()
	print("Pickaxe:start in Client")
	self.callbacks = {}

	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	if pickaxeConnect == nil then
		pickaxeConnect = character.ChildAdded:Connect(function(child)
			if child.Name == "Pickaxe" then
				self.pickaxe = child
				self:setupPickaxe()
			end
		end)
	end
end

function Pickaxe:setupPickaxe()
	print("Pickaxe:setupPickaxe in Client")

	if self.callbacks then
		-- RHM.clearCallbacks(self.callbacks)
	end

	self.callbacks = {}

	if not self.pickaxe then
		return
	end

	local callback = self.pickaxe.Activated:connect(function()
		self:onActivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.pickaxe.Deactivated:connect(function()
		self:onDeactivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.pickaxe.Equipped:connect(function()
		self:onEquipped()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.pickaxe.Unequipped:connect(function()
		self:onUnequipped()
	end)
	table.insert(self.callbacks, callback)
end

local active = false
local cooldown = 0.5

function Pickaxe:onActivated()
	active = true
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

	while active do
		if not self.AnimationTrack.IsPlaying then
			if humanoid then
				self.AnimationTrack.Looped = false
				self.AnimationTrack.Priority = "Action"
				self.AnimationTrack:Play()
				self.event:FireServer(self.pickaxe)
			end
		end

		task.wait(cooldown)
	end
end

function Pickaxe:onDeactivated()
	active = false
end

function Pickaxe:onEquipped()
	if self.isEquipped then
		return
	end

	self.isEquipped = true

	self.character = self.pickaxe.Parent
	self.hrp = self.character:WaitForChild("HumanoidRootPart")

	self.humanoid = self.character:WaitForChild("Humanoid")
	if self.humanoid then
		self.AnimationTrack = self.humanoid:LoadAnimation(swing_animation)
	end
end

function Pickaxe:onUnequipped()
	active = false
end

--//////////////////////////////////////////////
local PickaxeClientService = {}
PickaxeClientService.__index = PickaxeClientService

function PickaxeClientService.new()
	local output = {}
	setmetatable(output, PickaxeClientService)
	output.activeItems = {}

	swing_animation = Instance.new("Animation")
	swing_animation.Name = "SwingToolAnim"
	swing_animation.AnimationId = "rbxassetid://522635514"

	return output
end

function PickaxeClientService:addItem(model)
	if self.activeItems[model] then
		print("PickaxeClientService: item already managed.")
		return
	end

	local pickaxe = Pickaxe.new(model)
	self.activeItems[model] = pickaxe
	pickaxe:start()
end

function PickaxeClientService:removeItem(model)
	if not self.activeItems[model] then
		print("PickaxeClientService: item not already managed.")
		return
	end

	self.activeItems[model] = nil
end

return PickaxeClientService
