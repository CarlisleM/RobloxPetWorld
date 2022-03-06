local Eggs = {}

Eggs.Common = {
	{ name = "Chicken", eggType = "Common", rarity = 0.1 },
	{ name = "Bat", eggType = "Common", rarity = 0.45 },
	{ name = "Deer", eggType = "Common", rarity = 0.45 },
}

Eggs.Rare = {
	{ name = "Rat", eggType = "Rare", rarity = 0.5 },
	{ name = "Cat", eggType = "Rare", rarity = 0.5 },
}

Eggs.Legendary = {
	{ name = "Dog", eggType = "Legendary", rarity = 0.5 },
	{ name = "Snake", eggType = "Legendary", rarity = 0.5 },
}

return Eggs

-- TODO: At run time, check that egg rarity from each category adds up to 1
