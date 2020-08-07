Vendor = {}
Vendor.__index = Vendor
function Vendor:Create(def)

	local this =
	{
		mName = def.name,
		mId = def.id,
		mPortrait = Sprite.Create(),
		mRawPortrait = def.portrait,
		mDef = def,
		mStockOptions = def.stock,
		mTransactions = 0,
		mWealth = 1,
		mNextWealthLevel = 2,
		--mStock = def.stock[1],
		--mStats = def.stats,
	}

	if def.portrait then
		this.mPortraitTexture = Texture.Find(def.portrait)
		this.mPortrait:SetTexture(this.mPortraitTexture)
	end
	--this.mStock = this.mStockOptions[this.mWealth]
	
	setmetatable(this, self)

	this.mStock = this:SetStock()
	
	return this
end

function Vendor:UpgradeStock()
	local newstock = self.mStock
	local adding = self.mStockOptions[self.mWealth]
	
	if adding then 
		for i = #adding, 1, -1 do
			local v = adding[i]
			table.insert(newstock, v)
		end
	else return
	end

	self.mStock = newstock

end

function Vendor:AccumlatedWealth()
	if self.mTransactions >= 10 then
		self.mTransactions = 0
	
	return self:AddWealth(1)
	end
end

function Vendor:ReadyToLevelUp()
	return self.mWealth >= self.mNextWealthLevel
end

function Vendor:AddWealth(wealth)
	self.mWealth = self.mWealth + wealth
	return self:ReadyToLevelUp()
end

function Vendor:ApplyLevel()
	self.mNextWealthLevel = self.mNextWealthLevel + 1
	self:UpgradeStock()
end

function Vendor:SetStock()
	local newstock = {}
	local restocklevel = self.mWealth

	for k, v in pairs(self.mStockOptions) do
		if k == "weapons" then
			for i = 1, restocklevel do 			
				local supply = v[i]
					if supply then
						for j = 1, #supply do 			
							local item = supply[j]
							local stockitem = Item:Create(ItemDB[item])
							table.insert(newstock, stockitem)
						end
					end
			end
		
		elseif k == "village" then
			for i = 1, restocklevel do 			
				local supply = v[i]
					if supply then
						for j = 1, #supply do
							local item = supply[j] 			
							local stockitem = Item:Create(VillageItemDB[item])
							table.insert(newstock, stockitem)
						end
					end
			end

		elseif k == "armor" then
			for i = 1, restocklevel do 			
				local supply = v[i]
					if supply then
						for j = 1, #supply do
							local item = supply[j] 			
							local stockitem = Item:Create(ArmorItemDB[item])
							table.insert(newstock, stockitem)
						end
					end
			end
		end
	end
	return newstock
end

function Vendor:Restock()
	self.mStock = self:SetStock()
end