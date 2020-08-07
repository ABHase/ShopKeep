CustomerState = TransactionState:Create()
CustomerState.__index = CustomerState
function CustomerState:Create(parent, def)
	
	def = def or {}

	local this
	this = 
	{
		mParent = parent,
		mStack = parent.mStack,
		mWorld = gWorld,
		mDef = def, 
		mPanels = {},
		mName = def.mName or "Hero",
		mState = "choose",
		mItemStock = def.mItems,
		mGold = def.mGold,
		mRoll = Dice.RollDie(1, 20),
		mTabs =
		{
			["buy"] = 1,
			["sell"] = 2,
			["exit"] = 3,
		},
		mChooseSelection = Selection:Create
		{
			data =
			{
				"Buy",
				"Check Out",
				"Exit",
			},
			rows = 1,
			columns = 3,
			OnSelection = function(...) this:ChooseClick(...) end,
		},
		mInventory = nil,
		mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 405),
		mFilter = def.mId,
		mItemDescription = "",
		mItemSprite = Sprite.Create(),
		mPortraitSprite = Sprite.Create(),
		mPortraitSpriteTexture = def.mPortraitTexture,

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

function CustomerState:CreateStock()
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



function CustomerState:OnSell()

	local gold = self.mWorld.mGold
	local customergold = self.mGold

	local shoppinglist = self:DetermineWhatToBuy()

	for i = #shoppinglist, 1, -1 do
		local v = shoppinglist[i]
		local clothesbonus = gWorld:DetermineHaggleBonus()
		
		local markup = v.mPrice - v.mBasePrice
		local maxmarkup = 4/(v.mBasePrice^(1/3))

		local roll = self.mRoll 

		local finalroll = roll + clothesbonus

		local skillcheck = 20 * (markup / (maxmarkup * v.mBasePrice)) 
		local skillbonus = (self.mDef.mStats:Get("chr") - 10) / 2
		local finalcheck = skillcheck + skillbonus

		if finalroll < finalcheck then
			
			local name = v.mName
			local price = v.mPrice
			local customername = self.mName
			local message = string.format("The %s thinks the %s for %i is too much", customername, name, 
				price)
			gStack:PushFit(gRenderer, 0, 0, message)
		else

			self.mWorld.mTaxes = self.mWorld.mTaxes + v.mPrice

			gold = gold + v.mPrice
			self.mWorld.mGold = gold
			customergold = customergold - v.mPrice
			self.mDef.mGold = customergold

			gWorld:RemoveItem(v)
			print(v.mPrice)
			print(v.mName)
			self.mDef:AddItem(v)

			self.mDef:Equip(v.mSlot, v)

			local name = v.mName
			local price = v.mPrice
			local customername = self.mName
			local message = string.format("%s Bought %s for %i Gold", customername, name, 
				price)
			gStack:PushFit(gRenderer, 0, 0, message)
		end
	end	
end

function CustomerState:DetermineWhatToBuy()

	local customergold = self.mGold
	local list = {}
		
	--First we filter the list by what they can use and afford

	for i = #gWorld.mItems, 1, -1 do
		local v = gWorld.mItems[i]
		if self:IsEquipmentBetter(v) then
			if v.mType == self.mFilter then
				if customergold >= v.mPrice then
					table.insert(list, v)
					break
				end
			end
		end
	end

		--Then we return the item on the filtered list with highest price	
	return list    
end

function CustomerState:IsEquipmentBetter(item)

	if item.mSlot == "weapon" then
		local diff = self.mDef:PredictStats("weapon", item)
	
	return diff > 0
	
	elseif item.mSlot == "armor" then
		local diff = self.mDef:PredictStats("armor", item)
	
	return diff > 0
	
	end

	return false
end

function CustomerState:RemoveObsolete()
	for i = #gWorld.mItems, 1, -1 do
		local v = gWorld.mItems[i]
		if v.mType == self.mFilter then
			if self:IsEquipmentBetter(v) then
				self.mDef:Unequip(v.mSlot)
			end
		end
	end
end


--[[function CustomerState:OnBuy(index, item)
	
	local gold = self.mWorld.mGold

	if gold < item.mPrice then
		return --can't afford
	end

	gold = gold - item.mPrice
	self.mDef.mGold = self.mDef.mGold + item.mPrice
	
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


function CustomerState:RenderStock(menu, renderer, x, y, item)
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

function CustomerState:BackToChooseState()
	self.mState = "choose"
	self.mChooseSelection:ShowCursor()
	self.mStock:HideCursor()
end

function CustomerState:ChooseClick(index, item)

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

function CustomerState:RenderChooseFocus(renderer)
	renderer:AlignText("left", "center")
	self.mChooseSelection:Render(renderer)

	local focus = self.mChooseSelection:GetIndex()

	if focus == self.mTabs.buy then
		self.mStock:Render(renderer)
		self:UpdateScrollbar(renderer, self.mStock)
	else

	end
end

function CustomerState:SetItemData(item)
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


function CustomerState:UpdateScrollbar(renderer, selection)

	if selection:PercentageShown() <= 1 then
		local scrolled = selection:PercentageScrolled()
		local caretScale = selection:PercentageShown()
		self.mScrollbar:SetScrollCaretScale(caretScale)
		self.mScrollbar:SetNormalValue(scrolled)
		self.mScrollbar:Render(renderer)
	end

end


function CustomerState:Enter() 
--gWorld:RemoveHero(self.mDef)
end

function CustomerState:Exit() end

function CustomerState:HandleInput() end

function CustomerState:Update(dt) 

	if self.mState == "choose" then
		self.mChooseSelection:HandleInput()
	elseif self.mState == "buy" then
		self.mStock:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:BackToChooseState()
		end
	end
end

function CustomerState:Render(renderer)
	for k, v in ipairs(self.mPanels)do
		v:Render(renderer)
	end

	local pX = self.mLayout:MidX("portrait")
	local pY = self.mLayout:MidY("portrait")
	self.mPortraitSprite:SetPosition(pX, pY)
	renderer:DrawSprite(self.mPortraitSprite)

	renderer:AlignText("center", "center")
	renderer:ScaleText(1.25, 1.25)
	local tX = self.mLayout:MidX("title")
	local tY = self.mLayout:MidY("title")
	renderer:DrawText2d(tX, tY, self.mName)
	local wealth = string.format("%d", self.mDef.mGold)
	renderer:DrawText2d(tX, tY - 30, "Gold: ")
	renderer:DrawText2d(tX + 50, tY - 30, wealth)

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
