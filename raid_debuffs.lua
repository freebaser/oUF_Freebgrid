FreebgridDebuffs = {
	debuffs = setmetatable({

		["Viper Sting"] = 12,

		["Wound Poison"] = 9,
		["Mortal Strike"] = 8,
		["Aimed Shot"] = 8,

		["Counterspell"] = 10,

		["Blind"] = 10,
		["Cyclone"] = 10,

		["Polymorph"] = 7,

		["Entangling Roots"] = 7,
		["Freezing Trap"] = 7,

		["Crippling Poison"] = 6,
		["Hamstring"] = 5,
		["Wing Clip"] = 5,

		["Fear"] = 3,
		["Psychic Scream"] = 3,
		["Howl of Terror"] = 3,

	},{ __index = function() return 0 end }),
}
