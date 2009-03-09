local layoutName = "Freebgrid"
local layoutPath = "Interface\\Addons\\oUF_"..layoutName
local mediaPath = layoutPath.."\\media\\"

local texture = mediaPath.."gradient"
local hightlight = mediaPath.."white"

local font,fontsize = mediaPath.."CalibriBold.ttf",12			-- The font and fontSize for Names and Health
local symbols, symbolsSize = mediaPath.."PIZZADUDEBULLETS.ttf", 12	-- The font and fontSize for TagEvents
local symbols1, symbols1Size = mediaPath.."STYLBCC_.ttf", 12		-- The font and fontSize for TagEvents

local height, width = 40, 40
local playerClass = select(2, UnitClass("player"))

local highlight = true		-- MouseOver Highlight?
local filterdebuff = true	-- Filter debuffs by your class?(oUF_DebuffHighlight)
local indicators = false		-- Class Indicators?

local vertical = true 		-- Vertical bars?
local manabars = false		-- Mana Bars?
local Licon = false		-- Leader icon?
local ricon = false		-- Raid icon?

local numberize = function(val)
	if(val >= 1e4) then
        return ("%.1fk"):format(val / 1e3)
	elseif (val >= 1e6) then
		return ("%.1fm"):format(val / 1e6)
	else
		return val
	end
end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], tile = true, tileSize = 16,
	insets = {top = -2, left = -2, bottom = -2, right = -2},
}

--=========================------------- Big Thanks to jadakren! 

oUF.pomCount = {"i","h","g","f","Z","Y"}
oUF.unitStyle={
	["player"] = function()
	end,
	["target"] = function()
	end,
	["targettarget"] = function()
	end,
	["focus"] = function()
	end,
	["focustarget"] = function()
	end,
	["pet"] = function()
	end,
	["pettarget"] = function()
	end
}
oUF.classIndicators={
		["DRUID"] = {
				["TL"] = "[tree]",
				["TR"] = "[gotw]",
				["BL"] = "[lb]",
				["BR"] = "[rejuv][regrow][flour]"
		},
		["PRIEST"] = {
				["TL"] = "[pws][ws]",
				["TR"] = "[sp][fort][fw]",
				["BL"] = "[pom]",
				["BR"] = "[rnw][gotn]"
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
		["ROGUE"] = {
			["TL"] = "",
			["TR"] = "",
			["BL"] = "",
			["BR"] = ""
		}
		
	}
oUF.TagEvents["[shortName]"] = "UNIT_NAME_UPDATE"
oUF.Tags["[shortName]"] = function(u) 
	return string.sub(UnitName(u),1,4) or '' 
end

oUF.TagEvents["[raidhp]"] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags["[raidhp]"] = function(u)
	o = ""
	if not(u == nil) then
		local c, m, n= UnitHealth(u), UnitHealthMax(u), UnitName(u)
		if(c <= 1) then 
			o = "DEAD" 
		elseif not UnitIsConnected(u) then
			return "D/C" 
		elseif(c >= m) then 
			o = n:utf8sub(1,4)
		elseif(UnitCanAttack("player", u)) then
			o = math.floor(c/m*100+0.5).."%"
		else
		 	o = "-"..numberize(m - c)
		end
	end
	return o
end
oUF.Tags["[pom]"] = function(u) local c = select(4, UnitAura(u, "Prayer of Mending")) return c and "|cffFFCF7F"..oUF.pomCount[c].."|r" or "" end
oUF.TagEvents["[pom]"] = "UNIT_AURA"

oUF.Tags["[gotn]"] = function(u) return UnitAura(u, "Gift of the Naaru") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[gotn]"] = "UNIT_AURA"
oUF.Tags["[rnw]"] = function(u) return UnitAura(u, "Renew") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[rnw]"] = "UNIT_AURA"

oUF.Tags["[pws]"] = function(u) return UnitAura(u, "Power Word: Shield") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[pws]"] = "UNIT_AURA"
oUF.Tags["[ws]"] = function(u) return UnitDebuff(u, "Weakened Soul") and "|cffFF5500.|r" or "" end
oUF.TagEvents["[ws]"] = "UNIT_AURA"


oUF.Tags["[sp]"] = function(u) return (UnitAura(u, "Prayer of Shadow Protection") or UnitAura(u, "Shadow Protection")) and "" or "|cff9900FF.|r" end
oUF.TagEvents["[sp]"] = "UNIT_AURA"
oUF.Tags["[fort]"] = function(u) return (UnitAura(u, "Prayer of Fortitude") or UnitAura(u, "Power Word: Fortitude")) and "" or "|cff00A1DE.|r" end
oUF.TagEvents["[fort]"] = "UNIT_AURA"
oUF.Tags["[fw]"] = function(u) return UnitAura(u, "Fear Ward") and "|cffCA21FF.|r" or "" end
oUF.TagEvents["[fw]"] = "UNIT_AURA"

--druid

oUF.Tags["[lb]"] = function(u) local c = select(4, UnitAura(u, "Lifebloom")) return c and "|cffA7FD0A"..c.."|r" or "" end
oUF.Tags["[rejuv]"] = function(u) return UnitAura(u, "Rejuvenation") and "|cff00FEBF.|r" or "" end
oUF.Tags["[regrow]"] = function(u) return UnitAura(u, "Regrowth") and "|cff00FF10.|r" or "" end
oUF.Tags["[flour]"] = function(u) return UnitAura(u, "Flourish") and "|cff33FF33.|r" or "" end
oUF.Tags["[tree]"] = function(u) return UnitAura(u, "Tree of Life") and "|cff33FF33.|r" or "" end
oUF.Tags["[gotw]"] = function(u) return UnitAura(u, "Gift of the Wild") and "|cff33FF33.|r" or "" end
oUF.TagEvents["[lb]"] = "UNIT_AURA"
oUF.TagEvents["[rejuv]"] = "UNIT_AURA"
oUF.TagEvents["[regrow]"] = "UNIT_AURA"
oUF.TagEvents["[flour]"] = "UNIT_AURA"
oUF.TagEvents["[tree]"] = "UNIT_AURA"
oUF.TagEvents["[gotw]"] = "UNIT_AURA"


local function applyAuraIndicator(self)
--========= ----- =========--
		self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusTL:ClearAllPoints()
		self.AuraStatusTL:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 0, 18)
		self.AuraStatusTL:SetJustifyH("LEFT")
		self.AuraStatusTL:SetFont(font, 22, "OUTLINE")
		self:Tag(self.AuraStatusTL, oUF.classIndicators[playerClass]["TL"])
	
		self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusTR:ClearAllPoints()
		self.AuraStatusTR:SetPoint("TOPRIGHT", self.Health, "TOPRIGHT", 5, 18)
		self.AuraStatusTR:SetJustifyH("RIGHT")
		self.AuraStatusTR:SetFont(font, 22, "OUTLINE")
		self:Tag(self.AuraStatusTR, oUF.classIndicators[playerClass]["TR"])

		self.AuraStatusBR1 = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusBR1:ClearAllPoints()
		self.AuraStatusBR1:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 5, -5)
		self.AuraStatusBR1:SetJustifyH("RIGHT")
		self.AuraStatusBR1:SetFont(symbols, symbolsSize, "OUTLINE")
		self:Tag(self.AuraStatusBR1, oUF.classIndicators[playerClass]["BL"])	

		self.AuraStatusBR2 = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusBR2:ClearAllPoints()
		self.AuraStatusBR2:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 5, -5)
		self.AuraStatusBR2:SetJustifyH("RIGHT")
		self.AuraStatusBR2:SetFont(font, 22, "OUTLINE")
		self:Tag(self.AuraStatusBR2, oUF.classIndicators[playerClass]["BR"])	
	--========= ----- =========--
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
}, {__index = oUF.colors})

local colorsC = {
	class ={
		["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
		["DRUID"] = { 1.0 , 0.49, 0.04 },
		["HUNTER"] = { 0.67, 0.83, 0.45 },
		["MAGE"] = { 0.41, 0.8 , 0.94 },
		["PALADIN"] = { 0.96, 0.55, 0.73 },
		["PRIEST"] = { 1.0 , 1.0 , 1.0 },
		["ROGUE"] = { 1.0 , 0.96, 0.41 },
		["SHAMAN"] = { 0,0.86,0.73 },
		["WARLOCK"] = { 0.58, 0.51, 0.7 },
		["WARRIOR"] = { 0.78, 0.61, 0.43 },
	},
}
setmetatable(colorsC.class, {
	__index = function(self, key)
		return { 0.78, 0.61, 0.43 }
	end
})

local GetClassColor = function(unit)
	return unpack(colorsC.class[select(2, UnitClass(unit))])
end
local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

-- Health Function
local updateHealth = function(self, event, unit, bar, min, max)

	if(max ~= 0)then
	  r,g,b = self.ColorGradient((min/max), .9,.1,.1, .9,.1,.1, 1,1,1)
	end

	bar.value:SetTextColor(r,g,b)

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		bar.bg:SetVertexColor(0.3, 0.3, 0.3)
	else
		bar.bg:SetVertexColor(GetClassColor(unit))
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
	self.menu = menu
	self.colors = colors
	
	self:EnableMouse(true)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")

	-- Health
	local hp = CreateFrame"StatusBar"
	hp:SetStatusBarTexture(texture)
	hp:SetStatusBarColor(0, 0, 0)
	hp:SetAlpha(0.8)
	hp.colorHappiness = true
	hp.frequentUpdates = true
	if(manabars)then
	  if(vertical)then
	    hp:SetWidth(width*.95)
	    hp:SetOrientation("VERTICAL")
	    hp:SetParent(self)
	    hp:SetPoint"TOP"
	    hp:SetPoint"BOTTOM"
	    hp:SetPoint"LEFT"
  	  else
	    hp:SetHeight(height*.95)
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
	hpbg.colorClass = true

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, .5)

	-- Health Text
	local hpp = hp:CreateFontString(nil, "OVERLAY")
	hpp:SetFont(font, fontsize, "THINOUTLINE")
	hpp:SetShadowOffset(1,-1)
	hpp:SetPoint("CENTER")
	hpp:SetJustifyH("CENTER")

	self:Tag(hpp, "[raidhp]")

	hp.bg = hpbg
	hp.value = hpp
	self.Health = hp
	self.OverrideUpdateHealth = updateHealth

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

	-- Hightlight
	if(highlight)then
	  local hl = hp:CreateTexture(nil, "OVERLAY")
	  hl:SetAllPoints(self)
	  hl:SetTexture(hightlight)
	  hl:SetVertexColor(1,1,1,.1)
	  hl:SetBlendMode("ADD")
	  hl:Hide()

	  self.Highlight = hl
	end

	-- DebuffHidghtlight
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightAlpha = .5

	if(filterdebuff)then
	  self.DebuffHighlightFilter = true
	end

	-- Range Alpha
	if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .5
	end

--==========--
--  ICONS   --
--==========--
--Leader Icon
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
	
	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetPoint("TOPRIGHT", self, 0, 8)
	self.ReadyCheck:SetHeight(16)
	self.ReadyCheck:SetWidth(16)
	
	if(indictors)then
	  applyAuraIndicator(self)
  	end

	self:SetAttribute('initial-height', height)
	self:SetAttribute('initial-width', width)

	return self
end

oUF:RegisterStyle("Freebgrid", func)

oUF:SetActiveStyle"Freebgrid"  

local raid = {}
for i = 1, 8 do
	local group = oUF:Spawn('header', 'oUF_Group'..i)
	group:SetManyAttributes('groupFilter', tostring(i), 'showRaid', true, 'yOffset', -4)
	table.insert(raid, group)
	if(i == 1) then
		group:SetManyAttributes('showParty', true, 'showPlayer', true)
		group:SetPoint('TOPLEFT', UIParent, 5, -500)
	else
		group:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', 4, 0)
	end
	group:Show()
end



