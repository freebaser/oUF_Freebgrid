local layoutName = "Freebgrid"
local layoutPath = "Interface\\Addons\\oUF_"..layoutName
local mediaPath = layoutPath.."\\media\\"

local texture = mediaPath.."gradient"
local hightlight = mediaPath.."white"
local borderTex = mediaPath.."border"

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local font,fontsize = mediaPath.."CalibriBold.ttf",12			-- The font and fontSize for Names and Health
local symbols, symbolsSize = mediaPath.."PIZZADUDEBULLETS.ttf", 12	-- The font and fontSize for TagEvents
local symbols1, symbols1Size = mediaPath.."STYLBCC_.ttf", 12		-- The font and fontSize for TagEvents

local height, width = 40, 40
local playerClass = select(2, UnitClass("player"))

local reverseColors = false	-- Reverse Units color
local highlight = true		-- MouseOver Highlight?
local indicators = true 	-- Class Indicators?

local vertical = true 		-- Vertical bars?
local manabars = false		-- Mana Bars?
local Licon = true		-- Leader icon?
local ricon = true		-- Raid icon?

local banzai = LibStub("LibBanzai-2.0")

banzai:RegisterCallback(function(aggro, name, ...)
	for i = 1, select("#", ...) do
		local u = select(i, ...)
		local f = oUF.units[u]
		if f then
			f:UNIT_MAXHEALTH("OnBanzaiUpdate", f.unit)
		end
	end
end)

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

--=========================------------- Big Thanks to jadakren! 

oUF.pomCount = {"i","h","g","f","Z","Y"}

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
				["TR"] = "",
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

--priest
oUF.Tags["[pom]"] = function(u) local c = select(4, UnitAura(u, "Prayer of Mending")) return c and "|cffFFCF7F"..oUF.pomCount[c].."|r" or "" end
oUF.TagEvents["[pom]"] = "UNIT_AURA"

oUF.Tags["[gotn]"] = function(u) return UnitAura(u, "Gift of the Naaru") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[gotn]"] = "UNIT_AURA"
oUF.Tags["[rnw]"] = function(u)
 local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, "Renew")
 if not (fromwho == "player") then return end
 return UnitAura(u, "Renew") and "|cff33FF33.|r" or ""
end
oUF.TagEvents["[rnw]"] = "UNIT_AURA"
oUF.Tags["[pws]"] = function(u) return UnitAura(u, "Power Word: Shield") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[pws]"] = "UNIT_AURA"
oUF.Tags["[ws]"] = function(u) return UnitDebuff(u, "Weakened Soul") and "|cffFF5500.|r" or "" end
oUF.TagEvents["[ws]"] = "UNIT_AURA"


oUF.Tags["[sp]"] = function(u) return (UnitAura(u, "Prayer of Shadow Protection") or UnitAura(u, "Shadow Protection")) and "" or "|cff9900FF.|r" end
oUF.TagEvents["[sp]"] = "UNIT_AURA"
oUF.Tags["[fort]"] = function(u) return (UnitAura(u, "Prayer of Fortitude") or UnitAura(u, "Power Word: Fortitude")) and "" or "|cff00A1DE.|r" end
oUF.TagEvents["[fort]"] = "UNIT_AURA"
oUF.Tags["[fw]"] = function(u) return UnitAura(u, "Fear Ward") and "|cff8B4513 .|r" or "" end
oUF.TagEvents["[fw]"] = "UNIT_AURA"
oUF.Tags["[ds]"] = function(u) return (UnitAura(u, "Prayer of Spirit") or UnitAura(u, "Divine Spirit")) and "" or "|cffffff00.|r" end
oUF.TagEvents["[ds]"] = "UNIT_AURA"

--druid
oUF.Tags["[lb]"] = function(u) local c = select(4, UnitAura(u, "Lifebloom")) return c and "|cffA7FD0A"..c.."|r" or "" end
oUF.Tags["[rejuv]"] = function(u) return UnitAura(u, "Rejuvenation") and "|cff00FEBF.|r" or "" end
oUF.Tags["[regrow]"] = function(u) return UnitAura(u, "Regrowth") and "|cff00FF10.|r" or "" end
oUF.Tags["[wg]"] = function(u) return UnitAura(u, "Wild Growth") and "|cff33FF33.|r" or "" end
oUF.Tags["[tree]"] = function(u) return UnitAura(u, "Tree of Life") and "|cff33FF33.|r" or "" end
oUF.Tags["[gotw]"] = function(u) return UnitAura(u, "Gift of the Wild") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[lb]"] = "UNIT_AURA"
oUF.TagEvents["[rejuv]"] = "UNIT_AURA"
oUF.TagEvents["[regrow]"] = "UNIT_AURA"
oUF.TagEvents["[wg]"] = "UNIT_AURA"
oUF.TagEvents["[tree]"] = "UNIT_AURA"
oUF.TagEvents["[gotw]"] = "UNIT_AURA"

--warrior
oUF.Tags["[sh]"] = function(u) return (UnitAura(u, "Battle Shout") or UnitAura(u, "Commanding Shout")) and "" or "|cffffff00.|r" end
oUF.TagEvents["[sh]"] = "UNIT_AURA"


local function applyAuraIndicator(self)
--========= ----- =========--
		self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusTL:ClearAllPoints()
		self.AuraStatusTL:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, -5)
		self.AuraStatusTL:SetFont(font, 22, "OUTLINE")
		self:Tag(self.AuraStatusTL, oUF.classIndicators[playerClass]["TL"])
	
		self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusTR:ClearAllPoints()
		self.AuraStatusTR:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 5, -5)
		self.AuraStatusTR:SetFont(font, 22, "OUTLINE")
		self:Tag(self.AuraStatusTR, oUF.classIndicators[playerClass]["TR"])

		self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusBL:ClearAllPoints()
		self.AuraStatusBL:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -5, -5)
		self.AuraStatusBL:SetFont(font, 22, "OUTLINE")
		self:Tag(self.AuraStatusBL, oUF.classIndicators[playerClass]["BL"])	

		self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusBR:ClearAllPoints()
		self.AuraStatusBR:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 7, -3)
		self.AuraStatusBR:SetFont(symbols, symbolsSize, "OUTLINE")
		self:Tag(self.AuraStatusBR, oUF.classIndicators[playerClass]["BR"])	
	--========= ----- =========--
end
 
-- Credits to zariel

local debuffs = {
	["Viper Sting"] = 12,

	["Wound Poison"] = 9,
	["Mortal Strike"] = 8,
	["Aimed Shot"] = 8,

	["Counterspell - Silenced"] = 11,
	["Counterspell"] = 10,

	["Blind"] = 10,
	["Cyclone"] = 10,

	["Polymorph"] = 7,

	["Entangling Roots"] = 7,
	["Freezing Trap Effect"] = 7,

	["Crippling Poison"] = 6,
	["Hamstring"] = 5,
	["Wing Clip"] = 5,

	["Fear"] = 3,
	["Psychic Scream"] = 3,
	["Howl of Terror"] = 3,
}

local dispellClass
do
	local t = {
		["PRIEST"] = {
			["Magic"] = true,
			["Disease"] = true,
		},
		["SHAMAN"] = {
			["Poison"] = true,
			["Disease"] = true,
			--["Curse"] = true, -- uncomment to enable curses for shamans
		},
		["PALADIN"] = {
			["Poison"] = true,
			["Magic"] = true,
			["Disease"] = true,
		},
		["MAGE"] = {
			["Curse"] = true,
		},
		["DRUID"] = {
			["Curse"] = true,
			["Poison"] = true,
		},
	}
	if t[playerClass] then
		dispellClass = {}
		for k, v in pairs(t[playerClass]) do
			dispellClass[k] = v
		end
		t = nil
	end
end

local dispellPiority = {
	["Magic"] = 4,
	["Poison"] = 3,
	["Disease"] = 1,
	["Curse"] = 2,
}

local name, rank, buffTexture, count, duration, timeLeft, dtype
function f:UNIT_AURA(unit)
	if not oUF.units[unit] then return end

	local frame = oUF.units[unit]

	if not frame.Icon then return end
	local current, bTexture, dispell, dispellTexture
	for i = 1, 40 do
		name, rank, buffTexture, count, dtype, duration, timeLeft = UnitDebuff(unit, i)
		if not name then break end

		if dispellClass and dispellClass[dtype] then
			dispell = dispell or dtype
			dispellTexture = dispellTexture or buffTexture
			if dispellPiority[dtype] > dispellPiority[dispell] then
				dispell = dtype
				dispellTexture = buffTexture
			end
		end

		if debuffs[name] then
			current = current or name
			bTexture = bTexture or buffTexture

			local prio = debuffs[name]
			if prio > debuffs[current] then
				current = name
				bTexture = buffTexture
			end
		end
	end

	if dispellClass then
		if dispell then
			if dispellClass[dispell] then
				local col = DebuffTypeColor[dispell]
				frame.border:Show()
				frame.border:SetVertexColor(col.r, col.g, col.b)
				frame.Dispell = true
				if not bTexture and dispellTexture then
					current = dispell
					bTexture = dispellTexture
				end
			end
		else
			frame.border:SetVertexColor(1, 1, 1)
			frame.Dispell = false
			frame.border:Hide()
		end
	end

	if current and bTexture then
		frame.IconShown = true
		frame.Icon:SetTexture(bTexture)
		frame.Icon:ShowText()
		frame.DebuffTexture = true
	else
		frame.IconShown = false
		frame.DebuffTexture = false
		frame.Icon:HideText()
	end
end
-- Target Border
local ChangedTarget = function(self)
	if (UnitInRaid'player' == 1 or GetNumPartyMembers() > 0 ) and UnitIsUnit('target', self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

--===========================--
local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {.31,.45,.63},
		['RAGE'] = {.69,.31,.31},
		['FOCUS'] = {.71,.43,.27},
		['ENERGY'] = {.65,.63,.35},
		['RUNIC_POWER'] = {0,.8,.9},
	}, {__index = oUF.colors.power}),
	class =setmetatable({
		["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
		["DRUID"] = { 1.0 , 0.49, 0.04 },
		["HUNTER"] = { 0.67, 0.83, 0.45 },
		["MAGE"] = { 0.41, 0.8 , 0.94 },
		["PALADIN"] = { 0.96, 0.55, 0.73 },
		["PRIEST"] = { 1.0 , 1.0 , 1.0 },
		["ROGUE"] = { 1.0 , 0.96, 0.41 },
		["SHAMAN"] = { 0.14,  0.35,  1.00 },
		["WARLOCK"] = { 0.58, 0.51, 0.7 },
		["WARRIOR"] = { 0.78, 0.61, 0.43 },
	}, {__index = oUF.colors.class}),
}, {__index = oUF.colors})

--local menu = function(self)
--[[	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end]]

local round = function(x, y)
	return math.floor((x * 10 ^ y)+ 0.5) / 10 ^ y
end

local updateHealth = function(self, event, unit, bar, current, max)
	local def = max - current
	bar:SetValue(current)

	local r, g, b, t
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		r, g, b = .3, .3, .3
	elseif(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = colors.class[class]	
	else		
		-- MainTank target and Party Pet color
		r, g, b = .1, .8, .3
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	local per = round(current/max, 100)
	if (UnitIsPlayer(unit)) and (banzai:GetUnitAggroByUnitId(unit)) then
		self.Name:SetVertexColor(1, 0, 0)
	else	
		-- Name Color
		self.Name:SetTextColor(r, g, b)
	end

	if(not UnitIsConnected(unit)) then
		self.Name:SetText('|cffD7BEA5'..'D/C')
	elseif(UnitIsDead(unit)) then
		self.Name:SetText('|cffD7BEA5'..'Dead')
	elseif(UnitIsGhost(unit)) then
		self.Name:SetText('|cffD7BEA5'..'Ghost')
	elseif (per > 0.9) then
		self.Name:SetText(UnitName(unit):utf8sub(1, 3))
	else
		self.Name:SetFormattedText("-%0.1f",math.floor(def/100)/10)
	end

	bar.bg:SetVertexColor(r, g, b)

	if(reverseColors)then
	  bar:SetStatusBarColor(r, g, b)
  	else	
	  bar:SetStatusBarColor(0, 0, 0)
	end
end

local updatePower = function(self, event, unit, bar, current, max)	
	local powerType, powerTypeString = UnitPowerType(unit)

	local perc = round(current/max, 100)
	if (perc < 0.1 and UnitIsConnected(unit) and powerTypeString == 'MANA' and not UnitIsDeadOrGhost(unit)) then
		self.manaborder:Show()
	else
		self.manaborder:Hide()
	end
end

local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	self.Highlight:Show()
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Highlight:Hide()
end

-- Style
local func = function(self, unit)
	--self.menu = menu
	self.colors = colors
	
	self:EnableMouse(true)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")

	-- Health
	local hp = CreateFrame"StatusBar"
	hp:SetStatusBarTexture(texture)
	if(reverseColors)then
	  hp:SetAlpha(1)
	else
	  hp:SetAlpha(0.8)
  	end
	hp.frequentUpdates = true
	if(manabars)then
	  if(vertical)then
	    hp:SetWidth(width*.93)
	    hp:SetOrientation("VERTICAL")
	    hp:SetParent(self)
	    hp:SetPoint"TOP"
	    hp:SetPoint"BOTTOM"
	    hp:SetPoint"LEFT"
  	  else
	    hp:SetHeight(height*.93)
	    hp:SetParent(self)
	    hp:SetPoint"LEFT"
	    hp:SetPoint"RIGHT"
	    hp:SetPoint"TOP"
	  end
  	else
	  if(vertical)then
	    hp:SetWidth(width)
	    hp:SetOrientation("VERTICAL")
	    hp:SetParent(self)
	    hp:SetPoint"TOPLEFT"
	    hp:SetPoint"BOTTOMRIGHT"
  	  else
	    hp:SetParent(self)
	    hp:SetPoint"TOPLEFT"
	    hp:SetPoint"BOTTOMRIGHT"
	  end
	end

	local hpbg = hp:CreateTexture(nil, "BORDER")
	hpbg:SetAllPoints(hp)
	hpbg:SetTexture(texture)
	if(reverseColors)then
	  hpbg:SetAlpha(0.3)
	else
	  hpbg:SetAlpha(1)
  	end

	-- Backdrop
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)

	-- Health Text
	local hpp = hp:CreateFontString(nil, "OVERLAY")
	hpp:SetFont(font, fontsize)
	hpp:SetShadowOffset(1,-1)
	hpp:SetPoint("CENTER")
	hpp:SetJustifyH("CENTER")

	hp.bg = hpbg
	hp.value = hpp
	self.Health = hp
	self.OverrideUpdateHealth = updateHealth

	-- PowerBars
	if(manabars)then
	  local pp = CreateFrame"StatusBar"
	  pp:SetStatusBarTexture(texture)
	  pp.colorPower = true
	  pp.frequentUpdates = true
	
	  if(vertical)then
	    pp:SetWidth(width*.05)
	    pp:SetOrientation("VERTICAL")
	    pp:SetParent(self)
	    pp:SetPoint"TOP"
	    pp:SetPoint"BOTTOM"
	    pp:SetPoint"RIGHT"
  	  else
	    pp:SetHeight(height*.05)
	    pp:SetParent(self)
	    pp:SetPoint"LEFT"
	    pp:SetPoint"RIGHT"
	    pp:SetPoint"BOTTOM"
	  end

	  local ppbg = pp:CreateTexture(nil, "BORDER")
	  ppbg:SetAllPoints(pp)
	  ppbg:SetTexture(texture)
	  ppbg.multiplier = .3
	  pp.bg = ppbg

	  self.Power = pp
	  self.PostUpdatePower = updatePower
	end
	
	-- Highlight
	if(highlight)then
	  local hl = hp:CreateTexture(nil, "OVERLAY")
	  hl:SetAllPoints(self)
	  hl:SetTexture(hightlight)
	  hl:SetVertexColor(1,1,1,.1)
	  hl:SetBlendMode("ADD")
	  hl:Hide()

	  self.Highlight = hl
	end

	-- Range Alpha/SpellRange
	if(IsAddOnLoaded('oUF_SpellRange')) then
	  self.SpellRange = true
	  self.inRangeAlpha = 1.0 -- Frame alpha when in range
	  self.outsideRangeAlpha = 0.5 -- Frame alpha when out of range
	else
	  if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .5
	  end
  	end

	-- Name
	local name = hp:CreateFontString(nil, "OVERLAY")
	name:SetPoint("CENTER")
	name:SetJustifyH("CENTER")
	name:SetFont(font, fontsize)
	name:SetShadowOffset(1.25, -1.25)
	name:SetTextColor(1,1,1,1)

	self.Name = name

	local manaborder = self:CreateTexture(nil, "OVERLAY")
	manaborder:SetPoint("LEFT", self, "LEFT", -5, 0)
	manaborder:SetPoint("RIGHT", self, "RIGHT", 5, 0)
	manaborder:SetPoint("TOP", self, "TOP", 0, 5)
	manaborder:SetPoint("BOTTOM", self, "BOTTOM", 0, -5)
	manaborder:SetTexture(borderTex)
	manaborder:Hide()
	manaborder:SetVertexColor(0, .1, .9, .8)
	self.manaborder = manaborder

	tBorder = self:CreateTexture(nil, "OVERLAY")
	tBorder:SetPoint("LEFT", self, "LEFT", -6, 0)
	tBorder:SetPoint("RIGHT", self, "RIGHT", 6, 0)
	tBorder:SetPoint("TOP", self, "TOP", 0, 6)
	tBorder:SetPoint("BOTTOM", self, "BOTTOM", 0, -6)
	tBorder:SetTexture(borderTex)
	tBorder:Hide()
	tBorder:SetVertexColor(.8, .8, .8, .8)
	self.TargetBorder = tBorder

--==========--
--  ICONS   --
--==========--
-- Dispel Icons
	local icon = hp:CreateTexture(nil, "OVERLAY")
	icon:SetPoint("CENTER")
	icon:SetHeight(18)
	icon:SetWidth(18)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:Hide()
	icon.ShowText = function(s)
		self.Name:Hide()
		s:Show()
	end
	icon.HideText = function(s)
		self.Name:Show()
		s:Hide()
	end
	self.Icon = icon

	local border = self:CreateTexture(nil, "OVERLAY")
	border:SetPoint("LEFT", self, "LEFT", -5, 0)
	border:SetPoint("RIGHT", self, "RIGHT", 5, 0)
	border:SetPoint("TOP", self, "TOP", 0, 5)
	border:SetPoint("BOTTOM", self, "BOTTOM", 0, -5)
	border:SetTexture(borderTex)
	border:Hide()
	border:SetVertexColor(1, 1, 1)
	self.border = border

-- Leader Icon
	if(Licon)then
	self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
	self.Leader:SetPoint("TOPLEFT", self, 0, 8)
	self.Leader:SetHeight(16)
	self.Leader:SetWidth(16)
	end

-- Raid Icon
	if(ricon)then
	self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetPoint("TOP", self, 0, 8)
	self.RaidIcon:SetHeight(16)
	self.RaidIcon:SetWidth(16)
	end

-- ReadyCheck	
	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetPoint("TOPRIGHT", self, 0, 8)
	self.ReadyCheck:SetHeight(16)
	self.ReadyCheck:SetWidth(16)
	self.ReadyCheck.delayTime = 8
	self.ReadyCheck.fadeTime = 2

	if not(self:GetAttribute('unitsuffix') == 'target')then
	  if(indicators)then
	    applyAuraIndicator(self)
  	  end
	
	  self.applyHealComm = true
	end

	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	f:RegisterEvent("UNIT_AURA")

	self:SetAttribute('initial-height', height)
	self:SetAttribute('initial-width', width)

	return self
end

oUF:RegisterStyle("Freebgrid", func)

oUF:SetActiveStyle"Freebgrid"  

local party = oUF:Spawn('header', 'oUF_Party')
party:SetPoint('CENTER', UIParent, 0, -420)
party:SetManyAttributes('showParty', true, 
			'showPlayer', true,
			'point', 'LEFT', -- Remove to grow vertically
			'xOffset', 5)
party:SetAttribute("template", "oUF_Freebpets")

local raid = {}
for i = 1, 5 do
	local raidg = oUF:Spawn('header', 'oUF_Raid'..i)
	raidg:SetManyAttributes('groupFilter', tostring(i), 
				'showRaid', true,
				'point', 'LEFT', -- Remove to grow vertically
				'xOffset', 5)
	table.insert(raid, raidg)
	if(i == 1) then	
		raidg:SetPoint('CENTER', UIParent, 0, -420)
	else
		raidg:SetPoint('BOTTOMLEFT', raid[i-1], 'TOPLEFT', 0, 5)
	end
end

local tank = oUF:Spawn('header', 'oUF_MainTank')
tank:SetPoint('LEFT', UIParent, 5, 100)
tank:SetManyAttributes('showRaid', true, 
			'groupFilter', 'MAINTANK', 
			'yOffset', -5)
tank:SetAttribute("template", "oUF_FreebMtargets")

local partyToggle = CreateFrame('Frame')

partyToggle:RegisterEvent('PLAYER_LOGIN')
partyToggle:RegisterEvent('RAID_ROSTER_UPDATE')
partyToggle:RegisterEvent('PARTY_LEADER_CHANGED')
partyToggle:RegisterEvent('PARTY_MEMBERS_CHANGED')
partyToggle:SetScript('OnEvent', function(self)
	if(InCombatLockdown()) then
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		if(GetNumRaidMembers() > 5) then
			party:Hide()
			for i,v in ipairs(raid) do v:Show() end
			tank:Hide() --tank:Show() to enable MTs
		else
			party:Show()
			for i,v in ipairs(raid) do v:Hide() end
		end
	end
end)

