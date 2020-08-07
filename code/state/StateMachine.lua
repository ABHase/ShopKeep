StateMachine = {}
StateMachine.__index = StateMachine
function StateMachine:Create(states)
	local this =
	{
		empty = 
		{
			Render 	= function() end,
			Update 	= function() end,
			Enter 	= function() end,
			Exit 	= function() end
		},
		states = states or {}, -- [name] -> [function that returns state]
		current = nil,
	}

	this.current = this.empty
	setmetatable(this, self)
	return this
end

function StateMachine:Change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:Exit()
	self.current = self.states[stateName]()
	self.current:Enter(enterParams)
end

function StateMachine:Update(dt)
	self.current:Update(dt)
end

function StateMachine:Render(renderer)
	self.current:Render(renderer)
end