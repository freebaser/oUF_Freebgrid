local _, ns = ...
local oUF =  ns.oUF
if not oUF then return end
local _, class = UnitClass("player")
local mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"
local font, fontsize = mediapath.."calibri.ttf", 12
local indicator, indicatorSize = mediapath.."squares.ttf", 6
local symbols, symbolsSize = mediapath.."PIZZADUDEBULLETS.ttf", 11

local Update = function(self, event)
end

local Enable = function(self)
	if(self.Indicators) then
		self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusTL:ClearAllPoints()
		self.AuraStatusTL:SetPoint("TOPLEFT", 0, 0)
		self.AuraStatusTL:SetFont(indicator, indicatorSize, "THINOUTLINE")
		self:Tag(self.AuraStatusTL, oUF.classIndicators[class]["TL"])
		
		self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusTR:ClearAllPoints()
		self.AuraStatusTR:SetPoint("TOPRIGHT", 2, 0)
		self.AuraStatusTR:SetFont(indicator, indicatorSize, "THINOUTLINE")
		self:Tag(self.AuraStatusTR, oUF.classIndicators[class]["TR"])

		self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusBL:ClearAllPoints()
		self.AuraStatusBL:SetPoint("BOTTOMLEFT", 0, 0)
		self.AuraStatusBL:SetFont(indicator, indicatorSize, "THINOUTLINE")
		self:Tag(self.AuraStatusBL, oUF.classIndicators[class]["BL"])	

		self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusBR:ClearAllPoints()
		self.AuraStatusBR:SetPoint("BOTTOMRIGHT", 6, -2)
		self.AuraStatusBR:SetFont(symbols, symbolsSize, "THINOUTLINE")
		--self.AuraStatusBR.frequentUpdates = 1 -- Can be cpu intensive in large groups
		self:Tag(self.AuraStatusBR, oUF.classIndicators[class]["BR"])

		self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
		self.AuraStatusCen:ClearAllPoints()
		self.AuraStatusCen:SetPoint("TOP")
		self.AuraStatusCen:SetJustifyH("CENTER")
		self.AuraStatusCen:SetFont(font, fontsize)
		self.AuraStatusCen:SetShadowOffset(1.25, -1.25)
		self.AuraStatusCen.frequentUpdates = 1 -- Can be cpu intensive in large groups
		self:Tag(self.AuraStatusCen, oUF.classIndicators[class]["Cen"])

		return true
	end
end

local Disable = function(self)
end

oUF:AddElement('Indicators', Update, Enable, Disable)