local parent, ns = ...
local oUF = ns.oUF or oUF

local classList = {
	--[[
	["DRUID"] = {
		combat = GetSpellInfo(20484), -- Rebirth
		ooc = GetSpellInfo(50769), -- Revive
	},
	]]--
}

local body = ""
local function macroBody(class)
	local combatspell = classList[class].combat
	local oocspell = classList[class].ooc

	body = "/stopmacro [nodead,@mouseover]\n"
	if combatspell then
		body = body .. "/cast [combat,help,dead,@mouseover] " .. combatspell .. "; "

		if oocspell then
			body = body .. "[help,dead,@mouseover] " .. oocspell .. "; "
		end

		if class == "WARLOCK" then
			body = body .. "\n/cast Create Soulstone\n "
		end
	elseif oocspell then
		body = body .. "/cast [help,dead,@mouseover] " .. oocspell .. "; "
	end

	return body
end

local Enable = function(self)
	local _, class = UnitClass("player")
	if not class or not ns.db.autorez then return end

	if self.IsFreebgrid and classList[class] and not IsAddOnLoaded("Clique") then
		self:SetAttribute("*type3", "macro")
		self:SetAttribute("macrotext3", macroBody(class))

		return true
	end
end

local Disable = function(self)
	if self.IsFreebgrid and not ns.db.autorez then
		self:SetAttribute("*type3", nil)
	end
end

oUF:AddElement('freebAutoRez', nil, Enable, Disable)
