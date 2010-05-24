local parent, ns = ...
local oUF = ns.oUF
--[[
	This is a stripped and modified oUF Auras to fit my needs.
	-- freebaser
]]--
local VISIBLE = 1
local HIDDEN = 0

local createAuraIcon = function(icons, index)
	local button = CreateFrame("Button", nil, icons)
	button:EnableMouse(false)
	
	button:SetWidth(icons.size or 16)
	button:SetHeight(icons.size or 16)

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
	
	table.insert(icons, button)
	
	button.parent = icons
	button.icon = icon
	button.count = count
	button.cd = cd
	
	return button
end

local updateIcon = function(unit, icons, index, filter)
	local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, filter)
	if(name) then
		local icon = icons[index]
		if(not icon) then
			icon = createAuraIcon(icons, index)
		end

		local show = icons.CustomFilter(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		if(show) then
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

			icon.filter = filter
			icon.debuff = isDebuff
			
			icon:SetID(index)
			icon:Show()
			
			return VISIBLE
		else
			icon:Hide()
			table.remove(icons, index)
			
			return HIDDEN
		end
	end
end

local SetPosition = function(icons, x)
	if(icons and x > 0) then
		local anchor = "BOTTOMLEFT"
		for i = 1, #icons do
			local button = icons[i]
			if(button and button:IsShown()) then
				button:SetPoint(anchor, icons, anchor)
			elseif(not button) then
				break
			end
		end
	end
end

local filterIcons = function(unit, icons, filter, limit, isDebuff)
	local index = 1
	local visible = 0
	while(visible < limit) do
		local result = updateIcon(unit, icons, index, filter)
		if(not result) then
			break
		elseif(result == VISIBLE) then
			visible = visible + 1
		end
		index = index + 1
	end
	for i = visible + 1, #icons do
		icons[i]:Hide()
	end

	return visible
end

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end

	local debuffs = self.freebDebuffs
	if(debuffs) then
		local numDebuffs = debuffs.num or 40
		debuffs.visibleDebuffs = filterIcons(unit, debuffs, debuffs.filter or 'HARMFUL', numDebuffs, true)

		debuffs:PreSetPosition()
		SetPosition(debuffs, numDebuffs)
	end
end

local Enable = function(self)
	if(self.freebDebuffs) then
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
