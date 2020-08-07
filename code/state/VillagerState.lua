VillagerState = TransactionState:Create()
VillagerState.__index = VillagerState
function VillagerState:Create(parent)

	local this
	this = 
	{
		mParent = parent,
		mStack = parent.mStack,
		mWorld = gWorld,
		--mDef = def, 
		mPanels = {},
		mName = "Villager",
		mState = "choose",
		mPurchased = false,
		--mItemStock = def.mItems,
		mGold = Dice.RollDie(4, 10),
		mRoll = Dice.RollDie(1, 20),
		mTabs =
		{
			--["buy"] = 1,
			["sell"] = 1,
			["exit"] = 2,
		},
		mChooseSelection = Selection:Create
		{
			data =
			{
				--"Buy",
				"Check Out",
				"Exit",
			},
			rows = 1,
			columns = 2,
			OnSelection = function(...) this:ChooseClick(...) end,
		},
		mStock = Selection:Create
		{
			data = ItemDB[1],
			displayRows = 5,
			RenderItem = function(...) this:RenderStock(...) end,
			OnSelection = function(...) this:OnBuy(...) end,
		},
		mInventory = nil,
		mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 405),
		mFilter = "village",
		mItemDescription = "",
		mItemSprite = Sprite.Create(),
		--mPortraitSprite = Sprite.Create(),
		--mPortraitSpriteTexture = def.mPortraitTexture,

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


	--setting pos of the selection of the vendors inventory
	local sX = layout:Left("inv") - 16
	local sY = layout:Top("inv") - 30
	this.mPriceX = layout:Right("inv") - 56
	this.mStock:SetPosition(sX, sY)

	local scrollX = layout:Right("inv") - 14
	local scrollY = layout:MidY("inv")
	this.mScrollbar:SetPosition(scrollX, scrollY)

	setmetatable(this, self)
	--this.mInventory = this:CreateInvSelection()
	this.mStock:HideCursor()
	--this.mInventory:HideCursor()
	return this
end

function VillagerState:OnSell()

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

		local something = 20 * (markup / (maxmarkup * v.mBasePrice))



		if finalroll < something then
			
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
			self.mGold = customergold
			self.mPurchased = true

			gWorld:RemoveItem(v)
			print(v.mPrice)
			print(v.mName)
			
			local name = v.mName
			local price = v.mPrice
			local customername = self.mName
			local message = string.format("%s Bought %s for %i Gold", customername, name, 
				price)
			gStack:PushFit(gRenderer, 0, 0, message)
		end
	end	
end

function VillagerState:DetermineWhatToBuy()

	local customergold = self.mGold
	local list = {}
		
	--First we filter the list by what they can use and afford

	for i = #gWorld.mItems, 1, -1 do
		local v = gWorld.mItems[i]
		if not self.mPurchased then
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

--[[function VillagerState:OnBuy(index, item)
	
	local gold = self.mWorld.mGold
	local customergold = self.mGold

	if gold < item.mPrice then
		return --can't afford
	end

	gold = gold - item.mPrice
	customergold = customergold + item.mPrice
	self.mGold = customergold
	self.mWorld.mGold = gold
	table.remove(self.mItemStock, index)
	self.mStock.data = self.mItemStock
	self.mStock.displayRows = #self.mItemStock

	if #self.mStock < 1 then
		self:BackToChooseState()
	end
	
	--local name = item.mName
	--local message = string.format("Bought %s", name)
	--self.mStack:PushFit(gRenderer, 0, 0, message)
end

--[[function VillagerState:RenderStock(menu, renderer, x, y, item)
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

function VillagerState:BackToChooseState()
	self.mState = "choose"
	self.mChooseSelection:ShowCursor()
	self.mStock:HideCursor()
end

function VillagerState:ChooseClick(index, item)

	--[[if index == self.mTabs.buy and #self.mItemStock > 0 then
		self.mChooseSelection:HideCursor()
		self.mStock:ShowCursor()
		self.mState = "buy"
	if index == self.mTabs.sell then
		self:OnSell()
	else
		--print(self.mDef.mGold)
		--self:OnSell()
		--gWorld:AddHero(self.mDef)
		self.mStack:Pop()
	end
end

function VillagerState:RenderChooseFocus(renderer)
	renderer:AlignText("left", "center")
	self.mChooseSelection:Render(renderer)

	local focus = self.mChooseSelection:GetIndex()

	if focus == self.mTabs.buy then
		self.mStock:Render(renderer)
		self:UpdateScrollbar(renderer, self.mStock)
	else

	end
end

function VillagerState:SetItemData(item)
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


function VillagerState:UpdateScrollbar(renderer, selection)

	if selection:PercentageShown() <= 1 then
		local scrolled = selection:PercentageScrolled()
		local caretScale = selection:PercentageShown()
		self.mScrollbar:SetScrollCaretScale(caretScale)
		self.mScrollbar:SetNormalValue(scrolled)
		self.mScrollbar:Render(renderer)
	end

end


function VillagerState:Enter() 
--gWorld:RemoveHero(self.mDef)
end

function VillagerState:Exit() end

function VillagerState:HandleInput() end

function VillagerState:Update(dt) 
	--self:OnSell()
	if self.mState == "choose" then
		self.mChooseSelection:HandleInput()
	elseif self.mState == "buy" then
		self.mStock:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:BackToChooseState()
		end
	end
end

function VillagerState:Render(renderer)
	for k, v in ipairs(self.mPanels)do
		v:Render(renderer)
	end

	--[[local pX = self.mLayout:MidX("portrait")
	local pY = self.mLayout:MidY("portrait")
	self.mPortraitSprite:SetPosition(pX, pY)
	renderer:DrawSprite(self.mPortraitSprite)

	renderer:AlignText("center", "center")
	renderer:ScaleText(1.25, 1.25)
	local tX = self.mLayout:MidX("title")
	local tY = self.mLayout:MidY("title")
	renderer:DrawText2d(tX, tY, self.mName)
	local wealth = string.format("%d", self.mGold)
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
	renderer:ScaleText(1,1)
	local descX = self.mLayout:Left("desc") + 8
	local descY = self.mLayout:Top("desc") - 20
	renderer:DrawText2d(descX, descY, self.mItemDescription)

	--item image render
	local iX = self.mLayout:MidX("itemimg")
	local iY = self.mLayout:MidY("itemimg")
	self.mItemSprite:SetPosition(iX, iY)
	renderer:DrawSprite(self.mItemSprite)
end]]
