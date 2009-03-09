local texture = "Interface\\AddOns\\oUF_Freebgrid\\media\\gradient"
local hightlight = "Interface\\AddOns\\oUF_Freebgrid\\media\\white"
local font = "Interface\\AddOns\\oUF_Freebgrid\\media\\ABF.ttf"
local fontsize = 12

local height, width = 35, 35

-- Vertical health?
local verticalhp = true
-- Debuff icon size
local iconsize = 20
-- Filter debuffs by your class?
local filterdebuff = true

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], tile = true, tileSize = 16,
	insets = {top = -2, left = -2, bottom = -2, right = -2},
}

local colors = {
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
setmetatable(colors.class, {
	__index = function(self, key)
		return { 0.78, 0.61, 0.43 }
	end
})

local GetClassColor = function(unit)
	return unpack(colors.class[select(2, UnitClass(unit))])
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
	  r,g,b = self.ColorGradient((min/max), .9,.1,.1, .8,.8,.1, 1,1,1)
	end

	bar.value:SetTextColor(r,g,b)

	local perc = floor(min/max*100)
	if(not UnitIsConnected(unit)) then
		bar:SetValue(0)
		bar.value:SetText('|cffD7BEA5'..'Off')
	elseif(UnitIsDead(unit)) then
		bar.value:SetText('|cffD7BEA5'..'Dead')
	elseif(UnitIsGhost(unit)) then
		bar.value:SetText('|cffD7BEA5'..'Ghost')
        elseif(perc > 90) then
		bar.value:SetText(UnitName(unit):sub(1, 3))
	else
		bar.value:SetFormattedText("-%0.1f",math.floor((max-min)/100)/10)
	end
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

	self:EnableMouse(true)

	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)

	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")
	-- Health
	local hp = CreateFrame"StatusBar"
	hp:SetHeight(height)
	hp:SetStatusBarTexture(texture)
	if(verticalhp)then
	  hp:SetOrientation("VERTICAL")
	end
	hp:SetStatusBarColor(0, 0, 0)
	hp:SetAlpha(0.8)
	hp.frequentUpdates = true

	hp:SetParent(self)
	hp:SetPoint"TOPLEFT"
	hp:SetPoint"BOTTOMRIGHT"

	local hpbg = hp:CreateTexture(nil, "BORDER")
	hpbg:SetAllPoints(hp)
	hpbg:SetTexture(texture)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, .8)

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

	-- Hightlight
	local hl = hp:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(self)
	hl:SetTexture(hightlight)
	hl:SetVertexColor(1,1,1,.2)
	hl:SetBlendMode("ADD")
	hl:Hide()

	self.Highlight = hl

	-- DebuffHidghtlight
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightAlpha = .5

	if(filterdebuff)then
	  self.DebuffHighlightFilter = true
	end

	if(not unit) then
		self.Range = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .4
	end

	self:SetAttribute('initial-height', height)
	self:SetAttribute('initial-width', width)

	return self
end

oUF:RegisterStyle("Freebgrid", func)

oUF:SetActiveStyle"Freebgrid"

local raid = {}
for i = 1, 5 do
	local group = oUF:Spawn('header', 'oUF_Group'..i)
	group:SetManyAttributes('groupFilter', tostring(i), 'showRaid', true, 'yOffset', -4)
	table.insert(raid, group)
	if(i == 1) then
		group:SetManyAttributes('showParty', true, 'showPlayer', true)
		group:SetPoint('TOPLEFT', UIParent, 5, -550)
	else
		group:SetPoint('TOPLEFT', raid[i-1], 'TOPRIGHT', 4, 0)
	end
	group:Show()
end



