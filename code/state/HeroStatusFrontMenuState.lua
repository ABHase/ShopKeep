HeroStatusFrontMenuState = {}
HeroStatusFrontMenuState.__index = HeroStatusFrontMenuState
function HeroStatusFrontMenuState:Create(parent, world)

local layout = Layout:Create()
	layout:Contract('screen', 118, 40)
	layout:SplitHorz('screen', "top", "bottom", 0.12, 2)
	layout:SplitVert('bottom', "left", "party", 0.726, 2)
	layout:SplitHorz('left', "menu", "gold", 0.7, 2)
	
	local this
	this =
	{
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
				--"Open Shop",
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

		this.mCurrentHeroesMenu = Selection:Create{
			spacingY = 90,
			data = this:CreateCurrentHeroesSummaries(),
			columns = 1,
			rows = 7,
			OnSelection = function(...) this:OnCurrentHeroChosen(...) end,
			RenderItem = function(menu, renderer, x, y, item)
				if item then
					item:SetPosition(x, y + 35)
					item:Render(renderer)
				end
			end
		}
	this.mCurrentHeroesMenu:HideCursor()
	
	return this
end

function HeroStatusFrontMenuState:CreateCurrentHeroesSummaries()

	local currentHeroes = gWorld.mCurrentHeroes.mMembers

	local out = {}
	for _, v in pairs(currentHeroes) do 
		local summary = ActorSummary:Create(v,
			{ showXP = false})
		table.insert(out, summary)
	end
	return out
end



function HeroStatusFrontMenuState:Update(dt)
	self.mSelections:HandleInput()

	if Keyboard.JustPressed(KEY_BACKSPACE) or
	Keyboard.JustPressed(KEY_ESCAPE) then
		self.mStack:Pop()
	end
end

function HeroStatusFrontMenuState:Render(renderer)
	for k, v in ipairs(self.mPanels) do
	v:Render(renderer)
end

	renderer:ScaleText(1.5, 1.5)
	renderer:AlignText("left", "center")
	local menuX = self.mLayout:Left("menu") + 30
	local menuY = self.mLayout:Top("menu") - 50
	self.mSelections:SetPosition(menuX, menuY)
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

	local heroesX = self.mLayout:Left("party") + 100
	local heroesY = self.mLayout:Top("party") - 100
	self.mCurrentHeroesMenu:SetPosition(heroesX, heroesY)
	self.mCurrentHeroesMenu:Render(renderer)

end

function HeroStatusFrontMenuState:OnMenuClick(index)

	local RUMORS = 1
	--local OPEN = 2

	if index == RUMORS then
		return self.mStateMachine:Change("rumors")
	--elseif index == OPEN then
	--	return self.mStateMachine:Change("open shop")
	end
end

function HeroStatusFrontMenuState:Enter() end
function HeroStatusFrontMenuState:Exit() end