Encounter = {}
Encounter.__index = Encounter
function Encounter:Create(day)

	local difficulty = day or 1

	local this =
	{
		mChallenge = Dice.RollDie(1, 8) + difficulty,
		mGold = Dice.RollDie(1, 10) * difficulty,
		mStr = Dice.RollDie(3, 8) + (difficulty / 10),
		mInt = Dice.RollDie(3, 8) + (difficulty / 10),
		mWis = Dice.RollDie(3, 8) + (difficulty / 10),
		mDex = Dice.RollDie(3, 8) + (difficulty / 10),
		mCon = Dice.RollDie(3, 8) + (difficulty / 10),
		mChr = Dice.RollDie(3, 8) + (difficulty / 10),
		mItem = Item:Create(VillageItemDB[Dice.RollDie(1, 3)])
	}
	setmetatable(this, self)
	return this
end

function Encounter:RunChallenges(hero)
	local thisheronow = hero

	if 	thisheronow.mStats:Get("str") > self.mStr then 
		return true
	elseif thisheronow.mStats:Get("int") > self.mInt then
		return true
	elseif thisheronow.mStats:Get("wis") > self.mWis then
		return true
	elseif thisheronow.mStats:Get("dex") > self.mDex then
		return true
	elseif thisheronow.mStats:Get("con") > self.mCon then
		return true
	elseif thisheronow.mStats:Get("chr") > self.mChr then
		return true
	else
		return false
	end
end