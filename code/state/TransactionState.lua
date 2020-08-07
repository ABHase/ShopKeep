TransactionState = {}
TransactionState.__index = TransactionState
function TransactionState:Create()
	local this
	this = {}
	
	setmetatable(this, self)
	
	return this
end

function TransactionState:OnBuy(index, item)
	
	local gold = self.mWorld.mGold

	local freespace = self.mWorld:DetermineStorage() - #self.mWorld.mItems

	if gold < item.mBasePrice then
		return --can't afford
	end

	if freespace < 1 then
		local space = self.mWorld:DetermineStorage()
		local message = string.format("You only have storage for %i items, you'll have to expand to buy more", space)
		gStack:PushFit(gRenderer, 0, 0, message)
		return self:BackToChooseState()
	end

	gold = gold - item.mBasePrice

	if self.mDef.mGold then
	self.mDef.mGold = self.mDef.mGold + item.mBasePrice
	end

	if self.mDef.mTransactions then
	self.mDef.mTransactions = self.mDef.mTransactions + 1
	end

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

function TransactionState:RenderStock(menu, renderer, x, y, item)
	if item == nil then
		return
	end

	local color = nil
	if self.mWorld.mGold < item.mBasePrice then
		color = Vector.Create(0.6, 0.6, 0.6, 1)
	end

	self.mWorld:DrawItem(menu, renderer, x, y, item, color)

	renderer:AlignTextX("right")
	local priceStr = string.format(": %d", item.mBasePrice)
	renderer:DrawText2d(self.mPriceX, y, priceStr, color)
end

function TransactionState:BackToChooseState()
	self.mState = "choose"
	self.mChooseSelection:ShowCursor()
	self.mStock:HideCursor()
end

function TransactionState:ChooseClick(index, item)

	if index == self.mTabs.buy and #self.mItemStock > 0 then
		self.mChooseSelection:HideCursor()
		self.mStock:ShowCursor()
		self.mState = "buy"
	elseif index == self.mTabs.sell then
		self:OnSell()
	else
		self.mStack:Pop()
	end
end

function TransactionState:RenderChooseFocus(renderer)
	renderer:AlignText("left", "center")
	self.mChooseSelection:Render(renderer)

	local focus = self.mChooseSelection:GetIndex()

	if focus == self.mTabs.buy then
		self.mStock:Render(renderer)
		self:UpdateScrollbar(renderer, self.mStock)
	else

	end
end

function TransactionState:SetItemData(item)
	if item then
		--shopDef.stock[1].mBasePrice
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


function TransactionState:UpdateScrollbar(renderer, selection)

	if selection:PercentageShown() <= 1 then
		local scrolled = selection:PercentageScrolled()
		local caretScale = selection:PercentageShown()
		self.mScrollbar:SetScrollCaretScale(caretScale)
		self.mScrollbar:SetNormalValue(scrolled)
		self.mScrollbar:Render(renderer)
	end

end

function TransactionState:Enter() end
function TransactionState:Exit() end
function TransactionState:HandleInput() end

function TransactionState:Update(dt) 

	if self.mState == "choose" then
		self.mChooseSelection:HandleInput()
	elseif self.mState == "buy" then
		self.mStock:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:BackToChooseState()
		end
	end
end

function TransactionState:Render(renderer)
	for k, v in ipairs(self.mPanels)do
		v:Render(renderer)
	end

	if self.mPortraitSprite then
		local pX = self.mLayout:MidX("portrait") + 45
		local pY = self.mLayout:MidY("portrait")
		self.mPortraitSprite:SetScale(0.9, 0.9)
		self.mPortraitSprite:SetPosition(pX, pY)
		renderer:DrawSprite(self.mPortraitSprite)
	end

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
end