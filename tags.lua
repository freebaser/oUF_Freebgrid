local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.numberize = numberize

oUF.Tags['freebgrid:name'] = function(u, r)
    return UnitName(r or u) or "unknown"
end
oUF.TagEvents['freebgrid:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags['freebgrid:ddg'] = function(u)
    if UnitIsDead(u) then
        return "|cffCFCFCFDead|r"
    elseif UnitIsGhost(u) then
        return "|cffCFCFCFGhost|r"
    elseif not UnitIsConnected(u) then
        return "|cffCFCFCFD/C|r"
    end
end
oUF.TagEvents['freebgrid:ddg'] = 'UNIT_HEALTH'

oUF.Tags['freebgrid:heal'] = function(u)
    local incheal = UnitGetIncomingHeals(u, 'player') or 0
    if incheal > 0 then
        return numberize(incheal)
    end
end
oUF.TagEvents['freebgrid:heal'] = 'UNIT_HEAL_PREDICTION'

local x = "M"

local getTime = function(expirationTime)
    local expire = -1*(GetTime()-expirationTime)
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

ns.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["PRIEST"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["PALADIN"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    }
}
