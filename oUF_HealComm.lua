--==============================================================================
--
-- oUF_HealComm
--
-- Uses data from LibHealComm-3.0 to add incoming heal estimate bars onto units 
-- health bars.
--
--=============================================================================

if not oUF then return end

--set texture and color here
local color = {
    r = 0,
    g = 1,
    b = 0,
    a = .5,
}

local oUF_HealComm = {}

local healcomm = LibStub("LibHealComm-3.0")

local playerName = UnitName("player")
local playerIsCasting = false
local playerHeals = 0
local playerTarget = ""

--update a specific bar
local updateHealCommBar = function(frame, unit)
    local curHP = UnitHealth(unit)
    local maxHP = UnitHealthMax(unit)
    local percHP = curHP / maxHP

    local incHeals = select(2, healcomm:UnitIncomingHealGet(unit, GetTime())) or 0

    --add player's own heals if casting on this unit
    if playerIsCasting then
        for i = 1, select("#", playerTarget) do
            local target = select(i, playerTarget)
            if target == unit then
                incHeals = incHeals + playerHeals
            end
        end
    end

    --hide if unknown max hp or no heals inc
    if maxHP == 100 or incHeals == 0 then
        frame.HealCommBar:Hide()
        return
    else
        frame.HealCommBar:Show()
    end

    percInc = incHeals / maxHP
    h = frame.Health:GetHeight()
    w = frame.Health:GetWidth()
    orient = frame.Health:GetOrientation()
    
    frame.HealCommBar:ClearAllPoints()
    frame.HealCommBar:SetFrameStrata("TOOLTIP")
    if(orient=="VERTICAL")then
		frame.HealCommBar:SetHeight(percInc * h)
		frame.HealCommBar:SetWidth(w)
		frame.HealCommBar:SetPoint("BOTTOM", frame.Health, "BOTTOM", 0, h * percHP)
	else
		frame.HealCommBar:SetWidth(percInc * w)
		frame.HealCommBar:SetHeight(h)
		frame.HealCommBar:SetPoint("LEFT", frame.Health, "LEFT", w * percHP,0)
	end
end

--used by library callbacks, arguments should be list of units to update
local updateHealCommBars = function(...)
	for i = 1, select("#", ...) do
		local unit = select(i, ...)

        --search current oUF frames for this unit
        for frame in pairs(oUF.units) do
            local name, server = UnitName(frame)
            if server then name = strjoin("-",name,server) end
            if name == unit and oUF.units[frame].applyHealComm then
                updateHealCommBar(oUF.units[frame],unit)
            end
        end
	end
end

local function hook(frame)
if not frame.applyHealComm then return end
	
    --create heal bar here and set initial values
    if(frame.Health:GetOrientation() =="VERTICAL")then
		local hcb = CreateFrame"StatusBar"
		hcb:SetWidth(frame.Health:GetWidth()) -- same height as health bar
		hcb:SetHeight(0) --no initial width
		hcb:SetStatusBarTexture(frame.Health:GetStatusBarTexture():GetTexture())
		hcb:SetStatusBarColor(color.r, color.g, color.b, color.a)
		hcb:SetParent(frame)
		hcb:SetPoint("BOTTOM", frame.Health, "TOP",0,0) --attach to immediate top of health bar to start
	--    hcb:SetFrameLevel
		hcb:Hide() --hide it for now
		frame.HealCommBar = hcb
	else
		local hcb = CreateFrame"StatusBar"
		hcb:SetHeight(frame.Health:GetHeight()) -- same height as health bar
		hcb:SetWidth(0) --no initial width
		hcb:SetStatusBarTexture(frame.Health:GetStatusBarTexture():GetTexture())
		hcb:SetStatusBarColor(color.r, color.g, color.b, color.a)
		hcb:SetParent(frame)
		hcb:SetPoint("LEFT", frame.Health, "RIGHT",0,0) --attach to immediate right of health bar to start
	--    hcb:SetFrameLevel
		hcb:Hide() --hide it for now
		frame.HealCommBar = hcb
	end
	local o = frame.PostUpdateHealth
	frame.PostUpdateHealth = function(...)
		if o then o(...) end
        local name, server = UnitName(frame.unit)
        if server then name = strjoin("-",name,server) end
        updateHealCommBar(frame, name) --update the bar when unit's health is updated
	end
end

--hook into all existing frames
for i, frame in ipairs(oUF.objects) do hook(frame) end

--hook into new frames as they're created
oUF:RegisterInitCallback(hook)

--set up LibHealComm callbacks
function oUF_HealComm:HealComm_DirectHealStart(event, healerName, healSize, endTime, ...)
	if healerName == playerName then
		playerIsCasting = true
		playerTarget = ... 
		playerHeals = healSize
	end
    updateHealCommBars(...)
end

function oUF_HealComm:HealComm_DirectHealUpdate(event, healerName, healSize, endTime, ...)
    updateHealCommBars(...)
end

function oUF_HealComm:HealComm_DirectHealStop(event, healerName, healSize, succeeded, ...)
    if healerName == playerName then
        playerIsCasting = false
    end
    updateHealCommBars(...)
end

function oUF_HealComm:HealComm_HealModifierUpdate(event, unit, targetName, healModifier)
    updateHealCommBars(unit)
end

healcomm.RegisterCallback(oUF_HealComm, "HealComm_DirectHealStart")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_DirectHealUpdate")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_DirectHealStop")
healcomm.RegisterCallback(oUF_HealComm, "HealComm_HealModifierUpdate")

