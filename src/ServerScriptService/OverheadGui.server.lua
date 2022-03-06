-- TODO: Setup rank system

game.Players.PlayerAdded:Connect(function(player)
	local character = player.Character or player.CharacterAdded:Wait()

	local overheadGui = Instance.new("BillboardGui")
	overheadGui.MaxDistance = 25
	overheadGui.Size = UDim2.fromScale(2, 1)
	overheadGui.ExtentsOffsetWorldSpace = Vector3.new(0, 2.75, 0)
	overheadGui.Name = "PlayerTitleGui"

	local playerTitle = Instance.new("TextLabel")
	playerTitle.Text = "Rookie"
	playerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	playerTitle.Size = UDim2.fromScale(1, 1)
	playerTitle.TextScaled = true
	playerTitle.BackgroundTransparency = 1

	playerTitle.Parent = overheadGui

	task.wait(0.1)
	-- Alternative to wait is to use player.Name which also isn't ideal
	-- headGui.Parent = game.Workspace:WaitForChild(player.Name).Head

	overheadGui.Parent = character:WaitForChild("Head")
end)
