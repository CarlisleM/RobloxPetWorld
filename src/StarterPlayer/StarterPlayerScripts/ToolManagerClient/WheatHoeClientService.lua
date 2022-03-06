-- local RHM = require(game.ReplicatedStorage:WaitForChild("RobloxHelperModule"))

local swing_animation

local wheatHoeConnect = nil
local WheatHoe = {}
WheatHoe.__index = WheatHoe

function WheatHoe.new(model)
	print("Called WheatHoe.new")
	local output = {}
	setmetatable(output, WheatHoe)
	output.model = model
	output.event = game.ReplicatedStorage:WaitForChild("WheatHoeSwingEvent")

	return output
end

function WheatHoe:start()
	print("WheatHoe:start in Client")
	self.callbacks = {}

	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	if wheatHoeConnect == nil then
		wheatHoeConnect = character.ChildAdded:Connect(function(child)
			if child.Name == "WheatHoe" then
				self.wheatHoe = child
				self:setupWheatHoe()
			end
		end)
	end
end

function WheatHoe:setupWheatHoe()
	print("WheatHoe:setupWheatHoe in Client")

	if self.callbacks then
		-- RHM.clearCallbacks(self.callbacks)
	end

	self.callbacks = {}

	if not self.wheatHoe then
		return
	end

	local callback = self.wheatHoe.Activated:connect(function()
		self:onActivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.wheatHoe.Deactivated:connect(function()
		self:onDeactivated()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.wheatHoe.Equipped:connect(function()
		self:onEquipped()
	end)
	table.insert(self.callbacks, callback)
	local callback = self.wheatHoe.Unequipped:connect(function()
		self:onUnequipped()
	end)
	table.insert(self.callbacks, callback)
end

local active = false
local cooldown = 0.5

function WheatHoe:onActivated()
	active = true
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

	while active do
		if not self.AnimationTrack.IsPlaying then
			if humanoid then
				self.AnimationTrack.Looped = false
				self.AnimationTrack.Priority = "Action"
				self.AnimationTrack:Play()
				self.event:FireServer(self.wheatHoe) -- pass tool here
			end
		end

		task.wait(cooldown)
	end
end

function WheatHoe:onDeactivated()
	active = false
end

function WheatHoe:onEquipped()
	if self.isEquipped then
		return
	end

	self.isEquipped = true

	self.character = self.wheatHoe.Parent
	self.hrp = self.character:WaitForChild("HumanoidRootPart")

	self.humanoid = self.character:WaitForChild("Humanoid")
	if self.humanoid then
		self.AnimationTrack = self.humanoid:LoadAnimation(swing_animation)
	end
end

function WheatHoe:onUnequipped()
	active = false
end

--//////////////////////////////////////////////
local WheatHoeClientService = {}
WheatHoeClientService.__index = WheatHoeClientService

function WheatHoeClientService.new()
	local output = {}
	setmetatable(output, WheatHoeClientService)
	output.activeItems = {}

	swing_animation = Instance.new("Animation")
	swing_animation.Name = "SwingToolAnim"
	swing_animation.AnimationId = "rbxassetid://522635514"

	return output
end

function WheatHoeClientService:addItem(model)
	if self.activeItems[model] then
		print("WheatHoeClientService: item already managed.")
		return
	end

	local wheatHoe = WheatHoe.new(model)
	self.activeItems[model] = wheatHoe
	wheatHoe:start()
end

function WheatHoeClientService:removeItem(model)
	if not self.activeItems[model] then
		print("WheatHoeClientService: item not already managed.")
		return
	end

	self.activeItems[model] = nil
end

return WheatHoeClientService
