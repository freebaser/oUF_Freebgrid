local parent, ns = ...
local oUF = ns.oUF
--[[
	This is a stripped and modified oUF Auras to fit my needs.
	-- freebaser
]]--

local createAuraIcon = function(debuffs)
	local button = CreateFrame("Button", nil, debuffs)
	button:EnableMouse(false)
	
	button:SetWidth(debuffs.size or 16)
	button:SetHeight(debuffs.size or 16)

	local cd = CreateFrame("Cooldown", nil, button)
	cd:SetAllPoints(button)
	cd:SetReverse()

	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints(button)
	icon:SetTexCoord(.07, .93, .07, .93)
	
	local count = button:CreateFontString(nil, "OVERLAY")
	count:SetFontObject(NumberFontNormal)
	count:SetPoint("LEFT", button, "BOTTOM", 3, 2)

	local overlay = button:CreateTexture(nil, "OVERLAY")
	overlay:SetTexture("Interface\\AddOns\\oUF_Freebgrid\\media\\border")
	overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
	overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
	overlay:SetTexCoord(0, 1, 0.02, 1)
	button.overlay = overlay
	
	button:SetPoint("BOTTOMLEFT", debuffs, "BOTTOMLEFT")
	
	button.parent = debuffs
	button.icon = icon
	button.count = count
	button.cd = cd
	button:Hide()
	
	debuffs.button = button
end

local prior = 0
local cur = nil
local updateIcon = function(unit, debuffs, index, filter)
	local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, filter)
	if(name) then
		local icon = debuffs.button
		local show = debuffs.CustomFilter(debuffs, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		
		if(show) then
			if (icon.priority <= prior) and cur ~= name then
				cur = name
				return true
			end
			
			prior = icon.priority
			cur = nil
			
			local cd = icon.cd
			if(cd) then
				if(duration and duration > 0) then
					cd:SetCooldown(timeLeft - duration, duration)
					cd:Show()
				else
					cd:Hide()
				end
			end

			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none

			icon.overlay:SetVertexColor(color.r, color.g, color.b)
			icon.overlay:Show()

			icon.icon:SetTexture(texture)
			icon.count:SetText((count > 1 and count))

			icon:Show()
			
			return true
		else
			return false
		end
	end
end

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end

	local debuffs = self.freebDebuffs
	if(debuffs) then
		local index = 1
		local hide = true
		while true do
			local result = updateIcon(unit, debuffs, index, 'HARMFUL')
			
			if not result then
				break
			elseif result then
				hide = false
			end
			index = index + 1
		end
		if hide then
			debuffs.button:Hide()
			prior = 0
			cur = nil
		end
	end
end

local Enable = function(self)
	if(self.freebDebuffs) then
		createAuraIcon(self.freebDebuffs)
		self:RegisterEvent("UNIT_AURA", Update)

		return true
	end
end

local Disable = function(self)
	if(self.freebDebuffs) then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement('freebDebuffs', Update, Enable, Disable)
