local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local numberize = ns.numberize

oUF.Tags['freebgrid:heals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    end
end
oUF.TagEvents['freebgrid:heals'] = 'UNIT_HEAL_PREDICTION UNIT_MAXHEALTH UNIT_HEALTH'

oUF.Tags['freebgrid:othersheals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    local player = UnitGetIncomingHeals(u, "player") or 0

    incheal = incheal - player

    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    end
end
oUF.TagEvents['freebgrid:othersheals'] = oUF.TagEvents['freebgrid:heals']

local Enable = function(self)
    if(self.Heals) then
        self.heals = self.Health:CreateFontString(nil, "OVERLAY")
        self.heals:SetPoint("BOTTOM")
        self.heals:SetShadowOffset(1.25, -1.25)
        self.heals:SetFont(ns.fonts[ns.db.font], ns.db.fontsize-2)

        if ns.db.healcommtext then
            if ns.db.healothersonly then
                self:Tag(self.heals, "[freebgrid:othersheals]")
            else
                self:Tag(self.heals, "[freebgrid:heals]")
            end
        end
    end
end

oUF:AddElement('freebHeals', nil, Enable, nil)
