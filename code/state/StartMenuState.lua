--
-- Start Menu State
--
StartMenuState = {}
StartMenuState.__index = StartMenuState
function StartMenuState:Create(statemachine)

local this =
	{
		mStates = statemachine,
	}
	setmetatable(this, self)
	return this
end

function StartMenuState:Enter() end

function StartMenuState:Exit() end

function StartMenuState:Update(dt)
	if Keyboard.JustPressed(KEY_S) then
	self.mStates:Change("settings")
	end
end

function StartMenuState:Render(renderer)
renderer:AlignText("center", "center")
renderer:DrawText2d(0, 0, "START MENU")
end
