VendorSummary = {}
VendorSummary.__index = VendorSummary
function VendorSummary:Create(vendor, params)
params = params or {}
local this =
	{
		mX = 0,
		mY = 0,
		mWidth = 340, -- width of entire box
		mVendor = vendor,
		mAvatarTextPad = 40,
		mLabelRightPad = 45,
		mLabelValuePad = 18,
		mVerticalPad = 18,
	}
	
	setmetatable(this, self)
	this:SetPosition(this.mX, this.mY)
	return this
end

function VendorSummary:SetPosition(x, y)
	self.mX = x
	self.mY = y
end


function VendorSummary:GetCursorPosition()
	return Vector.Create(self.mX, self.mY - 40)
end

function VendorSummary:Render(renderer)

	local vendor = self.mVendor
	local color = nil
	
	--Possibly add a function on the vendors to see if they're available?
	

	--if vendor:CheckBusy(gWorld.mDay) then
	--	color = Vector.Create(0.6, 0.6, 0.6, 1)
	--end

	--
	-- Position avatar image from top left
	--
	local avatar = vendor.mPortrait
	local avatarW = vendor.mPortraitTexture:GetWidth()
	local avatarH = vendor.mPortraitTexture:GetHeight()
	local avatarX = self.mX + avatarW / 2
	local avatarY = self.mY - avatarH / 2
	avatar:SetPosition(avatarX, avatarY)
	renderer:DrawSprite(avatar)

	renderer:AlignText("left", "top")
	local textPadY = 2
	local textX = avatarX - vendor.mPortraitTexture:GetWidth() / 2  -- + avatarW / 2 + self.mAvatarTextPad
	local textY = avatarY - textPadY + vendor.mPortraitTexture:GetHeight() / 2 
	local displayname = vendor.mName
	renderer:ScaleText(1.6, 1.6)
	renderer:DrawText2d(textX, textY, displayname, color)

end
