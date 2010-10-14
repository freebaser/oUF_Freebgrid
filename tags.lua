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

local x = "M"

local getTime = function(expirationTime)
    local expire = -1*(GetTime()-expirationTime)
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

-- Priest
local pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags['freebgrid:pom'] = function(u) local c = select(4, UnitAura(u, GetSpellInfo(41635))) if c then return "|cffFFCF7F"..pomCount[c].."|r" end end
oUF.TagEvents['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags['freebgrid:rnw'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.TagEvents['freebgrid:rnw'] = "UNIT_AURA"

oUF.Tags['freebgrid:rnwTime'] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.TagEvents['freebgrid:rnwTime'] = "UNIT_AURA"

oUF.Tags['freebgrid:pws'] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end
oUF.TagEvents['freebgrid:pws'] = "UNIT_AURA"

oUF.Tags['freebgrid:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end
oUF.TagEvents['freebgrid:ws'] = "UNIT_AURA"

oUF.Tags['freebgrid:fw'] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513"..x.."|r" end end
oUF.TagEvents['freebgrid:fw'] = "UNIT_AURA"

oUF.Tags['freebgrid:sp'] = function(u) if not UnitAura(u, GetSpellInfo(79107)) then return "|cff9900FF"..x.."|r" end end
oUF.TagEvents['freebgrid:sp'] = "UNIT_AURA"

oUF.Tags['freebgrid:fort'] = function(u) if not UnitAura(u, GetSpellInfo(79105)) then return "|cff00A1DE"..x.."|r" end end
oUF.TagEvents['freebgrid:fort'] = "UNIT_AURA"

ns.classIndicators={
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["PRIEST"] = {
        ["TL"] = "[freebgrid:pws][freebgrid:ws]",
        ["TR"] = "[freebgrid:fw][freebgrid:sp][freebgrid:fort]",
        ["BL"] = "[freebgrid:rnw]",
        ["BR"] = "[freebgrid:pom]",
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
