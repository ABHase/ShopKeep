Village = {}
Village.__index = Village
function Village:Create()
	local this =
	{
		mCurrentVendors = {	--[[Vendor:Create(VendorDB[1])]]},
		mVendorCount = 0,
	}
	setmetatable(this, self)

	return this
end

function Village:Add(index)

	local num = index
	local member = Vendor:Create(VendorDB[num])

	self.mVendorCount = self.mVendorCount or 0
	self.mVendorCount = self.mVendorCount + 1

	local vendorId = member.mId
	local state = gWorld.mGameState.village
	local isVendor = state.vendors_unlocked[vendorId] or false

	if isVendor then
		return
	end

	table.insert(self.mCurrentVendors, member)
	state.vendors_unlocked[vendorId] = true
	--self.mCurrentVendors[member.mId] = member
end

function Village:Remove(member)
	for i = #self.mCurrentVendors, 1, -1 do
		local v = self.mCurrentVendors[i]
		if v == member then
			table.remove(self.mCurrentVendors, i)
		end
	end
end