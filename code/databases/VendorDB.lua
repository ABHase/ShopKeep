VendorDB =
{
	{
		name = "Urchin",
		portrait = "urchin_shop.png",
		--types = {ItemDB, VillageItemDB}
		stock = { 
					weapons =
							{
								{1,2,3,4,5,6,7},

								{8,9,10,11,12,13,14},
							},
					--[[village =
							{
								{1,2},
								{},
								{3},
							},]]
				},
	},

	{
		name = "Evilone has Wares",
		portrait = "evilone.png",
		stock = {					
								
					weapons =
							{
								{},
								{},
								{},
								{15,16,17,18,19,20,21},
							},
					village =
							{
								{1,2,3,4,5,6,7,8,9,10},
							},
					armor = 
							{
								{},
								{1,2,3,4,5,6,7},
								{8,9,10,11,12,13,14},
							},
								
				},
	},
}

--give all items id based on position in list
for id, def in pairs(VendorDB) do
	def.id = id
end