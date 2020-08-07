ArmorItemDB =
{
	[-1] =
	{
	name = "",
	type = "",
	slot = "",
	description = "",
	price = 0,
	texture = "",
	stats = 
	{
	},
},

--First item in seven - cleric
{
	name = "Holey Robes",
	type = "cleric",
	slot = "armor",
	description = "Blessed be the weak!  This only looks like a dirty blanket it's actually blessed vestments.",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--second mage
{
	name = "'Magick' Robes",
	type = "mage",
	slot = "armor",
	description = "There's nothing more mogical than imagination right?",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--third warrior
{
	name = "Wooden Helmet",
	type = "warrior",
	slot = "armor",
	description = "The bucket shape helps deflect blows!",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--fourth ranger
{
	name = "Cloak",
	type = "ranger",
	slot = "armor",
	description = "I mean technically anything wrapped around your neck is a cloak.",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--fifth druid
{
	name = "Girding Cloth",
	type = "druid",
	slot = "armor",
	description = "You're loins have never felt so cloth-ed",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--sixth bard
{
	name = "Boutonniere",
	type = "bard",
	slot = "armor",
	description = "A lovely floral decoration that certainly is not a weed",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--seventh thief
{
	name = "Cape",
	type = "thief",
	slot = "armor",
	description = "I mean technically anything wrapped around your neck is a cape.",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},

--First item in seven - cleric
{
	name = "Even Holey-er Robes",
	type = "cleric",
	slot = "armor",
	description = "Now with more holes!  I mean holiness.",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{wis = 5}, },
},
--second mage
{
	name = "Warm Robes",
	type = "mage",
	slot = "armor",
	description = "Double thick!",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{int = 5}, },
},
--third warrior
{
	name = "Metal Helmet",
	type = "warrior",
	slot = "armor",
	description = "It may seem the eye-holes are off center, but that will throw your enemies off too!",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{str = 5}, },
},
--fourth ranger
{
	name = "Cloak of Concealment",
	type = "ranger",
	slot = "armor",
	description = "The dark color makes the blank-  I mean cloak better camouflage.",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{dex = 5}, },
},
--fifth druid
{
	name = "Guarding Cloth",
	type = "druid",
	slot = "armor",
	description = "I'm not sure why this cloth stands up on it's own.",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{wis = 4},
						{int = 1}, },
},
--sixth bard
{
	name = "Boutonniere Bouquet",
	type = "bard",
	slot = "armor",
	description = "More is always better right?",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{chr = 5}, },
},
--seventh thief
{
	name = "Dark Cape",
	type = "thief",
	slot = "armor",
	description = "The dark color makes the blank-  I mean cape better camouflage.",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{str = 2},
						{dex = 2},
						{chr = 1}, },
},

--First item in seven - cleric
{
	name = "Holy Object",
	type = "cleric",
	slot = "armor",
	description = "Radiates some sort of Spirit Energy, goes with your aura",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{wis = 10}, },
},
--second mage
{
	name = "Book with Odd Symbols",
	type = "mage",
	slot = "armor",
	description = "Very Possibly an Actual Spellbook",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{int = 10}, },
},
--third warrior
{
	name = "Metal Sword",
	type = "warrior",
	slot = "armor",
	description = "Not sure what metal it's made of, but it's shiny!",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{str = 10}, },
},
--fourth ranger
{
	name = "Bow",
	type = "ranger",
	slot = "armor",
	description = "An actual bow!  No arrows, but I'm sure you can find some...",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{dex = 10}, },
},
--fifth druid
{
	name = "Member's Only Club",
	type = "druid",
	slot = "armor",
	description = "Chrome metal handle, hardwood shaft, beautiful leather cord",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{wis = 8},
						{int = 2}, },
},
--sixth bard
{
	name = "Brass Cymbals",
	type = "bard",
	slot = "armor",
	description = "A basic wooden sitar",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{chr = 10}, },
},
--seventh thief
{
	name = "Actual Metal Dagger",
	type = "thief",
	slot = "armor",
	description = "Sharp Edged Piece of metal with a handle!",
	price = 50,
	texture = "stick.png",
	stats = { add = 	{brv = 10},
						{str = 4},
						{dex = 5},
						{chr = 1}, },
},

}

EmptyItem = ItemDB[-1]

--give all items id based on position in list
for id, def in pairs(ItemDB) do
	def.id = id
end

local function DoesItemHaveStats(item)
	return 	item.type == "armor" or
			item.type == "accessory" or
			item.type == "armor"
end

--
-- If any stat is missing add it and set it to
-- the value in EmptyItem
--
for k, v in ipairs(ItemDB) do
	if DoesItemHaveStats(v) then
		v.stats = v.stats or {}
		local stats = v.stats
		for k, v in ipairs(EmptyItem) do
			stats[key] = stats[key] or v.stats
		end
	end
end

