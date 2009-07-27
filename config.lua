local addonName = "oUF_Freebgrid"
local addonPath = "Interface\\Addons\\"..addonName
local mediaPath = addonPath.."\\media\\"

FreebgridDefaults = {
	texture = mediaPath.."gradient",
	highlightTex = mediaPath.."white",
	borderTex = mediaPath.."border",
	
	height = 40,
	width = 40,
	
	font = mediaPath.."font.ttf",
	fontsize = 16,
	
	symbols = mediaPath.."PIZZADUDEBULLETS.ttf",
	symbolsSize = 12,
	symbols1 = mediaPath.."STYLBCC_.ttf",
	symbols1Size = 12,

	aurafont = mediaPath.."visitor.ttf",
	indicatorSize = 28,

	iconSize = 14,			-- Size of raid symbols, leader, etc.
	
	position = {"LEFT", "UIParent", "LEFT", 12, -200},
	--position = {"BOTTOM", "UIParent", "BOTTOM", 275, 150},
	
	point = "LEFT", --[[ usage: "TOP", "LEFT", "RIGHT", "BOTTOM"
						this is the unit anchor so TOP would make units grow down and LEFT would make units grow RIGHT etc. SEE growth COMMENT! ]]--
						
	growth = "UP", --[[ usage: "UP", "DOWN", "LEFT", "RIGHT"
						This defines how additional groups should be added.
						if point = "TOP" or "BOTTOM" this MUST be "LEFT" or "RIGHT". 
						if point = "LEFT" or "RIGHT" this MUST be "UP" or "DOWN" ]]--
						
	spacing = 5,	-- space between units and raid groups
	
	partyON = true,	-- dude?
	partyPets = true,	-- has no effect if partyON is false
	reverseColors = false,	-- Reverse Units color
	highlight = true,		-- MouseOver Highlight?
	indicators = true, 		-- Class Indicators?
	vertical = true,		-- Vertical bars?
	manabars = false,		-- Mana Bars?
	Licon = true,			-- Leader icon?
	ricon = true,			-- Raid icon?
	Healbar = false,		-- HealComm Bar
	Healtext = true,		-- HealComm Text
	frameBG = true,			-- apply raid Background?
	
	MTs = false, 			-- Main Tanks?
	MTposition = {"TOPLEFT", "UIParent", "TOPLEFT", 10, -150},
	
	focusHighlightcolor = {.8, .8, .2, .7},
	petColor = {.1, .8, .3},
	
	numRaidgroups = 8,		-- Number of Raid Groups
	
	debuffs = {
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
	},
	
	dispellPriority = {
		["Magic"] = 4,
		["Poison"] = 3,
		["Disease"] = 1,
		["Curse"] = 2,
	},
}
