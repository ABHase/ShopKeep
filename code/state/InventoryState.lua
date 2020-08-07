InventoryState = {}
InventoryState.__index = InventoryState
function InventoryState:Create(parent)
	
	local this
	this = 
	{
		mParent = parent,
		mStack = parent.mStack,
		mWorld = gWorld,
		mPanels = {},
		mName = "Stock",
		mState = "choose",
		mItemStock = gWorld.mItems,
		mManagedItem = nil,
		mTabs =
		{
			["check"] = 1,
			["exit"] = 2,
		},
		mChooseSelection = Selection:Create
		{
			data =
			{
				"Check",
				"Exit",
			},
			rows = 1,
			columns = 2,
			OnSelection = function(...) this:ChooseClick(...) end,
		},
		mStock = Selection:Create
		{
			data = gWorld.mItems,
			displayRows = 12,
			RenderItem = function(...) this:RenderStock(...) end,
			OnSelection = function(...) this:OnCheck(...) end,
		},
		mManage = Selection:Create
		{
			data =
			{
				"Raise",
				"Lower",
			},
			displayRows = 2,
			OnSelection = function(...) this:ManagePrice(...) end,
		},
		mInventory = nil,
		mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 405),
		mItemDescription = 0,
		mItemSprite = Sprite.Create(),
		--mPortraitSprite = Sprite.Create(),
		--mPortraitSpriteTexture = Texture.Find(def.portrait),

	}

	--this.mPortraitSprite:SetTexture(this.mPortraitSpriteTexture)

	local layout = Layout:Create()
	layout:Contract('screen', 118, 40)
	layout:SplitHorz('screen', 'top', 'bottom', 0.12, 1)
	layout:SplitVert('top', 'title', 'choose', 0.75, 1)
	layout:SplitHorz('bottom', 'top', 'desc', 0.55, 1)
	layout:SplitVert('desc', 'itemimg', 'desc', 0.75, 1)
	layout:SplitVert('top', 'inv', 'portrait', 0.35, 1)
	
	this.mPanels =
		{
			layout:CreatePanel("title"),
			layout:CreatePanel("choose"),
			layout:CreatePanel("itemimg"),
			layout:CreatePanel("desc"),
			layout:CreatePanel("inv"),
			layout:CreatePanel("portrait"),
		}
	
	this.mLayout = layout

	local cX = layout:Left("choose") + 24
	local cY = layout:MidY("choose")
	this.mChooseSelection:SetPosition(cX, cY)


	--setting pos of the selection of the inventory
	local sX = layout:Left("inv") + 50
	local sY = layout:Top("inv") - 65
	this.mPriceX = layout:Right("inv") - 56
	this.mStock:SetPosition(sX, sY)

	local scrollX = layout:Right("inv") - 14
	local scrollY = layout:MidY("inv")
	this.mScrollbar:SetPosition(scrollX, scrollY)

	local mX = layout:Left("portrait") + 36
	local mY = layout:Top("portrait") - 30
	this.mManage:SetPosition(mX, mY)

	setmetatable(this, self)
	--this.mInventory = this:CreateInvSelection()
	this.mStock:HideCursor()
	this.mManage:HideCursor()
	--this.mInventory:HideCursor()
	return this
end

function InventoryState:RenderStock(menu, renderer, x, y, item)
	if item == nil then
		return
	end

	local color = nil
	--[[if self.mWorld.mGold < item.mPrice then
		color = Vector.Create(0.6, 0.6, 0.6, 1)
	end]]

	self.mWorld:DrawItem(menu, renderer, x, y, item, color)

	renderer:AlignTextX("right")
	local priceStr = string.format(": %d", item.mPrice)
	renderer:DrawText2d(self.mPriceX, y, priceStr, color)
end

function InventoryState:OnCheck(index, item)

	self.mStock:HideCursor()
	self.mManage:ShowCursor()
	self.mManagedItem = self.mItemStock[index]
	self.mState = "manage"

--this needs to take in the selected item and pass into the manage price state, 
--make the selection appear and have it handle input

end

function InventoryState:ManagePrice(index)


	local RAISE = 1
	local LOWER = 2

	if index == RAISE then
		self.mManagedItem:ChangePrice(1)
	elseif index == LOWER then
		self.mManagedItem:ChangePrice(-1)
	end

	--if Keyboard.JustPressed(KEY_BACKSPACE) then
	--	self:BackToCheckState()
	--end
--this needs to raise or lower the price of the selected item 
--and then return to the check state on backspace

end

function InventoryState:BackToChooseState()
	self.mState = "choose"
	self.mChooseSelection:ShowCursor()
	self.mStock:HideCursor()
end

function InventoryState:BackToCheckState()
	self.mState = "check"
	self.mStock:ShowCursor()
	self.mManage:HideCursor()
end

function InventoryState:ChooseClick(index, item)

	if index == self.mTabs.check and #self.mItemStock > 0 then
		self.mChooseSelection:HideCursor()
		self.mStock:ShowCursor()
		self.mState = "check"
	else
		self.mStack:Pop()
	end
end

function InventoryState:RenderManageFocus(renderer)
	renderer:AlignText("left", "center")
	self.mManage:Render(renderer)
	self.mStock:Render(renderer)
end

function InventoryState:RenderChooseFocus(renderer)
	renderer:AlignText("left", "center")
	self.mChooseSelection:Render(renderer)

	local focus = self.mChooseSelection:GetIndex()

	if focus == self.mTabs.check then
		self.mStock:Render(renderer)
		self:UpdateScrollbar(renderer, self.mStock)
	else

	end
end

function InventoryState:SetItemData(item)
	if item then
		local def = item
		self.mItemDef = def
		self.mItemDescription = def.mDescription
		if def.mTexture then
			local itemtex = Texture.Find(def.mTexture)
			self.mItemSprite:SetTexture(itemtex)
		end
	else


		--maybe use a transparent texture as a place holder
		self.mItemDescription = ""
		self.mItemDef = nil
		--self.mItemSprite:SetTexture(nil)
	end
end


function InventoryState:UpdateScrollbar(renderer, selection)

	if selection:PercentageShown() <= 1 then
		local scrolled = selection:PercentageScrolled()
		local caretScale = selection:PercentageShown()
		self.mScrollbar:SetScrollCaretScale(caretScale)
		self.mScrollbar:SetNormalValue(scrolled)
		self.mScrollbar:Render(renderer)
	end

end


function InventoryState:Enter() end
function InventoryState:Exit() end

function InventoryState:HandleInput() end

function InventoryState:Update(dt) 
	if self.mState == "choose" then
		self.mChooseSelection:HandleInput()
	elseif self.mState == "check" then
		self.mStock:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:BackToChooseState()
		end
	elseif self.mState == "manage" then
		self.mManage:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:BackToCheckState()
		end
	end
end

function InventoryState:Render(renderer)
	for k, v in ipairs(self.mPanels)do
		v:Render(renderer)
	end

	--local pX = self.mLayout:MidX("portrait")
	--local pY = self.mLayout:MidY("portrait")
	--self.mPortraitSprite:SetPosition(pX, pY)
	--renderer:DrawSprite(self.mPortraitSprite)

	renderer:AlignText("center", "center")
	renderer:ScaleText(1.25, 1.25)
	local tX = self.mLayout:MidX("title")
	local tY = self.mLayout:MidY("title")
	renderer:DrawText2d(tX, tY, self.mName)

	local x = self.mLayout:MidX("choose")
	local y = self.mLayout:MidY("choose")

	if self.mState == "choose" then

		self:RenderChooseFocus(renderer)
		--self:SetItemData(nil)

	elseif self.mState == "check" then

		local checkMessage = "What do you want?"
		renderer:AlignText("center", "center")
		renderer:DrawText2d(x, y, checkMessage)
		renderer:AlignText("left", "center")
		self.mStock:Render(renderer)
		local item = self.mStock:SelectedItem()
		self:SetItemData(item)
		self:UpdateScrollbar(renderer, self.mStock)
		--self.mManage:Render(renderer)

	elseif self.mState == "manage" then

		self:RenderManageFocus(renderer)

	end

	--item desc render
	renderer:AlignText("left", "center")
	renderer:ScaleText(2,2)
	local descX = self.mLayout:Left("desc") + 100
	local descY = self.mLayout:Top("desc") - 80
	local desccolor = nil
	renderer:DrawText2d(descX, descY, self.mItemDescription, desccolor, 800)

	--item image render
	local iX = self.mLayout:MidX("itemimg")
	local iY = self.mLayout:MidY("itemimg")
	self.mItemSprite:SetPosition(iX, iY)
	renderer:DrawSprite(self.mItemSprite)
end
