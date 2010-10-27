local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local scaleRaid, raid = false
do
    local updateRaid = CreateFrame"Frame"
    updateRaid:RegisterEvent("RAID_ROSTER_UPDATE")
    updateRaid:RegisterEvent("PLAYER_ENTERING_WORLD")
    updateRaid:SetScript("OnEvent", function(self)
        if scaleRaid == false or oUF_Freebgrid.db.multi then return end
        if(InCombatLockdown()) then
            self:RegisterEvent('PLAYER_REGEN_ENABLED')
        else
            self:UnregisterEvent('PLAYER_REGEN_ENABLED')
            if GetNumRaidMembers() > 29 then
                raid:SetScale(oUF_Freebgrid.db.scale-0.4)
            elseif GetNumRaidMembers() > 20 then
                raid:SetScale(oUF_Freebgrid.db.scale-0.2)
            else
                raid:SetScale(oUF_Freebgrid.db.scale)
            end
        end
    end)
end

if true then
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager:Hide()
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer:Hide()
end

oUF.colors.power['MANA'] = {.31,.45,.63}
oUF.colors.power['RAGE'] = {.69,.31,.31}

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

local updateHealth = function(health, unit)
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

    if(b) then
        local bg = health.bg
        bg:SetVertexColor(r, g, b)
        health:SetStatusBarColor(0, 0, 0, .8)
    end
end

local updatePower = function(power, unit)
    local _, ptype = UnitPowerType(unit)
    local self = power.__owner

    if ptype == 'MANA' then
        if(ns.db.orientation == "VERTICAL")then
            power:SetPoint"TOP"
            power:SetWidth(ns.db.width*ns.db.powerbarsize)
            self.Health:SetWidth((0.98 - ns.db.powerbarsize)*ns.db.width)
        else
            power:SetPoint"LEFT"
            power:SetHeight(ns.db.height*ns.db.powerbarsize)
            self.Health:SetHeight((0.98 - ns.db.powerbarsize)*ns.db.height)
        end
    else
        if(ns.db.orientation == "VERTICAL")then
            power:SetPoint"TOP"
            power:SetWidth(0.0000001) -- in this case absolute zero is something, rather than nothing
            self.Health:SetWidth(ns.db.width)
        else
            power:SetPoint"LEFT"
            power:SetHeight(0.0000001) -- ^ ditto
            self.Health:SetHeight(ns.db.height)
        end
    end

    local r, g, b, t
    t = oUF.colors.power[ptype]
    r, g, b = 1, 1, 1
    if(t) then
        r, g, b = t[1], t[2], t[3]
    end

    if(b) then
        local bg = power.bg
        if ns.db.reversecolors then
            bg:SetVertexColor(r*.2, g*.2, b*.2)
            power:SetStatusBarColor(r, g, b)
        else
            bg:SetVertexColor(r, g, b)
            power:SetStatusBarColor(0, 0, 0, .8)
        end
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
    bar:GetStatusBarTexture():SetVertTile(false)
end

local powerbar = function(self)
    local pp = CreateFrame"StatusBar"
    pp:SetStatusBarTexture(ns.textures[ns.db.texture])
    fixStatusbar(pp)
    pp:SetOrientation(ns.db.orientation)
    pp.frequentUpdates = true

    pp:SetParent(self)
    pp:SetPoint"BOTTOM"
    pp:SetPoint"RIGHT"

    local ppbg = pp:CreateTexture(nil, "BORDER")
    ppbg:SetAllPoints(pp)
    ppbg:SetTexture(ns.textures[ns.db.texture])
    pp.bg = ppbg
    pp.PostUpdate = updatePower

    self.Power = pp
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

local instDebuffs = {}
local instances = ns.auras.instances
local getzone = function()
    local zone = GetInstanceInfo()
    if instances[zone] then
        instDebuffs = instances[zone]
    else
        instDebuffs = {}
    end
end

local debuffs, buffs = ns.auras.debuffs, ns.auras.buffs 
local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, dtype = ...

    if instDebuffs[name] then
        icon.priority = instDebuffs[name]
        return true
    elseif debuffs[name] then
        icon.priority = debuffs[name]
        return true
    elseif buffs[name] then
        icon.priority = buffs[name]
        icon.buff = true
        return true
    elseif dispellist[dtype] then
        icon.priority = dispellPriority[dtype]
        icon.buff = false
        return true
    else
        icon.priority = 0
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
    self:RegisterForClicks"AnyDown"
    self:SetAttribute("*type2", "menu")

    -- Health bar
    local hp = CreateFrame"StatusBar"
    hp:SetStatusBarTexture(ns.textures[ns.db.texture])
    fixStatusbar(hp)
    hp:SetOrientation(ns.db.orientation)
    hp:SetParent(self)
    hp:SetPoint"TOP"
    hp:SetPoint"LEFT"
    if ns.db.orientation == "VERTICAL" then
        hp:SetPoint"BOTTOM"
    else
        hp:SetPoint"RIGHT"
    end
    hp.frequentUpdates = true

    -- HP background
    local hpbg = hp:CreateTexture(nil, "BORDER")
    hpbg:SetTexture(ns.textures[ns.db.texture])
    hpbg:SetAllPoints(hp)

    if ns.db.reversecolors then
        hp.colorClass =  true
        hp.colorReaction = true
        hpbg.multiplier = .3
    else
        hp.PostUpdate = updateHealth
    end

    hp.bg = hpbg 
    self.Health = hp

    if ns.db.powerbar then
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
    threat.Override = updateThreat
    self.Threat = threat 

    -- Highlight tex
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
    local ricon = hp:CreateTexture(nil, 'OVERLAY')
    ricon:SetPoint("TOP", self, 0, 5)
    ricon:SetSize(ns.db.iconsize, ns.db.iconsize)
    self.RaidIcon = ricon

    -- Leader Icon
    self.Leader = hp:CreateTexture(nil, "OVERLAY")
    self.Leader:SetPoint("TOPLEFT", self, 0, 8)
    self.Leader:SetSize(ns.db.iconsize, ns.db.iconsize)

    -- Assistant Icon
    self.Assistant = hp:CreateTexture(nil, "OVERLAY")
    self.Assistant:SetPoint("TOPLEFT", self, 0, 8)
    self.Assistant:SetSize(ns.db.iconsize, ns.db.iconsize)

    local masterlooter = hp:CreateTexture(nil, 'OVERLAY')
    masterlooter:SetSize(ns.db.iconsize, ns.db.iconsize)
    masterlooter:SetPoint('LEFT', self.Leader, 'RIGHT')
    self.MasterLooter = masterlooter

    -- LFD Icon
    if ns.db.lfdicon then
        self.LFDRole = hp:CreateTexture(nil, 'OVERLAY')
        self.LFDRole:SetSize(ns.db.iconsize, ns.db.iconsize)
        self.LFDRole:SetPoint('RIGHT', self, 'LEFT', ns.db.iconsize/2, ns.db.iconsize/2)
    end

    self.Info = true

    -- Enable Indicators
    self.Indicators = true

    self.freebHeals = true 

    -- Range
    self.freebRange = {
        insideAlpha = ns.db.inRange,
        outsideAlpha = ns.db.outsideRange,
    }

    -- ReadyCheck
    self.ReadyCheck = hp:CreateTexture(nil, "OVERLAY")
    self.ReadyCheck:SetPoint("TOP", self)
    self.ReadyCheck:SetSize(ns.db.iconsize, ns.db.iconsize)

    -- Auras
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(ns.db.debuffsize, ns.db.debuffsize)
    auras:SetPoint("CENTER", hp)
    auras.size = ns.db.debuffsize
    auras.CustomFilter = CustomFilter
    self.freebAuras = auras

    -- Add events
    self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
    self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)
    self:RegisterEvent('PLAYER_ENTERING_WORLD', getzone)
end

local function SAP()
    if not ns then return end

    local pos, posRel, spacingX, spacingY, colX, colY, growth, point
    local db = ns.db
    -- SetPoint of MOTHERFUCKING DOOM!
    if db.point == "TOP" and db.growth == "LEFT" then
        pos = "TOPRIGHT"
        posRel = "TOPLEFT"
        growth = "RIGHT"
        spacingX = 0
        spacingY = -(db.spacing)
        colX = -(db.spacing)
        colY = 0
        point = "TOPRIGHT"
    elseif db.point == "TOP" and db.growth == "RIGHT" then
        pos = "TOPLEFT"
        posRel = "TOPRIGHT"
        growth = "LEFT"
        spacingX = 0
        spacingY = -(db.spacing)
        colX = db.spacing
        colY = 0
        point = "TOPLEFT"
    elseif db.point == "LEFT" and db.growth == "UP" then
        pos = "BOTTOMLEFT"
        posRel = "TOPLEFT"
        growth = "BOTTOM"
        spacingX = db.spacing
        spacingY = 0
        colX = 0
        colY = db.spacing
        point = "BOTTOMLEFT"
    elseif db.point == "LEFT" and db.growth == "DOWN" then
        pos = "TOPLEFT"
        posRel = "BOTTOMLEFT"
        growth = "TOP"
        spacingX = db.spacing
        spacingY = 0
        colX = 0
        colY = -(db.spacing)
        point = "TOPLEFT"
    elseif db.point == "RIGHT" and db.growth == "UP" then
        pos = "BOTTOMRIGHT"
        posRel = "TOPRIGHT"
        growth = "BOTTOM"
        spacingX = -(db.spacing)
        spacingY = 0
        colX = 0
        colY = db.spacing
        point = "BOTTOMRIGHT"
    elseif db.point == "RIGHT" and db.growth == "DOWN" then
        pos = "TOPRIGHT"
        posRel = "BOTTOMRIGHT"
        growth = "TOP"
        spacingX = -(db.spacing)
        spacingY = 0
        colX = 0
        colY = -(db.spacing)
        point = "TOPRIGHT"
    elseif db.point == "BOTTOM" and db.growth == "LEFT" then
        pos = "BOTTOMRIGHT"
        posRel = "BOTTOMLEFT"
        growth = "RIGHT"
        spacingX = 0
        spacingY = (db.spacing)
        colX = -(db.spacing)
        colY = 0
        point = "BOTTOMRIGHT"
    elseif db.point == "BOTTOM" and db.growth == "RIGHT" then
        pos = "BOTTOMLEFT"
        posRel = "BOTTOMRIGHT"
        growth = "LEFT"
        spacingX = 0
        spacingY = (db.spacing)
        colX = (db.spacing)
        colY = 0
        point = "BOTTOMLEFT"
    else -- You failed to equal any of the above. So I give this...
        pos = "TOPLEFT"
        posRel = "TOPRIGHT"
        growth = "LEFT"
        spacingX = 0
        spacingY = -(db.spacing)
        colX = db.spacing
        colY = 0
        point = "TOPLEFT"
    end

    return pos, posRel, spacingX, spacingY, colX, colY, growth, point
end

oUF:RegisterStyle("Freebgrid", style)

oUF:Factory(function(self)
    self:SetActiveStyle"Freebgrid"

    ns.Enable()

    local visible
    if ns.db.solo and ns.db.partyOn then
        visible = 'raid,party,solo'
    elseif ns.db.solo and not ns.db.partyOn then
        visible = 'raid,solo'
    elseif ns.db.partyOn and not ns.db.solo then
        visible = 'raid,party'
    else
        visible = 'raid'
    end

    local pos, posRel, spacingX, spacingY, colX, colY, growth, point = SAP()

    if ns.db.multi then
        raid = {}
        for i = 1, ns.db.numCol do 
            local group = self:SpawnHeader('Raid_Freebgrid'..i, nil, visible,
            'oUF-initialConfigFunction', ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            ]]):format(ns.db.width, ns.db.height),
            'showPlayer', ns.db.player,
            'showSolo', true,
            'showParty', ns.db.partyOn,
            'showRaid', true,
            'xoffset', spacingX, 
            'yOffset', spacingY,
            'point', ns.db.point,
            'groupFilter', tostring(i),
            'groupingOrder', '1,2,3,4,5,6,7,8',
            'groupBy', 'GROUP',
            'maxColumns', ns.db.numCol,
            'unitsPerColumn', ns.db.numUnits,
            'columnSpacing', ns.db.spacing,
            'columnAnchorPoint', growth
            )
            if i == 1 then
                group:SetPoint(point, "oUF_FreebgridRaidFrame", point)
            else
                group:SetPoint(pos, raid[i-1], posRel, colX, colY)
            end
            group:SetScale(ns.db.scale)
            raid[i] = group
        end
    else
        raid = self:SpawnHeader('Raid_Freebgrid', nil, visible,
        'oUF-initialConfigFunction', ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        ]]):format(ns.db.width, ns.db.height),
        'showPlayer', ns.db.player,
        'showSolo', true,
        'showParty', ns.db.partyOn,
        'showRaid', true,
        'xoffset', spacingX, 
        'yOffset', spacingY,
        'point', ns.db.point,
        'groupFilter', '1,2,3,4,5,6,7,8',
        'groupingOrder', '1,2,3,4,5,6,7,8',
        'groupBy', 'GROUP',
        'maxColumns', ns.db.numCol,
        'unitsPerColumn', ns.db.numUnits,
        'columnSpacing', ns.db.spacing,
        'columnAnchorPoint', growth
        )
        raid:SetPoint(point, "oUF_FreebgridRaidFrame", point)
        raid:SetScale(ns.db.scale)
    end

    if ns.db.pets then
        local pets = self:SpawnHeader('Pet_Freebgrid', 'SecureGroupPetHeaderTemplate', visible,
        'oUF-initialConfigFunction', ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        ]]):format(ns.db.width, ns.db.height),
        'showSolo', true,
        'showParty', ns.db.partyOn,
        'showRaid', true,
        'xoffset', spacingX,
        'yOffset', spacingY,
        'point', ns.db.point,
        'maxColumns', ns.db.numCol,
        'unitsPerColumn', ns.db.numUnits,
        'columnSpacing', ns.db.spacing,
        'columnAnchorPoint', growth
        )
        pets:SetPoint(point, "oUF_FreebgridPetFrame", point)
        pets:SetScale(ns.db.scale)
    end

    if ns.db.MT then
        local tank = self:SpawnHeader('MT_Freebgrid', nil, visible,
        'oUF-initialConfigFunction', ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
        ]]):format(ns.db.width, ns.db.height),
        "showRaid", true,
        "yOffset", -ns.db.spacing
        )
        tank:SetPoint(point, "oUF_FreebgridMTFrame", point)

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
        tank:SetScale(ns.db.scale)
    end
end)


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if addon ~= ADDON_NAME then return end

    FreebgridDB = FreebgridDB or {}
    ns.db = FreebgridDB

    for k, v in pairs(ns.defaults) do
        if(type(FreebgridDB[k]) == 'nil') then
            FreebgridDB[k] = v
        end
    end

    LibStub("tekKonfig-AboutPanel").new(ADDON_NAME, ADDON_NAME)

    self:UnregisterEvent("ADDON_LOADED")
end)

SLASH_OUF_FREEBGRIDOMF1 = '/freeb'
SlashCmdList['OUF_FREEBGRIDOMF'] = function(inp)
    if(inp:match("%S+")) then
        InterfaceOptionsFrame_OpenToCategory(ADDON_NAME)
    else
        ns.Movable()
    end
end
