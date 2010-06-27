local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then return end

oUF.Tags['freebgrid:name'] = function(u)
	local name = UnitName(u) or "unknown"
	return name
end
oUF.TagEvents['freebgrid:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags['freebgrid:ddg'] = function(u)
	local x
	if UnitIsDead(u) then
		x = "Dead"
	elseif UnitIsGhost(u) then
		x = "Ghost"
	elseif not UnitIsConnected(u) then
		x = "D/C"
	else
		x = " "
	end
	return "|cffCFCFCF"..x.."|r"
end
oUF.TagEvents['freebgrid:ddg'] = 'UNIT_HEALTH'

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
  ['Earth Shield'] = GetSpellInfo(49284),
  ['Riptide'] = GetSpellInfo(61301),
  ['Flash of Light'] = GetSpellInfo(66922),
  ['Shield Wall'] = GetSpellInfo(871),
}
local x = "M"

local getTime = function(expirationTime)
	local expire = -1*(GetTime()-expirationTime)
	local timeleft = format("%.0f", expire)
	if expire > 0.5 then
		local spellTimer = "|cffffff00"..timeleft.."|r"
		return spellTimer
	end
end

oUF.Tags['freebgrid:aggro'] = function(u) 
	local s = UnitThreatSituation(u) if s == 2 or s == 3 then return "|cffFF0000"..x.."|r" end end
oUF.TagEvents['freebgrid:aggro'] = "UNIT_THREAT_SITUATION_UPDATE"

--priest
oUF.pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags['freebgrid:pom'] = function(u) local c = select(4, UnitAura(u, L["Prayer of Mending"])) if c then return "|cffFFCF7F"..oUF.pomCount[c].."|r" end end
oUF.TagEvents['freebgrid:pom'] = "UNIT_AURA"
oUF.Tags['freebgrid:gotn'] = function(u) if UnitAura(u, L["Gift of the Naaru"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:gotn'] = "UNIT_AURA"
oUF.Tags['freebgrid:rnw'] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Renew"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Renew"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:rnw'] = "UNIT_AURA"
-- rnwtime
oUF.Tags['freebgrid:rnwTime'] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Renew"])
  if (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rnwTime'] = "UNIT_AURA"
oUF.Tags['freebgrid:pws'] = function(u) if UnitAura(u, L["Power Word: Shield"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:pws'] = "UNIT_AURA"
oUF.Tags['freebgrid:ws'] = function(u) if UnitDebuff(u, L["Weakened Soul"]) then return "|cffFF9900"..x.."|r" end end
oUF.TagEvents['freebgrid:ws'] = "UNIT_AURA"
oUF.Tags['freebgrid:fw'] = function(u) if UnitAura(u, L["Fear Ward"]) then return "|cff8B4513"..x.."|r" end end
oUF.TagEvents['freebgrid:fw'] = "UNIT_AURA"
oUF.Tags['freebgrid:sp'] = function(u) local c = UnitAura(u, L["Prayer of Shadow Protection"]) or UnitAura(u, "Shadow Protection") if not c then return "|cff9900FF"..x.."|r" end end
oUF.TagEvents['freebgrid:sp'] = "UNIT_AURA"
oUF.Tags['freebgrid:fort'] = function(u) local c = UnitAura(u, L["Prayer of Fortitude"]) or UnitAura(u, L["Power Word: Fortitude"]) if not c then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents['freebgrid:fort'] = "UNIT_AURA"
oUF.Tags['freebgrid:ds'] = function(u) local c = UnitAura(u, L["Prayer of Spirit"]) or UnitAura(u, L["Divine Spirit"]) if not c then return "|cffffff00"..x.."|r" end end
oUF.TagEvents['freebgrid:ds'] = "UNIT_AURA"
oUF.Tags['freebgrid:wsTime'] = function(u)
  local name, _,_,_,_,_, expirationTime = UnitDebuff(u, L["Weakened Soul"])
  if UnitDebuff(u, L["Weakened Soul"]) then return getTime(expirationTime) end
end
oUF.TagEvents['freebgrid:wsTime'] = "UNIT_AURA"

--druid
oUF.lbCount = { 4, 2, 3 }
oUF.Tags['freebgrid:lb'] = function(u) 
	local name, _,_, c,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Lifebloom"])
	if not (fromwho == "player") then return end
	local spellTimer = GetTime()-expirationTime
	if spellTimer > -2 then
		return "|cffFF0000"..oUF.lbCount[c].."|r"
	elseif spellTimer > -4 then
		return "|cffFF9900"..oUF.lbCount[c].."|r"
	else
		return "|cffA7FD0A"..oUF.lbCount[c].."|r"
	end
end
oUF.TagEvents['freebgrid:lb'] = "UNIT_AURA"
oUF.Tags['freebgrid:rejuv'] = function(u) 
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Rejuvenation"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Rejuvenation"]) then return "|cff00FEBF"..x.."|r" end end
oUF.TagEvents['freebgrid:rejuv'] = "UNIT_AURA"
-- rejuvtime
oUF.Tags['freebgrid:rejuvTime'] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Rejuvenation"])
  if (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rejuvTime'] = "UNIT_AURA"
oUF.Tags['freebgrid:regrow'] = function(u) if UnitAura(u, L["Regrowth"]) then return "|cff00FF10"..x.."|r" end end
oUF.TagEvents['freebgrid:regrow'] = "UNIT_AURA"
oUF.Tags['freebgrid:wg'] = function(u) if UnitAura(u, L["Wild Growth"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:wg'] = "UNIT_AURA"
oUF.Tags['freebgrid:tree'] = function(u) if UnitAura(u, L["Tree of Life"]) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:tree'] = "UNIT_AURA"
oUF.Tags['freebgrid:gotw'] = function(u) local c = UnitAura(u, L["Gift of the Wild"]) or UnitAura(u, L["Mark of the Wild"]) if not c then return "|cffFF00FF"..x.."|r" end end
oUF.TagEvents['freebgrid:gotw'] = "UNIT_AURA"

--warrior
oUF.Tags['freebgrid:Bsh'] = function(u) if UnitAura(u, L["Battle Shout"]) then return "|cffff0000"..x.."|r" end end
oUF.TagEvents['freebgrid:Bsh'] = "UNIT_AURA"
oUF.Tags['freebgrid:Csh'] = function(u) if UnitAura(u, L["Commanding Shout"]) then return "|cffffff00"..x.."|r" end end
oUF.TagEvents['freebgrid:Csh'] = "UNIT_AURA"
oUF.Tags['freebgrid:vigil'] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Vigilance"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Vigilance"]) then return "|cffDEB887"..x.."|r" end end
oUF.TagEvents['freebgrid:vigil'] = "UNIT_AURA"
oUF.Tags['freebgrid:SW'] = function(u) if UnitAura(u, L['Shield Wall']) then return "|cff9900FF"..x.."|r" end end
oUF.TagEvents['freebgrid:SW'] = "UNIT_AURA"

--deathknight
oUF.Tags['freebgrid:how'] = function(u) if UnitAura(u, L["Horn of Winter"]) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents['freebgrid:how'] = "UNIT_AURA"

--mage
oUF.Tags['freebgrid:mc'] = function(u) if UnitAura(u, L["Magic Concentration"]) then return "|cffffff00"..x.."|r" end end
oUF.TagEvents['freebgrid:mc'] = "UNIT_AURA"

--paladin
oUF.Tags['freebgrid:sacred'] = function(u) if UnitAura(u, L["Sacred Shield"]) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents['freebgrid:sacred'] = "UNIT_AURA"
oUF.Tags['freebgrid:beacon'] = function(u) if UnitAura(u, L["Beacon of Light"]) then return "|cffffff10"..x.."|r" end end
oUF.TagEvents['freebgrid:beacon'] = "UNIT_AURA"
oUF.Tags['freebgrid:selfsacred'] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Sacred Shield"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Sacred Shield"]) then return "|cffff33ff"..x.."|r" end end
oUF.TagEvents['freebgrid:selfsacred'] = "UNIT_AURA"
oUF.Tags['freebgrid:selfbeacon'] = function(u)
  local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L["Beacon of Light"])
  if not (fromwho == "player") then return end
  if UnitAura(u, L["Beacon of Light"]) then return "|cffff33ff"..x.."|r" end end
oUF.TagEvents['freebgrid:selfbeacon'] = "UNIT_AURA"
oUF.Tags['freebgrid:beaconTime'] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L["Beacon of Light"])
  if (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:beaconTime'] = "UNIT_AURA"
oUF.Tags['freebgrid:FoLTime'] = function(u)
  local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L['Flash of Light'])
  if (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:FoLTime'] = "UNIT_AURA"

--shaman
oUF.Tags['freebgrid:rip'] = function(u) 
	local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, L['Riptide'])
	if not (fromwho == 'player') then return end
	if UnitAura(u, L['Riptide']) then return '|cff00FEBF'..x..'|r' end end
oUF.TagEvents['freebgrid:rip'] = 'UNIT_AURA'

oUF.Tags['freebgrid:ripTime'] = function(u)
	local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, L['Riptide'])
	if (fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:ripTime'] = 'UNIT_AURA'

oUF.earthCount = {'i','h','g','f','p','q','Z','Y'}
oUF.Tags['freebgrid:earth'] = function(u) local c = select(4, UnitAura(u, L['Earth Shield'])) if c then return '|cffFFCF7F'..oUF.earthCount[c]..'|r' end end
oUF.TagEvents['freebgrid:earth'] = 'UNIT_AURA'

oUF.classIndicators={
		["DRUID"] = {
				["TL"] = "[freebgrid:tree]",
				["TR"] = "[freebgrid:gotw]",
				["BL"] = "[freebgrid:regrow][freebgrid:wg]",
				["BR"] = "[freebgrid:lb]",
				["Cen"] = "[freebgrid:rejuvTime]",
		},
		["PRIEST"] = {
				["TL"] = "[freebgrid:pws][freebgrid:ws]",
				["TR"] = "[freebgrid:ds][freebgrid:sp][freebgrid:fort][freebgrid:fw]",
				["BL"] = "[freebgrid:gotn]",
				["BR"] = "[freebgrid:pom]",
				["Cen"] = "[freebgrid:rnwTime]",
		},
		["PALADIN"] = {
				["TL"] = "[freebgrid:selfsacred][freebgrid:sacred]",
				["TR"] = "[freebgrid:selfbeacon][freebgrid:beacon]",
				["BL"] = "",
				["BR"] = "",
				["Cen"] = "[freebgrid:beaconTime]",
				
		},
		["WARLOCK"] = {
				["TL"] = "",
				["TR"] = "",
				["BL"] = "",
				["BR"] = "",
				["Cen"] = "",
		},
		["WARRIOR"] = {
				["TL"] = "[freebgrid:vigil]",
				["TR"] = "",
				["BL"] = "",
				["BR"] = "",
				["Cen"] = "",
		},
		["DEATHKNIGHT"] = {
				["TL"] = "",
				["TR"] = "[freebgrid:how]",
				["BL"] = "",
				["BR"] = "",
				["Cen"] = "",
		},
		["SHAMAN"] = {
				["TL"] = "[freebgrid:rip]",
				["TR"] = "",
				["BL"] = "",
				["BR"] = "[freebgrid:earth]",
				["Cen"] = "[freebgrid:ripTime]",
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
				["TR"] = "[freebgrid:mc]",
				["BL"] = "",
				["BR"] = "",
				["Cen"] = "",
		}
}
