function Adventure(world)
		for heroindex, herotable in pairs(world.mCurrentHeroes.mMembers) do
			local thisheronow = herotable
			local bravery = thisheronow.mStats:Get("brv")
				for i = #world.mEncounters, 1, -1 do
					local v = world.mEncounters[i]

				if bravery > v.mChallenge and bravery < (v.mChallenge * 2) and not
					world.mCurrentHeroes.mMembers[heroindex]:CheckBusy(world.mDay)
				 then
					--world:RemoveRumor(y)
					if v:RunChallenges(thisheronow) then
						world:RemoveEncounter(i)
						world:AddGossip(world.mCurrentHeroes.mMembers[heroindex].mName)
						world.mCurrentHeroes.mMembers[heroindex].mGold = 
						world.mCurrentHeroes.mMembers[heroindex].mGold + v.mGold
						world.mCurrentHeroes.mMembers[heroindex]:AddItem(v.mItem)
						world.mCurrentHeroes.mMembers[heroindex]:AddDaysAway(world.mDay, (v.mChallenge))
						world.mCurrentHeroes.mMembers[heroindex]:AddXP(v.mChallenge * 300)
							while world.mCurrentHeroes.mMembers[heroindex]:ReadyToLevelUp() do
								local levelup = world.mCurrentHeroes.mMembers[heroindex]:CreateLevelUp()
								world.mCurrentHeroes.mMembers[heroindex]:ApplyLevel(levelup)
							end
					else
						world:AddDeathGossip(world.mCurrentHeroes.mMembers[heroindex].mName) 
						world:RemoveHero(thisheronow)
					end
					break
				end

		end
	end
end
