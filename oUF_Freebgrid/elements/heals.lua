local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local numberize = ns.numberize
local colorCache = ns.colorCache

oUF.Tags['freebgrid:def'] = function(u)
    if UnitIsAFK(u) then
        return CHAT_FLAG_AFK
    elseif UnitIsDead(u) then
        return "|cffCFCFCFDead|r"
    elseif UnitIsGhost(u) then
        return "|cffCFCFCFGhost|r"
    elseif not UnitIsConnected(u) then
        return "|cffCFCFCFD/C|r"
    end

    if not ns.db.deficit then return end
    local max = UnitHealthMax(u)
    if max ~= 0 then
        local cur = UnitHealth(u)
        local per = cur/max
        if per < 0.9 then
            local _, class = UnitClass(u)
            local color = colorCache[class]
            if color then
                return color.."-"..numberize(max-cur).."|r"
            end
        end
    end
end
oUF.TagEvents['freebgrid:def'] = 'UNIT_MAXHEALTH UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'

oUF.Tags['freebgrid:heals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags['freebgrid:def'](u)
        return def
    end
end
oUF.TagEvents['freebgrid:heals'] = 'UNIT_HEAL_PREDICTION UNIT_MAXHEALTH UNIT_HEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'

oUF.Tags['freebgrid:othersheals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    local player = UnitGetIncomingHeals(u, "player") or 0

    incheal = incheal - player

    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags['freebgrid:def'](u)
        return def
    end
end
oUF.TagEvents['freebgrid:othersheals'] = oUF.TagEvents['freebgrid:heals']

local Update = function(self, event, unit)
    if self.unit ~= unit then return end

    local overflow = ns.db.healoverflow and 1.20 or 1
    local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

    local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

    if ( health + allIncomingHeal > maxHealth * overflow ) then
        allIncomingHeal = maxHealth * overflow - health
    end

    if ( allIncomingHeal < myIncomingHeal ) then
        myIncomingHeal = allIncomingHeal
        allIncomingHeal = 0
    else
        allIncomingHeal = allIncomingHeal - myIncomingHeal
    end

    if not ns.db.healothersonly then
        self.myHealPredictionBar:SetMinMaxValues(0, maxHealth)
        self.myHealPredictionBar:SetValue(myIncomingHeal)
        self.myHealPredictionBar:Show()
    end

    self.otherHealPredictionBar:SetMinMaxValues(0, maxHealth)
    self.otherHealPredictionBar:SetValue(allIncomingHeal)
    self.otherHealPredictionBar:Show()
end

local Enable = function(self)
    if self.freebHeals then
        if ns.db.healbar then
            self.myHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
            if ns.db.orientation == "VERTICAL" then
                self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
                self.myHealPredictionBar:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.myHealPredictionBar:SetHeight(ns.db.height)
                self.myHealPredictionBar:SetOrientation"VERTICAL"
            else
                self.myHealPredictionBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
                self.myHealPredictionBar:SetWidth(ns.db.width)
            end
            self.myHealPredictionBar:SetStatusBarTexture("", "BORDER", -1)
            self.myHealPredictionBar:GetStatusBarTexture():SetTexture(0, 1, 0.5, ns.db.healalpha)
            self.myHealPredictionBar:Hide()

            self.otherHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
            if ns.db.orientation == "VERTICAL" then
                self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
                self.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.otherHealPredictionBar:SetHeight(ns.db.height)
                self.otherHealPredictionBar:SetOrientation"VERTICAL"
            else
                self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
                self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
                self.otherHealPredictionBar:SetWidth(ns.db.width)
            end
            self.otherHealPredictionBar:SetStatusBarTexture("", "BORDER", -1)
            self.otherHealPredictionBar:GetStatusBarTexture():SetTexture(0, 1, 0, ns.db.healalpha)
            self.otherHealPredictionBar:Hide() 

            self:RegisterEvent('UNIT_HEAL_PREDICTION', Update)
            self:RegisterEvent('UNIT_MAXHEALTH', Update)
            self:RegisterEvent('UNIT_HEALTH', Update)
        end

        local healtext = self.Health:CreateFontString(nil, "OVERLAY")
        healtext:SetPoint("BOTTOM")
        healtext:SetShadowOffset(1.25, -1.25)
        healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
        healtext:SetWidth(ns.db.width)
        self.Healtext = healtext

        if ns.db.healtext then
            if ns.db.healothersonly then
                self:Tag(healtext, "[freebgrid:othersheals]")
            else
                self:Tag(healtext, "[freebgrid:heals]")
            end
        else
            self:Tag(healtext, "[freebgrid:def]")
        end
    end
end

local Disable = function(self)
    if self.freebHeals then
        if ns.db.healbar then
            self:UnregisterEvent('UNIT_HEAL_PREDICTION', Update)
            self:UnregisterEvent('UNIT_MAXHEALTH', Update)
            self:UnregisterEvent('UNIT_HEALTH', Update)
        end
    end
end

oUF:AddElement('freebHeals', Update, Enable, Disable)
