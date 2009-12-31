local L = {
	--Ex.
	["Weakened Soul"] = GetSpellInfo(6788),

	["Viper Sting"] = GetSpellInfo(3034),

	["Wound Poison"] = GetSpellInfo(57978),
	["Mortal Strike"] = GetSpellInfo(47486),
	["Aimed Shot"] = GetSpellInfo(49050),

	["Counterspell"] = GetSpellInfo(2139),

	["Blind"] = GetSpellInfo(2094),
	["Cyclone"] = GetSpellInfo(33786),

	["Polymorph"] = GetSpellInfo(12826),

	["Entangling Roots"] = GetSpellInfo(53308),
	["Freezing Trap"] = GetSpellInfo(14311),

	["Crippling Poison"] = GetSpellInfo(3775),
	["Hamstring"] = GetSpellInfo(1715),
	["Wing Clip"] = GetSpellInfo(2974),

	["Fear"] = GetSpellInfo(6215),
	["Psychic Scream"] = GetSpellInfo(10890),
	["Howl of Terror"] = GetSpellInfo(17928),

}

FreebgridDebuffs = {
	debuffs = setmetatable({

		--Ex.
		-- Standard: Add debuff name and priority
		--["Weakened Soul"] = 12,
		["Mark of the Fallen Champion"] = 1,

		-- or Add an Item from the table above that uses a spellID
		--[L["Weakened Soul"]] = 12,

		[L["Viper Sting"]] = 12,

		[L["Wound Poison"]] = 9,
		[L["Mortal Strike"]] = 8,
		[L["Aimed Shot"]] = 8,

		[L["Counterspell"]] = 10,

		[L["Blind"]] = 10,
		[L["Cyclone"]] = 10,

		[L["Polymorph"]] = 7,

		[L["Entangling Roots"]] = 7,
		[L["Freezing Trap"]] = 7,

		[L["Crippling Poison"]] = 6,
		[L["Hamstring"]] = 5,
		[L["Wing Clip"]] = 5,

		[L["Fear"]] = 3,
		[L["Psychic Scream"]] = 3,
		[L["Howl of Terror"]] = 3,

	},{ __index = function() return 0 end }),
}
