local _, ns = ...
local oUF = ns.oUF
if not oUF then return end

local debuffs = FreebgridDebuffs.debuffs

local _, class = UnitClass("player")
local dispellClass = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Poison = true, Disease = true, Curse = true, },
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Curse = true, Poison = true, }
}
local dispellist = dispellClass[class] or {}

local dispellPriority = {
	Magic = 4,
	Poison = 3,
	Curse = 2,
	Disease = 1,
	None = 0,
}

local Update = function(self, event, unit)
	if(unit ~= self.unit) then return end
	unit = unit or self.unit
	local debuff = self.freebDebuffs
	local cur, tex, dis, cnt, dur, exp
	local name, rank, buffTexture, count, dtype, duration, expire, isPlayer
	local i = 1
	while true do
		name, rank, buffTexture, count, dtype, duration, expire, isPlayer = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if not cur or (debuffs[name] >= debuffs[cur]) then
			if debuffs[name] > 0 and debuffs[name] > debuffs[cur or 1] then
				cur = name
				tex = buffTexture
				dis = dtype or "none"
				cnt = count
				exp = expire
				dur = duration
			elseif dtype and dtype ~= "none" then
				if not dis or (dispellPriority[dtype] > dispellPriority[dis]) then
					tex = buffTexture
					dis = dtype
					cnt = count
					exp = expire
					dur = duration
				end
			end	
		end
		i = i +1
	end

	if dis then
		if dispellist[dis] or cur then
			local col = DebuffTypeColor[dis]
			debuff.border:SetVertexColor(col.r, col.g, col.b)
			debuff.icon:SetTexture(tex)
			debuff.Dispell = true
			debuff:Show()
			if cnt > 1 then
				debuff.count:SetText(cnt)
			end
			if exp and dur then
				debuff.cd:SetCooldown(exp - dur, dur)
			end
			self.Info:Hide()
		elseif debuff.Dispell then
			debuff:Hide()
			debuff.Dispell = false
			self.Info:Show()
		end
	else
		debuff:Hide()
		self.Info:Show()
	end
end

local Enable = function(self)
	if not self.freebDebuffs then return end
	local debuff = self.freebDebuffs
	
	local icon = debuff:CreateTexture(nil, "OVERLAY")
	icon:SetAllPoints(debuff)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	debuff.icon = icon
	
	local border = debuff:CreateTexture(nil, "OVERLAY")
	border:SetTexture("Interface\\AddOns\\oUF_Freebgrid\\media\\border")
	border:SetPoint("TOP", debuff, "TOP", 0, 2)
	border:SetPoint("RIGHT", debuff, "RIGHT", 2, 0)
	border:SetPoint("BOTTOM", debuff, "BOTTOM", 0, -2)
	border:SetPoint("LEFT", debuff, "LEFT", -2, 0)
	debuff.border = border

	local count = debuff:CreateFontString(nil, "OVERLAY")
	count:SetFontObject(NumberFontNormal)
	count:SetPoint("LEFT", debuff, "BOTTOM", 3, 2)
	debuff.count = count

	local cd = CreateFrame("Cooldown", nil, debuff)
	cd:SetAllPoints(debuff)
	debuff.cd = cd
	
	self:RegisterEvent("UNIT_AURA", Update)
	
	return true
end

local Disable = function(self)
	if self.freebDebuffs then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement("freebDebuffs", Update, Enable, Disable)