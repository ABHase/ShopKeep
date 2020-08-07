BackdropState = {}
BackdropState.__index = BackdropState
function BackdropState:Create(stack, params)
	local this =
	{
		mStack = stack,
		mAppearTween = Tween:Create(550, 30, 3, Tween.Linear),
		mTime = 0,
		mTexture = params.texture,
		mFrontCloudScroll = 0,
		mBackCloudScroll = 0,
		mFrontCloudSpeed = 50,
		mBackCloudSpeed = 15,
		mCloudLoopingPoint = 1600, 
		mZoom = 1,
	}

	setmetatable(this, self)
	return this
end

function BackdropState:CustomerAppear()
	
	local marketing = gWorld:DetermineMarketing()
	local customers = {}
	local customerStates = {}


	--Determine who's around throw them in a table
	for i = 1, #gWorld.mCurrentHeroes.mMembers do
		local potentialcustomer = gWorld.mCurrentHeroes.mMembers[i]
			if not potentialcustomer:CheckBusy(gWorld.mDay) then
				table.insert(customers, potentialcustomer)
			end
	end

	local shopping = #customers

	if shopping < marketing then
		marketing = shopping
	end

	for i = 1, #customers*2 do
    	local a = math.random(#customers)
    	local b = math.random(#customers)
    	customers[a],customers[b] = customers[b],customers[a]
	end 

	for i = 1, marketing do
		local customer = customers[i]
				local customerstate = CustomerState:Create(self, customer)
				table.insert(customerStates, customerstate)
	end

	for j = 1, #customerStates do
		self.mStack:Push(customerStates[j])
	end
end

function BackdropState:VillagerAppear()
			local customerstate = VillagerState:Create(self)
			self.mStack:Push(customerstate)
end

function BackdropState:TaxesDue()

local width = System.ScreenWidth() - 4
local height = 400 -- a nice height
local x = 0
local y = -System.ScreenHeight()/2 + height / 2 -- bottom of the screen
local taxes = math.floor(gWorld.mTaxes / (10 + gWorld:DetermineTaxBonus()))
local text = "Taxes are due, let's call it an even %i"
local message = string.format(text, taxes)
local title = "Beadle:"
local avatar = Texture.Find("urchin_shop.png")

self.mStack:PushFit(gRenderer, 0, 0, message, 300,
{
title = title,
avatar = avatar,
choices =
{
options = {"Yes", "No"},
OnSelection = function(...) self:OnTaxesClick(...) end
}
})

end

function BackdropState:OnTaxesClick(index)

	local PAY = 1
	local REFUSE = 2

	if index == PAY then
		if gWorld.mGold > math.floor(gWorld.mTaxes / (10 + gWorld:DetermineTaxBonus())) then
			gWorld.mGold = gWorld.mGold - math.floor(gWorld.mTaxes / (10 + gWorld:DetermineTaxBonus()))
			gWorld.mTaxes = 0
		else
			self.mStack:PushFit(gRenderer, 0, 0, "Off to jail!", 150,
			{
			choices =
			{
			options = {"Yes", "No"},
			OnSelection = function(...) System.Exit()end
			}
			})
		end
	elseif index == REFUSE then
		self.mStack:PushFit(gRenderer, 0, 0, "Off to jail!", 150,
			{
			choices =
			{
			options = {"Yes", "No"},
			OnSelection = function(...) System.Exit()end
			}
			})
	end
end

function BackdropState:PlayGossip()

	

	if #gWorld.mDeathGossip > 0 then
		local heroindex = math.random(#gWorld.mDeathGossip)

		local heroname = gWorld.mDeathGossip[heroindex]

		local text = GossipDB[2][math.random(#GossipDB[2])]

		local message = string.format(text, heroname)
			self.mStack:PushFit(gRenderer, math.random(-System.ScreenWidth() / 2 + 300, System.ScreenWidth() / 2 - 300),
			math.random(-System.ScreenHeight() / 2 + 100, System.ScreenHeight() / 2 - 100), message, 600)

		table.remove(gWorld.mDeathGossip, heroindex)
	end

	if #gWorld.mGossip > 0 then
		local heroindex = math.random(#gWorld.mGossip)

		local heroname = gWorld.mGossip[heroindex]

		local text = GossipDB[1][math.random(#GossipDB[1])]

		local message = string.format(text, heroname)
			self.mStack:PushFit(gRenderer, math.random(-System.ScreenWidth() / 2 + 300, System.ScreenWidth() / 2 - 300),
			math.random(-System.ScreenHeight() / 2 + 100, System.ScreenHeight() / 2 - 100), message, 600)

		table.remove(gWorld.mGossip, heroindex)
	else
		local emptymessage = string.format("Not much happening today")
					self.mStack:PushFit(gRenderer, math.random(-System.ScreenWidth() / 2 + 300, System.ScreenWidth() / 2 - 300),
			math.random(-System.ScreenHeight() / 2 + 100, System.ScreenHeight() / 2 - 100), emptymessage, 600)	
	end
end

function BackdropState:Enter() end
function BackdropState:Exit() end

function BackdropState:Update(dt)
	
	self.mFrontCloudScroll = (self.mFrontCloudScroll + self.mFrontCloudSpeed * dt) 
		% self.mCloudLoopingPoint

	self.mBackCloudScroll = (self.mBackCloudScroll + self.mBackCloudSpeed * dt) 
		% self.mCloudLoopingPoint

	if self.mStack:Top() == self then
		self.mTime = self.mTime + dt
	end

		if self.mTime > 1 and self.mTime < 3 then
			for i = #gWorld.mGossip, 1, -1 do
				self:PlayGossip()
				self.mTime = 3
			end
		end

		if self.mTime > 8 and self.mTime < 12 and gWorld.mShopOpen then
			self:CustomerAppear()
			self.mTime = 13
		end

		if self.mTime > 20 and self.mTime < 25 and gWorld.mShopOpen then
			self:VillagerAppear()
			self.mTime = 26
		end

		if self.mTime > 30 then

			if #gWorld.mCurrentHeroes.mMembers < 7 then
				gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))
			end

			for i = 1, #gWorld.mVillage.mCurrentVendors do
				gWorld.mVillage.mCurrentVendors[i]:AccumlatedWealth()
			end

			gWorld:AddEncounter(1)
			gWorld:AddEncounter(1)
			--gWorld:AddEncounter(1)
			gWorld:AddEncounter()
			--gWorld:Encounter()
			Adventure(gWorld)

			self.mTime = 0
			gWorld.mDay = gWorld.mDay + 1

			if  gWorld.mDay % 7 == 0 then
				self:TaxesDue()

				for i = 1, #gWorld.mVillage.mCurrentVendors do
					gWorld.mVillage.mCurrentVendors[i]:Restock()
				end
			end

			for i = #gWorld.mCurrentHeroes.mMembers, 1, -1 do
				local v = gWorld.mCurrentHeroes.mMembers[i]
					for j = #v.mItems, 1, -1 do
						local gear = v.mItems[j]
						if gear.mType == v.mId then
							if v:IsEquipmentBetter(gear) then
								v:Equip(gear.mSlot, gear)
							end
						end
					end
			end
		end

	--if self.mTime > 15 then
	--	self.mTime = 0
	--end

	self.mAppearTween:Update(dt)
	print(self.mTime)
end

function BackdropState:Render(renderer)

	--local xs = self.mAppearTween:Value()
	local frontx = -self.mFrontCloudScroll + 950
	local backx = -self.mBackCloudScroll + 950

	local sky = Sprite.Create()
	local frontcloud = Sprite.Create()
	local backcloud = Sprite.Create()
	local mountains = Sprite.Create()
	local buildings = Sprite.Create()
	local railing = Sprite.Create()
	local face = Sprite.Create()

	mountains:SetTexture(Texture.Find("mountains.png"))
	buildings:SetTexture(Texture.Find("foreground.png"))
	railing:SetTexture(Texture.Find("railing.png"))
	--face:SetTexture(Texture.Find("face1.png"))

	--spriteimage
	sky:SetTexture(Texture.Find("sky.png"))


	frontcloud:SetTexture(Texture.Find("front_cloud.png"))
	frontcloud:SetPosition(frontx, 190)

	backcloud:SetTexture(Texture.Find("back_cloud.png"))
	backcloud:SetPosition(backx, 395)

	--face:SetPosition(240, 270)
	buildings:SetScale(self.mZoom, self.mZoom)

	renderer:DrawSprite(sky)
	renderer:DrawSprite(mountains)
	renderer:DrawSprite(backcloud)
	renderer:DrawSprite(frontcloud)
	renderer:DrawSprite(buildings)
	--renderer:DrawSprite(face)
	renderer:DrawSprite(railing)

	--renderer:DrawSprite(spriteimage)

	local opacity = self.mTime * 0.025

	local red = self.mTime * 0.007

	local blue = self.mTime * 0.005

	--[[if self.mTime > 29.5 then 
		blue = 0
		red = 0
		opacity = 1
	end]]

	--[[renderer:DrawRect2d(System.ScreenTopLeft(),
                     System.ScreenBottomRight(),
                     Vector.Create(0,0,0,opacity))]]

	--local goldX = -System.ScreenWidth()/2 
	--local goldY = System.ScreenHeight()/2

	local goldX = 600
	local goldY = 190

	local textColor = Vector.Create(0,0,0,1)

	local taxColor = Vector.Create(1,0,0,1)

	renderer:ScaleText(2, 2)
	renderer:AlignText("left", "top")
	renderer:DrawText2d(goldX, goldY, "Gold:", textColor)
	renderer:DrawText2d(goldX, goldY - 30, "Day:", textColor)
	renderer:DrawText2d(goldX, goldY + 30, "Sales:", textColor)
	
	renderer:AlignText("center", "top")
	renderer:DrawText2d(goldX + 125, goldY, gWorld:GoldAsString(), textColor)
	renderer:DrawText2d(goldX + 105, goldY - 30, gWorld:DayAsString(), textColor)
	renderer:DrawText2d(goldX + 125, goldY + 30, gWorld:TaxesAsString(), taxColor)
	--renderer:DrawText2d(goldX + 220, goldY - 160, gWorld:MarkupAsString(), textColor)

	renderer:AlignText("left", "top")
	if not gWorld.mShopOpen then
		renderer:DrawText2d(goldX, goldY - 60, "Closed", textColor)
	else
		renderer:DrawText2d(goldX, goldY - 60, "Open", textColor)
	end
end

function BackdropState:HandleInput()

	--[[if Keyboard.JustPressed(KEY_F) then
		local storyboard = Storyboard:Create(gStack, testcutscene[1], true)
		return self.mStack:Push(storyboard) 
	end]]

	if Keyboard.JustPressed(KEY_LALT) then
		local menu = InGameMenuState:Create(self.mStack)
		return self.mStack:Push(menu)
	end

	if Keyboard.JustPressed(KEY_O) then
		gWorld.mShopOpen = not gWorld.mShopOpen
	end

	--[[if Keyboard.JustPressed(KEY_M) then
		print(gWorld.mVillage.mCurrentVendors[2].mTransactions)
		gWorld.mVillage.mCurrentVendors[2]:AccumlatedWealth()
	end

	if Keyboard.JustPressed(KEY_R) then
		--self:TaxesDue()
		print("here?")
		gWorld.mVillage.mCurrentVendors[2]:Restock()
	end]]
end