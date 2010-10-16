local _, ns = ...

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

ns.auras = {
    debuffs = {
        -- Any Zone
        --["Weakened Soul"] = 8,
    },

    buffs = {
        --[GetSpellInfo(871)] = 15, -- Shield Wall
    },

    instances = {
        -- Raid Debuffs
        --["Zone"] = {
        --	[Name or GetSpellInfo(#)] = PRIORITY,
        --},

    },
}
