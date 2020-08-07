Day = {}
Day.__index = Day
function Day:Create()
	local this =
	{
		mTime = 0,
		
	}
	setmetatable(this, self)
	return this
end

function Day:Current()
	return self.mTime
end


--Adds one random rumor
function Day:AddRumor()
	local rumor = 1
	--gWorld:AddRumor(rumor)
	local cutscene = testcutscene[rumor]
	local storyboard = Storyboard:Create(gStack, cutscene, true)
	gStack:Push(storyboard)
	print("are you there")

	--gWorld:AddRumor(math.random(1, #RumorDB))
end

--Adds one random hero
function Day:RandomHero()
    local keys = {}
    local heroes = HeroDB
    for k in pairs(heroes) do table.insert(keys, k) end
    return heroes[keys[math.random(#keys)]]
end

function Day:AddHero()
	local hero = self.RandomHero()
	gWorld.mCurrentHeroes:Add(Actor:Create(hero))
end

function Day:Update(dt)
	self.mTime = self.mTime + dt
end

function Day:TimeAsString()

	local time = self.mTime
	local hours = math.floor(time / 3600)
	local minutes = math.floor((time % 3600) / 60)
	local seconds = time % 60

	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function Day:Adventure()
	--gWorld:Adventure()

	--local heroes = gWorld.mCurrentHeroes.mMembers
	--local rumors = gWorld.mRumors

	--print(heroes.mStats)

	-- key is the heroes v is the heroes stats
	--for k, v in pairs(heroes) do

		--h here is the key for each of the 
	--	for h, s in pairs(v) do
			--print(h)
	--	end
	--end

end