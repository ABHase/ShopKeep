Storyboard = {}
Storyboard.__index = Storyboard
function Storyboard:Create(stack, events, handIn)
	local this =
	{
		mStack = stack,
		mEvents = events,
		mStates = {},
		mSubStack = StateStack:Create(),
		mPlayingSounds = {}
	}
	setmetatable(this, self)
	
	if handIn then
		local state = this.mStack:Pop()
		this:PushState("handin", state)
	end
	
	return this
end

function Storyboard:Enter() end

function Storyboard:Exit() 

	for k, v in pairs(self.mPlayingSounds) do
		Sound.Stop(v)
	end
end

function Storyboard:AddSound(name, id)
	assert(self.mPlayingSounds[name] == nil)
	self.mPlayingSounds[name] = id
end

function Storyboard:StopSound(name)
	local id = self.mPlayingSounds[name]
	self.mPlayingSounds[name] = nil
	Sound.Stop(id)
end


function Storyboard:HandleInput() end
function Storyboard:CleanUp() end

function Storyboard:Update(dt)
	self.mSubStack:Update(dt)

	if #self.mEvents == 0 then
		self.mStack:Pop() --If there are no entries pops itself off stack
	end
	
	local deleteIndex = nil
	for k, v in ipairs(self.mEvents) do
		
		if type(v) == "function" then 	--if there are entries we check if next one is function
			self.mEvents[k] = v(self) 	--first time we've seen it, call it
			v = self.mEvents[k]			--take take teh returned event object and replaces in table
		end

		v:Update(dt, self)				--Once function check is done event object updated
		if v:IsFinished() then 			--Set deleted delete index to current loop index
			deleteIndex = k
			break						--And break out of looop
		end

		if v:IsBlocking() then 			--If it hasn't finished check if it's blocking
			break						--no more events are updated
		end
	end

	if deleteIndex then
		table.remove(self.mEvents, deleteIndex)
	end
end

function Storyboard:Render(renderer)
	self.mSubStack:Render(renderer)
	--local debugText = string.format("Events Stack: %d", #self.mEvents)
	--renderer:DrawText2d(0, 0, debugText)
end

function Storyboard:PushState(id, state)
	--push a state on the stack but keep a reference here.
	assert(self.mStates[id]  == nil)
	self.mStates[id] = state
	self.mSubStack:Push(state)
end

function Storyboard:RemoveState(id)
	local state = self.mStates[id]
	self.mStates[id] = nil
	for i = #self.mSubStack.mStates, 1, -1 do
		local v = self.mSubStack.mStates[i]
		if v == state then
			table.remove(self.mSubStack.mStates, i)
		end
	end
end


