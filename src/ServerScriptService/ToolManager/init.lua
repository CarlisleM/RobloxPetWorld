function GetToolServices()
	return {
		Axe = require(script:WaitForChild("Axe")).new(),
		Pickaxe = require(script:WaitForChild("Pickaxe")).new(),
		Shovel = require(script:WaitForChild("Shovel")).new(),
		Sickle = require(script:WaitForChild("Sickle")).new(),
		WheatHoe = require(script:WaitForChild("WheatHoe")).new(),
	}
end

local ToolManager = {}
ToolManager.__index = ToolManager

function ToolManager.new(services)
	print("ToolManager.new")
	local output = {}
	setmetatable(output, ToolManager)
	output.services = services or GetToolServices()
	return output
end

function ToolManager:start(ToolServerManager, catalog)
	local createToolEvent = Instance.new("RemoteEvent")
	createToolEvent.Name = "CreateToolEvent"
	createToolEvent.Parent = game.ReplicatedStorage
	createToolEvent.OnServerEvent:Connect(function(player, tool)
		self:createTool(player, tool)
	end)

	self.catalog = catalog

	for _, service in pairs(self.services) do
		service:start(ToolServerManager, catalog)
	end
end

function ToolManager:createTool(player, tool)
	local playerTool = game.ReplicatedStorage:WaitForChild("Tools"):WaitForChild(tool)
	local newTool = playerTool:Clone()
	newTool.Parent = player.Backpack
end

function ToolManager:getService(model, config)
	if not model then
		warn("ToolManager: No model passed to addItem.")
		return
	end

	local itemData = self.catalog[model.Name]
	if not itemData then
		warn("ToolManager: model not found in catalog " .. tostring(model.Name))
		return
	end

	if not itemData.InteractableType then
		warn("ToolManager: model not interactable " .. tostring(model.Name))
		return
	end

	local service = self.services[itemData.InteractableType]
	if not service then
		warn("ToolManager: unknown interactable type " .. tostring(itemData.InteractableType))
		return
	end

	return service
end

function ToolManager:addItem(model, loadedData)
	local service = self:getService(model)
	if not service then
		return
	end

	service:addItem(model, loadedData)
end

function ToolManager:removeItem(model)
	local service = self:getService(model)
	if not service then
		return
	end

	service:removeItem(model)
end

return ToolManager
