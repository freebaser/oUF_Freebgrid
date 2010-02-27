--[[
	Elements handled: .ResComm
	
	Optional:
	 - .OthersOnly: (boolean) Defines whether the player's resurrection triggers the element or not.
	   (Default: nil)
	
	Functions that can be overridden from within a layout:
	 - :CustomOnUpdate(elapsed)
]]

local _, ns = ...
local oUF = ns.oUF or oUF

local libResComm = LibStub("LibResComm-1.0")
local playerName = UnitName("player")

local duration
local onUpdate = function(self, elapsed)
	duration = self.duration + elapsed
	
	if duration >= self.endTime then
		self:Hide()
	end
	
	self.duration = duration
	self:SetValue(duration)
end

local Update = function(self, event, destUnit, endTime)
	local resComm = self.ResComm
	
	if resComm then
		local unitName, unitRealm = UnitName(destUnit)
		
		if unitName and unitRealm and unitRealm ~= "" then
			unitName = unitName .. "-" .. unitRealm
		elseif not unitName then
			unitName = destUnit
		end
		
		local beingRessed, resserName = libResComm:IsUnitBeingRessed(unitName)
		
		if (beingRessed and not (resComm.OthersOnly and resserName == playerName)) then
			if resComm:IsObjectType("Statusbar") then
				if endTime then
					local maxValue = endTime - GetTime()
					
					resComm.duration = 0
					resComm.endTime = maxValue
					resComm:SetMinMaxValues(0, maxValue)
					resComm:SetValue(0)
					
					if resComm.CustomOnUpdate then
						resComm:SetScript("OnUpdate", resComm.CustomOnUpdate)
					else
						resComm:SetScript("OnUpdate", onUpdate)
					end
				end
			end
			
			resComm:Show()
		else
			if resComm:IsObjectType("Statusbar") then
				resComm.duration = 0
				resComm.endTime = 0
				
				resComm:SetScript("OnUpdate", nil)
			end
			
			resComm:Hide()
		end
	end
end

local Enable = function(self)
	local resComm = self.ResComm
	
	if resComm then		
		if resComm:IsObjectType("Texture") and not resComm:GetTexture() then
			resComm:SetTexture([=[Interface\Icons\Spell_Holy_Resurrection]=])
		elseif resComm:IsObjectType("Statusbar") and not resComm:GetStatusBarTexture() then
			resComm:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end
		
		return true
	end
end

oUF:AddElement("ResComm", Update, Enable, nil)

local ResComm_Update = function(event, _, endTime, _)
	local destUnit
	for _, frame in ipairs(oUF.objects) do
		if frame.unit then
			destUnit = frame.unit
			Update(frame, event, destUnit, endTime)
		end
	end
end

libResComm.RegisterCallback("oUF_ResComm", "ResComm_ResStart", ResComm_Update)
libResComm.RegisterCallback("oUF_ResComm", "ResComm_ResEnd", ResComm_Update)