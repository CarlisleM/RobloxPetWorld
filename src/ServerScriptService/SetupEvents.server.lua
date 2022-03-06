local StartClientEvent = Instance.new("RemoteEvent")
StartClientEvent.Name = "StartClientEvent"
StartClientEvent.Parent = game.ReplicatedStorage

local StopClientEvent = Instance.new("RemoteEvent")
StopClientEvent.Name = "StopClientEvent"
StopClientEvent.Parent = game.ReplicatedStorage

local SetupPlayerDataFinished = Instance.new("BindableEvent")
SetupPlayerDataFinished.Name = "SetupPlayerDataFinished"
SetupPlayerDataFinished.Parent = game.ServerStorage

local EquipToolEvent = Instance.new("RemoteEvent")
EquipToolEvent.Name = "EquipToolEvent"
EquipToolEvent.Parent = game.ReplicatedStorage
