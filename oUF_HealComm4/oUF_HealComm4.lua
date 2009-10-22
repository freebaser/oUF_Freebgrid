--==============================================================================
--
-- oUF_HealComm4
--
-- Uses data from LibHealComm-4.0 to add incoming heal estimate bars onto units 
-- health bars.
--
-- * currently won't update the frame if max HP is unknown (ie, restricted to 
--   players/pets in your group that are in range), hides the bar for these
-- * can define frame.ignoreHealComm in layout to not have the bars appear on 
--   that frame
--
-- This addon is based on the original oUF_HealComm by Krage
--
--=============================================================================
local oUF = Freebgrid
local db = FreebgridDefaults

local healcomm = LibStub("LibHealComm-4.0", false)
if not healcomm then return end -- could not load LibHealComm-4.0, quit out early

-- set texture and color here
local color = {
    r = 0,
    g = 1,
    b = 0,
    a = .4,
}

local oUF_HealComm = {}

local  numberize = function(val)
	if(val >= 1e3) then
        	return ("%.1fk"):format(val / 1e3)
	elseif (val >= 1e6) then
		return ("%.1fm"):format(val / 1e6)
	else
		return ("%d"):format(val)
	end
end

local unitMap = healcomm:GetGUIDUnitMapTable()

local noIncomingHeals = function(frame)
	-- if showing incoming heals bar then hide it
	if not frame.ignoreHealComm then
		frame.HealCommBar:Hide()
	end

	-- if showing text then set it to an empty string
	if frame.HealCommText then
		frame.HealCommText:SetText("")
	end
end

-- update a specific bar
local updateHealCommBar = function(frame, unitName, playerGUID)

	-- hide bars for any units with an unknown name
	if not unitName then
		noIncomingHeals(frame)
		return
	end

	-- hide bars on DC'd or dead units
	if (not UnitIsConnected(unitName)) or UnitIsDeadOrGhost(unitName) then
		noIncomingHeals(frame)
		return
	end

	local maxHP = UnitHealthMax(unitName) or 0

	-- hide if unknown max hp
	if maxHP == 0 or maxHP == 100 then
		noIncomingHeals(frame)
		return
	end

	local incHeals = healcomm:GetHealAmount(playerGUID, healcomm.ALL_HEALS) or 0

	-- hide if no heals inc
	if incHeals == 0 then
		noIncomingHeals(frame)
		return
	end

	-- apply heal modifier
	incHeals = incHeals * healcomm:GetHealModifier(playerGUID)

	-- update the incoming heal bar
	if not frame.ignoreHealComm then
		frame.HealCommBar:Show()

		local percInc = incHeals / maxHP
		local curHP = UnitHealth(unitName)
		local percHP = curHP / maxHP

		frame.HealCommBar:ClearAllPoints()

		if frame.Health:GetOrientation() == "VERTICAL" then
			frame.HealCommBar:SetHeight(percInc * frame.Health:GetHeight())
			frame.HealCommBar:SetWidth(frame.Health:GetWidth())
			frame.HealCommBar:SetPoint("BOTTOM", frame.Health, "BOTTOM", 0, frame.Health:GetHeight() * percHP)
		else
			frame.HealCommBar:SetHeight(frame.Health:GetHeight())
			frame.HealCommBar:SetWidth(percInc * frame.Health:GetWidth())
			frame.HealCommBar:SetPoint("LEFT", frame.Health, "LEFT", frame.Health:GetWidth() * percHP, 0)
		end
	end

	-- update the incoming heal text
	if frame.HealCommText and db.Healtext then
		frame.HealCommText:SetText(frame.HealCommTextFormat and frame.HealCommTextFormat(incHeals) or numberize(incHeals))
	end
end

-- used by library callbacks, arguments should be list of units to update
local updateHealCommBars = function(...)
	local playerGUID, unit

	-- update the unitMap to make sure it is current
	unitMap = healcomm:GetGUIDUnitMapTable()

	for i = 1, select("#", ...) do
		playerGUID = select(i, ...)
		unit = unitMap[playerGUID]

		-- search current oUF frames for this unit
		-- each character may be in multiple frames (target, raid,
		-- focus, etc..) so need to check all frames
		for i, frame in ipairs(oUF.objects) do

			-- only update if GUID matches and there is an indicator to update
			if (frame.unit and (UnitGUID(frame.unit) == playerGUID)) and
			   ((not frame.ignoreHealComm) or frame.HealCommText) then
				updateHealCommBar(frame, unit, playerGUID)
			end
		end
	end
end

local function hook(frame)

	-- stop as it is not a unit frame with a health bar
	if not frame.Health then
		frame.ignoreHealComm = true
	end

	-- add incoming heal bars unless they disabled us
	if not frame.ignoreHealComm then
		-- create heal bar here and set initial values
		local hcb = CreateFrame("StatusBar")
		hcb:SetHeight(0) -- no initial height
		hcb:SetWidth(0) -- no initial width
		hcb:SetStatusBarTexture(frame.Health:GetStatusBarTexture():GetTexture())
		hcb:SetStatusBarColor(color.r, color.g, color.b, color.a)
		hcb:SetParent(frame)
		hcb:SetPoint("LEFT", frame.Health, "RIGHT") -- attach to immediate right of health bar to start
		hcb:Hide() -- hide it for now

		frame.HealCommBar = hcb
	end

	-- add update to any frame that needs it
	if (not frame.ignoreHealComm) or frame.HealCommText then
		local origPostUpdate = frame.PostUpdateHealth
		frame.PostUpdateHealth = function(...)
			if origPostUpdate then origPostUpdate(...) end
			local frameGUID = UnitGUID(frame.unit)
			unitMap = healcomm:GetGUIDUnitMapTable()
			updateHealCommBar(frame, unitMap[frameGUID], frameGUID) -- update the bar when unit's health is updated
		end
	end
end

-- hook into all existing frames
for i, frame in ipairs(oUF.objects) do hook(frame) end

-- hook into new frames as they're created
oUF:RegisterInitCallback(hook)

-- set up LibHealComm callbacks
function oUF_HealComm:HealComm_Heal_Update(event, casterGUID, spellID, healType, _, ...)
	updateHealCommBars(...)
end

function oUF_HealComm:HealComm_Modified(event, guid)
	updateHealCommBars(guid)
end

healcomm.RegisterCallback(oUF_HealComm, "HealComm_HealStarted", "HealComm_Heal_Update")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_HealUpdated", "HealComm_Heal_Update")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_HealDelayed", "HealComm_Heal_Update")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_HealStopped", "HealComm_Heal_Update")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_ModifierChanged", "HealComm_Modified")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_GUIDDisappeared", "HealComm_Modified")
