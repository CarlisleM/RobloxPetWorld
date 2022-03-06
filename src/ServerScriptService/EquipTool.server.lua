game.ReplicatedStorage:WaitForChild("EquipToolEvent").OnServerEvent:Connect(function(player, tool, parent, slot)
	local character = player.Character

	if character then
		if parent ~= character then
			print("Equipping")
			character.Humanoid:UnequipTools()
			character.Humanoid:EquipTool(tool)
		else
			tool.Parent = player.Backpack
		end

		-- game.ReplicatedStorage.EquipToolEvent:FireClient(player)
	end
end)
