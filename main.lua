LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

math.randomseed(os.time())
math.random(); math.random(); math.random()

gRenderer = Renderer.Create()
gRenderer:SetFont("default")
gStack = StateStack:Create()
gWorld = World:Create()
gWorld.mGold =  5


gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))
--[[gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))
gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))
gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))
gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))
gWorld.mCurrentHeroes:Add(Actor:Create(HeroDB[Dice.RollDie(1, 7)]))]]

--gWorld.mCurrentHeroes.mMembers[1]:AddItem(Item:Create(ItemDB[1]))

gWorld.mVillage:Add(1)
gWorld.mVillage:Add(2)
--gWorld.mVillage:Add(Vendor:Create(VendorDB[2]))

local backdropState = BackdropState:Create(gStack, 
											{
											texture = Texture.Find("cloudbox.png")
											})
gStack:Push(backdropState)

gCounter = 0

function update()
	local dt = GetDeltaTime()
	gStack:Update(dt)
	gRenderer:Translate(gCounter, 0)
	gStack:Render(gRenderer)
	


--[[if Keyboard.Held(KEY_LEFT) then
gCounter = gCounter - 10
elseif Keyboard.Held(KEY_RIGHT) then
gCounter = gCounter + 10
end

	

	--[[if Keyboard.JustPressed(KEY_O) then
		
		local heroname = "Warrior"

		local text = GossipDB[1][math.random(#GossipDB[1])]

		local message = string.format(text, heroname)

			gStack:PushFit(gRenderer, math.random(-System.ScreenWidth() / 2 + 300, System.ScreenWidth() / 2 - 300),
			math.random(-System.ScreenHeight() / 2 + 100, System.ScreenHeight() / 2 - 100), message, 600)

	end]]

end