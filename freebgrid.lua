local oUF = Freebgrid
local db = FreebgridDefaults
local dbDebuffs = FreebgridDebuffs
local petspacing
if db.pets then
	petspacing = db.petheight+2
else
	petspacing = 0
end

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
	self.AuraStatusTL:SetPoint("TOPLEFT", -1, 0)
	self.AuraStatusTL:SetFont(db.aurafont, db.indicatorSize, "THINOUTLINE")
	self:Tag(self.AuraStatusTL, oUF.classIndicators[playerClass]["TL"])
	
	self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusTR:ClearAllPoints()
	self.AuraStatusTR:SetPoint("TOPRIGHT", 1, 0)
	self.AuraStatusTR:SetFont(db.aurafont, db.indicatorSize, "THINOUTLINE")
	self:Tag(self.AuraStatusTR, oUF.classIndicators[playerClass]["TR"])

	self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusBL:ClearAllPoints()
	self.AuraStatusBL:SetPoint("BOTTOMLEFT", -1, 0)
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
	if frame:GetAttribute('unitsuffix') == 'pet' then return end
	local cur, tex, dis
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
			elseif dtype and dtype ~= "none" then
				if not dis or (dispellPriority[dtype] > dispellPriority[dis]) then
					tex = buffTexture
					dis = dtype
				end
			end	
		end
	end

	if dis then
		if dispellClass[dis] or cur then
			local col = DebuffTypeColor[dis]
			frame.border:SetVertexColor(col.r, col.g, col.b)
			frame.Dispell = true
			frame.border:Show()
			frame.Icon:SetTexture(tex)
			frame.Icon:Show()
			frame.Name:Hide()
		elseif frame.Dispell then
			frame.border:Hide()
			frame.Dispell = false
			frame.Icon:Hide()
			frame.Name:Show()
		end
	else
		frame.border:Hide()
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

local SubGroups = function()
	local t = {}
	local last = db.numRaidgroups
	for i = 1, last do t[i] = 0 end
	for i = 1, GetNumRaidMembers() do
			local s = select(3, GetRaidRosterInfo(i))
			if s > last then break end
			t[s] = t[s] + 1
	end
	return t
end

function bg:PARTY_MEMBERS_CHANGED()
	if not db.frameBG or UnitInRaid("player") then return end
	if not db.solo then return end

	self:ClearAllPoints()
	self:SetPoint("TOP", "oUF_FreebRaid1", "TOP", 0, 8)
	self:SetPoint("LEFT", "oUF_FreebRaid1", "LEFT", -8 , 0)
	self:SetPoint("RIGHT", "oUF_FreebRaid1", "RIGHT", 8, 0)
	self:SetPoint("BOTTOM", "oUF_FreebRaid1", "BOTTOM", 0, -8+(-(petspacing)))
	self:Show()
end

function bg:RAID_ROSTER_UPDATE()
	if not db.frameBG then return end
	if not UnitInRaid("player") then
		self:Hide() 
		return self:PARTY_MEMBERS_CHANGED()
	else
		self:Show()
	end

	local roster = SubGroups()

	local h, last, first = 1
	for k, v in ipairs(roster) do
		if v > 0 then
			if not first then
				first = k
			end
			last = k
		end
		if v > roster[h] then
			h = k
		end
	end
	
	if db.growth == "RIGHT" then
		self:ClearAllPoints()
		self:SetPoint("TOP", "oUF_FreebRaid1", "TOP", 0, 8)
		self:SetPoint("LEFT", "oUF_FreebRaid" .. first, "LEFT", -8 , 0)
		self:SetPoint("RIGHT", "oUF_FreebRaid" .. last, "RIGHT", 8, 0)
		self:SetPoint("BOTTOM", "oUF_FreebRaid" .. h, "BOTTOM", 0, -8+(-(petspacing)))
	elseif db.growth == "UP" then
		self:ClearAllPoints()
		self:SetPoint("LEFT", "oUF_FreebRaid1", "LEFT", -8, 0)
		self:SetPoint("BOTTOM", "oUF_FreebRaid" .. first, "BOTTOM", 0, -8+(-(petspacing)))
		self:SetPoint("TOP", "oUF_FreebRaid" .. last, "TOP", 0, 8)
		self:SetPoint("RIGHT", "oUF_FreebRaid" .. h, "RIGHT", 8, 0)
	elseif db.growth == "DOWN" then
		self:ClearAllPoints()
		self:SetPoint("LEFT", "oUF_FreebRaid1", "LEFT", -8, 0)
		self:SetPoint("TOP", "oUF_FreebRaid" .. first, "TOP", 0, 8)
		self:SetPoint("BOTTOM", "oUF_FreebRaid" .. last, "BOTTOM", 0, -8+(-(petspacing)))
		self:SetPoint("RIGHT", "oUF_FreebRaid" .. h, "RIGHT", 8, 0)
	elseif db.growth == "LEFT" then
		self:ClearAllPoints()
		self:SetPoint("TOP", "oUF_FreebRaid1", "TOP", 0, 8)
		self:SetPoint("RIGHT", "oUF_FreebRaid" .. first, "RIGHT", 8 , 0)
		self:SetPoint("LEFT", "oUF_FreebRaid" .. last, "LEFT", -8, 0)
		self:SetPoint("BOTTOM", "oUF_FreebRaid" .. h, "BOTTOM", 0, -8+(-(petspacing)))
	else
		self:ClearAllPoints()
		self:SetPoint("TOP", "oUF_FreebRaid1", "TOP", 0, 8)
		self:SetPoint("LEFT", "oUF_FreebRaid" .. first, "LEFT", -8 , 0)
		self:SetPoint("RIGHT", "oUF_FreebRaid" .. last, "RIGHT", 8, 0)
		self:SetPoint("BOTTOM", "oUF_FreebRaid" .. h, "BOTTOM", 0, -8+(-(petspacing)))
	end
end

bg.PLAYER_ENTERING_WORLD = bg.RAID_ROSTER_UPDATE
bg.PLAYER_LOGIN = bg.RAID_ROSTER_UPDATE
bg:RegisterEvent("RAID_ROSTER_UPDATE")
bg:RegisterEvent("PARTY_MEMBERS_CHANGED")
bg:RegisterEvent("PLAYER_ENTERING_WORLD")
bg:RegisterEvent("PLAYER_LOGIN")

--=======================================================================================--

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

-- Target Border
local ChangedTarget = function(self)
	if (UnitInRaid'player' == 1 or GetNumPartyMembers() > 0 ) and UnitIsUnit('target', self.unit) then
		if self:GetAttribute('unitsuffix') == 'pet' then return end
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

local FocusTarget = function(self)
	if UnitIsUnit('focus', self.unit) then
		if self:GetAttribute('unitsuffix') == 'pet' then return end
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
		
	if self:GetAttribute('unitsuffix') == 'pet' then
	else
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
			end
			nameCache[name] = substring
		else
			self.Name:SetText('-'..numberize(def))
		end
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
		self.manaborder:Show()
	else
		self.manaborder:Hide()
	end
end

local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	if(db.highlight)then
	  self.Highlight:Show()	
  	end
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	if(db.highlight)then
	  self.Highlight:Hide()	
  	end
end

local function menu(self)
  if(self.unit:match('party')) then
    ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
  else
    ToggleDropDownMenu(1, nil, TargetFrameDropDown, "cursor")
  end
end

local function updateThreat(self, event, u)
	if (self.unit ~= u) then return end
	local s = UnitThreatSituation(u)
	if s and s > 1 then
		r, g, b = GetThreatStatusColor(s)
		self.FrameBackdrop:SetBackdropBorderColor(r, g, b)
	else
		self.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
	end
end

-- Style
local func = function(self, unit)
	self.colors = colors
	self.menu = menu
	
	self:EnableMouse(true)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
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
	    if self:GetAttribute('unitsuffix') == 'pet' then
		  hp:SetWidth(db.width)
	    else
	      hp:SetOrientation("VERTICAL")
		  hp:SetWidth(db.width*.90)
        end
	    hp:SetParent(self)
	    hp:SetPoint"TOP"
	    hp:SetPoint"BOTTOM"
	    hp:SetPoint"LEFT"
  	  else
		if self:GetAttribute('unitsuffix') == 'pet' then
		  hp:SetHeight(db.petheight)
		else
	      hp:SetHeight(db.height*.90)
		end
	    hp:SetParent(self)
	    hp:SetPoint"LEFT"
	    hp:SetPoint"RIGHT"
	    hp:SetPoint"TOP"
	  end
  	else
	  if(db.vertical)then
	    hp:SetWidth(db.width)
	    if self:GetAttribute('unitsuffix') == 'pet' then
	    else
	      hp:SetOrientation("VERTICAL")
    	end
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
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)	

	self.FrameBackdrop = CreateFrame("Frame", nil, self)
	self.FrameBackdrop:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
	self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
	self.FrameBackdrop:SetFrameStrata("LOW")
	self.FrameBackdrop:SetBackdrop {
	  edgeFile = db.glowTex, edgeSize = 5,
	  insets = {left = 3, right = 3, top = 3, bottom = 3}
	}
	self.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
	self.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
	
	if self:GetAttribute('unitsuffix') == 'pet' then
	else
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
		  ppbg.multiplier = .3
		  pp.bg = ppbg

		  self.Power = pp
		  self.PostUpdatePower = updatePower
		end
		
		local heal = hp:CreateFontString(nil, "OVERLAY")
		heal:SetPoint("BOTTOM")
		heal:SetJustifyH("CENTER")
		heal:SetFont(db.font, db.fontsize-2)
		heal:SetShadowOffset(1.25, -1.25)
		heal:SetTextColor(0,1,0,1)

		self.HealCommText = heal

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
	if self:GetAttribute('unitsuffix') == 'pet' then
	  DDG:SetFont(db.font, db.fontsize-4)
  	else
	  DDG:SetFont(db.font, db.fontsize-2)
  	end
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

	-- Range Alpha
	if self:GetAttribute('unitsuffix') == 'target' then
	else
	  if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .5
	  end
	end

	local manaborder = self:CreateTexture(nil, "OVERLAY")
	manaborder:SetPoint("LEFT", self, "LEFT", -5, 0)
	manaborder:SetPoint("RIGHT", self, "RIGHT", 5, 0)
	manaborder:SetPoint("TOP", self, "TOP", 0, 5)
	manaborder:SetPoint("BOTTOM", self, "BOTTOM", 0, -5)
	manaborder:SetTexture(db.borderTex)
	manaborder:Hide()
	manaborder:SetVertexColor(0, .1, .9, .8)
	self.manaborder = manaborder

	local tBorder = self:CreateTexture(nil, "OVERLAY")
	tBorder:SetPoint("LEFT", self, "LEFT", -6, 0)
	tBorder:SetPoint("RIGHT", self, "RIGHT", 6, 0)
	tBorder:SetPoint("TOP", self, "TOP", 0, 6)
	tBorder:SetPoint("BOTTOM", self, "BOTTOM", 0, -6)
	tBorder:SetTexture(db.borderTex)
	tBorder:Hide()
	tBorder:SetVertexColor(.8, .8, .8, .8)
	self.TargetBorder = tBorder

	local fBorder = self:CreateTexture(nil, "OVERLAY")
	fBorder:SetPoint("LEFT", self, "LEFT", -6, 0)
	fBorder:SetPoint("RIGHT", self, "RIGHT", 6, 0)
	fBorder:SetPoint("TOP", self, "TOP", 0, 6)
	fBorder:SetPoint("BOTTOM", self, "BOTTOM", 0, -6)
	fBorder:SetTexture(db.borderTex)
	fBorder:Hide()
	fBorder:SetVertexColor(db.focusHighlightcolor[1], db.focusHighlightcolor[2], db.focusHighlightcolor[3], db.focusHighlightcolor[4])
	self.FocusHighlight = fBorder
	
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

	if (self:GetAttribute('unitsuffix') == 'target') or (self:GetAttribute('unitsuffix') == 'pet') then
	  self.ignoreHealComm = true
  	else
	  if(db.indicators)then
	    applyAuraIndicator(self)
  	  end
	end
	self.ignoreHealComm = db.noHealbar
	
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", updateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", updateThreat)

	if (self:GetAttribute('unitsuffix') == 'pet') then
	  self:SetAttribute('initial-height', db.petheight)
	else
	  self:SetAttribute('initial-height', db.height)
	end
	self:SetAttribute('initial-width', db.width)

	return self
end

oUF:RegisterStyle("Freebgrid", func)
oUF:SetActiveStyle"Freebgrid"

local pos, posRel, spacingX, spacingY
petsTemp = "oUF_FreebpetsDOWN"
-- SetPoint of MOTHERFUCKING DOOM!
if db.point == "TOP" and db.growth == "LEFT" then
	pos = "TOPRIGHT"
	posRel = "TOPLEFT"
	spacingX = 0
	spacingY = -(db.spacing)+(-(petspacing))
	colX = -(db.spacing)
	colY = 0
elseif db.point == "TOP" and db.growth == "RIGHT" then
	pos = "TOPLEFT"
	posRel = "TOPRIGHT"
	spacingX = 0
	spacingY = -(db.spacing)+(-(petspacing))
	colX = db.spacing
	colY = 0
elseif db.point == "LEFT" and db.growth == "UP" then
	pos = "BOTTOMLEFT"
	posRel = "TOPLEFT"
	spacingX = db.spacing
	spacingY = 0
	colX = 0
	colY = db.spacing+((petspacing))
elseif db.point == "LEFT" and db.growth == "DOWN" then
	pos = "TOPLEFT"
	posRel = "BOTTOMLEFT"
	spacingX = db.spacing
	spacingY = 0
	colX = 0
	colY = -(db.spacing)+(-(petspacing))
elseif db.point == "RIGHT" and db.growth == "UP" then
	pos = "BOTTOMRIGHT"
	posRel = "TOPRIGHT"
	spacingX = -(db.spacing)
	spacingY = 0
	colX = 0
	colY = db.spacing+((petspacing))
elseif db.point == "RIGHT" and db.growth == "DOWN" then
	pos = "TOPRIGHT"
	posRel = "BOTTOMRIGHT"
	spacingX = -(db.spacing)
	spacingY = 0
	colX = 0
	colY = -(db.spacing)+(-(petspacing))
elseif db.point == "BOTTOM" and db.growth == "LEFT" then
	pos = "BOTTOMRIGHT"
	posRel = "BOTTOMLEFT"
	spacingX = 0
	spacingY = (db.spacing)+((petspacing))
	colX = -(db.spacing)
	colY = 0
elseif db.point == "BOTTOM" and db.growth == "RIGHT" then
	pos = "BOTTOMLEFT"
	posRel = "BOTTOMRIGHT"
	spacingX = 0
	spacingY = (db.spacing)+((petspacing))
	colX = (db.spacing)
	colY = 0
else -- You failed to equal any of the above. So I give this...
	pos = "TOPLEFT"
	posRel = "TOPRIGHT"
	spacingX = 0
	spacingY = -(db.spacing)+(-(petspacing))
	colX = db.spacing
	colY = 0
end

-- Credits to Zork for the drag frame
local function make_me_movable(f)
	if db.moveable == false then
			f:IsUserPlaced(false)
		else
			f:SetMovable(true)
			f:SetUserPlaced(true)
			if db.locked == false then
				f:EnableMouse(true)
				f:RegisterForDrag("LeftButton","RightButton")
				f:SetScript("OnDragStart", function(self) if IsAltKeyDown() then self:StartMoving() end end)
				f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
			end
	end
end

local oUF_FreebgridDragFrame = CreateFrame("Frame","oUF_FreebgridDragFrame",UIParent)
oUF_FreebgridDragFrame:SetWidth(db.height)
oUF_FreebgridDragFrame:SetHeight(db.width)
oUF_FreebgridDragFrame:SetScale(db.scale)
oUF_FreebgridDragFrame:SetFrameStrata("HIGH")
if db.locked == false then
	oUF_FreebgridDragFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
oUF_FreebgridDragFrame:SetPoint(db.position[1], db.position[2], db.position[3], db.position[4], db.position[5])

local oUF_FreebgridMTDFrame = CreateFrame("Frame","oUF_FreebgridMTDFrame",UIParent)
oUF_FreebgridMTDFrame:SetWidth(db.height)
oUF_FreebgridMTDFrame:SetHeight(db.width)
oUF_FreebgridMTDFrame:SetScale(db.scale)
oUF_FreebgridMTDFrame:SetFrameStrata("HIGH")
if db.locked == false then
	oUF_FreebgridMTDFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
end
oUF_FreebgridMTDFrame:SetPoint(db.MTposition[1], db.MTposition[2], db.MTposition[3], db.MTposition[4], db.MTposition[5])

make_me_movable(oUF_FreebgridDragFrame)
make_me_movable(oUF_FreebgridMTDFrame)

local raid = {}
for i = 1, db.numRaidgroups do
	local raidg = oUF:Spawn('header', 'oUF_FreebRaid'..i, nil)
	raidg:SetManyAttributes('groupFilter', tostring(i),
				'showRaid', true,
				'showSolo', db.solo,
				'showParty', db.partyON,
				'showPlayer', true,
				'point', db.point,
				'xoffset', spacingX,
				'yOffset', spacingY)
	table.insert(raid, raidg)
	if(i == 1) then	
		raidg:SetPoint("TOPLEFT", "oUF_FreebgridDragFrame", "TOPLEFT")
	else
		raidg:SetPoint(pos, raid[i-1], posRel, colX, colY) 
	end
	if db.pets then
		raidg:SetAttribute("template", petsTemp)
	end
	raidg:SetScale(db.scale)
end
for i,v in ipairs(raid) do v:Show() end

if db.MTs then

	local tank = oUF:Spawn('header', 'oUF_FreebMainTank')
		tank:SetPoint("TOPLEFT", "oUF_FreebgridMTDFrame", "TOPLEFT")
		tank:SetManyAttributes(
				"showRaid", true, 
					"yOffset", -5,
					"template", "oUF_FreebMtargets"
		)
	
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
		tank:Show()
end
