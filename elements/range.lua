local parent, ns = ...
local oUF = ns.oUF or oUF

-- oUF range element with code sniplets from TomTom

local _FRAMES = {}
local OnRangeFrame

local UnitInRange, UnitIsConnected = UnitInRange, UnitIsConnected
local GetPlayerMapPosition, GetPlayerFacing = GetPlayerMapPosition, GetPlayerFacing

local twopi = math.pi * 2
local atan2 = math.atan2

local function ColorGradient(perc, ...)
    local num = select("#", ...)
    local hexes = type(select(1, ...)) == "string"

    if perc == 1 then
        return select(num-2, ...), select(num-1, ...), select(num, ...)
    end

    num = num / 3

    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2
    r1, g1, b1 = select((segment*3)+1, ...), select((segment*3)+2, ...), select((segment*3)+3, ...)
    r2, g2, b2 = select((segment*3)+4, ...), select((segment*3)+5, ...), select((segment*3)+6, ...)

    if not r2 or not g2 or not b2 then
        return r1, g1, b1
    else
        return r1 + (r2-r1)*relperc,
        g1 + (g2-g1)*relperc,
        b1 + (b2-b1)*relperc
    end
end

local function getCoords(column, row)
    local xstart = (column * 56) / 512
    local ystart = (row * 42) / 512
    local xend = ((column + 1) * 56) / 512
    local yend = ((row + 1) * 42) / 512
    return xstart, xend, ystart, yend
end

local texcoords = setmetatable({}, {__index = function(t, k)
    local col,row = k:match("(%d+):(%d+)")
    col,row = tonumber(col), tonumber(row)
    local obj = {getCoords(col, row)}
    rawset(t, k, obj)
    return obj
end})

local function ColorTexture(texture, angle)
    local perc = math.abs((math.pi - math.abs(angle)) / math.pi)

    local gr,gg,gb = 0, 1, 0
    local mr,mg,mb = 1, 1, 0
    local br,bg,bb = 1, 0, 0
    local r,g,b = ColorGradient(perc, br, bg, bb, mr, mg, mb, gr, gg, gb)		
    texture:SetVertexColor(r,g,b)
end

local function RotateTexture(parent, texture, angle)
    local cell = floor(angle / twopi * 108 + 0.5) % 108
    local column = cell % 9
    local row = floor(cell / 9)

    local key = column .. ":" .. row
    texture:SetTexCoord(unpack(texcoords[key]))
    parent:Show()

    ColorTexture(texture, angle)
end

local function GetBearing(unit)
    local tx, ty = GetPlayerMapPosition(unit)
    if tx == 0 and ty == 0 then
        return 999
    end
    local px, py = GetPlayerMapPosition("player")
    return -GetPlayerFacing() - atan2(tx - px, py - ty)
end

local timer = 0
local OnRangeUpdate = function(self, elapsed)
    timer = timer + elapsed

    if(timer >= .10) then
        for _, object in next, _FRAMES do
            if(object:IsShown()) then
                local range = object.freebRange
                if(UnitIsConnected(object.unit) and not UnitInRange(object.unit)) then
                    if(object:GetAlpha() == range.insideAlpha) then
                        object:SetAlpha(range.outsideAlpha)
                    end
                    local bearing = GetBearing(object.unit)
                    if bearing == 999 then
                        object.freebarrow:Hide()
                        return
                    end

                    RotateTexture(object.freebarrow, object.freebarrow.Tex, bearing)

                elseif(object:GetAlpha() ~= range.insideAlpha) then
                    object:SetAlpha(range.insideAlpha)
                    object.freebarrow:Hide()
                end
            else
                object.freebarrow:Hide()
            end
        end

        timer = 0
    end
end

local Enable = function(self)
    local range = self.freebRange
    if(range and range.insideAlpha and range.outsideAlpha) then
        table.insert(_FRAMES, self)

        if(not OnRangeFrame) then
            OnRangeFrame = CreateFrame"Frame"
            OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)
        end
        OnRangeFrame:Show()

        local arrow = CreateFrame"Frame"
        arrow:SetAllPoints(self)
        arrow:SetFrameLevel(6)
        arrow.Tex = arrow:CreateTexture(nil, "OVERLAY")
        arrow.Tex:SetTexture"Interface\\Addons\\oUF_Freebgrid\\Media\\Arrow"
        arrow.Tex:SetPoint("TOPRIGHT", arrow, "TOPRIGHT")
        arrow.Tex:SetSize(18, 18)
        
        self.freebarrow = arrow
        self.freebarrow:Hide()
        
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
