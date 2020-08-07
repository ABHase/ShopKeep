intro = {
	SOP.Scene
	{
		name = "opening",
		texture = "backdrop.png"
	},
	SOP.BlackScreen(),
	SOP.Wait(4),
	SOP.Play("rain"),
	SOP.NoBlock(
		SOP.FadeSound("rain", 0, 1, 3) --Fade in from 0 to max in 3 seconds without blocking
	),
	SOP.Caption("place", "title", "A Village Somewhere"),
	SOP.Caption("time", "subtitle", "MIDDAY"),
	SOP.Wait(2),
	SOP.NoBlock(
		SOP.FadeOutCaption("place", 3)
	),
	SOP.FadeOutCaption("time", 3),
	SOP.FadeSound("rain", 1, 0, 1), --max to 0 volume in 1 sec
	SOP.KillState("place"),
	SOP.KillState("time"),
	SOP.FadeOutScreen(),
	SOP.Stop("rain"),
	SOP.Play("streetsounds"),
	SOP.NoBlock(
		SOP.FadeSound("streetsounds", 0, 1, 3) --Fade in from 0 to max in 3 seconds without blocking
	),
	SOP.Say("Wake up!", 5, {avatar = avatar, title = "Urchin"}),
	SOP.Wait(0.5),
	SOP.Say("You can't sleep here, I've tried...", 4, {avatar = avatar, title = "Urchin"}),
	SOP.Wait(0.5),
	SOP.Say("What are you doing anyway?", 4, {avatar = avatar, title = "Urchin"}),
	SOP.Wait(0.5),
	SOP.Say("If you're a merchant, what are you selling?", 4, {avatar = avatar, title = "Urchin"}),
	SOP.Wait(0.5),
	SOP.Say("You were robbed huh? I can get you some stuff.", 4, {avatar = avatar, title = "Urchin"}),
	SOP.Wait(0.5),
	SOP.Say("Don't look at me that way!", 4, {avatar = avatar, title = "Urchin"}),
	SOP.Wait(0.5),
	SOP.FadeSound("streetsounds", 1, 0, 1),
	SOP.Say("You're the one sleeping in the mud!", 4, {avatar = avatar, title = "Urchin"}),
	SOP.Stop("streetsounds"),
	SOP.HandOff("opening"),
}