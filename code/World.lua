World = {}
World.__index = World
function World:Create()
	local this =
	{
		mDay = 1,
		mGameState = GetDefaultGameState(),
		mGold = 0,
		mCurrentHeroes = CurrentHeroes:Create(),
		mItems = 
		{
		},
		mKeyItems = {},
		mRumors = {},
		mEncounters = {},
		mVillage = Village:Create(),
		mGossip = {},
		mDeathGossip = {},
		mShopOpen = false,
		mTaxes = 0,
		--mStorage = 3,
		mSkills = 
				{
				--[[Security]]		{
					level = 1,
				},
				--[[Storage]]		{
					level = 1,
				},
				--[[Tax Law]]		{
					level = 1,
				},
				--[[Haggle]]		{
					level = 1,
				},
				--[[Appraisal]]		{
					level = 1,
				},
				--[[Networking]]	{
					level = 1,
				},
				--[[Marketing]]		{
					level = 1,
				},
				}
	}
	setmetatable(this, self)

	return this
end

function World:Update(dt)
end

function World:Day()
	self.mDay = self.mDay + 1
end

function World:DayAsString()
	return string.format("%d", self.mDay)
end

function World:TaxesAsString()
	return string.format("%d", self.mTaxes)
end

function World:GoldAsString()
	return string.format("%d", self.mGold)
end

function World:MarkupAsString()
	return string.format("%d", self.mMarkup)
end

function World:SkillUp(index)
	local i = index
	local level = self.mSkills[i].level
	local price = SkillsDB[i].price[level]

	if self.mGold >= price then
	 self.mSkills[i].level = self.mSkills[i].level + 1
	 self.mGold = self.mGold - price
	end

end

function World:DetermineStorage()
	local storagelevel = self.mSkills[2].level
	return storagelevel * storagelevel + 1
end

function World:DetermineTaxBonus()
	local taxlevel = self.mSkills[3].level
	return taxlevel - 1
end

function World:DetermineHaggleBonus()
	local hagglelevel = self.mSkills[4].level
	return hagglelevel * 5
end

function World:DetermineMarketing()
	local marketing = self.mSkills[7].level
	return marketing
end

function World:LevelStorage()
	self.mStorage = self.DetermineStorage()
end

function World:AddItem(item)
	--local item = Item:Create(ItemDB[itemId])

	table.insert(self.mItems, item)
end

function World:RemoveItem(item)
	for i = #self.mItems, 1, -1 do
		local v = self.mItems[i]
		if v.mName == item.mName and v.mPrice == item.mPrice then
				table.remove(self.mItems, i)
			return
		end
	end
	assert(false) -- shouldn't ever get here!
end

--[[function World:RemoveItem(item)
	local vItem = item

	for i = 1, #self.mItems do
		local c = self.mItems[i] 		--loop through all the items in inventory
			for k, _ in pairs(c) do 
				if not vItem[k] then 		--If it doesn't match every value break
					break
				else
					table.remove(self.mItems, i) 		--Otherwise make a remove placeholder
				end			
		end			
	end
	
end]]

function World:HasKey(itemId)
	for k, v in ipairs(self.mKeyItems) do
		if v.id == itemId then
			return true
		end
	end
	return false
end

function World:AddKey(itemId)
	assert(not self:HasKey(itemId))
	table.insert(self.mKeyItems, {id = itemId})
end

function World:RemoveKey(itemId)
	for i = #self.mKeyItems, 1, -1 do
		local v = self.mKeyItems[i]

		if v.id == itemId then
			table.remove(self.mKeyItems, i)
			return
		end
	end
	assert(false) -- should never get here.
end

function World:HasRumor(rumorId)
	for k, v in ipairs(self.mRumors) do
		if v.id == rumorId then
			return true
		end
	end
	return false
end

function World:AddHero(hero)

	self.mCurrentHeroes:Add(hero)
	--print(self.mCurrentHeroes)

	--table.insert(self.mCurrentHeroes[#self.mCurrentHeroes + 1], hero)
end

function World:RemoveHero(hero)
	self.mCurrentHeroes:Remove(hero)
end


function World:AddRumor(rumorId)
	--assert(not self:HasRumor(rumorId), "You already have that rumor crash to desktop")
	
	if not self:HasRumor(rumorId) then
	table.insert(self.mRumors, {id = rumorId})
	end
end

function World:RemoveRumor(rumorId)
	for i = #self.mRumors, 1, -1 do
		local v = self.mRumors[i]

		if v.id == rumorId then
			table.remove(self.mRumors, i)
			return
		end
	end
	assert(false) -- should never get here.
end

function World:RemoveKey(itemId)
	for i = #self.mKeyItems, 1, -1 do
		local v = self.mKeyItems[i]

		if v.id == itemId then
			table.remove(self.mKeyItems, i)
			return
		end
	end
	assert(false) -- should never get here.
end

--will eventually need to make it iterate over all heroes, and much more
--so we did that

function World:Adventure()

	for k, v in pairs(self.mRumors) do
		for x, y in pairs(v) do
			for heroindex, herotable in pairs(self.mCurrentHeroes.mMembers) do
				local thisheronow = herotable

					if 	thisheronow.mStats:Get("brv") > RumorDB[y].challenge and not
						self.mCurrentHeroes.mMembers[heroindex]:CheckBusy(self.mDay)
					 then
						self:RemoveRumor(y)
						self.mCurrentHeroes.mMembers[heroindex]:AddDaysAway(self.mDay, RumorDB[y].challenge)
						self.mCurrentHeroes.mMembers[heroindex]:AddXP(RumorDB[y].challenge * 5000)
							while self.mCurrentHeroes.mMembers[heroindex]:ReadyToLevelUp() do
								local levelup = self.mCurrentHeroes.mMembers[heroindex]:CreateLevelUp()
								self.mCurrentHeroes.mMembers[heroindex]:ApplyLevel(levelup)
							end
						break
					end

			end
		end
	end

end

function World:DrawRumor(menu, renderer, x, y, item)
	if item then
		local rumorDef = RumorDB[item.id]
		renderer:AlignText("left", "center")
		renderer:DrawText2d(x, y, rumorDef.name)
	else
		renderer:AlignText("left", "center")
		renderer:DrawText2d(x, y, " - ")
	end
end

function World:DrawRumorDesc(menu, renderer, x, y, item)
	if item then
		local rumorDef = RumorDB[item.id]
		if rumorDef.image then
			local rumorImage = RumorImages:Create(Texture.Find(rumorDef.image))
			if rumorImage then
				rumorImage:SetPosition(x + 200, y + 200)
				renderer:DrawSprite(rumorImage)
			end
		end
		renderer:AlignText("left", "center")
		renderer:DrawText2d(x, y, rumorDef.description)
	else
		renderer:AlignText("left", "center")
		renderer:DrawText2d(x, y, " - ")
	end
end

function World:DrawItem(menu, renderer, x, y, item, color)

	color = color or Vector.Create(1, 1, 1, 1)

	if item then
		local itemDef = item
		if itemDef.image then
			local itemImage = RumorImages:Create(Texture.Find(itemDef.image))
			if itemImage then
				itemImage:SetPosition(x + 200, y + 200)
				renderer:DrawSprite(itemImage)
			end
		end
		renderer:AlignText("left", "center")
		renderer:DrawText2d(x, y, itemDef.mName, color)

		if item.count then 
			local right = x + menu.mSpacingX - 64
			renderer:AlignText("right", "center")
			local countStr = string.format("%02d", item.count)
			renderer:DrawText2d(right, y, countStr, color)
		end

	else
		renderer:AlignText("center", "center")
		renderer:DrawText2d(x + menu.mSpacingX/2, y, " - ", color)
	end
end

function World:AddEncounter(day)
	difficulty = day or self.mDay
	table.insert(self.mEncounters, Encounter:Create(difficulty))
end

function World:RemoveEncounter(encounter)
	table.remove(self.mEncounters, encounter)
end

function World:AddGossip(heroname)
	table.insert(self.mGossip, heroname)
end

function World:AddDeathGossip(heroname)
	table.insert(self.mDeathGossip, heroname)
end

--[[function World:PlayGossip()

	if #self.mGossip > 0 then
		local heroindex = math.random(#self.mGossip)

		local heroname = self.mGossip[heroindex]

		local text = GossipDB[math.random(#GossipDB)]

		local message = string.format(text, heroname)
					gStack:PushFit(gRenderer, 0, 0, message)

		table.remove(self.mGossip, heroindex)
	else
		local emptymessage = string.format("Not much happening today")
					gStack:PushFit(gRenderer, 0, 0, emptymessage)	
	end
end]]

function World:Encounter()
		for heroindex, herotable in pairs(self.mCurrentHeroes.mMembers) do
			local thisheronow = herotable
			local bravery = thisheronow.mStats:Get("brv")
				for i = #gWorld.mEncounters, 1, -1 do
					local v = gWorld.mEncounters[i]

				if bravery > v.mChallenge and bravery < (v.mChallenge * 2) and not
					self.mCurrentHeroes.mMembers[heroindex]:CheckBusy(self.mDay)
				 then
					--self:RemoveRumor(y)
					if v:RunChallenges(thisheronow) then
						self:RemoveEncounter(i)
						self:AddGossip(self.mCurrentHeroes.mMembers[heroindex].mName)
						self.mCurrentHeroes.mMembers[heroindex].mGold = 
						self.mCurrentHeroes.mMembers[heroindex].mGold + v.mGold
						self.mCurrentHeroes.mMembers[heroindex]:AddItem(v.mItem)
						self.mCurrentHeroes.mMembers[heroindex]:AddDaysAway(self.mDay, (v.mChallenge))
						self.mCurrentHeroes.mMembers[heroindex]:AddXP(v.mChallenge * 300)
							while self.mCurrentHeroes.mMembers[heroindex]:ReadyToLevelUp() do
								local levelup = self.mCurrentHeroes.mMembers[heroindex]:CreateLevelUp()
								self.mCurrentHeroes.mMembers[heroindex]:ApplyLevel(levelup)
							end
					else
						self:AddDeathGossip(self.mCurrentHeroes.mMembers[heroindex].mName) 
						self:RemoveHero(thisheronow)
					end
					break
				end

		end
	end
end