ShopOpenState = {}
ShopOpenState.__index = ShopOpenState
function ShopOpenState:Create(parent)

local layout = Layout:Create()
	layout:Contract('screen', 118, 40)
	layout:SplitHorz('screen', "top", "bottom", 0.12, 2)
	layout:SplitVert('bottom', "left", "party", 0.726, 2)
	layout:SplitHorz('left', "menu", "gold", 0.7, 2)
	
	local this
	this =
	{
		mDay = Day:Create(),
		mParent = parent,
		mStack = parent.mStack,
		mStateMachine = parent.mStateMachine,
		mLayout = layout,
		
		mSelections = Selection:Create
		{
			spacingY = 32,
			data =
			{
				"Rumors",
				--"Magic",
				--"Equipment",
				--"Status",
				--"Save"
			},
			OnSelection = function(...) this:OnMenuClick(...) end
		},
		
		mPanels =
		{
			layout:CreatePanel("gold"),
			layout:CreatePanel("top"),
			layout:CreatePanel("party"),
			layout:CreatePanel("menu")
		},

		mTopBarText = "Shop",
	}

	setmetatable(this, self)
	return this
end

function ShopOpenState:Update(dt)
	self.mDay:Update(dt)
	local time = self.mDay:Current()
	if time > 1 then
		

		--taking this out temporarily
		--self.mDay:AddHero(HeroDB)
		--self.mDay:Adventure()
		--self.mDay:AddRumor()
		self.mStateMachine:Change("frontmenu")
	end
end


--This is probably where code that will do procedural stuff happens
--Haven't decided yet if while the shop is open is while dungeons will be cleared cross that bridge later
--But for sure where the rumors will be added, new heroes spawned, and obviously items bought and sold
--Except for restocking from vendors but we'll cross hat bridge later too




--I'm sure there's a smarter way than copying the code right out of the previous state but again later

function ShopOpenState:Render(renderer)
	for k, v in ipairs(self.mPanels) do
	v:Render(renderer)
end

	renderer:ScaleText(1.5, 1.5)
	renderer:AlignText("left", "center")
	local menuX = self.mLayout:Left("menu") - 16
	local menuY = self.mLayout:Top("menu") - 24
	self.mSelections:SetPosition(menuX, menuY)
	self.mSelections:HideCursor()
	self.mSelections:Render(renderer)

	local nameX = self.mLayout:MidX("top")
	local nameY = self.mLayout:MidY("top")
	renderer:AlignText("center", "center")
	renderer:DrawText2d(nameX, nameY, self.mTopBarText)

	local goldX = self.mLayout:MidX("gold") - 22
	local goldY = self.mLayout:MidY("gold") + 22

	renderer:ScaleText(1.22, 1.22)
	renderer:AlignText("right", "top")
	renderer:DrawText2d(goldX, goldY, "GP:")
	renderer:DrawText2d(goldX, goldY - 25, "Day:")
	renderer:AlignText("left", "top")
	renderer:DrawText2d(goldX + 10, goldY, gWorld:GoldAsString())
	renderer:DrawText2d(goldX + 10, goldY - 25, gWorld:DayAsString())

	renderer:DrawText2d(goldX + 200, goldY - 25, self.mDay:TimeAsString())

end

function ShopOpenState:Enter() 
end
function ShopOpenState:Exit() 
gWorld:Day()
end