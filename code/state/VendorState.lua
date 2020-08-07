VendorState = TransactionState:Create()
VendorState.__index = VendorState
function VendorState:Create(parent, def)
	
	def = def or {}

	local this
	this = 
	{
		mParent = parent,
		mStack = parent.mStack,
		mWorld = gWorld,
		mDef = def, 
		mPanels = {},
		mName = def.mName or "Vendor",
		mState = "choose",
		mItemStock = def.mStock,
		mTabs =
		{
			["buy"] = 1,
			["exit"] = 2,
		},
		mChooseSelection = Selection:Create
		{
			data =
			{
				"Buy",
				"Exit",
			},
			rows = 1,
			columns = 2,
			OnSelection = function(...) this:ChooseClick(...) end,
		},
		--[[mStock = Selection:Create
		{
			data = def.mStock,
			displayRows = 13,
			RenderItem = function(...) this:RenderStock(...) end,
			OnSelection = function(...) this:OnBuy(...) end,
		},]]
		mInventory = nil,
		mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 405),
		mItemDescription = "",
		mItemSprite = Sprite.Create(),
		mPortraitSprite = Sprite.Create(),
		mPortraitSpriteTexture = Texture.Find(def.mRawPortrait),

	}

	this.mPortraitSprite:SetTexture(this.mPortraitSpriteTexture)

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


	--setting pos of the selection of the vendors inventory
	local sX = layout:Left("inv") + 30
	local sY = layout:Top("inv") - 60
	this.mPriceX = layout:Right("inv") - 56
	--this.mStock:SetPosition(sX, sY)

	local scrollX = layout:Right("inv") - 14
	local scrollY = layout:MidY("inv")
	this.mScrollbar:SetPosition(scrollX, scrollY)

	setmetatable(this, self)



	this.mStock = this:CreateStock()
	this.mStock:HideCursor()
	--this.mInventory:HideCursor()
	return this
end

function VendorState:CreateStock()
	local stock = self.mItemStock
	local inv = Selection:Create
		{
			data = stock,
			displayRows = 13,
			RenderItem = function(...) self:RenderStock(...) end,
			OnSelection = function(...) self:OnBuy(...) end,
		}
	local sX = self.mLayout:Left("inv") + 30
	local sY = self.mLayout:Top("inv") - 60
	inv:SetPosition(sX, sY)
	inv:HideCursor() -- hidden by default
	return inv
end


--[[function VendorState:OnBuy(index, item)
	
	local gold = self.mWorld.mGold

	if gold < item.mPrice then
		return --can't afford
	end

	gold = gold - item.mPrice
	self.mWorld.mGold = gold
	self.mWorld:AddItem(item)
	table.remove(self.mItemStock, index)
	self.mStock.data = self.mItemStock

	-- Refresh inventory display
	self.mStock = self:CreateStock()
	self.mStock:ShowCursor()

	-- Attempt to restore the index
	for i = 1, index - 1 do
		self.mStock:MoveDown()
	end


	if #self.mItemStock < 1 then
		self:BackToChooseState()
	end
end

function VendorState:RenderStock(menu, renderer, x, y, item)
	if item == nil then
		return
	end

	local color = nil
	if self.mWorld.mGold < item.mPrice then
		color = Vector.Create(0.6, 0.6, 0.6, 1)
	end

	self.mWorld:DrawItem(menu, renderer, x, y, item, color)

	renderer:AlignTextX("right")
	local priceStr = string.format(": %d", item.mPrice)
	renderer:DrawText2d(self.mPriceX, y, priceStr, color)
end

function VendorState:BackToChooseState()
	self.mState = "choose"
	self.mChooseSelection:ShowCursor()
	self.mStock:HideCursor()
end

function VendorState:ChooseClick(index, item)

	if index == self.mTabs.buy and #self.mItemStock > 0 then
		self.mChooseSelection:HideCursor()
		self.mStock:ShowCursor()
		self.mState = "buy"
	else
		self.mStack:Pop()
	end
end

function VendorState:RenderChooseFocus(renderer)
	renderer:AlignText("left", "center")
	self.mChooseSelection:Render(renderer)

	local focus = self.mChooseSelection:GetIndex()

	if focus == self.mTabs.buy then
		self.mStock:Render(renderer)
		self:UpdateScrollbar(renderer, self.mStock)
	else

	end
end

function VendorState:SetItemData(item)
	if item then
		--shopDef.stock[1].mPrice
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


function VendorState:UpdateScrollbar(renderer, selection)

	if selection:PercentageShown() <= 1 then
		local scrolled = selection:PercentageScrolled()
		local caretScale = selection:PercentageShown()
		self.mScrollbar:SetScrollCaretScale(caretScale)
		self.mScrollbar:SetNormalValue(scrolled)
		self.mScrollbar:Render(renderer)
	end

end


function VendorState:Enter() end
function VendorState:Exit() end
function VendorState:HandleInput() end

function VendorState:Update(dt) 
	if self.mState == "choose" then
		self.mChooseSelection:HandleInput()
	elseif self.mState == "buy" then
		self.mStock:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:BackToChooseState()
		end
	end
end

function VendorState:Render(renderer)
	for k, v in ipairs(self.mPanels)do
		v:Render(renderer)
	end

	local pX = self.mLayout:MidX("portrait") + 45
	local pY = self.mLayout:MidY("portrait")
	self.mPortraitSprite:SetScale(0.9, 0.9)
	self.mPortraitSprite:SetPosition(pX, pY)
	renderer:DrawSprite(self.mPortraitSprite)

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

	elseif self.mState == "buy" then

		local buyMessage = "What do you want?"
		renderer:AlignText("center", "center")
		renderer:DrawText2d(x, y, buyMessage)
		renderer:AlignText("left", "center")
		self.mStock:Render(renderer)
		local item = self.mStock:SelectedItem()
		self:SetItemData(item)
		self:UpdateScrollbar(renderer, self.mStock)

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
end]]
