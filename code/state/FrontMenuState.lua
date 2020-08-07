FrontMenuState = {}
FrontMenuState.__index = FrontMenuState
function FrontMenuState:Create(parent, world)

	local this
	this =
	{
		mParent = parent,
		mStack = parent.mStack,
		mState = "main",
		mStateMachine = parent.mStateMachine,
		mLayout = layout,
		mMenuY = 160,
		mTween = Tween:Create(-900, -550, 0.6, Tween.Linear),
		mTime = 0,
		
		mSelections = Selection:Create
		{
			spacingY = 32,
			data =
			{
				"Rumors",
				"Inventory",
				"Heroes",
				"Vendor",
				"Skills"
			},
			OnSelection = function(...) this:OnMenuClick(...) end
		},

		mPanel = Panel:Create
			{
				texture = Texture.Find("panel2.png"),
				size = 30,
			},

		mVenPanel = Panel:Create
			{
				texture = Texture.Find("panel2.png"),
				size = 30,
			},
		mSkillPanel = Panel:Create
			{
				texture = Texture.Find("panel2.png"),
				size = 30,
			},
		mSkillDescPanel = Panel:Create
			{
				texture = Texture.Find("panel2.png"),
				size = 30,
			},
		mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 500),
	}

	setmetatable(this, self)

			this.mCurrentVendorsMenu = Selection:Create{
			spacingY = 90,
			data = this:CreateVendorSummaries(),
			columns = 1,
			--rows = 1,
			--spacingY = 400,
			displayRows = 1,
			OnSelection = function(...) this:OnVendorChosen(...) end,
			RenderItem = function(menu, renderer, x, y, item)
				if item then
					item:SetPosition(-385, 330)
					item:Render(renderer)
				end
			end
		}

		this.mSkillsMenu = Selection:Create{
			spacingY = 90,
			data = this:CreateSkillsSelection(),
			columns = 1,
			--rows = 1,
			spacingY = 48,
			displayRows = 7,
			OnSelection = function(...) this:OnSkillChosen(...) end,
			--[[RenderItem = function(menu, renderer, x, y, item)
				if item then
					item:SetPosition(-385, 330)
					item:Render(renderer)
				end
			end]]
		}

		this.mSkillsMenu:HideCursor()

		this.mCurrentVendorsMenu:HideCursor()

	local scrollX = 50
	local scrollY = 150
	this.mScrollbar:SetPosition(scrollX, scrollY)
	this.mVenPanel:CenterPosition(-200, 150,
						 500, 500)
	this.mSkillPanel:CenterPosition(-325, 150,
						 250, 500)
	this.mSkillDescPanel:CenterPosition(175, 150,
						 750, 500)		

	return this
end

function FrontMenuState:UpdateScrollbar(renderer, selection)

	if selection:PercentageShown() <= 1 then
		local scrolled = selection:PercentageScrolled()
		local caretScale = selection:PercentageShown()
		self.mScrollbar:SetScrollCaretScale(caretScale)
		self.mScrollbar:SetNormalValue(scrolled)
		self.mScrollbar:Render(renderer)
	end

end

function FrontMenuState:CreateSkillsSelection()
	local skills = {}

	for i = 1, #SkillsDB do		
		for k, v in pairs(SkillsDB[i]) do
			if k == "name" then
				local skillname = v
				table.insert(skills, skillname)
			end
		end
	end
	return skills
end

function FrontMenuState:DrawSkillDesc(menu, renderer, x, y, item)

		local skillLevel = gWorld.mSkills[item].level
		local skillDef = SkillsDB[item]
		--[[if rumorDef.image then
			local rumorImage = RumorImages:Create(Texture.Find(rumorDef.image))
			if rumorImage then
				rumorImage:SetPosition(x + 200, y + 200)
				renderer:DrawSprite(rumorImage)
			end
		end]]

		local name = skillDef.name
		local mastery = string.format("You have cornered the market on %s", name)
		local desc = skillDef.description[skillLevel] or mastery
		local color = nil
		renderer:AlignText("left", "center")
		renderer:DrawText2d(x, y, desc, color, 600)

		local price = skillDef.price[skillLevel] or 0

		local invest = string.format("Make this investment for %i gold?", price)
		local message = ""
		if price > 0 then
			message = invest
		else
			message = ""
		end

		renderer:DrawText2d(x + 50, y - 330, message)
end

function FrontMenuState:OnSkillChosen(index, item)
	gWorld:SkillUp(index)
end

function FrontMenuState:CreateVendorSummaries()

	local currentvendors = gWorld.mVillage.mCurrentVendors

	local out = {}
	for _, v in pairs(currentvendors) do 
		local summary = VendorSummary:Create(v)
		table.insert(out, summary)
	end
	return out
end


function FrontMenuState:TurnOff()
	local current = self.mTween:Value()

	self.mTween = Tween:Create(current, -900, 0.6, Tween.Linear)
end

function FrontMenuState:IsTurningOff()
	return self.mTween:FinishValue() == -900
end

function FrontMenuState:IsFinished()
	return self.mTween:Value() == -900  and self.mTween:FinishValue() == -900
end

function FrontMenuState:HandleInput()
	--self.mSelections:HandleInput()
end

function FrontMenuState:OnVendorChosen(index, item)

	local vendorstate = VendorState:Create(self.mParent, item.mVendor)
	self.mStack:Push(vendorstate)

end

function FrontMenuState:ToVendorChoose()
	self.mState = "vendor"
	self.mSelections:HideCursor()
	--self.mCurrentVendorsMenu:ShowCursor()
end

function FrontMenuState:ToSkillsChoose()
	self.mState = "skills"
	self.mSelections:HideCursor()
	self.mSkillsMenu:ShowCursor()
end

function FrontMenuState:ReturnToMain()
	self.mState = "main"
	self.mSelections:ShowCursor()
	self.mCurrentVendorsMenu:HideCursor()
end

function FrontMenuState:Update(dt)

	self.mTime = self.mTime + dt
	self.mTween:Update(dt)
	
	if self.mState == "main" then
	self.mSelections:HandleInput()

		if Keyboard.JustPressed(KEY_BACKSPACE) or
		Keyboard.JustPressed(KEY_ESCAPE) then
			self:TurnOff()
			
		end

	elseif self.mState == "vendor" then
		self.mCurrentVendorsMenu:HandleInput()
		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:ReturnToMain()
		end

	elseif self.mState == "skills" then
		self.mSkillsMenu:HandleInput()
		if Keyboard.JustPressed(KEY_BACKSPACE) then
			self:ReturnToMain()
		end
	end


	if self:IsFinished() then
			print("here we are")
			self.mStack:Pop()
	end
end

function FrontMenuState:Render(renderer)

	local x = self.mTween:Value()

	self.mPanel:CenterPosition(x, self.mMenuY,
						 250, 250)

	self.mPanel:Render(renderer)

	renderer:ScaleText(1.5, 1.5)
	renderer:AlignText("left", "center")
	local selectionX = self.mTween:Value() - 80
	local selectionY = self.mMenuY + 55
	self.mSelections:SetPosition(selectionX, selectionY)
	self.mSelections:Render(renderer)


	--Building the render for the vendor selector
	if self.mState == "vendor" then
	self.mVenPanel:Render(renderer)
	self.mCurrentVendorsMenu:Render(renderer)
	self:UpdateScrollbar(renderer, self.mCurrentVendorsMenu)
	end

	--Building the render for the skills selector


	local skillx = -425
	local skilly = 290
	self.mSkillsMenu:SetPosition(skillx, skilly)

	if self.mState == "skills" then
	self.mSkillPanel:Render(renderer)
	self.mSkillsMenu:Render(renderer)
	self.mSkillDescPanel:Render(renderer)
	--self:UpdateScrollbar(renderer, self.mSkillsMenu)


	--local menu = self.mSkillsMenu:GetIndex()
	local skilldescx = -100
	local skilldescy = 310
		
	local description = ""
	local selectedItem = self.mSkillsMenu:GetIndex()
	--[[if selectedItem then
		local skillDef = SkillDB[selectedItem.id]
		description = skillDef.description
	end]]
		self:DrawSkillDesc(self, renderer, skilldescx, skilldescy, selectedItem)
	end

end

function FrontMenuState:OnMenuClick(index)

	local RUMORS = 1
	local INVENTORY = 2
	local HEROES = 3
	local VENDOR = 4
	local SKILLS = 5

	if index == RUMORS then
		return self.mStateMachine:Change("rumors")
	elseif index == INVENTORY then
		return self.mStateMachine:Change("inventory")
	elseif index == HEROES then
		return self.mStateMachine:Change("check heroes")
	elseif index == VENDOR then
		self:ToVendorChoose()
	elseif index == SKILLS then
		self:ToSkillsChoose()
	end
end

function FrontMenuState:Enter()
--self.mTween = Tween:Create(-900, -360, 0.6, Tween.Linear)
end
function FrontMenuState:Exit() end