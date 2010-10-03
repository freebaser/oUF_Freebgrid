local _, ns = ...

ns.auras = {
    debuffs = {
        -- Any Zone
        --[GetSpellInfo(47486)] = 8, -- Mortal Strike
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
