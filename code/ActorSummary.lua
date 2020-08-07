ActorSummary = {}
ActorSummary.__index = ActorSummary
function ActorSummary:Create(actor, params)
params = params or {}
local this =
	{
		mX = 0,
		mY = 0,
		mWidth = 340, -- width of entire box
		mActor = actor,
		mAvatarTextPad = 40,
		mLabelRightPad = 45,
		mLabelValuePad = 18,
		mVerticalPad = 18,
		mShowXP = params.showXP
	}

	if this.mShowXP then
	this.mXPBar = ProgressBar:Create
	{
		value = actor.mXP,
		maximum = actor.mNextLevelXP,
		background = Texture.Find("background.png"),
		foreground = Texture.Find("foreground.png"),
	}
	end
	
	setmetatable(this, self)
	this:SetPosition(this.mX, this.mY)
	return this
end

function ActorSummary:SetPosition(x, y)
	self.mX = x
	self.mY = y
end


function ActorSummary:GetCursorPosition()
	return Vector.Create(self.mX, self.mY - 40)
end

function ActorSummary:Render(renderer)

	local actor = self.mActor
	local color = nil
	
	--if the hero is busy grey out the text
	if actor:CheckBusy(gWorld.mDay) then
		color = Vector.Create(0.6, 0.6, 0.6, 1)
	end

	--
	-- Position avatar image from top left
	--
	local avatar = actor.mPortrait
	local avatarW = actor.mPortraitTexture:GetWidth()
	local avatarH = actor.mPortraitTexture:GetHeight()
	local avatarX = self.mX + avatarW / 2
	local avatarY = self.mY - avatarH / 2
	avatar:SetPosition(avatarX, avatarY)
	renderer:DrawSprite(avatar)

	--
	-- Position basic stats to the left of the
	-- avatar
	--

	renderer:AlignText("left", "top")
	local textPadY = 2
	local textX = avatarX + avatarW / 2 + self.mAvatarTextPad
	local textY = self.mY - textPadY
	local displayName = actor.mName
	renderer:ScaleText(1.6, 1.6)
	renderer:DrawText2d(textX, textY, displayName, color)
	
	local displayLevel = actor:DisplayLevel()

	renderer:DrawText2d(textX + 150, textY, displayLevel, color)
	--
	-- Draw LVL, HP and MP labels
	--

	renderer:AlignText("right", "top")
	renderer:ScaleText(1.22, 1.22)
	textX = textX + self.mLabelRightPad
	textY = textY - 5
	local statsStartY = textY
	--renderer:DrawText2d(textX + 30, textY, displayLevel)
	textY = textY - self.mVerticalPad
	renderer:DrawText2d(textX, textY, "Bravery", color)
	textY = textY - self.mVerticalPad
	renderer:DrawText2d(textX, textY, "Gold", color)


--
-- Fill in the values
--
local textY = statsStartY
local textX = textX + self.mLabelValuePad
renderer:AlignText("left", "top")
local level = actor.mLevel

--Here we grab the bravery might convert this to a phrase later
local brv = actor.mStats:Get("brv")
--Grab the gold
local actorgold = actor.mGold

--this counter does something to string formatting find out about that for options
local counter = "%02d"
local bravery = string.format(counter,
brv)

local gold = string.format(counter,
actorgold)

--renderer:DrawText2d(textX, textY, displayLevel, color)
textY = textY - self.mVerticalPad
renderer:DrawText2d(textX, textY, bravery, color)
textY = textY - self.mVerticalPad
renderer:DrawText2d(textX, textY, gold, color)


--
-- Next Level area
--

if self.mShowXP then
	renderer:AlignText("right", "top")
	local boxRight = self.mX + self.mWidth
	local textY = statsStartY
	local left = boxRight - self.mXPBar.mHalfWidth * 2
	renderer:DrawText2d(left, textY, "Next Level")
	
	self.mXPBar:Render(renderer)
end
--
-- MP & HP bars
--
--self.mHPBar:Render(renderer)
--self.mMPBar:Render(renderer)
end
