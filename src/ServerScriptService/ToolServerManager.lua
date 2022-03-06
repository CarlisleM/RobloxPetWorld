--!strict
local ToolServerManager = {}
ToolServerManager.__index = ToolServerManager

function ToolServerManager.new()
	local output = {}
	setmetatable(output, ToolServerManager)
	return output
end

function ToolServerManager:start()
	print("Start server manager")
	-- self.catalog = require(game.ReplicatedStorage:WaitForChild("ConfigModules"):WaitForChild("FurnitureItems"))
	self.ToolManager = require(script.Parent:WaitForChild("ToolManager")).new()
	self.ToolManager:start(self, self.catalog)
end

function ToolServerManager:finish() end

function ToolServerManager:makeNewItem(player, itemName)
	-- print(string.format("Player %s has requested to create new item %s", player.Name, itemName))

	-- self.ToolManager:addItem(furnitureItem)
end

return ToolServerManager
