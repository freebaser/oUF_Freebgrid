local _, ns = ...
local oUF = ns.oUF or oUF
if not oUF then return end

local Update = function(self, event, unit)
	if(unit ~= self.unit) then return end
	local threat = self.freebThreat

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 1) then
		local r, g, b = GetThreatStatusColor(status)
		threat:SetBackdropBorderColor(r, g, b, 1)
	else
		threat:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

local Enable = function(self)
	local threat = self.freebThreat
	if(threat) then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", Update)
		threat:Show()

		return true
	end
end

local Disable = function(self)
	local threat = self.freebThreat
	if(threat) then
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE", Update)
	end
end

oUF:AddElement('freebThreat', Update, Enable, Disable)