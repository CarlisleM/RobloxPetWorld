--!strict
local HttpService = game:GetService("HttpService")
local PlayerStatManager = require(game:GetService("ServerScriptService").PlayerStatManager)

local GambleManager = {}
GambleManager.__index = GambleManager

local MAX_PARTICIPANTS = 2
local TIME_PER_ROUND = 45
local DISPLAY_WINNERS_LENGTH = 5

function GambleManager.new()
	local self = setmetatable({}, GambleManager)
	self.callbacks = {}
	self.gambleParticipants = {}
	return self
end

function GambleManager:run()
	self:init()
	self:runLoop()
end

function GambleManager:init()
	print("Start gamble server manager")

	local SelectWinnerEvent = Instance.new("RemoteEvent")
	SelectWinnerEvent.Name = "SelectWinnerEvent"
	SelectWinnerEvent.Parent = game.ReplicatedStorage

	self.InvestedIntoPotEvent = Instance.new("RemoteEvent")
	self.InvestedIntoPotEvent.Name = "InvestedIntoPotEvent"
	self.InvestedIntoPotEvent.Parent = game.ReplicatedStorage

	self.GambleVariable = Instance.new("StringValue")
	self.GambleVariable.Name = "GambleVariable"
	self.GambleVariable.Value = HttpService:JSONEncode({})
	self.GambleVariable.Parent = game.ReplicatedStorage

	self.GambleTimeLeftVariable = Instance.new("StringValue")
	self.GambleTimeLeftVariable.Name = "GambleTimeLeftVariable"
	self.GambleTimeLeftVariable.Value = HttpService:JSONEncode({})
	self.GambleTimeLeftVariable.Parent = game.ReplicatedStorage

	self.GambleTotalVariable = Instance.new("IntValue")
	self.GambleTotalVariable.Name = "GambleTotalVariable"
	self.GambleTotalVariable.Value = 0
	self.GambleTotalVariable.Parent = game.ReplicatedStorage

	table.insert(
		self.callbacks,
		game.Players.PlayerRemoving:Connect(function(player) -- TODO: give money back
			for index, investedPlayer in pairs(self.gambleParticipants) do
				if investedPlayer.player == player then
					self.GambleTotalVariable.Value -= investedPlayer.amount
					table.remove(self.gambleParticipants, index)
					return
				end
			end
		end)
	)

	local AddPlayerToGroup = Instance.new("RemoteEvent")
	AddPlayerToGroup.Name = "AddPlayerToGroup"
	table.insert(
		self.callbacks,
		AddPlayerToGroup.OnServerEvent:Connect(function(player, amount)
			if tick() - self.runTimeStamp >= TIME_PER_ROUND then
				return
			end

			if #self.gambleParticipants >= MAX_PARTICIPANTS then
				warn("Max participants has been reached")
				return
			end

			for _, investedPlayer in pairs(self.gambleParticipants) do
				if investedPlayer.player == player then
					return
				end
			end

			table.insert(self.gambleParticipants, {
				["player"] = player,
				["amount"] = amount,
			})
			PlayerStatManager:ChangeStat(player, "Coins", 0 - amount)

			local potTotal = 0

			for index, investedPlayer in ipairs(self.gambleParticipants) do
				potTotal += investedPlayer.amount
				self.gambleParticipants[index] = {
					["player"] = investedPlayer.player,
					["amount"] = investedPlayer.amount,
					["potIndex"] = potTotal,
				}
			end

			self.InvestedIntoPotEvent:FireClient(player, player, amount)
			self.GambleTotalVariable.Value = potTotal
		end)
	)
	AddPlayerToGroup.Parent = game.ReplicatedStorage

	table.insert(
		self.callbacks,
		self.GambleTotalVariable.Changed:Connect(function(PotTotal)
			game.Workspace:WaitForChild("GambleDisplay"):WaitForChild("FrontSurfaceGui"):WaitForChild("Amount").Text =
				PotTotal
			game.Workspace:WaitForChild("GambleDisplay"):WaitForChild("BackSurfaceGui"):WaitForChild("Amount").Text =
				PotTotal
		end)
	)

	self:runLoop()
end

function GambleManager:runLoop()
	if self.running then
		return
	end

	print("Starting gamble loop")

	self.running = true
	self.runTimeStamp = tick()

	task.spawn(function()
		while self.running do
			if tick() - self.runTimeStamp >= TIME_PER_ROUND then
				print("Reset!")

				local frontDisplay = game.Workspace:WaitForChild("GambleDisplayBoard"):WaitForChild("FrontDisplay")
				local backDisplay = game.Workspace:WaitForChild("GambleDisplayBoard"):WaitForChild("BackDisplay")

				local frontCountdown = game.Workspace:WaitForChild("GambleDisplayBoard"):WaitForChild("FrontCountdown")
				local backCountdown = game.Workspace:WaitForChild("GambleDisplayBoard"):WaitForChild("BackCountdown")

				local winner
				local randomnumber = math.random(1, self.GambleTotalVariable.Value)

				for _, investedPlayer in pairs(self.gambleParticipants) do
					print("looping through players to pick a winner")
					print("random number: ", randomnumber)
					print("investedPlayer.potIndex: ", investedPlayer.potIndex)
					if
						randomnumber <= investedPlayer.potIndex
						and randomnumber > investedPlayer.potIndex - investedPlayer.amount
					then
						winner = investedPlayer
					end
				end

				-- TODO: Wait until at least 2 players enter the draw
				-- Once 2 players have entered we begin the timer
				-- Add debug variable for 1 player testing to override the minimum requirement

				local randomTween = math.random(0, 1)

				if randomTween == 1 then
					frontCountdown:WaitForChild("DisplayBackground").Size = UDim2.fromScale(1, 0)
					backCountdown:WaitForChild("DisplayBackground").Size = UDim2.fromScale(1, 0)
				else
					frontCountdown:WaitForChild("DisplayBackground").Size = UDim2.fromScale(0, 0.65)
					backCountdown:WaitForChild("DisplayBackground").Size = UDim2.fromScale(0, 0.65)
				end

				frontCountdown.Enabled = true
				frontCountdown:WaitForChild("DisplayBackground")
				frontCountdown:WaitForChild("DisplayBackground"):TweenSize(
					UDim2.fromScale(1, 0.65),
					Enum.EasingDirection.In,
					Enum.EasingStyle.Sine,
					0.2, -- time
					true,
					function()
						print("Tween end")
					end
				)

				backCountdown.Enabled = true
				backCountdown:WaitForChild("DisplayBackground")
				backCountdown:WaitForChild("DisplayBackground"):TweenSize(
					UDim2.fromScale(1, 0.65),
					Enum.EasingDirection.In,
					Enum.EasingStyle.Sine,
					0.2, -- time
					true,
					function()
						print("Tween end")
					end
				)

				for countdown = 0, 9 do
					frontCountdown:WaitForChild("CountdownLabel").Text = 10 - countdown
					backCountdown:WaitForChild("CountdownLabel").Text = 10 - countdown
					task.wait(1)
				end

				frontCountdown.Enabled = false
				backCountdown.Enabled = false

				if winner then
					print("winner: ", winner.player.DisplayName)

					local Players = game:GetService("Players")

					local userId = winner.player.UserId
					local thumbType = Enum.ThumbnailType.HeadShot
					local thumbSize = Enum.ThumbnailSize.Size420x420
					local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

					frontDisplay.Enabled = true
					frontDisplay:WaitForChild("WinnerLeft").Image = content
					frontDisplay:WaitForChild("WinnerRight").Image = content
					frontDisplay:WaitForChild("PlayerWon").Text = winner.player.DisplayName
					frontDisplay:WaitForChild("AmountEntered").Text = winner.amount
					frontDisplay:WaitForChild("AmountWon").Text = self.GambleTotalVariable.Value

					backDisplay.Enabled = true
					backDisplay:WaitForChild("WinnerLeft").Image = content
					backDisplay:WaitForChild("WinnerRight").Image = content
					backDisplay:WaitForChild("PlayerWon").Text = winner.player.DisplayName
					backDisplay:WaitForChild("AmountEntered").Text = winner.amount
					backDisplay:WaitForChild("AmountWon").Text = self.GambleTotalVariable.Value

					PlayerStatManager:ChangeStat(winner.player, "Coins", self.GambleTotalVariable.Value)

					-- TODO: Display the countdown on a billboard gui (make a countdown)

					self.GambleTotalVariable.Value = 0
					self.gambleParticipants = {}
					self.runTimeStamp = tick()

					task.wait(DISPLAY_WINNERS_LENGTH)

					-- Display winner here and payout
					if frontDisplay and backDisplay then
						frontDisplay.Enabled = false
						backDisplay.Enabled = false
					end

					print("Starting the next round!")
				end
			end

			self.GambleTimeLeftVariable.Value = HttpService:JSONEncode(
				math.floor(self.runTimeStamp + TIME_PER_ROUND - tick())
			)
			self.GambleVariable.Value = HttpService:JSONEncode(self.gambleParticipants)

			task.wait(1)
		end
	end)
end

function GambleManager:stop()
	self.running = false
	self.runTimeStamp = 0
	self.callbacks = {}
	self.gambleParticipants = {}
end

return GambleManager
