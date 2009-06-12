local L = {
  ["Prayer of Mending"] = GetSpellInfo(33076),
  ["Gift of the Naaru"] = GetSpellInfo(59542),
  ["Renew"] = GetSpellInfo(139),
  ["Power Word: Shield"] = GetSpellInfo(17),
  ["Weakened Soul"] = GetSpellInfo(6788),
  ["Prayer of Shadow Protection"] = GetSpellInfo(27683),
  ["Shadow Protection"] = GetSpellInfo(976),
  ["Prayer of Fortitude"] = GetSpellInfo(21562),
  ["Power Word: Fortitude"] = GetSpellInfo(1243),
  ["Divine Spirit"] = GetSpellInfo(48073),
  ["Prayer of Spirit"] = GetSpellInfo(48074),
  ["Fear Ward"] = GetSpellInfo(6346),
  ["Lifebloom"] = GetSpellInfo(33763),
  ["Rejuvenation"] = GetSpellInfo(774),
  ["Regrowth"] = GetSpellInfo(8936),
  ["Wild Growth"] = GetSpellInfo(48438),
  ["Tree of Life"] = GetSpellInfo(33891),
  ["Gift of the Wild"] = GetSpellInfo(21849),
  ["Horn of Winter"] = GetSpellInfo(57623),
  ["Battle Shout"] = GetSpellInfo(47436),
  ["Commanding Shout"] = GetSpellInfo(47440),
}

--priest
oUF.pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags["[pom]"] = function(u) local c = select(4, UnitAura(u, L["Prayer of Mending"])) return c and "|cffFFCF7F"..oUF.pomCount[c].."|r" or "" end
oUF.TagEvents["[pom]"] = "UNIT_AURA"
oUF.Tags["[gotn]"] = function(u) return UnitAura(u, L["Gift of the Naaru"]) and "|cff33FF33.|r" or "" end
oUF.TagEvents["[gotn]"] = "UNIT_AURA"
oUF.Tags["[rnw]"] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Renew"])
  if not (fromwho == "player") then return end
  return UnitAura(u, L["Renew"]) and "|cff33FF33.|r" or ""
end
oUF.TagEvents["[rnw]"] = "UNIT_AURA"
oUF.Tags["[pws]"] = function(u) return UnitAura(u, L["Power Word: Shield"]) and "|cff33FF33.|r" or "" end
oUF.TagEvents["[pws]"] = "UNIT_AURA"
oUF.Tags["[ws]"] = function(u) return UnitDebuff(u, L["Weakened Soul"]) and "|cffFF5500.|r" or "" end
oUF.TagEvents["[ws]"] = "UNIT_AURA"
oUF.Tags["[sp]"] = function(u) return UnitAura(u, L["Prayer of Shadow Protection"]) or UnitAura(u, "Shadow Protection") and "" or "|cff9900FF.|r" end
oUF.TagEvents["[sp]"] = "UNIT_AURA"
oUF.Tags["[fort]"] = function(u) return UnitAura(u, L["Prayer of Fortitude"]) or UnitAura(u, L["Power Word: Fortitude"]) and "" or "|cff00A1DE.|r" end
oUF.TagEvents["[fort]"] = "UNIT_AURA"
oUF.Tags["[fw]"] = function(u) return UnitAura(u, L["Fear Ward"]) and "|cff8B4513 .|r" or "" end
oUF.TagEvents["[fw]"] = "UNIT_AURA"
oUF.Tags["[ds]"] = function(u) return UnitAura(u, L["Prayer of Spirit"]) or UnitAura(u, L["Divine Spirit"]) and "" or "|cffffff00.|r" end
oUF.TagEvents["[ds]"] = "UNIT_AURA"

--druid
oUF.Tags["[lb]"] = function(u) local c = select(4, UnitAura(u, L["Lifebloom"])) return c and "|cffA7FD0A"..c.."|r" or "" end
oUF.TagEvents["[lb]"] = "UNIT_AURA"
oUF.Tags["[rejuv]"] = function(u) return UnitAura(u, L["Rejuvenation"]) and "|cff00FEBF.|r" or "" end
oUF.TagEvents["[rejuv]"] = "UNIT_AURA"
oUF.Tags["[regrow]"] = function(u) return UnitAura(u, L["Regrowth"]) and "|cff00FF10.|r" or "" end
oUF.TagEvents["[regrow]"] = "UNIT_AURA"
oUF.Tags["[wg]"] = function(u) return UnitAura(u, L["Wild Growth"]) and "|cff33FF33.|r" or "" end
oUF.TagEvents["[wg]"] = "UNIT_AURA"
oUF.Tags["[tree]"] = function(u) return UnitAura(u, L["Tree of Life"]) and "|cff33FF33.|r" or "" end
oUF.TagEvents["[tree]"] = "UNIT_AURA"
oUF.Tags["[gotw]"] = function(u) return UnitAura(u, L["Gift of the Wild"]) and "|cff33FF33.|r" or "" end
oUF.TagEvents["[gotw]"] = "UNIT_AURA"

--warrior
oUF.Tags["[sh]"] = function(u) return UnitAura(u, L["Battle Shout"]) or UnitAura(u, L["Commanding Shout"]) and "" or "|cffffff00.|r" end
oUF.TagEvents["[sh]"] = "UNIT_AURA"

--deathknight
oUF.Tags["[how]"] = function(u) return UnitAura(u, L["Horn of Winter"]) and "|cffffff10.|r" or ""end
oUF.TagEvents["[how]"] = "UNIT_AURA"

oUF.classIndicators={
		["DRUID"] = {
				["TL"] = "[tree]",
				["TR"] = "[gotw]",
				["BL"] = "[rejuv][regrow][wg]",
				["BR"] = "[lb]"
		},
		["PRIEST"] = {
				["TL"] = "[pws][ws]",
				["TR"] = "[ds][sp][fort][fw]",
				["BL"] = "[rnw][gotn]",
				["BR"] = "[pom]"
		},
		["PALADIN"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = ""
		},
		["WARLOCK"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = ""
		},
		["WARRIOR"] = {
				["TL"] = "",
				["TR"] = "[sh]",
				["BL"] = "",
				["BR"] = ""
		},
		["DEATHKNIGHT"] = {
				["TL"] = "",
				["TR"] = "[how]",
				["BL"] = "",
				["BR"] = ""
		},
		["SHAMAN"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = ""
		},
		["HUNTER"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = ""
		},
		["ROGUE"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = ""
		},
		["MAGE"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = ""
		}
		
	}
