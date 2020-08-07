Item = {}
Item.__index =  Item
function Item:Create(def)

	local this = 
	{
	mName = def.name,
	mType = def.type,
	mSlot = def.slot,
	mDescription = def.description,
	mStats = def.stats,
	mBasePrice = def.price,
	mStats = def.stats,
	mId = def.id,
	mTexture = def.texture or "",
	mUniqueId = math.random()
	}

	setmetatable(this, self)
	
	this.mPrice = this:SetPrice()

	return this
end

function Item:ChangePrice(value)
	self.mPrice = self.mPrice + value 
end

function Item:SetPrice()
	return self.mBasePrice
end