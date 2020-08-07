SOP = {}

WaitEvent = {}
WaitEvent.__index = WaitEvent
function WaitEvent:Create(seconds)
	local this = 
	{
		mSeconds = seconds,
	}
	setmetatable(this, self)
	return this
end

function WaitEvent:Update(dt)
	self.mSeconds = self.mSeconds - dt
end

function WaitEvent:IsBlocking()
	return true
end

function WaitEvent:IsFinished()
	return self.mSeconds <= 0
end

SOP.Wait = function(seconds)
	return function(storyboard)
		return WaitEvent:Create(seconds)
	end
end

EmptyEvent = WaitEvent:Create(0)

SOP.BlackScreen = function(id, alpha)
	id = id or "blackscreen"
	local black = Vector.Create(0, 0, 0, alpha or 1)

	return function(storyboard)
		local screen = ScreenState:Create(black)
		storyboard:PushState(id, screen)
		return EmptyEvent
	end
end

TweenEvent = {}
TweenEvent.__index = TweenEvent
function TweenEvent:Create(tween, target, ApplyFunc)
	local this =
	{
		mTween = tween,
		mTarget = target,
		mApplyFunc = ApplyFunc
	}
	setmetatable(this, self)
	return this
end

function TweenEvent:Update(dt, storyboard)
	self.mTween:Update(dt)
	self.mApplyFunc(self.mTarget, self.mTween:Value())
end

function TweenEvent:Render() end

function TweenEvent:IsFinished()
	return self.mTween:IsFinished()
end

function TweenEvent:IsBlocking()
	return true
end

SOP.FadeScreen = function(id, duration, start, finish)

	local duration = duration or 3
	
	return function(storyboard)

		local target = storyboard.mSubStack:Top()
		if id then
			target = storyboard.mStates[id]
		end
		assert(target and target.mColor)

		return TweenEvent:Create(
			Tween:Create(start, finish, duration),
			target,
			function(target, value)
				target.mColor:SetW(value)
			end)
	end
end

SOP.FadeInScreen = function(id, duration)
	return SOP.FadeScreen(id, duration, 0, 1)
end

SOP.FadeOutScreen = function(id, duration)
	return SOP.FadeScreen(id, duration, 1, 0)
end

SOP.Caption = function(id, style, text)
	print("caption")

	return function(storyboard)
		local style = ShallowClone(CaptionStyles[style])
		local caption = CaptionState:Create(style, text)
		storyboard:PushState(id, caption)

	return TweenEvent:Create(
		Tween:Create(0, 1, style.duration),
		style,
		style.ApplyFunc)
	end

end

SOP.FadeOutCaption = function(id, duration)
	return function(storyboard)
		local target = storyboard.mSubStack:Top()
		if id then
			target = storyboard.mStates[id]
		end
		local style = target.mStyle
		duration = duration or style.duration
	
		return TweenEvent:Create(
			Tween:Create(1, 0, duration),
			style,
			style.ApplyFunc
		)
	end
end

SOP.NoBlock = function(f)
	return function(...)
		local event = f(...)
		event.IsBlocking = function()
			return false
		end
		return event
	end
end

SOP.KillState = function(id)
	return function(storyboard)
		storyboard:RemoveState(id)
		return EmptyEvent
	end
end

SOP.Play = function(soundName, name, volume)
	name = name or soundName
	volume = volume or 1
	return function(storyboard)
		local id = Sound.Play(soundName)
		Sound.SetVolume(id, volume)
		storyboard:AddSound(name, id)
		return EmptyEvent
	end
end

SOP.Stop = function(name)
	return function(storyboard)
		storyboard:StopSound(name)
		return EmptyEvent
	end
end

SOP.FadeSound = function(name, start, finish, duration)
	return function(storyboard)

		local id = storyboard.mPlayingSounds[name]
		return TweenEvent:Create(
		Tween:Create(start, finish, duration),
		id,
		function(target, value)
			Sound.SetVolume(target, value)
		end)
	end
end

BlockUntilEvent = {}
BlockUntilEvent.__index = BlockUntilEvent
function BlockUntilEvent:Create(UntilFunc)
	local this =
	{
		mUntilFunc = UntilFunc,
	}
	setmetatable(this, self)
	return this
end

function BlockUntilEvent:Update(dt) end
function BlockUntilEvent:Render() end

function BlockUntilEvent:IsBlocking()
	return not self.mUntilFunc()
end

function BlockUntilEvent:IsFinished()
	return not self:IsBlocking()
end

TimedTextboxEvent = {}
TimedTextboxEvent.__index = TimedTextboxEvent
function TimedTextboxEvent:Create(box, time)
	local this =
	{
		mTextbox = box,
		mCountDown = time
	}
	setmetatable(this, self)
	return this
end

function TimedTextboxEvent:Update(dt, storyboard)
	self.mCountDown = self.mCountDown - dt
	if self.mCountDown <= 0 then
		self.mTextbox:OnClick()
	end
end

function TimedTextboxEvent:Render() end

function TimedTextboxEvent:IsBlocking()
	return self.mCountDown > 0
end

function TimedTextboxEvent:IsFinished()
	return not self:IsBlocking()
end

SOP.Say = function(text, time, params)
	time = time or 1
	params = params or {textScale = 0.8}

	return function(storyboard)
		--local pos = npc.mEntity.mSprite:GetPosition()
		storyboard.mStack:PushFit(
			gRenderer,
			10, 10,
			text, -1, params)
		local box = storyboard.mStack:Top()
		return TimedTextboxEvent:Create(box, time)
	end
end

SOP.Scene = function(params)
	return function(storyboard)
	local id = params.name
	local scenetexture = params.texture
	local stack = StateStack:Create()
	local state = BackdropState:Create(stack, {
											texture = Texture.Find(scenetexture)
											})
	storyboard:PushState(id, state)
		
	-- Allows the following operation to run on the same frame
		return SOP.NoBlock(SOP.Wait(0))()
	end
end

SOP.HandOff = function(name)
	return function(storyboard)
	local menustate = storyboard.mStates[name]
	-- remove storyboard from the top of stack
		storyboard.mStack:Pop()
		storyboard.mStack:Push(menustate)
		menustate.mStack = gStack
		return EmptyEvent
	end
end

SOP.ReplaceScene = function(name, params)
return function(storyboard)
local state = storyboard.mStates[name]
-- Give the state an updated name
	local id = params.name
	storyboard.mStates[name] = nil
	storyboard.mStates[id] = state
	return SOP.NoBlock(SOP.Wait(0))()
end
end
