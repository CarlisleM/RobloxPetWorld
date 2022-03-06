local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local ServerStorage = game:GetService("ServerStorage")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local CurrencyGui = require(script.Parent:WaitForChild("PlayerCurrencyGui"))
local HotbarGui = require(script.Parent:WaitForChild("PlayerHotbarGui"))
local HotbarSlot = require(script.Parent:WaitForChild("PlayerHotbarSlot"))
local DebugMenu = require(script.Parent:WaitForChild("PlayerDebugMenuGui"))
local RunService = game:GetService("RunService")

local Client = {}

function Client:start()
	task.spawn(function()
		if RunService:IsStudio() then
			print("I am in Roblox Studio")
			self.debugMenuTree = Roact.mount(Roact.createElement(DebugMenu, {}), PlayerGui, "DebugMenuGui")
		end
	end)

	task.spawn(function()
		local PlayerInventoryManager = require(script.Parent:WaitForChild("PlayerInventoryManager")).new()
		PlayerInventoryManager:start()
	end)

	task.spawn(function()
		local EggManager = require(script.Parent:WaitForChild("EggManager")).new()
		print("Starting EggManager")
		EggManager:start()
	end)

	task.spawn(function()
		local ShopManager = require(script.Parent:WaitForChild("ShopManager")).new()
		print("Starting ShopManager")
		ShopManager:start()
	end)

	task.spawn(function()
		local ToolManager = require(script.Parent:WaitForChild("ToolManagerClient")).new()
		ToolManager:start()
	end)

	task.spawn(function()
		print("Starting CurrencyGui")
		self.currencyGuiTree = Roact.mount(Roact.createElement(CurrencyGui, {}), PlayerGui, "CurrencyGui")
	end)

	task.spawn(function()
		local HotbarHandler = require(script.Parent:WaitForChild("HotbarHandler")).new()
		print("Starting HotbarHandler")
		HotbarHandler:start()
	end)

	task.spawn(function()
		print("Starting HotbarGui")
		self.hotbarGuiTree = Roact.mount(Roact.createElement(HotbarGui, {}), PlayerGui, "HotbarGui")
	end)

	task.spawn(function()
		print("Starting HotbarSlot")
		self.hotbarSlotTree = Roact.mount(Roact.createElement(HotbarSlot, {}), ServerStorage, "Slot")
	end)

	task.spawn(function()
		print("Starting gamble client")
		self.GambleDetector = require(script.Parent:WaitForChild("GambleDetector"))
		self.GambleDetector:start()
	end)

	task.spawn(function()
		game.ReplicatedStorage:WaitForChild("GambleClient")
		local GambleClient = require(game.ReplicatedStorage.GambleClient).new()
		GambleClient:start()
	end)

	-- task.spawn(function()
	-- 	local ZoneManager = require(script.Parent:WaitForChild("ZoneManager")).new()
	-- 	print("Starting ZoneManager")
	-- 	ZoneManager:start()
	-- end)
end

return Client
