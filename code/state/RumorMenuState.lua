RumorMenuState = {}
RumorMenuState.__index = RumorMenuState
function RumorMenuState:Create(parent)

	local layout = Layout:Create()
	layout:Contract('screen', 118, 40)
	layout:SplitHorz('screen', "top", "bottom", 0.12, 2)
	layout:SplitVert('top', "title", "category", 0.6, 2)
	layout:SplitVert('bottom', "rumor", "desc", 0.72, 0)

	local this
	this =
	{
		mParent = parent,
		mStack = parent.mStack,
		mStateMachine = parent.mStateMachine,

		mLayout = layout,
		mPanels =
		{
			layout:CreatePanel("title"),
			layout:CreatePanel("category"),
			layout:CreatePanel("rumor"),
			layout:CreatePanel("desc"),

		},

		mScrollbar = Scrollbar:Create(Texture.Find("scrollbar.png"), 378),
		mRumorMenus =
		{
			Selection:Create
			{
				data = gWorld.mRumors,
				spacingX = 256,
				columns = 1,
				displayRows = 4,
				spacingY = 28,
				rows = 20,
				RenderItem = function(self, renderer, x, y, item)
					gWorld:DrawRumor(self, renderer, x, y, item)
				end
			},
			Selection:Create
			{
				data = gWorld.mRumors,
				spacingX = 256,
				columns = 1,
				displayRows = 8,
				spacingY = 28,
				rows = 20,
				RenderItem = function(self, renderer, x, y, item)
					gWorld:DrawRumor(self, renderer, x, y, item)
				end
			},
		},

		mCategoryMenu = Selection:Create
		{
			data = {"Dungeons", "Town"},
			OnSelection = function(...) this:OnCategorySelect(...) end,
			spacingX = 150,
			columns = 2,
			rows = 1,
		},
		mInCategoryMenu = true
	}

	for k, v in ipairs(this.mRumorMenus) do
		v:HideCursor()
	end

	setmetatable(this, self)
	return this
end

function RumorMenuState:Enter() end
function RumorMenuState:Exit() end

function RumorMenuState:OnCategorySelect(index, value)
	self.mCategoryMenu:HideCursor()
	self.mInCategoryMenu = false
	local menu = self.mRumorMenus[index]
	menu:ShowCursor()
end

function RumorMenuState:Render(renderer)
	for k, v in ipairs(self.mPanels) do
		v:Render(renderer)
	end

	local titleX = self.mLayout:MidX("title") - 60
	local titleY = self.mLayout:MidY("title")
	renderer:ScaleText(2, 2)
	renderer:AlignText("left, center")
	renderer:DrawText2d(titleX, titleY, "Rumors")

	renderer:AlignText("left", "center")
	local categoryX = self.mLayout:Left("category") + 5
	local categoryY = self.mLayout:MidY("category")
	renderer:ScaleText(1.5, 1.5)
	self.mCategoryMenu:Render(renderer)
	self.mCategoryMenu:SetPosition(categoryX, categoryY)

	local descX = self.mLayout:Left("desc") + 10
	local descY = self.mLayout:Bottom("desc") + 35
	local descImageX = self.mLayout:MidX("desc")
	local descImageY = self.mLayout:Top("desc") - 150
	renderer:ScaleText(1, 1)

	local menu = self.mRumorMenus[self.mCategoryMenu:GetIndex()]

	if not self.mInCategoryMenu then
		local description = ""
		local selectedItem = menu:SelectedItem()
		if selectedItem then
			local rumorDef = RumorDB[selectedItem.id]
			description = rumorDef.description
		end
		--renderer:DrawText2d(descX, descY, description)
		gWorld:DrawRumorDesc(self, renderer, descX, descY, selectedItem)
	end

	local rumorX = self.mLayout:MidX("rumor") - 50
	local rumorY = self.mLayout:Top("rumor") - 20

	menu:SetPosition(rumorX, rumorY)
	menu:Render(renderer)

	local scrollX = self.mLayout:Right("rumor") - 14
	local scrollY = self.mLayout:MidY("rumor")
	self.mScrollbar:SetPosition(scrollX, scrollY)
	self.mScrollbar:Render(renderer)
end

function RumorMenuState:Update(dt)

	local menu = self.mRumorMenus[self.mCategoryMenu:GetIndex()]

	if self.mInCategoryMenu then
		
		if 	Keyboard.JustReleased(KEY_BACKSPACE) or
			Keyboard.JustReleased(KEY_ESCAPE) then
			self.mStateMachine:Change("frontmenu")
		end
		self.mCategoryMenu:HandleInput()
	
	else

		if 	Keyboard.JustReleased(KEY_BACKSPACE) or
			Keyboard.JustReleased(KEY_ESCAPE) then
			self:FocusOnCategoryMenu()
		end

		menu:HandleInput()
	end

	local scrolled = menu:PercentageScrolled()
	self.mScrollbar:SetScrollCaretScale(menu:PercentageShown())
	self.mScrollbar:SetNormalValue(scrolled)
end

function RumorMenuState:FocusOnCategoryMenu()
	self.mInCategoryMenu = true
	local menu = self.mRumorMenus[self.mCategoryMenu:GetIndex()]
	menu:HideCursor()
	self.mCategoryMenu:ShowCursor()
end
