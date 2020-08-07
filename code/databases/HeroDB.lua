HeroDB =
{
	{
		id = "warrior",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("2d4"),
			int = Dice:Create("1d2"),
			wis = Dice:Create("1d2"),
			dex = Dice:Create("1d2"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("1d2"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Warrior",
		--Level names as indices?  Going to try it might be hard to manage
		displayLevels = 
		{
			--Level 1 
			"Commoner With a Sword",
			--Level 2
			"Butcher's Boy",
			--Level 3- 
			"Lumberjack",
			--Level 4- 
			"I Saw This Bounty Flier?",
			--Level 5 - 
			"Accidental Avenger",
			--Level 6 - 
			"Novice Bodyguard",
			--Level 7 - 
			"Carpenter",
			--Level 8 - 
			"Noble of Spirit",
			--Level 9 - 
			"Aspiring Adventurer",
			--Level 10 - 
			"Squire",

		},
		gold = Dice.RollDie(2, 4),


-- additional actor definition info
	},

	{
		id = "cleric",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("1d2"),
			int = Dice:Create("1d2"),
			wis = Dice:Create("2d4"),
			dex = Dice:Create("1d2"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("1d2"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Cleric",

		displayLevels = 
		{
			--Level 1 
			"Cleric PlaceHolder 1",
			--Level 2
			"Cleric PlaceHolder 2",
			--Level 3- 
			"Cleric PlaceHolder 3",
			--Level 4- 
			"Cleric PlaceHolder 4",
			--Level 5 - 
			"Cleric PlaceHolder 5",
			--Level 6 - 
			"Cleric PlaceHolder 6",
			--Level 7 - 
			"Cleric PlaceHolder 7",
			--Level 8 - 
			"Cleric PlaceHolder 8",
			--Level 9 - 
			"Cleric PlaceHolder 9",
			--Level 10 - 
			"Cleric PlaceHolder 10",

		},
		gold = Dice.RollDie(1, 4),

-- additional actor definition info
	},

	{
		id = "bard",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("1d2"),
			int = Dice:Create("1d2"),
			wis = Dice:Create("1d2"),
			dex = Dice:Create("1d2"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("2d4"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Bard",

		displayLevels = 
		{
			--Level 1 
			"Whistling Kid",
			--Level 2
			"Humming Townsperson",
			--Level 3- 
			"Off-tune Singer",
			--Level 4- 
			"Jabbering Dandy",
			--Level 5 - 
			"Three String Player",
			--Level 6 - 
			"Layabout Luteist",
			--Level 7 - 
			"Sousaphone Player",
			--Level 8 - 
			"Trotter of the Boreds",
			--Level 9 - 
			"Town Gossip",
			--Level 10 - 
			"Roving Bard",
		},

		gold = Dice.RollDie(3, 6),
	},

	{
		id = "druid",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("1d2"),
			int = Dice:Create("1d3"),
			wis = Dice:Create("1d3"),
			dex = Dice:Create("1d2"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("1d2"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Druid",
		displayLevels = 
		{
			--Level 1 
			"Druid PlaceHolder 1",
			--Level 2
			"Druid PlaceHolder 2",
			--Level 3- 
			"Druid PlaceHolder 3",
			--Level 4- 
			"Druid PlaceHolder 4",
			--Level 5 - 
			"Druid PlaceHolder 5",
			--Level 6 - 
			"Druid PlaceHolder 6",
			--Level 7 - 
			"Druid PlaceHolder 7",
			--Level 8 - 
			"Druid PlaceHolder 8",
			--Level 9 - 
			"Druid PlaceHolder 9",
			--Level 10 - 
			"Druid PlaceHolder 10",

		},

		gold = Dice.RollDie(1, 4),

-- additional actor definition info
	},

	{
		id = "ranger",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("1d2"),
			int = Dice:Create("1d2"),
			wis = Dice:Create("1d2"),
			dex = Dice:Create("2d4"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("1d2"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Ranger",

		displayLevels = 
		{
			--Level 1 
			"Herdsman's Son",
			--Level 2
			"Once Owned a Slingshot",
			--Level 3- 
			"Outdoorsy",
			--Level 4- 
			"Survived a Week on Nothing But Berries...",
			--Level 5 - 
			"Nomad",
			--Level 6 - 
			"Horseman",
			--Level 7 - 
			"Merry Man",
			--Level 8 - 
			"Fletcher",
			--Level 9 - 
			"Hunter",
			--Level 10 - 
			"Woodsman",

		},

		gold = Dice.RollDie(2, 4),
-- additional actor definition info
	},

	{
		id = "mage",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("1d2"),
			int = Dice:Create("2d4"),
			wis = Dice:Create("1d2"),
			dex = Dice:Create("1d2"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("1d2"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Mage",

		displayLevels = 
		{
			--Level 1 
			"Knows a Card Trick",
			--Level 2
			"Makes Static",
			--Level 3- 
			"Dustomancer",
			--Level 4- 
			"Mage Placeholder 4",
			--Level 5 - 
			"Mage Placeholder 5",
			--Level 6 - 
			"Mage Placeholder 6",
			--Level 7 - 
			"Mage Placeholder 7",
			--Level 8 - 
			"Unnatural Intuition",
			--Level 9 - 
			"“I'm a wizard Shopkeep…”",
			--Level 10 - 
			"Herbalist",

		},
		gold = Dice.RollDie(3, 4),
	},
		{
		id = "thief",

		stats = 
		{ 
			str = Dice.RollDie(3, 6),
			int = Dice.RollDie(3, 6),
			wis = Dice.RollDie(3, 6),
			dex = Dice.RollDie(3, 6),
			con = Dice.RollDie(3, 6),
			chr = Dice.RollDie(3, 6),
			brv = Dice.RollDie(3, 6),
		}, -- starting stats
		
		statGrowth =
		{
			str = Dice:Create("1d2"),
			int = Dice:Create("1d2"),
			wis = Dice:Create("1d4"),
			dex = Dice:Create("2d4"),
			con = Dice:Create("1d2"),
			chr = Dice:Create("1d2"),
			brv = Dice:Create("1d2"),
		},
		portrait = "evilone.png",
		name = "Thief",
		displayLevels = 
		{
			--Level 1 
			"Never Returned Item",
			--Level 2
			"Keeps Quills",
			--Level 3- 
			"Borrower",
			--Level 4- 
			"Unattended Attender",
			--Level 5 - 
			"Kleptomaniac",
			--Level 6 - 
			"Lock Jiggler",
			--Level 7 - 
			"Found It Somewhere",
			--Level 8 - 
			"Heavy Dice",
			--Level 9 - 
			"Mugger",
			--Level 10 - 
			"WANTED",

		},

		gold = Dice.RollDie(4, 6),
-- additional actor definition info
	},

}
