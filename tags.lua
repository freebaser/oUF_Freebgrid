local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local foo = {""}
local spellcache = setmetatable({},
{__index=function(t,id)
	local a = {GetSpellInfo(id)}

	if GetSpellInfo(id) then
		t[id] = a
		return a
	end

	--print("Invalid spell ID: ", id)
	t[id] = foo
	return foo
end
})

local function GetSpellInfo(a)
	return unpack(spellcache[a])
end

local GetTime = GetTime

local numberize = function(val)
	if (val >= 1e6) then
		return ("%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end
ns.numberize = numberize

ns.classIndicators={
	["DRUID"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["PRIEST"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["PALADIN"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["WARLOCK"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["WARRIOR"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["DEATHKNIGHT"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["SHAMAN"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["HUNTER"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["ROGUE"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["MAGE"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
	["MONK"] = {
		["TL"] = "",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "",
		["Cen"] = "",
	},
}
