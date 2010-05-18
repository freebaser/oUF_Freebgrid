
FreebgridDebuffs = {
	debuffs = {
		-- Any Zone
		[GetSpellInfo(3034)] = 12, -- Viper Sting

		[GetSpellInfo(57978)] = 9, -- Wound Poison
		[GetSpellInfo(47486)] = 8, -- Mortal Strike
		[GetSpellInfo(49050)] = 8, -- Aimed Shot

		[GetSpellInfo(2139)] = 10, -- Counterspell

		[GetSpellInfo(2094)] = 10, -- Blind
		[GetSpellInfo(33786)] = 10, -- Cyclone

		[GetSpellInfo(12826)] = 7, -- Polymorph

		[GetSpellInfo(53308)] = 7, -- Entangling Roots
		[GetSpellInfo(14311)] = 7, -- Freezing Trap

		[GetSpellInfo(3775)] = 6, -- Crippling Poison
		[GetSpellInfo(1715)] = 5, -- Hamstring
		[GetSpellInfo(2974)] = 5, -- Wing Clip

		[GetSpellInfo(6215)] = 3, -- Fear
		[GetSpellInfo(10890)] = 3, -- Psychic Scream
		[GetSpellInfo(17928)] = 3, -- Howl of Terror
	},
	instances = {
		--[[
		["Zone"] = {
			[Name or GetSpellInfo(#)] = PRIORITY,
		}
		]]--
		
		},
	},
}
