local ADDON_NAME, ns = ...

ns.mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"

ns.defaults = {
	scale = 1.0,
	scale25 = 1.0,
	scale40 = 1.0,
	scaleYes = false,
	width = 42,
	height = 42,
	texture = "gradient",
	texturePath = ns.mediapath.."gradient",
	font = "calibri",
	fontPath = ns.mediapath.."calibri.ttf",
	fontsize = 14,
	fontsizeEdge = 12,
	outline = nil,
	solo = false,
	player = true,
	party = true,
	numCol = 8,
	numUnits = 5,
	petUnits = 5,
	MTUnits = 5,
	spacing = 5,
	orientation = "VERTICAL",
	porientation = "VERTICAL",
	horizontal = false,
	pethorizontal = false,
	MThorizontal = false,
	growth = "RIGHT",
	petgrowth = "RIGHT",
	MTgrowth = "RIGHT",
	omfChar = false,
	reversecolors = false,
	definecolors = false,
	powerbar = false,
	powerbarsize = .08,
	outsideRange = .40,
	arrow = true,
	arrowmouseover = true,
	arrowmouseoveralways = false,
	arrowscale = 1.0,
	healtext = false,
	healbar = true,
	healoverflow = true,
	healothersonly = false,
	healalpha = .40,
	roleicon = false,
	pets = false,
	MT = false,
	indicatorsize = 6,
	symbolsize = 11,
	leadersize = 12,
	aurasize = 18,
	multi = false,
	deficit = false,
	perc = false,
	actual = false,
	myhealcolor = { r = 0.0, g = 1.0, b = 0.5, a = 0.4 },
	otherhealcolor = { r = 0.0, g = 1.0, b = 0.0, a = 0.4 },
	hpcolor = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
	hpbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
	powercolor = { r = 1, g = 1, b = 1, a = 1 },
	powerbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
	powerdefinecolors = false,
	colorSmooth = false,
	gradient = { r = 1, g = 0, b = 0, a = 1 },
	tborder = true,
	fborder = true,
	afk = true,
	highlight = true,
	dispel = true,
	powerclass = false,
	tooltip = true,
	smooth = false,
	altpower = false,
	sortName = false,
	sortClass = false,
	classOrder = "DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR",
	hidemenu = false,
	autorez = false,
	cluster = {
		enabled = false,
		range = 30,
		freq = 250,
		perc = 90,
		textcolor = { r = 0, g = .9, b = .6, a = 1 },
	},
	hpinverted = false,
	hpreversed = false,
	ppinverted = false,
	ppreversed = false,
}

function ns.InitDB()
	_G[ADDON_NAME.."DB"] = _G[ADDON_NAME.."DB"] or {}
	ns.db = _G[ADDON_NAME.."DB"]

	for k, v in pairs(ns.defaults) do
		if(type(ns.db[k]) == 'nil') then
			ns.db[k] = v
		elseif(type(ns.db[k]) == 'table') then
			for i, x in pairs(ns.defaults[k]) do
				if(ns.db[k][i] == nil) then
					ns.db[k][i] = x
				end
			end
		end
	end
end

function ns.FlushDB()
	for k,v in pairs(ns.defaults) do 
		if ns.db[k] == v and type(ns.db[k]) ~= "table" then 
			ns.db[k] = nil 
		end 
	end
end

