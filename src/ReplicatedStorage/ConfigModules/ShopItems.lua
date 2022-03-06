local module = {}

module.data = {
	ItemType_ItemName = {
		Image = "rbxassetid://4996323583", -- Image for shop/inventory
		Name = "Egg_Common", -- For searching with WaitForChild
		Title = "Common Egg", -- Display name for UI
		Type = "Gacha", -- Type of item
		Price = 100, -- Price
		MaxItemLimit = 5, -- Player limited to having x amount of item at a time
		Tags = { "Egg", "Gacha" }, -- For searching
	},
}

return module
