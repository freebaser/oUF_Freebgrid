local _, ns = ...
local oUF = oUF or ns.oUF
local db = FreebgridDefaults
local dbDebuffs = FreebgridDebuffs

local playerClass = select(2, UnitClass("player"))

local numberize = function(val)
	if(val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end

local function applyAuraIndicator(self)
	self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusTL:ClearAllPoints()
	self.AuraStatusTL:SetPoint("TOPLEFT", 0, 0)
	self.AuraStatusTL:SetFont(db.aurafont, db.indicatorSize, "THINOUTLINE")
	self:Tag(self.AuraStatusTL, oUF.classIndicators[playerClass]["TL"])
	
	self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusTR:ClearAllPoints()
	self.AuraStatusTR:SetPoint("TOPRIGHT", 2, 0)
	self.AuraStatusTR:SetFont(db.aurafont, db.indicatorSize, "THINOUTLINE")
	self:Tag(self.AuraStatusTR, oUF.classIndicators[playerClass]["TR"])

	self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusBL:ClearAllPoints()
	self.AuraStatusBL:SetPoint("BOTTOMLEFT", 0, 0)
	self.AuraStatusBL:SetFont(db.aurafont, db.indicatorSize, "THINOUTLINE")
	self:Tag(self.AuraStatusBL, oUF.classIndicators[playerClass]["BL"])	

	self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusBR:ClearAllPoints()
	self.AuraStatusBR:SetPoint("BOTTOMRIGHT", 6, -2)
	self.AuraStatusBR:SetFont(db.symbols, db.symbolsSize, "THINOUTLINE")
	--self.AuraStatusBR.frequentUpdates = 1 -- Can be cpu intensive in large groups
	self:Tag(self.AuraStatusBR, oUF.classIndicators[playerClass]["BR"])

	self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusCen:ClearAllPoints()
	self.AuraStatusCen:SetPoint("TOP")
	self.AuraStatusCen:SetJustifyH("CENTER")
	self.AuraStatusCen:SetFont(db.font, db.fontsize-2)
	self.AuraStatusCen:SetShadowOffset(1.25, -1.25)
	self.AuraStatusCen.frequentUpdates = 1 -- Can be cpu intensive in large groups
	self:Tag(self.AuraStatusCen, oUF.classIndicators[playerClass]["Cen"])
end

--=======================================================================================--
--[[
	This license applies to the following code provided by oUF_Grid by zariel

Copyright (c) 2009, Chris Bannister
All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the <ORGANIZATION> nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
]]--	

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
			["Curse"] = true,
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
		["DEATHKNIGHT"] = {},
		["HUNTER"] = {},
		["ROGUE"] = {},
		["WARLOCK"] = {},
		["WARRIOR"] = {},
	}
	if t[playerClass] then
		dispellClass = {}
		for k, v in pairs(t[playerClass]) do
			dispellClass[k] = v
		end
		t = nil
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

function f:UNIT_AURA(unit)
	local frame = oUF.units[unit]
	if not frame or frame.unit ~= unit then return end
	if frame:GetAttribute('unitsuffix') == 'target' then return end
	local cur, tex, dis, cnt, exp, dur
	local name, rank, buffTexture, count, duration, expire, dtype, isPlayer
	local dispellPriority, debuffs = db.dispellPriority, dbDebuffs.debuffs
	for i = 1, 40 do
		name, rank, buffTexture, count, dtype, duration, expire, isPlayer = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if not cur or (debuffs[name] >= debuffs[cur]) then
			if debuffs[name] > 0 and debuffs[name] > debuffs[cur or 1] then
				cur = name
				tex = buffTexture
				dis = dtype or "none"
				cnt = count
				exp = expire
				dur = duration
			elseif dtype and dtype ~= "none" then
				if not dis or (dispellPriority[dtype] > dispellPriority[dis]) then
					tex = buffTexture
					dis = dtype
					cnt = count
					exp = expire
					dur = duration
				end
			end	
		end
	end

	if dis and frame.border and frame.Icon then
		if dispellClass[dis] or cur then
			local col = DebuffTypeColor[dis]
			frame.border:SetVertexColor(col.r, col.g, col.b)
			frame.Dispell = true
			frame.border:Show()
			frame.Icon:SetTexture(tex)
			if cnt > 1 then
				frame.Icon.count:SetText(cnt)
				frame.Icon.count:Show()
			end
			if exp and dur then
				frame.Icon.cd:SetCooldown(exp - dur, dur)
				frame.Icon.cd:Show()
			end
			frame.Icon:Show()
			frame.Name:Hide()
		elseif frame.Dispell then
			frame.border:Hide()
			frame.Dispell = false
			frame.Icon.count:Hide()
			frame.Icon.cd:Hide()
			frame.Icon:Hide()
			frame.Name:Show()
		end
	elseif frame.border and frame.Icon then
		frame.border:Hide()
		frame.Icon.count:Hide()
		frame.Icon.cd:Hide()
		frame.Icon:Hide()
		frame.Name:Show()
	end
end
f:RegisterEvent("UNIT_AURA")

local bg = CreateFrame("Frame", nil, UIParent)
bg:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10,
	insets = {left = 2, right = 2, top = 2, bottom = 2}
})
bg:SetBackdropColor(0, 0, 0, 0.7)
bg:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
bg:SetFrameStrata("BACKGROUND")
bg:EnableMouse(true)
bg:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end)
	
function bg:RAID_ROSTER_UPDATE()
	if not db.frameBG then return end
	
	if UnitInRaid("player") then
		self:ClearAllPoints()
		self:SetPoint("TOP", "Raid_Freebgrid", "TOP", 0, 8)
		self:SetPoint("LEFT", "Raid_Freebgrid", "LEFT", -8 , 0)
		self:SetPoint("RIGHT", "Raid_Freebgrid", "RIGHT", 8, 0)
		self:SetPoint("BOTTOM", "Raid_Freebgrid", "BOTTOM", 0, -8)
		self:Show()
	else
		self:Hide()
	end
end

bg.PLAYER_ENTERING_WORLD = bg.RAID_ROSTER_UPDATE
bg:RegisterEvent("RAID_ROSTER_UPDATE")
bg:RegisterEvent("PLAYER_ENTERING_WORLD")

--=======================================================================================--

local backdrop = {
	bgFile = db.highlightTex,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local border = {
	bgFile = db.highlightTex,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

-- Target Border
local ChangedTarget = function(self)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:SetBackdropColor(.8, .8, .8, 1)
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

local FocusTarget = function(self)
	if UnitIsUnit('focus', self.unit) then
		self.FocusHighlight:SetBackdropColor(db.focusHighlightcolor[1], db.focusHighlightcolor[2], db.focusHighlightcolor[3], db.focusHighlightcolor[4])
		self.FocusHighlight:Show()
	else
		self.FocusHighlight:Hide()
	end
end

local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {.31,.45,.63},
		['RAGE'] = {.69,.31,.31},
		['FOCUS'] = {.71,.43,.27},
		['ENERGY'] = {.65,.63,.35},
		['RUNIC_POWER'] = {0,.8,.9},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

local function utf8sub(str, start, numChars) 
	local currentIndex = start 
	while numChars > 0 and currentIndex <= #str do 
	    local char = string.byte(str, currentIndex) 
	    if char >= 240 then 
	      currentIndex = currentIndex + 4 
	    elseif char >= 225 then 
	      currentIndex = currentIndex + 3 
	    elseif char >= 192 then 
	      currentIndex = currentIndex + 2 
	    else 
	      currentIndex = currentIndex + 1 
	    end 
		numChars = numChars - 1 
	end 
	return str:sub(start, currentIndex - 1) 
end 
	 
local nameCache = {}
local updateHealth = function(self, event, unit, bar)
	local def = oUF.Tags["[missinghp]"](unit)
	local per = oUF.Tags["[perhp]"](unit)
	
	local r, g, b, t
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	else		
		r, g, b = db.petColor[1], db.petColor[2], db.petColor[3]
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	if(UnitIsDead(unit)) then
		bar:SetValue(0)
		self.DDG:SetText('Dead')
		self.DDG:Show()
	elseif(UnitIsGhost(unit)) then
		bar:SetValue(0)
		self.DDG:SetText('Ghost')
		self.DDG:Show()
	elseif(not UnitIsConnected(unit)) then
		bar:SetValue(0)
		self.DDG:SetText('D/C')
		self.DDG:Show()
	else
		self.DDG:Hide()
	end
		
	self.Name:SetTextColor(r, g, b)
	
	local name = UnitName(unit) or "Unknown"
	if(per > 90) or UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) or self:GetAttribute('unitsuffix') == 'target' then
		if nameCache[name] then 
			self.Name:SetText(nameCache[name]) 
		else 
			local substring 
			for length=#name, 1, -1 do 
			substring = utf8sub(name, 1, length) 
			self.Name:SetText(substring) 
				if self.Name:GetStringWidth() <= db.width-2 then break end 
			end
			nameCache[name] = substring
		end
	else
		self.Name:SetText('-'..numberize(def))
	end

	bar.bg:SetVertexColor(r, g, b)
	if(db.reverseColors)then
		bar:SetStatusBarColor(r, g, b)
  	else	
		bar:SetStatusBarColor(0, 0, 0)
	end
end

local updatePower = function(self, event, unit)	
	local powerType, powerTypeString = UnitPowerType(unit)

	local perc = oUF.Tags["[perpp]"](unit)
	if (perc < 10 and UnitIsConnected(unit) and powerTypeString == 'MANA' and not UnitIsDeadOrGhost(unit)) then
		self.manaborder:SetBackdropColor(0, .1, .9, .7)
		self.manaborder:Show()
	else
		self.manaborder:Hide()
	end
end

local updateThreat = function(self, event, unit, status)
	local threat = self.Threat

	if(status and status > 1) then
		local r, g, b = GetThreatStatusColor(status)
		threat:SetBackdropBorderColor(r, g, b, 1)
	else
		threat:SetBackdropBorderColor(0, 0, 0, 1)
	end
	threat:Show()
end

local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	self.Highlight:Show()	
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Highlight:Hide()	
end

local function menu(self)
  if(self.unit:match('party')) then
    ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
  else
    ToggleDropDownMenu(1, nil, TargetFrameDropDown, "cursor")
  end
end

-- Style
local func = function(self, unit)
	self.colors = colors
	self.menu = menu

	if(db.highlight)then
		self:SetScript("OnEnter", OnEnter)
		self:SetScript("OnLeave", OnLeave)
	end
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")

	-- Health
	local hp = CreateFrame"StatusBar"
	hp:SetStatusBarTexture(db.texture)
	if(db.reverseColors)then
	  hp:SetAlpha(1)
	else
	  hp:SetAlpha(0.8)
  	end
	hp.frequentUpdates = true
	if(db.manabars)then
	  if(db.vertical)then
	    hp:SetOrientation("VERTICAL")
		hp:SetWidth(db.width*.90)
	    hp:SetParent(self)
	    hp:SetPoint"TOP"
	    hp:SetPoint"BOTTOM"
	    hp:SetPoint"LEFT"
  	  else
	    hp:SetHeight(db.height*.90)
	    hp:SetParent(self)
	    hp:SetPoint"LEFT"
	    hp:SetPoint"RIGHT"
	    hp:SetPoint"TOP"
	  end
  	else
	  if(db.vertical)then
	    hp:SetWidth(db.width)
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
	hpbg:SetTexture(db.texture)
	if(db.reverseColors)then
	  hpbg:SetAlpha(0.3)
	else
	  hpbg:SetAlpha(1)
  	end

	hp.bg = hpbg
	self.Health = hp
	self.OverrideUpdateHealth = updateHealth

	-- Backdrop
	self.BG = CreateFrame("Frame", nil, self)
	self.BG:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.BG:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.BG:SetFrameLevel(3)
	self.BG:SetBackdrop(backdrop)
	self.BG:SetBackdropColor(0, 0, 0)

	-- Threat
	local threat = CreateFrame("Frame", nil, self)
	threat:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
	threat:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
	threat:SetFrameStrata("LOW")
	threat:SetBackdrop {
	  edgeFile = db.glowTex, edgeSize = 5,
	  insets = {left = 3, right = 3, top = 3, bottom = 3}
	}
	threat:SetBackdropColor(0, 0, 0, 0)
	threat:SetBackdropBorderColor(0, 0, 0, 1)
	
	self.Threat = threat
	self.OverrideUpdateThreat = updateThreat
	
	-- PowerBars
	if(db.manabars)then
	  local pp = CreateFrame"StatusBar"
	  pp:SetStatusBarTexture(db.texture)
	  pp.colorPower = true
	  pp.frequentUpdates = true
	
	  if(db.vertical)then
		pp:SetWidth(db.width*.08)
		pp:SetOrientation("VERTICAL")
		pp:SetParent(self)
		pp:SetPoint"TOP"
		pp:SetPoint"BOTTOM"
		pp:SetPoint"RIGHT"
	  else
		pp:SetHeight(db.height*.08)
		pp:SetParent(self)
		pp:SetPoint"LEFT"
		pp:SetPoint"RIGHT"
		pp:SetPoint"BOTTOM"
	  end

	  local ppbg = pp:CreateTexture(nil, "BORDER")
	  ppbg:SetAllPoints(pp)
	  ppbg:SetTexture(db.texture)
	  ppbg.multiplier = .2
	  pp.bg = ppbg

	  self.Power = pp
	  self.PostUpdatePower = updatePower
	end
	
	--Heal Text
	local heal = hp:CreateFontString(nil, "OVERLAY")
	heal:SetPoint("BOTTOM")
	heal:SetJustifyH("CENTER")
	heal:SetFont(db.font, db.fontsize-2)
	heal:SetShadowOffset(1.25, -1.25)
	heal:SetTextColor(0,1,0,1)

	self.HealCommText = db.Healtext and heal or nil
	self.HealCommTextFormat = numberize

	-- Leader/Assistant Icon
	if(db.Licon)then
	  self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
	  self.Leader:SetPoint("TOPLEFT", self, 0, 8)
	  self.Leader:SetHeight(db.iconSize)
	  self.Leader:SetWidth(db.iconSize)
	  
	  self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	  self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
	  self.Assistant:SetHeight(db.iconSize)
	  self.Assistant:SetWidth(db.iconSize)
	end

-- Raid Icon
	if(db.ricon)then
	  self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	  self.RaidIcon:SetPoint("TOP", self, 0, 5)
	  self.RaidIcon:SetHeight(db.iconSize)
	  self.RaidIcon:SetWidth(db.iconSize)
	end

-- ReadyCheck	
	self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetPoint("TOP", self)
	self.ReadyCheck:SetHeight(db.iconSize)
	self.ReadyCheck:SetWidth(db.iconSize)
	self.ReadyCheck.delayTime = 8
	self.ReadyCheck.fadeTime = 1
	
-- Range
	if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = db.OoR
	end

	-- Name
	local name = hp:CreateFontString(nil, "OVERLAY")
	name:SetPoint("CENTER")
	name:SetJustifyH("CENTER")
	name:SetFont(db.font, db.fontsize)
	name:SetShadowOffset(1.25, -1.25)
	name:SetTextColor(1,1,1,1)

	self.Name = name

	local DDG = hp:CreateFontString(nil, "OVERLAY")
	DDG:SetPoint("BOTTOM")
	DDG:SetJustifyH("CENTER")
	DDG:SetFont(db.font, db.fontsize-2)
	DDG:SetShadowOffset(1.25, -1.25)
	DDG:SetTextColor(.8,.8,.8,1)

	self.DDG = DDG
	
	-- Highlight
	if(db.highlight)then
	  local hl = hp:CreateTexture(nil, "OVERLAY")
	  hl:SetAllPoints(self)
	  hl:SetTexture(db.highlightTex)
	  hl:SetVertexColor(1,1,1,.1)
	  hl:SetBlendMode("ADD")
	  hl:Hide()

	  self.Highlight = hl
	end

	local tBorder = CreateFrame("Frame", nil, self)
	tBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	tBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	tBorder:SetBackdrop(border)
	tBorder:SetFrameLevel(2)
	tBorder:Hide()
	
	self.TargetBorder = tBorder
	
	local fBorder = CreateFrame("Frame", nil, self)
	fBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	fBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	fBorder:SetBackdrop(border)
	fBorder:SetFrameLevel(2)
	fBorder:Hide()
	
	self.FocusHighlight = fBorder
	
	local mBorder = CreateFrame("Frame", nil, self)
	mBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	mBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	mBorder:SetBackdrop(border)
	mBorder:SetFrameLevel(2)
	mBorder:Hide()
	
	self.manaborder = mBorder
	
--==========--
--  ICONS   --
--==========--
-- Dispel Icons
	local icon = hp:CreateTexture(nil, "OVERLAY")
	icon:SetPoint("CENTER")
	icon:SetHeight(db.debuffsize)
	icon:SetWidth(db.debuffsize)
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

	local dummy = CreateFrame"StatusBar"
	dummy:SetParent(hp)
	dummy:SetPoint"Center"
	dummy:SetStatusBarTexture(db.trans)
	dummy:SetHeight(db.debuffsize)
	dummy:SetWidth(db.debuffsize)
	self.Dummy = dummy

	local border = dummy:CreateTexture(nil, "OVERLAY")
	border:SetPoint("LEFT", dummy, "LEFT", -3, 0)
	border:SetPoint("RIGHT", dummy, "RIGHT", 3, 0)
	border:SetPoint("TOP", dummy, "TOP", 0, 3)
	border:SetPoint("BOTTOM", dummy, "BOTTOM", 0, -3)
	border:SetTexture(db.iconborder)
	border:Hide()
	border:SetVertexColor(1, 1, 1)
	self.border = border

	local count = dummy:CreateFontString(nil, "OVERLAY")
	count:SetFontObject(NumberFontNormalSmall)
	count:SetPoint("LEFT", dummy, "BOTTOM")
	self.Icon.count = count

	local cd = CreateFrame("Cooldown", nil, dummy)
	cd:SetAllPoints(dummy)
	self.Icon.cd = cd

	if (self:GetAttribute('unitsuffix') == 'target') then
  	else
	-- Healcomm Bar
	  if db.Healbar then
		  self.HealCommBar = CreateFrame('StatusBar', nil, self.Health)
		  self.HealCommBar:SetStatusBarTexture(self.Health:GetStatusBarTexture():GetTexture())
		  self.HealCommBar:SetStatusBarColor(0, 1, 0, 0.4)
		  if db.vertical then
			self.HealCommBar:SetPoint('BOTTOM', self.Health, 'BOTTOM')
		  else
			self.HealCommBar:SetPoint('LEFT', self.Health, 'LEFT')
		  end

		  self.allowHealCommOverflow = db.healOverflow
	  end
	  
	  if(db.indicators)then
	    applyAuraIndicator(self)
  	  end
	end
	
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
		
	self:SetAttribute('initial-height', db.height)
	self:SetAttribute('initial-width', db.width)
	--self:SetAttribute('initial-scale', db.scale)

	return self
end

oUF:RegisterStyle("Freebgrid", func)
oUF:SetActiveStyle"Freebgrid"

local spacingX, spacingY, growth
-- SetPoint of MOTHERFUCKING DOOM!
if db.point == "TOP" and db.growth == "LEFT" then
	growth = "RIGHT"
	spacingX = 0
	spacingY = -(db.spacing)
elseif db.point == "TOP" and db.growth == "RIGHT" then
	growth = "LEFT"
	spacingX = 0
	spacingY = -(db.spacing)
elseif db.point == "LEFT" and db.growth == "UP" then
	growth = "BOTTOM"
	spacingX = db.spacing
	spacingY = 0
elseif db.point == "LEFT" and db.growth == "DOWN" then
	growth = "TOP"
	spacingX = db.spacing
	spacingY = 0
elseif db.point == "RIGHT" and db.growth == "UP" then
	growth = "BOTTOM"
	spacingX = -(db.spacing)
	spacingY = 0
elseif db.point == "RIGHT" and db.growth == "DOWN" then
	growth = "TOP"
	spacingX = -(db.spacing)
	spacingY = 0
elseif db.point == "BOTTOM" and db.growth == "LEFT" then
	growth = "RIGHT"
	spacingX = 0
	spacingY = (db.spacing)
elseif db.point == "BOTTOM" and db.growth == "RIGHT" then
	growth = "LEFT"
	spacingX = 0
	spacingY = (db.spacing)
else -- You failed to equal any of the above. So I give this...
	growth = "RIGHT"
	spacingX = 0
	spacingY = -(db.spacing)
end

local raid = oUF:Spawn('header', 'Raid_Freebgrid', nil, db.disableBlizz)
raid:SetPoint(db.position[1], db.position[2], db.position[3], db.position[4], db.position[5])
raid:SetManyAttributes(
	'showPlayer', true,
	'showSolo', db.solo,
	'showParty', db.partyON,
	'showRaid', true,
	'xoffset', spacingX,
	'yOffset', spacingY,
	'point', db.point,
	'groupFilter', '1,2,3,4,5,6,7,8',
	'groupingOrder', '1,2,3,4,5,6,7,8',
	'groupBy', 'GROUP',
	'maxColumns', db.numRaidgroups,
	'unitsPerColumn', db.units,
	'columnSpacing', db.spacing,
	'columnAnchorPoint', growth
)
raid:SetScale(db.scale)
raid:Show()

if db.pets then
	local pets = oUF:Spawn('header', 'Pet_Freebgrid', 'SecureGroupPetHeaderTemplate')
	pets:SetPoint('TOPLEFT', 'Raid_Freebgrid', 'TOPRIGHT', db.spacing, 0)
	pets:SetManyAttributes(
		'showSolo', db.solo,
		'showParty', db.partyON,
		'showRaid', true,
		'xoffset', spacingX,
		'yOffset', spacingY,
		'point', db.point,
		'maxColumns', db.numRaidgroups,
		'unitsPerColumn', db.units,
		'columnSpacing', db.spacing,
		'columnAnchorPoint', growth
	)
	pets:SetScale(db.scale)
	pets:Show()
end

if db.MTs then
	local tank = oUF:Spawn('header', 'MT_Freebgrid')
		tank:SetPoint(db.MTposition[1], db.MTposition[2], db.MTposition[3], db.MTposition[4], db.MTposition[5])
		tank:SetManyAttributes(
				"showRaid", true, 
				"yOffset", -5
		)
		if db.MTtarget then
			tank:SetAttribute("template", "oUF_FreebMtargets")
		end
	
	if oRA3 and not select(2,IsInInstance()) == "pvp" and not select(2,IsInInstance()) == "arena" then
				tank:SetAttribute(
					"initial-unitWatch", true,
						"nameList", table.concat(oRA3:GetSortedTanks(), ",")
				)
		
				local tankhandler = CreateFrame('Frame')

				function tankhandler:OnEvent()
					if(InCombatLockdown()) then
							self:RegisterEvent('PLAYER_REGEN_ENABLED')
					else
							self:UnregisterEvent('PLAYER_REGEN_ENABLED')
							if self.tanks then
								tank:SetAttribute(
									"nameList", table.concat(self.tanks, ",")
								)
								self.tanks = nil
							end
					end
				end

				function tankhandler:OnTanksUpdated(event, tanks)
					self.tanks = tanks
					self:OnEvent()
				end
		
				tankhandler:SetScript('OnEvent', tankhandler.OnEvent)
				oRA3.RegisterCallback(tankhandler, "OnTanksUpdated")
		
		else
				tank:SetAttribute(
					'groupFilter', 'MAINTANK'
				)
		end
		tank:SetScale(db.scale)
		tank:Show()
end
