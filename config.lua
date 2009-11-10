local addonName = "oUF_Freebgrid"
local addonPath = "Interface\\Addons\\"..addonName
local mediaPath = addonPath.."\\media\\"

FreebgridDefaults = {
	texture = mediaPath.."gradient",
	highlightTex = mediaPath.."white",
	borderTex = mediaPath.."border",
	iconborder = mediaPath.."border2",
	trans = mediaPath.."trans",
	glowTex = mediaPath.."glowTex",
	
	height = 42,
	petheight = 10,
	width = 42,

	scale = 1.0,
	
	font = mediaPath.."calibri.ttf",
	fontsize = 16,
	
	symbols = mediaPath.."PIZZADUDEBULLETS.ttf",
	symbolsSize = 11,
	symbols1 = mediaPath.."STYLBCC_.ttf",
	symbols1Size = 12,

	aurafont = mediaPath.."squares.ttf",
	indicatorSize = 6,	-- Size of the Corner Indicators

	iconSize = 14,	-- Size of raid symbols, leader, etc.
	debuffsize = 16,
	
	moveable = true, -- will use "position"(below) instead of any savedvarible if false.
	locked = true, -- false to move frames

	position = {"LEFT", "UIParent", "LEFT", 10, 0},
	
	point = "TOP", --[[ usage: "TOP", "LEFT", "RIGHT", "BOTTOM"
						this is the unit anchor so TOP would make units grow down and LEFT would make units grow RIGHT etc. SEE growth COMMENT! ]]--
						
	growth = "RIGHT", --[[ usage: "UP", "DOWN", "LEFT", "RIGHT"
						This defines how additional groups should be added.
						if point = "TOP" or "BOTTOM" this MUST be "LEFT" or "RIGHT". 
						if point = "LEFT" or "RIGHT" this MUST be "UP" or "DOWN" ]]--
						
	spacing = 5,	-- space between units and raid groups

	solo = false,
	partyON = true,	-- dude?
	ShowBlizzParty = true, -- Show the blizzard default party frames?
	pets = false,	-- Party/Raid pets

	reverseColors = false,	-- Reverse Units color
	highlight = true,		-- MouseOver Highlight?
	indicators = true, 		-- Class Indicators?
	vertical = true,		-- Vertical bars?
	manabars = false,		-- Mana Bars?
	Licon = true,			-- Leader icon?
	ricon = true,			-- Raid icon?
	noHealbar = true,		-- Disable HealComm Bar
	Healtext = true,		-- Enable HealComm Text
	frameBG = true,			-- apply raid Background?
	
	MTs = true, 			-- Main Tanks?
	MTposition = {"TOPLEFT", "UIParent", "TOPLEFT", 10, -150},
	
	focusHighlightcolor = {.8, .8, .2, .7},
	petColor = {.1, .8, .3},
	
	numRaidgroups = 8,		-- Number of Raid Groups
	
	dispellPriority = {
		["Magic"] = 4,
		["Poison"] = 3,
		["Disease"] = 1,
		["Curse"] = 2,
		["None"] = 0,
	},
}
