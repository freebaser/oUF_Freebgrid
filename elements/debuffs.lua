local _, ns = ...
local oUF = ns.oUF or oUF
--[[
	This is a stripped and modified oUF Auras to fit my needs.
	-- freebaser
]]--

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -0.5, left = -0.5, bottom = -0.5, right = -0.5},
}

local createAuraIcon = function(debuffs)
	local button = CreateFrame("Button", nil, debuffs)
	button:EnableMouse(false)
	button:SetBackdrop(backdrop)
	button:SetBackdropColor(0, 0, 0)
	
	button:SetSize(debuffs.size, debuffs.size)

	local cd = CreateFrame("Cooldown", nil, button)
	cd:SetAllPoints(button)
	cd:SetReverse()

	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetAllPoints(button)
	icon:SetTexCoord(.07, .93, .07, .93)
	
	local count = button:CreateFontString(nil, "OVERLAY")
	count:SetFontObject(NumberFontNormal)
	count:SetPoint("LEFT", button, "BOTTOM", 3, 2)
	
	button:SetPoint("BOTTOMLEFT", debuffs, "BOTTOMLEFT")
	
	button.parent = debuffs
	button.icon = icon
	button.count = count
	button.cd = cd
	button:Hide()
	
	debuffs.button = button
end

local updateDebuff = function(icon, texture, count, dtype, duration, timeLeft, buff)
	local cd = icon.cd
	if(duration and duration > 0) then
		cd:SetCooldown(timeLeft - duration, duration)
		cd:Show()
	else
		cd:Hide()
	end

	local buffcolor =  { r = 0.0, g = 1.0, b = 1.0 }
	local color = buff and buffcolor or DebuffTypeColor[dtype] or DebuffTypeColor.none

	icon:SetBackdropColor(color.r, color.g, color.b)

	icon.icon:SetTexture(texture)
	icon.count:SetText((count > 1 and count))
end

local updateIcon = function(unit, debuffs)
	local cur
	local hide = true
	local index = 1
	while true do
		local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, 'HARMFUL')
		if not name then break end
		
		local icon = debuffs.button
		local show = debuffs.CustomFilter(debuffs, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		
		if(show) then
			if not cur then
				cur = icon.priority
				updateDebuff(icon, texture, count, dtype, duration, timeLeft)
			else
				if icon.priority > cur then
					updateDebuff(icon, texture, count, dtype, duration, timeLeft)
				end
			end
			
			icon:Show()
			hide = false
		end
		
		index = index + 1
	end
	
	index = 1
	while true do
		local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, 'HELPFUL')
		if not name then break end
		
		local icon = debuffs.button
		local show = debuffs.CustomFilter(debuffs, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		
		if(show) and icon.buff then
			if not cur then
				cur = icon.priority
				updateDebuff(icon, texture, count, dtype, duration, timeLeft, true)
			else
				if icon.priority > cur then
					updateDebuff(icon, texture, count, dtype, duration, timeLeft, true)
				end
			end
			
			icon:Show()
			hide = false
		end
		
		index = index + 1
	end
	
	if hide then
		debuffs.button:Hide()
	end
end

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end

	local debuffs = self.freebDebuffs
	if(debuffs) then
		updateIcon(unit, debuffs)	
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
