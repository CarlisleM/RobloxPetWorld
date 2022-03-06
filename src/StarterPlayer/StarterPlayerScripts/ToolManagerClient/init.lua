--!strict
function GetToolClientServices()
	return {
		Axe = require(script:WaitForChild("AxeClientService")).new(),
		Pickaxe = require(script:WaitForChild("PickaxeClientService")).new(),
		Shovel = require(script:WaitForChild("ShovelClientService")).new(),
		Sickle = require(script:WaitForChild("SickleClientService")).new(),
		WheatHoe = require(script:WaitForChild("WheatHoeClientService")).new(),
	}
end

local ToolManagerClient = {}
ToolManagerClient.__index = ToolManagerClient

function ToolManagerClient.new(services)
	local output = {}
	setmetatable(output, ToolManagerClient)
	output.services = services or GetToolClientServices()
	return output
end

function ToolManagerClient:start()
	print("ToolManagerClient:start")
	self.catalog = require(game.ReplicatedStorage:WaitForChild("ConfigModules"):WaitForChild("Tools"))

	self.modelToServiceMap = {}
	self.modelToConfigMap = {}

	for itemName, item in pairs(self.catalog) do
		if item.InteractableType and self.services[item.InteractableType] then
			self.modelToServiceMap[itemName] = self.services[item.InteractableType]
			self.modelToConfigMap[itemName] = item.InteractableConfig
		end
	end

	local toolsFolder = game.ReplicatedStorage:WaitForChild("Tools") -- used to be workspace folder
	local toolsItems = toolsFolder:GetChildren()
	toolsFolder.DescendantRemoving:Connect(function(child)
		self:removeItem(child)
	end)
	toolsFolder.DescendantAdded:Connect(function(child)
		self:addItem(child)
	end)

	for _, child in pairs(toolsItems) do
		self:addItem(child)
	end
end

function ToolManagerClient:addItem(model)
	local service = self.modelToServiceMap[model.Name]
	if service then
		service:addItem(model, self.modelToConfigMap[model.Name], self.catalog)
	end
end

function ToolManagerClient:removeItem(model)
	local service = self.modelToServiceMap[model.Name]
	if service then
		service:removeItem(model)
	end
end

return ToolManagerClient
