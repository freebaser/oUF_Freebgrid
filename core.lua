local ADDON_NAME, ns = ...
local oUF = ns.oUF
if not oUF then return end

-- Number formatting
local numberize = function(val)
	if (val >= 1e6) then
		return ("%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end

-- Unit Menu
local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(cunit == 'Vehicle') then
		cunit = 'Pet'
	end

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local updateRIcon = function(self, event)
	local index = GetRaidTargetIndex(self.unit)
	if(index) then
		self.RIcon:SetText(ICON_LIST[index].."22|t")
	else
		self.RIcon:SetText()
	end
end

-- Raid Background
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
	
local function Framebg(self)
	bg:ClearAllPoints()
	bg:SetPoint("TOP", "Raid_Freebgrid", "TOP", 0, 8)
	bg:SetPoint("LEFT", "Raid_Freebgrid", "LEFT", -8 , 0)
	bg:SetPoint("RIGHT", "Raid_Freebgrid", "RIGHT", 8, 0)
	bg:SetPoint("BOTTOM", "Raid_Freebgrid", "BOTTOM", 0, -8)
	if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
		bg:Show()
	else
		bg:Hide()
	end
end

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local border = {
	bgFile = [=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local glowBorder = {
	  edgeFile = [=[Interface\AddOns\oUF_Freebgrid\media\glowTex.tga]=], edgeSize = 5,
	  insets = {left = 3, right = 3, top = 3, bottom = 3}
}

-- Show Target Border
local ChangedTarget = function(self)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:SetBackdropColor(.8, .8, .8, 1)
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

-- Show Focus Border
local FocusTarget = function(self)
	if UnitIsUnit('focus', self.unit) then
		self.FocusHighlight:SetBackdropColor(.6, .8, 0, 1)
		self.FocusHighlight:Show()
	else
		self.FocusHighlight:Hide()
	end
end

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

-- Upate Health, Name, and coloring
local updateHealth = function(self, event, unit, bar)
	local def = oUF.Tags["[missinghp]"](unit)
	local per = oUF.Tags["[perhp]"](unit)
	local name = oUF.Tags["[FGname]"](unit)

	if per > 90 or per == 0 then
		if nameCache[name] then 
			self.Info:SetText(nameCache[name]) 
		else 
			local substring 
			for length=#name, 1, -1 do 
				substring = utf8sub(name, 1, length) 
				self.Info:SetText(substring) 
				if self.Info:GetStringWidth() <= oUF_Freebgrid.db.width - 1 then break end 
			end
			nameCache[name] = substring
		end
	else
		self.Info:SetText('-'..numberize(def))
	end

	local r, g, b, t
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	else		
		r, g, b = .2, .9, .1
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	self.Info:SetTextColor(r, g, b)
	
	bar.bg:SetVertexColor(r, g, b)
	bar:SetStatusBarColor(0, 0, 0, .8)
end

-- Upate border with threat
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

-- Add healcomm stuff
local addHealcomm = function(self)
	local heal = self.Health:CreateFontString(nil, "OVERLAY")
	heal:SetPoint("BOTTOM")
	heal:SetJustifyH("CENTER")
	heal:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], oUF_Freebgrid.db.fontsize-2)
	heal:SetShadowOffset(1.25, -1.25)
	heal:SetTextColor(0,1,0,1)

	self.HealCommText = true and heal or nil
	self.HealCommTextFormat = numberize

	local healbar = CreateFrame('StatusBar', nil, self.Health)
	healbar:SetStatusBarTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
	healbar:SetStatusBarColor(0, 1, 0, 0.4)
	healbar:SetPoint('BOTTOM', self.Health, 'BOTTOM')

	self.HealCommBar = false and healbar or nil
	self.allowHealCommOverflow = true
end

-- Show Mouseover highlight
local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	self.Highlight:Show()	
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Highlight:Hide()	
end

local style = function(self, unit)
	self.menu = menu

	-- Backdrop
	self.BG = CreateFrame("Frame", nil, self)
	self.BG:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.BG:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.BG:SetFrameLevel(3)
	self.BG:SetBackdrop(backdrop)
	self.BG:SetBackdropColor(0, 0, 0)

	-- Mouseover script
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")

	-- Health bar
	local hp = CreateFrame"StatusBar"
	hp:SetStatusBarTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
	hp:SetOrientation("VERTICAL")
	hp:SetParent(self)
	hp:SetPoint"TOPLEFT"
	hp:SetPoint"BOTTOMRIGHT"
	hp.frequentUpdates = true
	
	-- HP background
	local hpbg = hp:CreateTexture(nil, "BORDER")
	hpbg:SetTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
	hpbg:SetAllPoints(hp)

	hp.bg = hpbg
	self.Health = hp
	self.OverrideUpdateHealth = updateHealth

	-- Threat
	local threat = CreateFrame("Frame", nil, self)
	threat:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
	threat:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
	threat:SetFrameStrata("LOW")
	threat:SetBackdrop(glowBorder)
	threat:SetBackdropColor(0, 0, 0, 0)
	threat:SetBackdropBorderColor(0, 0, 0, 1)
	self.Threat = threat
	self.OverrideUpdateThreat = updateThreat

	-- Healcomm
	addHealcomm(self)

	-- Range
	self.Range = true
	self.inRangeAlpha = oUF_Freebgrid.db.inRange
	self.outsideRangeAlpha = oUF_Freebgrid.db.outsideRange

	-- Name/Hp
	local info = hp:CreateFontString(nil, "OVERLAY")
	info:SetPoint("CENTER")
	info:SetJustifyH("CENTER")
	info:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], oUF_Freebgrid.db.fontsize)
	info:SetShadowOffset(1.25, -1.25)
	self.Info = info

	-- Dead/DC/Ghost text
	local DDG = hp:CreateFontString(nil, "OVERLAY")
	DDG:SetPoint("BOTTOM")
	DDG:SetJustifyH("CENTER")
	DDG:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], oUF_Freebgrid.db.fontsize-2)
	DDG:SetShadowOffset(1.25, -1.25)
	self:Tag(DDG, '[DDG]')

	-- Highliget tex
	local hl = hp:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(self)
	hl:SetTexture([=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=])
	hl:SetVertexColor(1,1,1,.1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl

	-- Target tex
	local tBorder = CreateFrame("Frame", nil, self)
	tBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	tBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	tBorder:SetBackdrop(border)
	tBorder:SetFrameLevel(2)
	tBorder:Hide()
	self.TargetBorder = tBorder
	
	-- Focus tex
	local fBorder = CreateFrame("Frame", nil, self)
	fBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	fBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	fBorder:SetBackdrop(border)
	fBorder:SetFrameLevel(2)
	fBorder:Hide()
	self.FocusHighlight = fBorder

	-- Raid Icons
	local ricon = hp:CreateFontString(nil, "OVERLAY")
	ricon:SetPoint("TOP", self, 0, 5)
	ricon:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], oUF_Freebgrid.db.iconsize)
	self.RIcon = ricon
	self:RegisterEvent("RAID_TARGET_UPDATE", updateRIcon)
	table.insert(self.__elements, updateRIcon)

	-- Leader Icon
	self.Leader = hp:CreateTexture(nil, "OVERLAY")
	self.Leader:SetPoint("TOPLEFT", self, 0, 8)
	self.Leader:SetHeight(oUF_Freebgrid.db.iconsize)
	self.Leader:SetWidth(oUF_Freebgrid.db.iconsize)
	
	-- Assistant Icon
	self.Assistant = hp:CreateTexture(nil, "OVERLAY")
	self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
	self.Assistant:SetHeight(oUF_Freebgrid.db.iconsize)
	self.Assistant:SetWidth(oUF_Freebgrid.db.iconsize)
	
	-- ReadyCheck
	self.ReadyCheck = hp:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetPoint("TOP", self)
	self.ReadyCheck:SetHeight(oUF_Freebgrid.db.iconsize)
	self.ReadyCheck:SetWidth(oUF_Freebgrid.db.iconsize)
	self.ReadyCheck.delayTime = 8
	self.ReadyCheck.fadeTime = 1
	
	-- Debuff
	local debuff = CreateFrame("StatusBar", nil, self)
	debuff:SetPoint("CENTER", hp)
	debuff:SetHeight(oUF_Freebgrid.db.debuffsize)
	debuff:SetWidth(oUF_Freebgrid.db.debuffsize)
	self.freebDebuffs = debuff
	
	-- Enable Indicators
	self.Indicators = true
	
	-- Add events
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', Framebg)
	self:RegisterEvent('PARTY_MEMBERS_CHANGED', Framebg)
		
	-- Unit sizes
	self:SetAttribute('initial-height', oUF_Freebgrid.db.height)
	self:SetAttribute('initial-width', oUF_Freebgrid.db.width)
end

local Spawn = function()
	oUF:RegisterStyle("Freebgrid", style)
	oUF:SetActiveStyle"Freebgrid"

	local raid = oUF:Spawn('header', 'Raid_Freebgrid', nil, 'party')
	raid:SetPoint("LEFT", UIParent, "LEFT", 8, 0)
	raid:SetManyAttributes(
		'showPlayer', true,
		'showSolo', true,
		'showParty', true,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -5,
		'point', 'TOP',
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', 'LEFT'
	)
	raid:SetScale(oUF_Freebgrid.db.scale)
	raid:Show()
end

oUF_Freebgrid = {}
local oUF_Freebgrid, f = oUF_Freebgrid, CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon ~= ADDON_NAME then return end
	
	FreebgridDB = FreebgridDB or {}
	oUF_Freebgrid.db = FreebgridDB
	
	for k, v in pairs(FreebgridDefaults) do
		if(type(FreebgridDB[k]) == 'nil') then
			FreebgridDB[k] = v
		end
	end
	
	Spawn()
	
	LibStub("tekKonfig-AboutPanel").new("oUF_Freebgrid", "oUF_Freebgrid")
	
	self:UnregisterEvent("ADDON_LOADED")
end)