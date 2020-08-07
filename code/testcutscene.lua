testcutscene = 

{
	{
		SOP.Scene
		{
			name = "evilone",
			texture = "evilone.png",
		},
		SOP.Caption("caption", "title", tostring(math.random())),
	},
	{	
		SOP.Scene
		{
			name = "fallen_tree",
			texture = "fallentree_backdrop.png",
		},
		SOP.Play("chopping"),
		SOP.NoBlock(
		SOP.FadeSound("chopping", 0, 1, 3) --Fade in from 0 to max in 3 seconds without blocking
						),
		SOP.Say([[Did you hear about that Caravan Guard what came into town?]], 3),
		SOP.Wait(0.5),
		SOP.Say([[Talking 'bout being attacked and all that?]], 3),
		SOP.Wait(0.5),
		SOP.Say([[Ohhh that's so terrible!]], 3),
		SOP.Wait(0.5),
		SOP.Say([[Why would such a thing happen 'round here??? ]], 3),
		SOP.Wait(0.5),
		SOP.Say([[Agatha thinks it's some thug highwaymen ]], 3),
		SOP.Wait(0.5),
		SOP.Say([[I says "Agatha, that's ridiculous ]], 3),
		SOP.Wait(0.5),
		SOP.Play("tree_falling"),
		SOP.FadeSound("chopping", 1, 0, 1), --max to 0 volume in 1 sec
		SOP.Say([[Why would regular bandits not leave no one alive" ]], 3),
		SOP.Wait(0.5),
		SOP.Say([[It's got to be a monster of some sort. ]], 3),
		SOP.Wait(0.5),
		SOP.Stop("chopping"),
		SOP.Say([[With a gaping maw and terrible tentacles for eyes ]], 3),
		SOP.Wait(0.5),
		SOP.Stop("tree_falling"),
		SOP.Play("chopping"),
		SOP.Say([[Course Mortin thinks it's just the traders being lazy ]], 3),
		SOP.Wait(0.5),
		SOP.Play("tree_falling"),
		SOP.Say([[Bless him good old sensible Mortin never had any mind ]], 3),
		SOP.Wait(0.5),
		SOP.Say([[For the supernatural world at least. ]], 3),
		SOP.Wait(0.5),
		SOP.Say([[But MY great grand-aunt told me once- ]], 3),
		SOP.Play("wood_crash"),
		SOP.Wait(0.5),
		SOP.Say([[of the spirit of suffering that once plagued the road ]], 3),
		SOP.Wait(0.5),
		SOP.Say([[back when her father was a youngun']], 3),
		SOP.Wait(0.5),
		SOP.HandOff("fallen_tree"),
	},
	{
		SOP.Say("test3"),
		SOP.HandOff("handin"),
	},
}