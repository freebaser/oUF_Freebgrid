local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
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

local colors = setmetatable({
	power = setmetatable({
		['MANA'] = {.31,.45,.63},
		['RAGE'] = {.69,.31,.31},
		['FOCUS'] = {.71,.43,.27},
		['ENERGY'] = {.65,.63,.35},
		['RUNIC_POWER'] = {0,.8,.9},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

-- Unit Menu
local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)

	if(cunit == 'Vehicle') then
		cunit = 'Pet'
	end

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	else
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, "cursor")
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
--[[
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
	if not oUF_Freebgrid.db.framebg then return end

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
end ]]--

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

local updateThreat = function(self, event, unit)
	if(unit ~= self.unit) then return end
	local threat = self.Threat

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 1) then
		local r, g, b = GetThreatStatusColor(status)
		threat:SetBackdropBorderColor(r, g, b, 1)
	else
		threat:SetBackdropBorderColor(0, 0, 0, 1)
	end
	threat:Show()
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
local updateHealth = function(health, unit)
	local def = oUF.Tags['missinghp'](unit)
	local per = oUF.Tags['perhp'](unit)
	local name = oUF.Tags['freebgrid:name'](unit)
	local self = health:GetParent()
    local val = 1
    if oUF_Freebgrid.db.powerbar then
        val = 8
    end

	if per > 90 or per == 0 or oUF_Freebgrid.db.showname then
		if nameCache[name] then 
			self.Info:SetText(nameCache[name]) 
		else 
			local substring 
			for length=#name, 1, -1 do 
				substring = utf8sub(name, 1, length) 
				self.Info:SetText(substring) 
				if self.Info:GetStringWidth() <= oUF_Freebgrid.db.width - val then break end 
			end
			nameCache[name] = substring
		end
	else
		self.Info:SetText('-'..numberize(def))
	end

	local r, g, b, t
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = oUF.colors.class[class]
	else		
		r, g, b = .2, .9, .1
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	self.Info:SetTextColor(r, g, b)
	
    if oUF_Freebgrid.db.reversecolors then
        health.bg:SetVertexColor(r*.2, g*.2, b*.2)
        health:SetStatusBarColor(r, g, b)
    else
        health.bg:SetVertexColor(r, g, b)
        health:SetStatusBarColor(0, 0, 0, .8)
    end
end

local updatePower = function(power, unit)
	local _, ptype = UnitPowerType(unit)
	local self = power:GetParent()

	if ptype == 'MANA' then
		if(oUF_Freebgrid.db.orientation == "VERTICAL")then
			power:SetPoint"TOP"
			power:SetWidth(oUF_Freebgrid.db.width*oUF_Freebgrid.db.powerbarsize)
			self.Health:SetWidth((0.98 - oUF_Freebgrid.db.powerbarsize)*oUF_Freebgrid.db.width)
		else
			power:SetPoint"LEFT"
			power:SetHeight(oUF_Freebgrid.db.height*oUF_Freebgrid.db.powerbarsize)
			self.Health:SetHeight((0.98 - oUF_Freebgrid.db.powerbarsize)*oUF_Freebgrid.db.height)
		end
	else
		if(oUF_Freebgrid.db.orientation == "VERTICAL")then
			power:SetPoint"TOP"
			power:SetWidth(0.0000001) -- in this case absolute zero is something, rather than nothing
			self.Health:SetWidth(oUF_Freebgrid.db.width)
		else
			power:SetPoint"LEFT"
			power:SetHeight(0.0000001) -- ^ ditto
			self.Health:SetHeight(oUF_Freebgrid.db.height)
		end
	end
	
	local r, g, b, t
	t = colors.power[ptype]
	r, g, b = 1, 1, 1
	if(t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	if oUF_Freebgrid.db.reversecolors then
        power.bg:SetVertexColor(r*.2, g*.2, b*.2)
        power:SetStatusBarColor(r, g, b)
    else
        power.bg:SetVertexColor(r, g, b)
        power:SetStatusBarColor(0, 0, 0, .8)
    end
	
	local perc = oUF.Tags['perpp'](unit)
	-- This kinda conflicts with the threat module, but I don't really care
	if (perc < 10 and UnitIsConnected(unit) and ptype == 'MANA' and not UnitIsDeadOrGhost(unit)) then
		self.Threat:SetBackdropBorderColor(0, 0, 1, 1)
	else
		-- pass the coloring back to the threat func
		return updateThreat(self, nil, unit)
	end
end

local fixStatusbar = function(bar)
	bar:GetStatusBarTexture():SetHorizTile(false)
end

local powerbar = function(self)
    local pp = CreateFrame"StatusBar"
    pp:SetStatusBarTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
	fixStatusbar(pp)
    pp:SetOrientation(oUF_Freebgrid.db.orientation)
    pp.frequentUpdates = true

    pp:SetParent(self)
    pp:SetPoint"BOTTOM"
    pp:SetPoint"RIGHT"
    
    local ppbg = pp:CreateTexture(nil, "BORDER")
    ppbg:SetAllPoints(pp)
    ppbg:SetTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
    pp.bg = ppbg
	pp.PostUpdate = updatePower

    self.Power = pp
end

-- Add healcomm stuff
local addHealcomm = function(self)
	local heal = self.Health:CreateFontString(nil, "OVERLAY")
	heal:SetPoint("BOTTOM")
	heal:SetJustifyH("CENTER")
	heal:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], oUF_Freebgrid.db.fontsize-2)
	heal:SetShadowOffset(1.25, -1.25)
	heal:SetTextColor(0,1,0,1)

	self.HealCommText = oUF_Freebgrid.db.healcommtext and heal or nil
	self.HealCommTextFormat = numberize

	local healbar = CreateFrame('StatusBar', nil, self.Health)
	healbar:SetStatusBarTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
	fixStatusbar(healbar)
	healbar:SetStatusBarColor(0, 1, 0, oUF_Freebgrid.db.healalpha)
	if oUF_Freebgrid.db.orientation == "VERTICAL" then
		healbar:SetPoint('BOTTOM', self.Health, 'BOTTOM')
	else
		healbar:SetPoint('LEFT', self.Health, 'LEFT')
	end

	self.HealCommBar = oUF_Freebgrid.db.healcommbar and healbar or nil
	self.allowHealCommOverflow = oUF_Freebgrid.db.healcommoverflow
	self.HealCommOthersOnly = oUF_Freebgrid.db.healothersonly
end

local PostCreateIcon = function(debuffs, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetPoint("LEFT", debuffs, "BOTTOM", 3, 2)
	
	button.icon:SetTexCoord(.07, .93, .07, .93)
	
	debuffs.showDebuffType = true
	
	button.overlay:SetTexture("Interface\\AddOns\\oUF_Freebgrid\\media\\border")
	button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
	button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
	button.overlay:SetTexCoord(0, 1, 0.02, 1)
	
	button:EnableMouse(false)
end

local _, class = UnitClass("player")
local dispellClass = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Poison = true, Disease = true, Curse = true, },
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Curse = true, Poison = true, },
}
local dispellist = dispellClass[class] or {}
local dispellPriority = {
	Magic = 4,
	Poison = 3,
	Curse = 2,
	Disease = 1,
}

local debuffs = FreebgridDebuffs.debuffs
local CustomFilter = function(icons, ...)
	local _, icon, name, _, _, _, dtype = ...
	
	if debuffs[name] and debuffs[name] > 0 then
		icon.priority = debuffs[name]
	elseif dispellist[dtype] then
		icon.priority = dispellPriority[dtype]
	else
		icon.priority = 0
	end
	
	return true
end

local sort = function(a,b)
	return a.priority > b.priority
end

local PreSetPosition = function(icons, max)
	table.sort(icons, sort)
	
	if icons.visibleDebuffs and icons.visibleDebuffs > 1 then
		for i = 2, icons.visibleDebuffs do
			icons[i]:Hide()
		end
	end
end

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	if icon.priority == 0 then
		icon:Hide()
	end
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

local style = function(self)
	self.menu = menu
	self.colors = colors

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
	fixStatusbar(hp)
	hp:SetOrientation(oUF_Freebgrid.db.orientation)
	hp:SetParent(self)
	hp:SetPoint"TOP"
	hp:SetPoint"LEFT"
	if oUF_Freebgrid.db.orientation == "VERTICAL" then
		hp:SetPoint"BOTTOM"
	else
		hp:SetPoint"RIGHT"
	end
	hp.frequentUpdates = true
	
	-- HP background
	local hpbg = hp:CreateTexture(nil, "BORDER")
	hpbg:SetTexture(oUF_Freebgrid.textures[oUF_Freebgrid.db.texture])
	hpbg:SetAllPoints(hp)

	hp.bg = hpbg
	hp.PostUpdate = updateHealth
	self.Health = hp
    
	if oUF_Freebgrid.db.powerbar then
		powerbar(self)
	end

	-- Threat
	local threat = CreateFrame("Frame", nil, self)
	threat:SetPoint("TOPLEFT", self, "TOPLEFT", -4, 4)
	threat:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 4, -4)
	threat:SetFrameStrata("LOW")
	threat:SetBackdrop(glowBorder)
	threat:SetBackdropColor(0, 0, 0, 0)
	threat:SetBackdropBorderColor(0, 0, 0, 1)
	threat.Update = updateThreat
	self.Threat = threat

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
	self:Tag(DDG, '[freebgrid:ddg]')

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
	
	-- LFD Icon
	if oUF_Freebgrid.db.lfdicon then
		self.LFDRole = hp:CreateTexture(nil, 'OVERLAY')
		self.LFDRole:SetSize(oUF_Freebgrid.db.iconsize, oUF_Freebgrid.db.iconsize)
		self.LFDRole:SetPoint('RIGHT', self, 'LEFT', oUF_Freebgrid.db.iconsize/2, oUF_Freebgrid.db.iconsize/2)
	end
    
    -- ResComm
	if oUF_Freebgrid.db.rescomm then
		local rescomm = CreateFrame("StatusBar", nil, hp)
		rescomm:SetStatusBarTexture([=[Interface\Icons\Spell_Holy_Resurrection]=])
		fixStatusbar(rescomm)
		rescomm:SetAllPoints(hp)
		rescomm:SetAlpha(oUF_Freebgrid.db.rescommalpha)
		self.ResComm = rescomm
	end
	
	if (self:GetAttribute('unitsuffix') == 'target') then
	else
		-- Enable Indicators
		self.Indicators = true
        
		-- Range
		self.Range = {
			insideAlpha = oUF_Freebgrid.db.inRange,
			outsideAlpha = oUF_Freebgrid.db.outsideRange,
		}
        
		-- Healcomm
		addHealcomm(self)
		
		-- ReadyCheck
		self.ReadyCheck = hp:CreateTexture(nil, "OVERLAY")
		self.ReadyCheck:SetPoint("TOP", self)
		self.ReadyCheck:SetHeight(oUF_Freebgrid.db.iconsize)
		self.ReadyCheck:SetWidth(oUF_Freebgrid.db.iconsize)
		self.ReadyCheck.delayTime = 8
		self.ReadyCheck.fadeTime = 1
		
		-- Debuffs
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetSize(oUF_Freebgrid.db.debuffsize, oUF_Freebgrid.db.debuffsize)
		debuffs:SetPoint("CENTER", hp)
		debuffs.size = oUF_Freebgrid.db.debuffsize
		debuffs.num = 20
		
		debuffs.PostCreateIcon = PostCreateIcon
		debuffs.PreSetPosition = PreSetPosition
		debuffs.CustomFilter = CustomFilter
		debuffs.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = debuffs
	end
	
	-- Add events
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)
	--self:RegisterEvent('RAID_ROSTER_UPDATE', Framebg)
	--self:RegisterEvent('PARTY_MEMBERS_CHANGED', Framebg)
		
	-- Unit sizes
	self:SetAttribute('initial-height', oUF_Freebgrid.db.height)
	self:SetAttribute('initial-width', oUF_Freebgrid.db.width)
end

local function SAP()
	if not oUF_Freebgrid then return end
	
	local spacingX, spacingY, growth
	local db = oUF_Freebgrid.db
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
	
	return spacingX, spacingY, growth
end

oUF:RegisterStyle("Freebgrid", style)
	
oUF:Factory(function(self)
	self:SetActiveStyle"Freebgrid"
	
	local visible
	if oUF_Freebgrid.db.solo and oUF_Freebgrid.db.partyOn then
		visible = 'raid,party,solo'
	elseif oUF_Freebgrid.db.solo and not oUF_Freebgrid.db.partyOn then
		visible = 'raid,solo'
	elseif oUF_Freebgrid.db.partyOn and not oUF_Freebgrid.db.solo then
		visible = 'raid,party'
	else
		visible = 'raid'
	end
	
	local spacingX, spacingY, growth = SAP()
	local setpoint = oUF_Freebgrid.setpoint.raid.position
	local raid = self:SpawnHeader('Raid_Freebgrid', nil, visible,
		'showPlayer', oUF_Freebgrid.db.player,
		'showSolo', true,
		'showParty', oUF_Freebgrid.db.partyOn,
		'showRaid', true,
		'xoffset', spacingX, 
		'yOffset', spacingY,
		'point', oUF_Freebgrid.db.point,
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', oUF_Freebgrid.db.numCol,
		'unitsPerColumn', oUF_Freebgrid.db.numUnits,
		'columnSpacing', oUF_Freebgrid.db.spacing,
		'columnAnchorPoint', growth
	)
	raid:SetPoint(setpoint[1], setpoint[2], setpoint[3], setpoint[4], setpoint[5])
	raid:SetScale(oUF_Freebgrid.db.scale)
	
	setpoint = oUF_Freebgrid.setpoint.pet.position
	if oUF_Freebgrid.db.pets then
		local pets = self:SpawnHeader('Pet_Freebgrid', 'SecureGroupPetHeaderTemplate', visible,
			'showSolo', true,
			'showParty', oUF_Freebgrid.db.partyOn,
			'showRaid', true,
			'xoffset', spacingX,
			'yOffset', spacingY,
			'point', oUF_Freebgrid.db.point,
			'maxColumns', oUF_Freebgrid.db.numCol,
			'unitsPerColumn', oUF_Freebgrid.db.numUnits,
			'columnSpacing', oUF_Freebgrid.db.spacing,
			'columnAnchorPoint', growth
		)
		pets:SetPoint(setpoint[1], setpoint[2], setpoint[3], setpoint[4], setpoint[5])
		pets:SetScale(oUF_Freebgrid.db.scale)
	end
	
	setpoint = oUF_Freebgrid.setpoint.mt.position
	if oUF_Freebgrid.db.MT then
		local tank = self:SpawnHeader('MT_Freebgrid', nil, visible,
			"showRaid", true,
			"yOffset", -oUF_Freebgrid.db.spacing
		)
		tank:SetPoint(setpoint[1], setpoint[2], setpoint[3], setpoint[4], setpoint[5])
		if oUF_Freebgrid.db.MTT then
			tank:SetAttribute("template", "oUF_FreebMtargets")
		end
	
		if oRA3 then
			tank:SetAttribute("initial-unitWatch", true)
			tank:SetAttribute("nameList", table.concat(oRA3:GetSortedTanks(), ","))

			local tankhandler = {}
			function tankhandler:OnTanksUpdated(event, tanks) 
				tank:SetAttribute("nameList", table.concat(tanks, ","))
			end
			oRA3.RegisterCallback(tankhandler, "OnTanksUpdated")
		
		else
			tank:SetAttribute('groupFilter', 'MAINTANK')
		end
		tank:SetScale(oUF_Freebgrid.db.scale)
	end
end)

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
	
	LibStub("tekKonfig-AboutPanel").new("oUF_Freebgrid", "oUF_Freebgrid")
	
	self:UnregisterEvent("ADDON_LOADED")
end)

SLASH_OUF_FREEBGRIDOMF1 = '/freeb'
SlashCmdList['OUF_FREEBGRIDOMF'] = function(inp)
	if(inp:match("%S+")) then
		InterfaceOptionsFrame_OpenToCategory'oUF_Freebgrid'
	else
		OUF_FREEBGRIDMOVABLE()
	end
end
