local _, ns = ...

local foo = {""}
local spellcache = setmetatable({}, 
{__index=function(t,id) 
	local a = {GetSpellInfo(id)} 

	if GetSpellInfo(id) then
	    t[id] = a
	    return a
	end

	--print("Invalid spell ID: ", id)
   t[id] = foo
	return foo
end
})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

ns.auras = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
        [GetSpellInfo(92956)] = true, -- Wrack
    },

    -- Any Zone
    debuffs = {
        --[6788] = 16,
        --[GetSpellInfo(6788)] = 16, -- Weakened Soul
        [GetSpellInfo(39171)] = 9, -- Mortal Strike
        [GetSpellInfo(76622)] = 9, -- Sunder Armor
    },

    buffs = {
        --[GetSpellInfo(871)] = 15, -- Shield Wall
    },

    -- Raid Debuffs
    instances = {
        --["MapID"] = {
        --	[Name or GetSpellInfo(spellID) or SpellID] = PRIORITY,
        --},
		[886] = { --[[ Terrace of Endless Spring ]]--

            --Protector Kaolan
			[GetSpellInfo(117519)] = 7, --Touch of Sha
			[GetSpellInfo(111850)] = 7, --Lightning Prison: Targeted
			[GetSpellInfo(117436)] = 7, --Lightning Prison: Stunned
			[GetSpellInfo(118191)] = 7, --Corrupted Essence
			[GetSpellInfo(117986)] = 8, --Defiled Ground: Stacks
			
			--Tsulong
			[GetSpellInfo(122768)] = 7, --Dread Shadows
			[GetSpellInfo(122777)] = 7, --Nightmares (dispellable)
			[GetSpellInfo(122752)] = 7, --Shadow Breath
			[GetSpellInfo(122789)] = 7, --Sunbeam
			[GetSpellInfo(123012)] = 7, --Terrorize: 5% (dispellable)
			[GetSpellInfo(123011)] = 7, --Terrorize: 10% (dispellable)
			[GetSpellInfo(123036)] = 7, --Fright (dispellable)
			[GetSpellInfo(122858)] = 6, --Bathed in Light
			
			--Lei Shi
			[GetSpellInfo(123121)] = 7, --Spray
			[GetSpellInfo(123705)] = 7, --Scary Fog
			
			--Sha of Fear
			[GetSpellInfo(119414)] = 7, --Breath of Fear
			[GetSpellInfo(129147)] = 7, --Onimous Cackle
			[GetSpellInfo(119983)] = 7, --Dread Spray
			[GetSpellInfo(120669)] = 7, --Naked and Afraid
			[GetSpellInfo(75683)] = 7, --Waterspout

			[GetSpellInfo(120629)] = 7, --Huddle in Terror
			[GetSpellInfo(120394)] = 7, --Eternal Darkness
			[GetSpellInfo(129189)] = 7, --Sha Globe
			[GetSpellInfo(119086)] = 7, --Penetrating Bolt
			[GetSpellInfo(119775)] = 7, --Reaching Attack

        },
		
		[897] = { --[[ Heart of Fear ]]--

            --Imperial Vizier Zor'lok
			[GetSpellInfo(123812)] = 7, --Pheromones of Zeal
			[GetSpellInfo(122740)] = 7, --Convert (MC)
			[GetSpellInfo(122706)] = 7, --Noise Cancelling (AMZ)
			
			--Blade Lord Ta'yak
			[GetSpellInfo(123474)] = 7, --Overwhelming Assault
			[GetSpellInfo(122949)] = 7, --Unseen Strike
			[GetSpellInfo(124783)] = 7, --Storm Unleashed
			
			--Garalon
			[GetSpellInfo(122835)] = 7, --Pheromones
			[GetSpellInfo(123081)] = 8, --Pungency
			[GetSpellInfo(122774)] = 7, --Crush
			[GetSpellInfo(123423)] = 8, --Weak Points

			--Wind Lord Mel'jarak
			[GetSpellInfo(121881)] = 8, --Amber Prison
			[GetSpellInfo(122055)] = 7, --Residue
			[GetSpellInfo(122064)] = 7, --Corrosive Resin

			--Amber-Shaper Un'sok
			[GetSpellInfo(121949)] = 7, --Parasitic Growth
			[GetSpellInfo(122784)] = 7, --Reshape Life
			
			--Grand Empress Shek'zeer
			[GetSpellInfo(123707)] = 7, --Eyes of the Empress
			[GetSpellInfo(125390)] = 7, --Fixate
			[GetSpellInfo(123788)] = 8, --Cry of Terror
			[GetSpellInfo(124097)] = 7, --Sticky Resin
			[GetSpellInfo(123184)] = 8, --Dissonance Field
			[GetSpellInfo(124777)] = 7, --Poison Bomb
			[GetSpellInfo(124821)] = 7, --Poison-Drenched Armor
			[GetSpellInfo(124827)] = 7, --Poison Fumes
			[GetSpellInfo(124849)] = 7, --Consuming Terror
			[GetSpellInfo(124863)] = 7, --Visions of Demise
			[GetSpellInfo(124862)] = 7, --Visions of Demise: Target
			[GetSpellInfo(123845)] = 7, --Heart of Fear: Chosen
			[GetSpellInfo(123846)] = 7, --Heart of Fear: Lure
			[GetSpellInfo(125283)] = 7, --Sha Corruption

        },
		
		[896] = { --[[ Mogu'shan Vaults ]]--

			--The Stone Guard
			[GetSpellInfo(130395)] = 7, --Jasper Chains
			[GetSpellInfo(130774)] = 7, --Amethyst Pool
			[GetSpellInfo(116281)] = 7, --Cobalt Mine Blast
			[GetSpellInfo(125206)] = 7, --Rend Flesh
			
			--Feng The Accursed
			[GetSpellInfo(131788)] = 7, --Lightning Lash
			[GetSpellInfo(116942)] = 7, --Flaming Spear
			[GetSpellInfo(131790)] = 7, --Arcane Shock
			[GetSpellInfo(131792)] = 7, --Shadowburn
			[GetSpellInfo(116784)] = 9, --Wildfire Spark
			[GetSpellInfo(116374)] = 7, --Lightning Charge
			[GetSpellInfo(116364)] = 7, --Arcane Velocity
			[GetSpellInfo(116040)] = 7, --Epicenter
			
			--Gara'jal the Spiritbinder
			[GetSpellInfo(122151)] = 9, --Voodoo doll
			[GetSpellInfo(117723)] = 8, --Frail Soul
			[GetSpellInfo(116260)] = 7, --Crossed Over
			[GetSpellInfo(116278)] = 7, --Soul Sever
			
			--The Spirit Kings
			--Meng the Demented
			[GetSpellInfo(117708)] = 7, --Maddening Shout
			--Subetai the Swift
			[GetSpellInfo(118048)] = 7, --Pillaged
			[GetSpellInfo(118047)] = 7, --Pillage: Target
			[GetSpellInfo(118135)] = 7, --Pinned Down
			[GetSpellInfo(118163)] = 7, --Robbed Blind
			--Zian of the Endless Shadow
			[GetSpellInfo(118303)] = 7, --Undying Shadow: Fixate

			--Elegon
			[GetSpellInfo(117878)] = 7, --Overcharged
			[GetSpellInfo(117949)] = 7, --Closed circuit
			[GetSpellInfo(117945)] = 7, --Arcing Energy
			-- Celestial Protector (Heroic)
			[GetSpellInfo(132222)] = 8, --Destabilizing Energies

			--Will of the Emperor
			--Jan-xi and Qin-xi
			[GetSpellInfo(116835)] = 7, --Devastating Arc
			[GetSpellInfo(132425)] = 7, --Stomp
			-- Rage
			[GetSpellInfo(116525)] = 7, --Focused Assault (Rage fixate)
			-- Courage
			[GetSpellInfo(116778)] = 7, --Focused Defense (fixate)
			[GetSpellInfo(117485)] = 7, --Impeding Thrust (slow debuff)
			-- Strength
			[GetSpellInfo(116550)] = 7, --Energizing Smash (knock down)
			-- Titan Spark (Heroic)
			[GetSpellInfo(116829)] = 7, --Focused Energy (fixate)

        },
		
        [824] = { --[[ Dragon Soul ]]--
           --Deep Corruption IDs
           [109389] = 8,
           [103628] = 8,

            --Ultraxion
            [GetSpellInfo(109075)] = 7, -- Fading Light
        },

        [800] = { --[[ Firelands ]]--

            --Baleroc
            [GetSpellInfo(100232)] = 9, -- Torment
        },

        [752] = { --[[ Baradin Hold ]]--

            [GetSpellInfo(88954)] = 6, -- Consuming Darkness
        },
        
        [754] = { --[[ Blackwing Descent ]]--

            --Magmaw
            [GetSpellInfo(78941)] = 6, -- Parasitic Infection
            [GetSpellInfo(89773)] = 7, -- Mangle

            --Omnitron Defense System
            [GetSpellInfo(79888)] = 6, -- Lightning Conductor
            [GetSpellInfo(79505)] = 8, -- Flamethrower
            [GetSpellInfo(80161)] = 7, -- Chemical Cloud
            [GetSpellInfo(79501)] = 8, -- Acquiring Target
            [GetSpellInfo(80011)] = 7, -- Soaked in Poison
            [GetSpellInfo(80094)] = 7, -- Fixate
            [GetSpellInfo(92023)] = 9, -- Encasing Shadows
            [GetSpellInfo(92048)] = 9, -- Shadow Infusion
            [GetSpellInfo(92053)] = 9, -- Shadow Conductor
            --[GetSpellInfo(91858)] = 6, -- Overcharged Power Generator
            
            --Maloriak
            [GetSpellInfo(92973)] = 8, -- Consuming Flames
            [GetSpellInfo(92978)] = 8, -- Flash Freeze
            [GetSpellInfo(92976)] = 7, -- Biting Chill
            [GetSpellInfo(91829)] = 7, -- Fixate
            [GetSpellInfo(92787)] = 9, -- Engulfing Darkness

            --Atramedes
            [GetSpellInfo(78092)] = 7, -- Tracking
            [GetSpellInfo(78897)] = 8, -- Noisy
            [GetSpellInfo(78023)] = 7, -- Roaring Flame

            --Chimaeron
            [GetSpellInfo(89084)] = 8, -- Low Health
            [GetSpellInfo(82881)] = 7, -- Break
            [GetSpellInfo(82890)] = 9, -- Mortality

            --Nefarian
            [GetSpellInfo(94128)] = 7, -- Tail Lash
            --[GetSpellInfo(94075)] = 8, -- Magma
            [GetSpellInfo(79339)] = 9, -- Explosive Cinders
            [GetSpellInfo(79318)] = 9, -- Dominion
        },

        [758] = { --[[ The Bastion of Twilight ]]--

            --Halfus
            [GetSpellInfo(39171)] = 7, -- Malevolent Strikes
            [GetSpellInfo(86169)] = 8, -- Furious Roar

            --Valiona & Theralion
            [GetSpellInfo(86788)] = 6, -- Blackout
            [GetSpellInfo(86622)] = 7, -- Engulfing Magic
            [GetSpellInfo(86202)] = 7, -- Twilight Shift

            --Council
            [GetSpellInfo(82665)] = 7, -- Heart of Ice
            [GetSpellInfo(82660)] = 7, -- Burning Blood
            [GetSpellInfo(82762)] = 7, -- Waterlogged
            [GetSpellInfo(83099)] = 7, -- Lightning Rod
            [GetSpellInfo(82285)] = 7, -- Elemental Stasis
            [GetSpellInfo(92488)] = 8, -- Gravity Crush

            --Cho'gall
            [GetSpellInfo(86028)] = 6, -- Cho's Blast
            [GetSpellInfo(86029)] = 6, -- Gall's Blast
            [GetSpellInfo(93189)] = 7, -- Corrupted Blood
            [GetSpellInfo(93133)] = 7, -- Debilitating Beam
            [GetSpellInfo(81836)] = 8, -- Corruption: Accelerated
            [GetSpellInfo(81831)] = 8, -- Corruption: Sickness
            [GetSpellInfo(82125)] = 8, -- Corruption: Malformation
            [GetSpellInfo(82170)] = 8, -- Corruption: Absolute

            --Sinestra
            [GetSpellInfo(92956)] = 9, -- Wrack
        },

        [773] = { --[[ Throne of the Four Winds ]]--

            --Conclave
            [GetSpellInfo(85576)] = 9, -- Withering Winds
            [GetSpellInfo(85573)] = 9, -- Deafening Winds
            [GetSpellInfo(93057)] = 7, -- Slicing Gale
            [GetSpellInfo(86481)] = 8, -- Hurricane
            [GetSpellInfo(93123)] = 7, -- Wind Chill
            [GetSpellInfo(93121)] = 8, -- Toxic Spores

            --Al'Akir
            --[GetSpellInfo(93281)] = 7, -- Acid Rain
            [GetSpellInfo(87873)] = 7, -- Static Shock
            [GetSpellInfo(88427)] = 7, -- Electrocute
            [GetSpellInfo(93294)] = 8, -- Lightning Rod
            [GetSpellInfo(93284)] = 9, -- Squall Line
        },
    },
}
