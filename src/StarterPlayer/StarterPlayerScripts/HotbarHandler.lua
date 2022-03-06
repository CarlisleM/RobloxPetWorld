local ServerStorage = game:GetService("ServerStorage")

-- Disable default hotbar gui
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local HotbarHandler = {}
HotbarHandler.__index = HotbarHandler

function HotbarHandler.new()
	local self = setmetatable({}, HotbarHandler)
	return self
end

function HotbarHandler:start()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local backpack = player:WaitForChild("Backpack")
	local tools = backpack:GetChildren()
	local toolConnections = {}
	local slotMax = 5
	local hotbar = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HotbarGui"):WaitForChild("Hotbar")

	local numToWord = {
		[1] = "One",
		[2] = "Two",
		[3] = "Three",
		[4] = "Four",
		[5] = "Five",
		[6] = "Six",
		[7] = "Seven",
		[8] = "Eight",
		[9] = "Nine",
	}

	local function updateHotbar()
		-- Remove all current slots
		for _, child in pairs(hotbar:GetChildren()) do
			if child.Name == "Slot" then
				child:Destroy()
			end
		end

		for _, toolConnection in pairs(toolConnections) do
			toolConnection:Disconnect()
		end

		-- Create slots for the number of tools
		for i, tool in pairs(tools) do
			if i > slotMax then
				return
			end

			local slotClone = ServerStorage:WaitForChild("Slot"):Clone()
			slotClone.ImageButton.HotkeyNumber.Text = i

			slotClone.ImageButton:WaitForChild("Icon").Image = tool:WaitForChild("ImageId").Value

			slotClone.Parent = hotbar

			-- If slot is selected
			if tool.Parent == character then
				slotClone.ImageButton.BackgroundColor3 = Color3.fromRGB(175, 119, 171)
			end

			toolConnections[i] = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
				if not processed then
					if input.KeyCode == Enum.KeyCode[numToWord[i]] then
						game.ReplicatedStorage:WaitForChild("EquipToolEvent"):FireServer(tool, tool.Parent)
					end
				end
			end)
		end
	end

	updateHotbar()

	-- Fix this logic for the case where you have mulitple of the asme tool, only remove 1
	backpack.ChildAdded:Connect(function(child)
		-- if child:IsA("Tool") and not table.find(tools, child) then
		if child:IsA("Tool") and not table.find(tools, child) then
			table.insert(tools, child)
			updateHotbar()
		else
			updateHotbar()
		end
	end)

	-- backpack.ChildRemoved:Connect(function(child)
	-- 	if child:IsA("Tool") then
	-- 		table.remove(tools, tools[child])
	-- 		updateHotbar()
	-- 	end
	-- end)

	character.ChildAdded:Connect(function(child)
		-- if child:IsA("Tool") and not table.find(tools, child) then
		if child:IsA("Tool") then
			-- table.insert(tools, child)
			updateHotbar()
		end
	end)

	-- character.ChildRemoved:Connect(function(child)
	-- 	print("Removed from character: ", child)
	-- 	if child:IsA("Tool") then
	-- 		table.remove(tools, tools[child])
	-- 		updateHotbar()
	-- 	end
	-- end)

	-- game.ReplicatedStorage.EquipToolEvent.OnClientEvent:Connect(function()
	-- 	for _, slot in pairs(hotbar:GetChildren()) do
	-- 		if slot:IsA("Frame") then
	-- 			local tool = tools[tonumber(slot.ImageButton.HotkeyNumber.Text)]

	-- 			if tool.Parent ~= character then
	-- 				slot.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
	-- 			else
	-- 				slot.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
	-- 			end
	-- 		end
	-- 	end
	-- end)
end

return HotbarHandler
