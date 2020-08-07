ItemDB =
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
	name = "Staff",
	type = "cleric",
	slot = "weapon",
	description = "A basic staff",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--second mage
{
	name = "Wand",
	type = "mage",
	slot = "weapon",
	description = "A basic wand",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--third warrior
{
	name = "Wooden Sword",
	type = "warrior",
	slot = "weapon",
	description = "A basic wooden sword",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--fourth ranger
{
	name = "Sling",
	type = "ranger",
	slot = "weapon",
	description = "A basic wooden sling (cloth not included)",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--fifth druid
{
	name = "Club",
	type = "druid",
	slot = "weapon",
	description = "A basic wooden club",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--sixth bard
{
	name = "Wooden Guitar",
	type = "bard",
	slot = "weapon",
	description = "A basic wooden guitar (strings not included)",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},
--seventh thief
{
	name = "Stick",
	type = "thief",
	slot = "weapon",
	description = "Sophisticated tool for distracting guard dogs",
	price = 1,
	texture = "stick.png",
	stats = { add = { brv = 1} },
},

--First item in seven - cleric
{
	name = "Somewhat Holey Staff",
	type = "cleric",
	slot = "weapon",
	description = "A staff that might have been blessed or punctured",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{wis = 5}, },
},
--second mage
{
	name = "Wand with Grip",
	type = "mage",
	slot = "weapon",
	description = "A basic wand with customer nonslip grip",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{int = 5}, },
},
--third warrior
{
	name = "Wooden Sword Sharp",
	type = "warrior",
	slot = "weapon",
	description = "A wooden sword",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{str = 5}, },
},
--fourth ranger
{
	name = "Slinging Sling",
	type = "ranger",
	slot = "weapon",
	description = "A basic wooden sling",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{dex = 5}, },
},
--fifth druid
{
	name = "Exclusive Club",
	type = "druid",
	slot = "weapon",
	description = "An exclusive wooden club",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{wis = 4},
						{int = 1}, },
},
--sixth bard
{
	name = "Wooden Sitar",
	type = "bard",
	slot = "weapon",
	description = "A basic wooden sitar",
	price = 10,
	texture = "stick.png",
	stats = { add = 	{brv = 5},
						{chr = 5}, },
},
--seventh thief
{
	name = "Shank",
	type = "thief",
	slot = "weapon",
	description = "Sturdy wooden dagger, works on vampires and humans alike!",
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
	slot = "weapon",
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
	slot = "weapon",
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
	slot = "weapon",
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
	slot = "weapon",
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
	slot = "weapon",
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
	slot = "weapon",
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
	slot = "weapon",
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
	return 	item.type == "weapon" or
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

