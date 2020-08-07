CurrentHeroes = {}
CurrentHeroes.__index = CurrentHeroes
function CurrentHeroes:Create()
	local this =
	{
		mMembers = {}
	}

	setmetatable(this, self)
	return this
end

function CurrentHeroes:Add(member)
	table.insert(self.mMembers, member)

	--self.mMembers[member.mId] = member
end

function CurrentHeroes:Remove(member)
	for i = #self.mMembers, 1, -1 do
		local v = self.mMembers[i]
		if v == member then
			table.remove(self.mMembers, i)
		end
	end
end