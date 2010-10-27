local _, ns = ...
local oUF =  ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local namelength = 4

local function hex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local numberize = ns.numberize

local function utf8sub(str, start, numChars) 
    local currentIndex = start 
    while numChars > 0 and currentIndex <= #str do 
        local char = string.byte(str, currentIndex) 
        if char >= 240 then 
            currentIndex = currentIndex + 4 
        elseif char >= 225 then 
            currentIndex = currentIndex + 3 
        elseif char >= 192 then 
            currentIndex = currentIndex + 2 
        else 
            currentIndex = currentIndex + 1 
        end 
        numChars = numChars - 1 
    end 
    return str:sub(start, currentIndex - 1) 
end 
local nameCache = {}
local colorCache = {}

oUF.Tags['freebgrid:info'] = function(u, r)
    local name = UnitName(r or u) or "unknown"
    local def = oUF.Tags['missinghp'](u)
    local per = oUF.Tags['perhp'](u)
    local _, class = UnitClass(u)
    local color
    if class then
        if colorCache[class] then
            color = colorCache[class]
        else
            color = hex(oUF.colors.class[class])
        end
    else
        color = "|cffFFFFFF"
    end

    if r or per > 90 or per == 0 or ns.db.showname then
        if nameCache[name] then
            return nameCache[name]
        else 
            local str = color..utf8sub(name, 1, namelength).."|r"
            nameCache[name] = str
            
            return str
        end
    else
        return (color.."-"..numberize(def).."|r")
    end
end
oUF.TagEvents['info'] = 'UNIT_NAME_UPDATE'

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

local Enable = function(self)
    if(self.freebInfo) then
        local name = self.Health:CreateFontString(nil, "OVERLAY")
        name:SetPoint("CENTER")
        name:SetJustifyH("CENTER")
        name:SetFont(ns.fonts[ns.db.font], ns.db.fontsize, ns.db.outline)
        name:SetShadowOffset(1.25, -1.25)
        name.overrideUnit = true
        self:Tag(name, '[freebgrid:info]')

        -- Dead/DC/Ghost text
        local DDG = self.Health:CreateFontString(nil, "OVERLAY")
        DDG:SetPoint("BOTTOM")
        DDG:SetJustifyH("CENTER")
        DDG:SetFont(ns.fonts[ns.db.font], ns.db.fontsize, ns.db.outline)
        DDG:SetShadowOffset(1.25, -1.25)
        self:Tag(DDG, '[freebgrid:ddg]')
    end
end

oUF:AddElement('freebInfo', nil, Enable, nil)
