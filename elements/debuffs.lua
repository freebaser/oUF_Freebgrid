local _, ns = ...
local oUF = ns.oUF or oUF
--[[
	This is a stripped and modified oUF Auras to fit my needs.
	-- freebaser
]]--

local backdrop = {
	bgFile = [=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=], tile = true, tileSize = 16,
	edgeFile = [=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=], edgeSize = 1,
	insets = {top = 1, left = 1, bottom = 1, right = 1},
}

local BBackdrop = {
	bgFile = [=[Interface\AddOns\oUF_Freebgrid\media\white.tga]=], tile = true, tileSize = 16,
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	end
	return floor(s + 0.5), (s * 100 - floor(s * 100))/100
end

local CreateAuraTimer = function(self,elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				if self.timeLeft < 5 then
					self.remaining:SetTextColor(1, 0, 0)
				else
					self.remaining:SetTextColor(1, 1, 0)
				end
				local atime = FormatTime(self.timeLeft)
				self.remaining:SetText(atime)
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local createAuraIcon = function(debuffs)
	local button = CreateFrame("Button", nil, debuffs)
	button:EnableMouse(false)
	button:SetBackdrop(BBackdrop)
	button:SetBackdropColor(0,0,0,1)
	button:SetBackdropBorderColor(0,0,0,0)
	
	button:SetSize(debuffs.size, debuffs.size)

	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetAllPoints(button)
	icon:SetTexCoord(.07, .93, .07, .93)
	
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints(button)
	overlay:SetBackdrop(backdrop)
	overlay:SetBackdropColor(0,0,0,0)
	overlay:SetBackdropBorderColor(1,1,1,1)
	overlay:SetFrameLevel(6)
	button.overlay = overlay
	
	local count = overlay:CreateFontString(nil, "OVERLAY")
	count:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], 11, "THINOUTLINE")
	count:SetPoint("LEFT", button, "BOTTOM", 3, 2)
	
	button:SetPoint("BOTTOMLEFT", debuffs, "BOTTOMLEFT")
	
	local remaining = button:CreateFontString(nil, "OVERLAY")
	remaining:SetPoint("CENTER")
	remaining:SetFont(oUF_Freebgrid.fonts[oUF_Freebgrid.db.font], 11, "OUTLINE")
	remaining:SetTextColor(1, 1, 0)
	button.remaining = remaining
	
	button.parent = debuffs
	button.icon = icon
	button.count = count
	button.cd = cd
	button:Hide()
	
	debuffs.button = button
end

local updateDebuff = function(icon, texture, count, dtype, duration, timeLeft, buff)
	if(duration and duration > 0) then
		icon.remaining:Show()
	else
		icon.remaining:Hide()
	end

	local buffcolor =  { r = 0.0, g = 1.0, b = 1.0 }
	local color = buff and buffcolor or DebuffTypeColor[dtype] or DebuffTypeColor.none

	icon.overlay:SetBackdropBorderColor(color.r, color.g, color.b)

	icon.icon:SetTexture(texture)
	icon.count:SetText((count > 1 and count))
	
	icon.duration = duration
	icon.timeLeft = timeLeft
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
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
