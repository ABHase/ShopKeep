InGameMenuState = {}
InGameMenuState.__index = InGameMenuState
function InGameMenuState:Create(stack)
	local this =
	{
	mStack = stack
	}

	this.mStateMachine = StateMachine:Create
	{
		["frontmenu"] =
		function()
			return FrontMenuState:Create(this)
		end,
		["rumors"] =
		function()
			return RumorMenuState:Create(this)
			--return this.mStateMachine.mEmpty
		end,
		["inventory"] =
		function()
			return InventoryState:Create(this)
			--return this.mStateMachine.mEmpty
		end,
		["vendor"] =
		function()
			return this.mStateMachine.mEmpty
		end,
		["check heroes"] =
		function()
			return HeroStatusFrontMenuState:Create(this)
			--return this.mStateMachine.mEmpty
		end
	}
	this.mStateMachine:Change("frontmenu")

	setmetatable(this, self)
	return this

end

function InGameMenuState:Update(dt)
	if self.mStack:Top() == self then
		self.mStateMachine:Update(dt)
	end
end

function InGameMenuState:Render(renderer)
	self.mStateMachine:Render(renderer)
end

function InGameMenuState:Enter() end
function InGameMenuState:Exit() end
function InGameMenuState:HandleInput() end
