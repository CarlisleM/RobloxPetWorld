local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local GambleClient = {}
GambleClient.__index = GambleClient

game.ReplicatedStorage:WaitForChild("Roact")
local Roact = require(game.ReplicatedStorage.Roact)

script:WaitForChild("InvestedPlayerGui")
local InvestedPlayerGui = require(script.InvestedPlayerGui)
local GambleTimeLeftVariable = ReplicatedStorage:WaitForChild("GambleTimeLeftVariable")

-- local Players = game:GetService("Players")

function GambleClient.new()
	return setmetatable({}, GambleClient)
end

function GambleClient:start()
	self.Player = game.Players.LocalPlayer
	self.PlayerGui = self.Player:WaitForChild("PlayerGui")

	self.playerUserId = nil

	self.callbacks = {}
	self.gambleTreeMap = {}

	table.insert(
		self.callbacks,
		GambleTimeLeftVariable.Changed:Connect(function()
			self.decodedGambleTimeLeftVariable = HttpService:JSONDecode(GambleTimeLeftVariable.Value)
			if self.decodedGambleTimeLeftVariable == 0 then
				self:_closeGambleGui()
			end
		end)
	)

	local InvestedIntoPotEvent: RemoteEvent = game.ReplicatedStorage:WaitForChild("InvestedIntoPotEvent")
	self.investedEvent = InvestedIntoPotEvent.OnClientEvent:Connect(function(player, amountInvested)
		self.playerUserId = player.UserId

		if self.gambleTreeMap[self.Player.UserId] then
			return
		end
		self:_showCurrentInvestment(amountInvested)
	end)
	table.insert(self.callbacks, self.investedEvent)
end

function GambleClient:_showCurrentInvestment(amountInvested)
	self:_closeGambleGui()

	local tree = Roact.mount(
		Roact.createElement(InvestedPlayerGui, {
			amountInvested = amountInvested,
		}),
		self.PlayerGui,
		"InvestedPlayerGui"
	)
	self.gambleTreeMap[self.Player.UserId] = tree
end

function GambleClient:_closeGambleGui()
	if self.gambleTreeMap[self.Player.UserId] then
		Roact.unmount(self.gambleTreeMap[self.Player.UserId])
		self.gambleTreeMap[self.Player.UserId] = nil
	end
end

function GambleClient:teardown()
	self.investedEvent:Disconnect()
	self.investedEvent = nil
end

return GambleClient
