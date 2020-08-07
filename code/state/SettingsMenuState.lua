SettingsMenuState = {}
SettingsMenuState.__index = SettingsMenuState
function SettingsMenuState:Create(statemachine)
local this =
{
mStates = statemachine,
}
setmetatable(this, self)
return this
end
function SettingsMenuState:Enter() end
function SettingsMenuState:Exit() end
function SettingsMenuState:Update(dt)
if Keyboard.JustPressed(KEY_B) then
self.mStates:Change("start")
end
end
function SettingsMenuState:Render(renderer)
renderer:AlignText("center", "center")
renderer:DrawText2d(0, 0, "SETTINGS MENU")
end
