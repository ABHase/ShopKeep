RumorImages = {}
RumorImages.__index = RumorImaes
function RumorImages:Create(texture)
	local this = 
	{
		mTexture = texture,
		mSprite = nil
	}

	local sprite = Sprite.Create()
	sprite:SetTexture(this.mTexture)
	this.mSprite = sprite

	setmetatable(this, self)
	return this.mSprite
end
