Actor = 
{
	EquipSlotId = 
	{
		"weapon",
		"armor",
	},
	ActorStats =
	{
		"str",
		"int",
		"wis",
		"dex",
		"con",
		"chr",
		"brv",
	},
	ItemStats =
	{
		"str",
		"int",
		"wis",
		"dex",
		"con",
		"chr",
		"brv",
	},
}
Actor.__index = Actor
function Actor:Create(def)

	local growth = def.statGrowth or {}

	local this =
	{
		mName = def.name,
		mId = def.id,
		mUniqueIdentifier = math.random(),
		mPortrait = Sprite.Create(),
		mDef = def,
		mStats = Stats:Create(def.stats),
		mStatGrowth = def.statGrowth,
		mXp = 0,
		mLevel = 1,
		mGold = def.gold,
		mEquipment = 
		{
			weapon = def.weapon,
			armor = def.armor,
			acces1 = def.acces1,
			acces2 = def.acces2,
		},
		mDisplayLevels = def.displayLevels,
		mAdventureTime = 0,
		mAdventureEnd = 0,
		mItems = {},
		mActiveEquipSlots = def.equipslots or {1, 2, 3 },

		
		--this is where I'll need to add inventory? Gold

	}

	if def.portrait then
		this.mPortraitTexture = Texture.Find(def.portrait)
		this.mPortrait:SetTexture(this.mPortraitTexture)
	end

	this.mNextLevelXP = NextLevel(this.mLevel)
	setmetatable(this, self)
	return this
end


--takes in the day the adventure started and how long it will take returns a number
function Actor:AddDaysAway(day, duration)
self.mAdventureTime = day
self.mAdventureEnd = duration + day
end

function Actor:CheckBusy(day)
	return day < self.mAdventureEnd - self.mAdventureTime
end


function Actor:DisplayLevel()
	local displayLevel = ""
	if self.mLevel < 11 then
		displayLevel = self.mDisplayLevels[self.mLevel]
	else
		displayLevel = self.mDisplayLevels[10]
	end
	return displayLevel
end

function Actor:ReadyToLevelUp()
	return self.mXp >= self.mNextLevelXP
end

function Actor:AddXP(xp)
	self.mXp = self.mXp + xp
	return self:ReadyToLevelUp()
end

function Actor:CreateLevelUp()

local levelup =
	{
		xp = - self.mNextLevelXP,
		level = 1,
		stats = {},
	}

	for id, dice in pairs(self.mStatGrowth) do
		levelup.stats[id] = dice:Roll()
	end

-- Additional level up code
-- e.g. if you want to apply
-- a bonus every 4 levels
-- or heal the players MP/HP
	
	return levelup
end

function Actor:ApplyLevel(levelup)
	self.mXp = self.mXp + levelup.xp
	self.mLevel = self.mLevel + levelup.level
	self.mNextLevelXP = NextLevel(self.mLevel)

	assert(self.mXp >= 0)

	for k, v in pairs(levelup.stats) do
		self.mStats.mBase[k] = self.mStats.mBase[k] + v
	end
	-- Unlock any special abilities etc.
end

function Actor:AddItem(item)


	--local item = Item:Create(ItemDB[itemId])

	table.insert(self.mItems, item)
end

function Actor:RemoveItem(item)
	for i = #self.mItems, 1, -1 do
		
		local v = self.mItems[i]
		
		if v.mId == item.mId then
				--self.mItems[i] = nil
				table.remove(self.mItems, i)
		end
	--		return
	end
	--assert(false) -- shouldn't ever get here!
end


function Actor:Equip(slot, item)

	--	1. Remove any item curently in slot
	--	Put that item back into hero'es inventory

	local prevItem = self.mEquipment[slot]
	self.mEquipment[slot] = nil
	if prevItem then
		--Remove previous item modifier
		self.mStats:RemoveModifier(slot)
		self:AddItem(prevItem)
	end

	--	2. If there's a replacement item move it to the slot
	if not item then
		return
	end

	self:RemoveItem(item)
	self.mEquipment[slot] = item
	local modifier = item.mStats or {}
	self.mStats:AddModifier(slot, modifier)
end

function Actor:Unequip(slot)
	self:Equip(slot, nil)
end

function Actor:CreateStatNameList()

	local list = {}

	for _, v in ipairs(Actor.ActorStats) do
		table.insert(list, v)
	end

	for _, v in ipairs(Actor.ItemStats) do
		table.insert(list, v)
	end

	return list
end

function Actor:PredictStats(slot, item)

	local statsId = self:CreateStatNameList()

	-- Get values for all current stats
	local current = {}
	for _, v in ipairs(statsId) do
		current[v] = self.mStats:Get(v)
	end

	--Replace item
	local prevItemId = self.mEquipment[slot]
	self.mStats:RemoveModifier(slot)
	self.mStats:AddModifier(slot, item.mStats)

	-- Get values for modified stats
	local modified = {}
	for _, v in ipairs(statsId) do
		modified[v] = self.mStats:Get(v)
	end

	-- Get difference for individual stats
	local diff = {}
	for _, v in ipairs(statsId) do
		diff[v] = modified[v] - current[v]
	end

	--Total up all stats 
	local totaldiff = 0
	for _, v in pairs(diff) do
		totaldiff = totaldiff + v
	end

	-- Undo replace item
	self.mStats:RemoveModifier(slot)
	 if prevItemId then
	 	self.mStats:AddModifier(slot, prevItemId.mStats)
	 end

	 return totaldiff
end

function Actor:IsEquipmentBetter(item)

	if item.mSlot == "weapon" then
		local diff = self:PredictStats("weapon", item)
	
	return diff > 0
	
	elseif item.mSlot == "armor" then
		local diff = self:PredictStats("armor", item)
	
	return diff > 0
	
	end

	return false
end

function Actor:RemoveObsolete()
	for i = #self.mItems, 1, -1 do
		local v = self.mItems[i]
		if self:IsEquipmentBetter(v) then
			self:Equip(v.mSlot, v)
		else 
			return
		end
	end
end