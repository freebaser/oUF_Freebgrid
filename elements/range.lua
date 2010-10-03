local parent, ns = ...
local oUF = ns.oUF or oUF

local _FRAMES = {}
local OnRangeFrame

local UnitInRange, UnitIsConnected = UnitInRange, UnitIsConnected

local classSpells = {
    --["PRIEST"] = GetSpellInfo(2050),
    --["DRUID"] = GetSpellInfo(5185),
    --["PALADIN"] = GetSpellInfo(635),
    --["SHAMAN"] = GetSpellInfo(331),
    --["MAGE"] = GetSpellInfo(475),
}

-- updating of range.
local timer = 0
local OnRangeUpdate = function(self, elapsed)
    timer = timer + elapsed

    if(timer >= .20) then
        for _, object in next, _FRAMES do
            if(object:IsShown()) then
                local range = object.freebRange
                if(self.class) then
                    if(UnitIsConnected(object.unit) and IsSpellInRange(self.class, object.unit) == 0) then
                        if(object:GetAlpha() == range.insideAlpha) then
                            object:SetAlpha(range.outsideAlpha)
                        end
                    elseif(object:GetAlpha() ~= range.insideAlpha) then
                        object:SetAlpha(range.insideAlpha)
                    end
                else
                    if(UnitIsConnected(object.unit) and not UnitInRange(object.unit)) then
                        if(object:GetAlpha() == range.insideAlpha) then
                            object:SetAlpha(range.outsideAlpha)
                        end
                    elseif(object:GetAlpha() ~= range.insideAlpha) then
                        object:SetAlpha(range.insideAlpha)
                    end
                end
            end
        end

        timer = 0
    end
end

local Enable = function(self)
    local range = self.freebRange
    if(range and range.insideAlpha and range.outsideAlpha) then
        table.insert(_FRAMES, self)

        local _, class = UnitClass("player")
        if(not OnRangeFrame) then
            OnRangeFrame = CreateFrame"Frame"
            OnRangeFrame.class = classSpells[class]
            OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)
        end

        OnRangeFrame:Show()
    end
end

local Disable = function(self)
    local range = self.freebRange
    if(range) then
        for k, frame in next, _FRAMES do
            if(frame == self) then
                table.remove(_FRAMES, k)
                break
            end
        end

        if(#_FRAMES == 0) then
            OnRangeFrame:Hide()
        end
    end
end

oUF:AddElement('freebRange', nil, Enable, Disable)
