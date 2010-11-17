local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local _, class = UnitClass("player")
local mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"
local indicator = mediapath.."squares.ttf"
local symbols = mediapath.."PIZZADUDEBULLETS.ttf"

local Enable = function(self)
    if(self.freebIndicators) then
        self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", 0, -1)
        self.AuraStatusTL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
        --self.AuraStatusTL.frequentUpdates = ns.db.frequpdate
        self:Tag(self.AuraStatusTL, ns.classIndicators[class]["TL"])

        self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        self.AuraStatusTR:SetPoint("TOPRIGHT", 2, -1)
        self.AuraStatusTR:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
        --self.AuraStatusTR.frequentUpdates = ns.db.frequpdate
        self:Tag(self.AuraStatusTR, ns.classIndicators[class]["TR"])

        self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("BOTTOMLEFT", 0, 0)
        self.AuraStatusBL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
        --self.AuraStatusBL.frequentUpdates = ns.db.frequpdate
        self:Tag(self.AuraStatusBL, ns.classIndicators[class]["BL"])	

        self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", 6, -2)
        self.AuraStatusBR:SetFont(symbols, ns.db.symbolsize, "THINOUTLINE")
        self.AuraStatusBR.frequentUpdates = ns.db.frequpdate
        self:Tag(self.AuraStatusBR, ns.classIndicators[class]["BR"])

        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusCen:ClearAllPoints()
        self.AuraStatusCen:SetPoint("TOP")
        self.AuraStatusCen:SetJustifyH("CENTER")
        self.AuraStatusCen:SetFont(ns.fonts[ns.db.font], ns.db.fontsize, ns.db.outline)
        self.AuraStatusCen:SetShadowOffset(1.25, -1.25)
        self.AuraStatusCen.frequentUpdates = ns.db.frequpdate
        self:Tag(self.AuraStatusCen, ns.classIndicators[class]["Cen"])
    end
end

oUF:AddElement('freebIndicators', nil, Enable, nil)
