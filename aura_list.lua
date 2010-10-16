local _, ns = ...

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

ns.auras = {
    debuffs = {
        -- Any Zone
        --[GetSpellInfo(6788)] = 5, -- Weakened Soul
        [GetSpellInfo(39171)] = 5, -- Mortal Strike
    },

    buffs = {
        --[GetSpellInfo(871)] = 15, -- Shield Wall
    },

    instances = {
        -- Raid Debuffs
        --["Zone"] = {
        --	[Name or GetSpellInfo(#)] = PRIORITY,
        --},
--[[
        ["The Ruby Sanctum"] = {
            [GetSpellInfo(74562)] = 6, -- Fiery Combustion
            [GetSpellInfo(75883)] = 5, -- Combustion
            [GetSpellInfo(74792)] = 6, -- Soul Consumption
            [GetSpellInfo(75876)] = 5, -- Consumption
        },
        ["Icecrown Citadel"] = {
            --The Lower Spire
            [GetSpellInfo(70980)] = 6, -- Web Wrap
            [GetSpellInfo(69483)] = 6, -- Dark Reckoning
            [GetSpellInfo(69969)] = 5, -- Curse of Doom
            --The Plagueworks
            [GetSpellInfo(71089)] = 5, -- Bubbling Pus
            [GetSpellInfo(71127)] = 7, -- Mortal Wound
            [GetSpellInfo(71163)] = 6, -- Devour Humanoid
            [GetSpellInfo(71103)] = 6, -- Combobulating Spray
            [GetSpellInfo(71157)] = 5, -- Infested Wound
            --The Crimson Hall
            [GetSpellInfo(70645)] = 9, -- Chains of Shadow
            [GetSpellInfo(70671)] = 5, -- Leeching Rot
            [GetSpellInfo(70432)] = 6, -- Blood Sap
            [GetSpellInfo(70435)] = 7, -- Rend Flesh
            --Frostwing Hall
            [GetSpellInfo(71257)] = 6, -- Barbaric Strike
            [GetSpellInfo(71252)] = 5, -- Volley
            [GetSpellInfo(71327)] = 6, -- Web
            [GetSpellInfo(36922)] = 5, -- Bellowing Roar
            --Lord Marrowgar
            [GetSpellInfo(70823)] = 5, -- Coldflame
            [GetSpellInfo(69065)] = 8, -- Impaled
            [GetSpellInfo(70835)] = 5, -- Bone Storm
            --Lady Deathwhisper
            [GetSpellInfo(72109)] = 5, -- Death and Decay
            [GetSpellInfo(71289)] = 9, -- Dominate Mind
            [GetSpellInfo(71204)] = 4, -- Touch of Insignificance
            [GetSpellInfo(67934)] = 5, -- Frost Fever
            [GetSpellInfo(71237)] = 5, -- Curse of Torpor
            [GetSpellInfo(72491)] = 5, -- Necrotic Strike
            --Gunship Battle
            [GetSpellInfo(69651)] = 5, -- Wounding Strike
            --Deathbringer Saurfang
            [GetSpellInfo(72293)] = 6, -- Mark of the Fallen Champion
            [GetSpellInfo(72442)] = 8, -- Boiling Blood
            [GetSpellInfo(72449)] = 5, -- Rune of Blood
            [GetSpellInfo(72769)] = 5, -- Scent of Blood (heroic)
            --Rotface
            [GetSpellInfo(71224)] = 5, -- Mutated Infection
            [GetSpellInfo(71215)] = 5, -- Ooze Flood
            [GetSpellInfo(69774)] = 5, -- Sticky Ooze
            --Festergut
            [GetSpellInfo(69279)] = 5, -- Gas Spore
            [GetSpellInfo(71218)] = 5, -- Vile Gas
            [GetSpellInfo(72219)] = 5, -- Gastric Bloat
            --Proffessor
            [GetSpellInfo(70341)] = 5, -- Slime Puddle
            [GetSpellInfo(72549)] = 5, -- Malleable Goo
            [GetSpellInfo(71278)] = 5, -- Choking Gas Bomb
            [GetSpellInfo(70215)] = 5, -- Gaseous Bloat
            [GetSpellInfo(70447)] = 5, -- Volatile Ooze Adhesive
            [GetSpellInfo(72454)] = 5, -- Mutated Plague
            [GetSpellInfo(70405)] = 5, -- Mutated Transformation
            [GetSpellInfo(72856)] = 6, -- Unbound Plague
            [GetSpellInfo(70953)] = 4, -- Plague Sickness
            --Blood Princes
            [GetSpellInfo(72796)] = 7, -- Glittering Sparks
            [GetSpellInfo(71822)] = 5, -- Shadow Resonance
            --Blood-Queen Lana'thel
            [GetSpellInfo(70838)] = 5, -- Blood Mirror
            [GetSpellInfo(72265)] = 6, -- Delirious Slash
            [GetSpellInfo(71473)] = 5, -- Essence of the Blood Queen
            [GetSpellInfo(71474)] = 6, -- Frenzied Bloodthirst
            [GetSpellInfo(73070)] = 5, -- Incite Terror
            [GetSpellInfo(71340)] = 7, -- Pact of the Darkfallen
            [GetSpellInfo(71265)] = 6, -- Swarming Shadows
            [GetSpellInfo(70923)] = 9, -- Uncontrollable Frenzy
            --Valithria Dreamwalker
            [GetSpellInfo(70873)] = 1, -- Emerald Vigor
            [GetSpellInfo(71746)] = 5, -- Column of Frost
            [GetSpellInfo(71741)] = 4, -- Mana Void
            [GetSpellInfo(71738)] = 7, -- Corrosion
            [GetSpellInfo(71733)] = 6, -- Acid Burst
            [GetSpellInfo(71283)] = 6, -- Gut Spray
            [GetSpellInfo(71941)] = 1, -- Twisted Nightmares
            --Sindragosa
            [GetSpellInfo(69762)] = 5, -- Unchained Magic
            [GetSpellInfo(70106)] = 6, -- Chlled to the Bone
            [GetSpellInfo(69766)] = 6, -- Instability
            [GetSpellInfo(70126)] = 9, -- Frost Beacon
            [GetSpellInfo(70157)] = 8, -- Ice Tomb
            [GetSpellInfo(70127)] = 7, -- Mystic Buffet
            --The Lich King
            [GetSpellInfo(70337)] = 8, -- Necrotic plague
            [GetSpellInfo(72149)] = 5, -- Shockwave
            [GetSpellInfo(70541)] = 7, -- Infest
            [GetSpellInfo(69242)] = 5, -- Soul Shriek
            [GetSpellInfo(69409)] = 9, -- Soul Reaper
            [GetSpellInfo(72762)] = 5, -- Defile
            [GetSpellInfo(68980)] = 8, --Harvest Soul
        },]]
    },
}
