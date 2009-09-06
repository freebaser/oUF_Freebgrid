local oUF = Freebgrid
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
  ["Gift of the Wild"] = GetSpellInfo(48470),
  ["Mark of the Wild"] = GetSpellInfo(48469),
  ["Horn of Winter"] = GetSpellInfo(57623),
  ["Battle Shout"] = GetSpellInfo(47436),
  ["Commanding Shout"] = GetSpellInfo(47440),
  ["Vigilance"] = GetSpellInfo(50720),
  ["Magic Concentration"] = GetSpellInfo(54646),
  ["Beacon of Light"] = GetSpellInfo(53563),
  ["Sacred Shield"] = GetSpellInfo(53601),
  
}
local x = "M"

oUF.Tags["[Freebaggro]"] = function(u) 
	local s = UnitThreatSituation(u) if s == 2 or s == 3 then return "|cffFF0000"..x.."|r" end end
oUF.TagEvents["[Freebaggro]"] = "UNIT_THREAT_SITUATION_UPDATE"

--priest
oUF.pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags["[pom]"] = function(u) local c = select(4, UnitAura(u, L["Prayer of Mending"])) if c then return "|cffFFCF7F"..oUF.pomCount[c].."|r" end end
oUF.TagEvents["[pom]"] = "UNIT_AURA"
oUF.Tags["[gotn]"] = function(u) if UnitAura(u, L["Gift of the Naaru"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents["[gotn]"] = "UNIT_AURA"
oUF.Tags["[rnw]"] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Renew"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Renew"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents["[rnw]"] = "UNIT_AURA"
-- rnwtime
oUF.Tags["[rnwTime]"] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Renew"])
  if not (fromwho == "player") then return end
  local spellTimer = "|cffffff00"..format("%.0f",-1*(GetTime()-expirationTime)).."|r"
  return spellTimer end
oUF.TagEvents["[rnwTime]"] = "UNIT_AURA"
oUF.Tags["[pws]"] = function(u) if UnitAura(u, L["Power Word: Shield"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents["[pws]"] = "UNIT_AURA"
oUF.Tags["[ws]"] = function(u) if UnitDebuff(u, L["Weakened Soul"]) then return "|cffFF9900"..x.."|r" end end
oUF.TagEvents["[ws]"] = "UNIT_AURA"
oUF.Tags["[fw]"] = function(u) if UnitAura(u, L["Fear Ward"]) then return "|cff8B4513"..x.."|r" end end
oUF.TagEvents["[fw]"] = "UNIT_AURA"
oUF.Tags["[sp]"] = function(u) local c = UnitAura(u, L["Prayer of Shadow Protection"]) or UnitAura(u, "Shadow Protection") if not c then return "|cff9900FF"..x.."|r" end end
oUF.TagEvents["[sp]"] = "UNIT_AURA"
oUF.Tags["[fort]"] = function(u) local c = UnitAura(u, L["Prayer of Fortitude"]) or UnitAura(u, L["Power Word: Fortitude"]) if not c then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents["[fort]"] = "UNIT_AURA"
oUF.Tags["[ds]"] = function(u) local c = UnitAura(u, L["Prayer of Spirit"]) or UnitAura(u, L["Divine Spirit"]) if not c then return "|cffffff00"..x.."|r" end end
oUF.TagEvents["[ds]"] = "UNIT_AURA"

--druid
oUF.lbCount = { 4, 2, 3 }
oUF.Tags["[lb]"] = function(u) 
	local name, _,_, c,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Lifebloom"])
	if not (fromwho == "player") then return end
	local spellTimer = GetTime()-expirationTime
	if spellTimer > -2 then
		return "|cffFF0000"..oUF.lbCount[c].."|r"
	else
		return "|cffA7FD0A"..oUF.lbCount[c].."|r"
	end
end
oUF.TagEvents["[lb]"] = "UNIT_AURA"
oUF.Tags["[rejuv]"] = function(u) 
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Rejuvenation"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Rejuvenation"]) then return "|cff00FEBF"..x.."|r" end end
oUF.TagEvents["[rejuv]"] = "UNIT_AURA"
-- rejuvtime
oUF.Tags["[rejuvTime]"] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Rejuvenation"])
  if not (fromwho == "player") then return end
  local spellTimer = "|cffffff00"..format("%.0f",-1*(GetTime()-expirationTime)).."|r"
  return spellTimer end
oUF.TagEvents["[rejuvTime]"] = "UNIT_AURA"
oUF.Tags["[regrow]"] = function(u) if UnitAura(u, L["Regrowth"]) then return "|cff00FF10"..x.."|r" end end
oUF.TagEvents["[regrow]"] = "UNIT_AURA"
oUF.Tags["[wg]"] = function(u) if UnitAura(u, L["Wild Growth"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents["[wg]"] = "UNIT_AURA"
oUF.Tags["[tree]"] = function(u) if UnitAura(u, L["Tree of Life"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents["[tree]"] = "UNIT_AURA"
oUF.Tags["[gotw]"] = function(u) local c = UnitAura(u, L["Gift of the Wild"]) or UnitAura(u, L["Mark of the Wild"]) if not c then return "|cffFF00FF"..x.."|r" end end
oUF.TagEvents["[gotw]"] = "UNIT_AURA"

--warrior
oUF.Tags["[Bsh]"] = function(u) if UnitAura(u, L["Battle Shout"]) then return "|cffff00000"..x.."|r" end end
oUF.TagEvents["[Bsh]"] = "UNIT_AURA"
oUF.Tags["[Csh]"] = function(u) if UnitAura(u, L["Commanding Shout"]) then return "|cffffff00"..x.."|r" end end
oUF.TagEvents["[Csh]"] = "UNIT_AURA"
oUF.Tags["[vigil]"] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Vigilance"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Vigilance"]) then return "|cffDEB887"..x.."|r" end end
oUF.TagEvents["[vigil]"] = "UNIT_AURA"

--deathknight
oUF.Tags["[how]"] = function(u) if UnitAura(u, L["Horn of Winter"]) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents["[how]"] = "UNIT_AURA"

--mage
oUF.Tags["[mc]"] = function(u) if UnitAura(u, L["Magic Concentration"]) then return "|cffffff00"..x.."|r" end end
oUF.TagEvents["[mc]"] = "UNIT_AURA"

--paladin
oUF.Tags["[sacred]"] = function(u) if UnitAura(u, L["Sacred Shield"]) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents["[sacred]"] = "UNIT_AURA"
oUF.Tags["[beacon]"] = function(u) if UnitAura(u, L["Beacon of Light"]) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents["[beacon]"] = "UNIT_AURA"
oUF.Tags["[selfsacred]"] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Sacred Shield"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Sacred Shield"]) then return "|cffff33ff"..x.."|r" end end
oUF.TagEvents["[selfsacred]"] = "UNIT_AURA"
oUF.Tags["[selfbeacon]"] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Beacon of Light"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Beacon of Light"]) then return "|cffff33ff"..x.."|r" end end
oUF.TagEvents["[selfbeacon]"] = "UNIT_AURA"
oUF.Tags["[beaconTime]"] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Beacon of Light"])
  if not (fromwho == "player") then return end
  local spellTimer = "|cffff33ff"..format("%.0f",-1*(GetTime()-expirationTime)).."|r"
  return spellTimer end
oUF.TagEvents["[beaconTime]"] = "UNIT_AURA"

oUF.classIndicators={
		["DRUID"] = {
				["TL"] = "[tree]",
				["TR"] = "[gotw]",
				["BL"] = "[regrow][wg][Freebaggro]",
				["BR"] = "[lb]",
				["Cen"] = "[rejuvTime]",
		},
		["PRIEST"] = {
				["TL"] = "[pws][ws]",
				["TR"] = "[ds][sp][fort][fw]",
				["BL"] = "[gotn][Freebaggro]",
				["BR"] = "[pom]",
				["Cen"] = "[rnwTime]",
		},
		["PALADIN"] = {
				["TL"] = "[selfsacred][sacred]",
				["TR"] = "[selfbeacon][beacon]",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "[beaconTime]",
				
		},
		["WARLOCK"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		},
		["WARRIOR"] = {
				["TL"] = "",
				["TR"] = "[Bsh][Csh]",
				["BL"] = "[vigil][Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		},
		["DEATHKNIGHT"] = {
				["TL"] = "",
				["TR"] = "[how]",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		},
		["SHAMAN"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		},
		["HUNTER"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		},
		["ROGUE"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		},
		["MAGE"] = {
				["TL"] = "",
				["TR"] = "[mc]",
				["BL"] = "[Freebaggro]",
				["BR"] = "",
				["Cen"] = "",
		}
		
	}
