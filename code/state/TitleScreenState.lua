TitleScreenState = {}
TitleScreenState.__index = TitleScreenState
function TitleScreenState:Create(stack, storyboard)
	local this
	this =
	{
		mTitleBanner = Sprite.Create(),
		mStack = stack,
		mStoryboard = storyboard,
		mMenu = Selection:Create
		{
			data = {"Play", "Exit"},
			spacingY = 32,
			OnSelection = function(index)
				this:OnSelection(index)
			end
		}
	}
	this.mTitleBanner:SetTexture(Texture.Find("title_banner.png"))
	this.mTitleBanner:SetPosition(0, 100)
	
	-- Code to center the menu
	this.mMenu.mCursorWidth = 50
	this.mMenu.mX = -this.mMenu:GetWidth()/2 - this.mMenu.mCursorWidth
	this.mMenu.mY = -50
	setmetatable(this, self)
	return this
end

function TitleScreenState:Enter() end
function TitleScreenState:Exit() end
function TitleScreenState:Update(dt) end

function TitleScreenState:OnSelection(index)
	if index == 1 then
		self.mStack:Pop()
		self.mStack:Push(self.mStoryboard)
	elseif index == 2 then
		System.Exit()
	end
end

function TitleScreenState:Render(renderer)

renderer:DrawRect2d(
	-System.ScreenWidth()/2,
	-System.ScreenHeight()/2,
	System.ScreenWidth()/2,
	System.ScreenHeight()/2,
	Vector.Create(0, 0, 0, 1)
	)

	renderer:DrawSprite(self.mTitleBanner)
	renderer:AlignText("center", "center")
	renderer:ScaleText(2, 2)
	renderer:DrawText2d(0, 10, "If you had a sister you'd sell her in a second")
	renderer:ScaleText(1, 1)
	renderer:AlignText("left", "center")
	self.mMenu:Render(renderer)
end

function TitleScreenState:HandleInput()
	self.mMenu:HandleInput()
end