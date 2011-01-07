local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_Freebgrid was unable to locate oUF install.")

local mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"

-- These are just the defaults that are created at first login.
ns.defaults = {
    locked = true,

    scale = 1.0,
    width = 42,
    height = 42,

    powerbar = false,
    powerbarsize = 0.08,
    porientation = "VERTICAL",

    reversecolors = false,

    iconsize = 12,
    debuffsize = 18,
    fontsize = 14,

    inRange = 1,
    outsideRange = 0.4,

    texture = "gradient",
    textureSM = mediapath.."gradient",

    font = "calibri",
    fontSM = mediapath.."calibri.ttf",

    outline = "",

    showBlizzParty = false,
    solo = false,
    player = true,
    partyOn = true,

    pets = false,

    MT = true,
    MTT = false,

    symbolsize = 11,
    indicatorsize = 6,

    numCol = 8,
    numUnits = 5,
    spacing = 5,

    orientation = "VERTICAL",
    point = "TOP",
    growth = "RIGHT",

    framebg = false,

    healcommtext = true,
    healcommbar = false,
    healcommoverflow = true,
    healothersonly = false,
    healalpha = 0.4, 

    rescomm =  true,
    rescommalpha = 0.6,

    showname = false,

    disableomf = false,
    omfChar = false,

    lfdicon = true,

    frequent = false,
    multi = false,

    frequpdate = 0.5,
    arrow = true,
    mouseover = true,
}

ns.orientation = {
    ["VERTICAL"] = "VERTICAL",
    ["HORIZONTAL"] = "HORIZONTAL",
}

ns.point = {
    ["TOP"] = "TOP",
    ["RIGHT"] = "RIGHT",
    ["BOTTOM"] = "BOTTOM",
    ["LEFT"] = "LEFT",
}

ns.growth = {
    ["UP"] = "UP",
    ["RIGHT"] = "RIGHT",
    ["DOWN"] = "DOWN",
    ["LEFT"] = "LEFT",
}

ns.outline = {
    ["None"] = "",
    ["OUTLINE"] = "OUTLINE",
    ["THINOUTLINE"] = "THINOUTLINE",
    ["MONOCHROME"] = "MONOCHROME",
    ["OUTLINEMONO"] = "THINOUTLINEMONOCHROME",
}

ns.textures = {
    ["gradient"] = mediapath.."gradient",
    ["Cabaret"] = mediapath.."Cabaret",
}

ns.fonts = {
    ["calibri"] = mediapath.."calibri.ttf",
    ["Accidental Presidency"] = mediapath.."Accidental Presidency.ttf",
    ["Expressway"] = mediapath.."expressway.ttf",
}

local SM = LibStub("LibSharedMedia-3.0", true)
do
    local frame = CreateFrame"Frame"
    frame:RegisterEvent"ADDON_LOADED"
    frame:SetScript("OnEvent", function(self, event, addon)
        if addon ~= ADDON_NAME then return end

        if SM then
            for font, path in pairs(ns.fonts) do
                SM:Register("font", font, path)
            end

            for tex, path in pairs(ns.textures) do
                SM:Register("statusbar", tex, path)
            end

            wipe(ns.fonts)
            for i, v in pairs(SM:List("font")) do
                table.insert(ns.fonts, v)
                ns.fonts[v] = SM:Fetch("font", v)
            end

            wipe(ns.textures)
            for i, v in pairs(SM:List("statusbar")) do
                table.insert(ns.textures, v)
                ns.textures[v] = SM:Fetch("statusbar", v)
            end
        end

        self:UnregisterEvent"ADDON_LOADED"
    end)
end

local generalopts = {
    type = "group", name = "General", order = 1,
    args = {
        scale = {
            name = "Scale",
            type = "range",
            order = 1,
            min = 0.5,
            max = 2.0,
            step = .05,
            get = function(info) return ns.db.scale end,
            set = function(info,val) ns.db.scale = val end,
        },
        width = {
            name = "Width",
            type = "range",
            order = 2,
            min = 20,
            max = 150,
            step = 1,
            get = function(info) return ns.db.width end,
            set = function(info,val) ns.db.width = val end,
        },
        height = {
            name = "Height",
            type = "range",
            order = 3,
            min = 20,
            max = 150,
            step = 1,
            get = function(info) return ns.db.height end,
            set = function(info,val) ns.db.height = val end,
        },
        statusbar = {
            name = "Statusbar",
            type = "select",
            order = 4,
            dialogControl = "LSM30_Statusbar",
            values = SM:HashTable("statusbar"),
            get = function(info) return ns.db.texture end,
            set = function(info, val) ns.db.texture = val; ns.db.textureSM = SM:Fetch("statusbar",val) end,
        },
        orientation = {
            name = "Statusbar Orientation",
            type = "select",
            order = 5,
            values = ns.orientation,
            get = function(info) return ns.db.orientation end,
            set = function(info,val) ns.db.orientation = val end,
        },
        point = {
            name = "Point Direction",
            type = "select",
            order = 6,
            values = ns.point,
            get = function(info) return ns.db.point end,
            set = function(info,val) ns.db.point = val end,
        },
        growth ={
            name = "Growth Direction",
            type = "select",
            order = 7,
            values = ns.growth,
            get = function(info) return ns.db.growth end,
            set = function(info,val) ns.db.growth = val end,
        },
        units = {
            name = "Units per group",
            type = "range",
            order = 11,
            min = 1,
            max = 40,
            step = 1,
            disabled = function(info) if ns.db.multi then return true end end,
            get = function(info) return ns.db.numUnits end,
            set = function(info,val) ns.db.numUnits = val end,
        },
        groups = {
            name = "Number of groups",
            type = "range",
            order = 9,
            min = 1,
            max = 8,
            step = 1,
            get = function(info) return ns.db.numCol end,
            set = function(info,val) ns.db.numCol = val end,
        },
        spacing = {
            name = "Space between units",
            type = "range",
            order = 8,
            min = 0,
            max = 30,
            step = 1,
            get = function(info) return ns.db.spacing end,
            set = function(info,val) ns.db.spacing = val end,
        },
        multi = {
            name = "Multiple headers",
            type = "toggle",
            desc = "Use multiple headers for better sorting. Note: This disables units per group and sets it to 5.",
            order = 10,
            get = function(info) return ns.db.multi end,
            set = function(info,val) ns.db.multi = val end,
        },
        power = {
            name = "Enable PowerBars",
            type = "toggle",
            order = 12,
            get = function(info) return ns.db.powerbar end,
            set = function(info,val) ns.db.powerbar = val end,
        },
        porientation = {
            name = "PowerBar Orientation",
            type = "select",
            order = 13,
            values = ns.orientation,
            get = function(info) return ns.db.porientation end,
            set = function(info,val) ns.db.porientation = val end,
        },
        psize = {
            name = "PowerBar size",
            type = "range",
            order = 14,
            min = .02,
            max = .30,
            step = .02,
            get = function(info) return ns.db.powerbarsize end,
            set = function(info,val) ns.db.powerbarsize = val end,
        },
    },
}

local fontopts = {
    type = "group", name = "Font", order = 2,
    args = {
        font = {
            name = "Font",
            type = "select",
            order = 1,
            dialogControl = "LSM30_Font",
            values = SM:HashTable("font"),
            get = function(info) return ns.db.font end,
            set = function(info, val) ns.db.font = val; ns.db.fontSM = SM:Fetch("font",val) end,
        },
        outline = {
            name = "Font Flag",
            type = "select",
            order = 2,
            values = ns.outline,
            get = function(info) return ns.db.outline end,
            set = function(info,val) ns.db.outline = val end,
        },
        fontsize = {
            name = "Font Size",
            type = "range",
            order = 3,
            min = 8,
            max = 32,
            step = 1,
            get = function(info) return ns.db.fontsize end,
            set = function(info,val) ns.db.fontsize = val end,
        },
    },
}

local rangeopts = {
    type = "group", name = "Range", order = 3,
    args = {
        oor = {
            name = "Out of range alpha",
            type = "range",
            order = 1,
            min = 0,
            max = 1,
            step = .1,
            get = function(info) return ns.db.outsideRange end,
            set = function(info,val) ns.db.outsideRange = val end,
        },
        arrow = {
            name = "Enable range arrow",
            type = "toggle",
            order = 2,
            get = function(info) return ns.db.arrow end,
            set = function(info,val) ns.db.arrow = val end,
        },
        mouseover = {
            name = "Only show on mouseover",
            type = "toggle",
            order = 3,
            get = function(info) return ns.db.mouseover end,
            set = function(info,val) ns.db.mouseover = val end,
        },
    },
}

local healopts = {
    type = "group", name = "HealPrediction", order = 4,
    args = {
        text = {
            name = "Text",
            type = "toggle",
            order = 1,
            get = function(info) return ns.db.healcommtext end,
            set = function(info,val) ns.db.healcommtext= val end,
        },
        bar = {
            name = "Bar",
            type = "toggle",
            order = 2,
            get = function(info) return ns.db.healcommbar end,
            set = function(info,val) ns.db.healcommbar = val end,
        },
        overflow = {
            name = "Overflow",
            type = "toggle",
            order = 4,
            get = function(info) return ns.db.healcommoverflow end,
            set = function(info,val) ns.db.healcommoverflow = val end,
        },
        others = {
            name = "Others' heals only",
            type = "toggle",
            order = 5,
            get = function(info) return ns.db.healothersonly end,
            set = function(info,val) ns.db.healothersonly = val end,
        },
        alpha = {
            name = "Bar alpha",
            type = "range",
            order = 3,
            min = 0,
            max = 1,
            step = .1,
            get = function(info) return ns.db.healalpha end,
            set = function(info,val) ns.db.healalpha = val end,
        },
    },
}

local miscopts = {
    type = "group", name = "Miscellaneous", order = 5,
    args = {
        party = {
            name = "Show in party",
            type = "toggle",
            order = 1,
            get = function(info) return ns.db.partyOn end,
            set = function(info,val) ns.db.partyOn = val end,
        },
        solo = {
            name = "Show player when solo",
            type = "toggle",
            order = 2,
            get = function(info) return ns.db.solo end,
            set = function(info,val) ns.db.solo = val end,
        },
        player = {
            name = "Show self in group",
            type = "toggle",
            order = 3,
            get = function(info) return ns.db.player end,
            set = function(info,val) ns.db.player = val end,
        },
        lfd = {
            name = "Show role icon",
            type = "toggle",
            order = 4,
            get = function(info) return ns.db.lfdicon end,
            set = function(info,val) ns.db.lfdicon = val end,
        },
        pets = {
            name = "Show party/raid pets",
            type = "toggle",
            order = 5,
            get = function(info) return ns.db.pets end,
            set = function(info,val) ns.db.pets = val end,
        },
        MT = {
            name = "Show MainTanks",
            type = "toggle",
            order = 6,
            get = function(info) return ns.db.MT end,
            set = function(info,val) ns.db.MT = val end,
        },
        omfChar = {
            name = "Save position per character",
            type = "toggle",
            order = 7,
            get = function(info) return ns.db.omfChar end,
            set = function(info,val) ns.db.omfChar = val end,
        },
        indicator = {
            name = "Indicator size",
            type = "range",
            order = 8,
            min = 4,
            max = 20,
            step = 1,
            get = function(info) return ns.db.indicatorsize end,
            set = function(info,val) ns.db.indicatorsize = val end,
        },
        symbol = {
            name = "Symbol size",
            type = "range",
            order = 9,
            min = 8,
            max = 20,
            step = 1,
            get = function(info) return ns.db.symbolsize end,
            set = function(info,val) ns.db.symbolsize = val end,
        },
        icon = {
            name = "Icon size",
            type = "range",
            order = 10,
            min = 8,
            max = 20,
            step = 1,
            get = function(info) return ns.db.iconsize end,
            set = function(info,val) ns.db.iconsize = val end,
        },
        aura = {
            name = "Aura size",
            type = "range",
            order = 11,
            min = 8,
            max = 30,
            step = 1,
            get = function(info) return ns.db.debuffsize end,
            set = function(info,val) ns.db.debuffsize = val end,
        },
        tagupdate = {
            name = "Tag update frequency",
            type = "range",
            order = 12,
            min = .1,
            max = 1,
            step = .05,
            get = function(info) return ns.db.frequpdate end,
            set = function(info,val) ns.db.frequpdate = val end,
        },
    },
}

local coloropts = {
    type = "group", name = "Colors", order = 6,
    args = {
        reverse = {
            name = "Reverse health colors",
            type = "toggle",
            order = 1,
            get = function(info) return ns.db.reversecolors end,
            set = function(info,val) ns.db.reversecolors = val end,
        },
    },
}

local options = {
    type = "group", name = "Freebgrid",
    args = {
        unlock = {
            name = "Toggle anchors",
            type = "execute",
            func = function() ns:Movable(); end,
            order = 1,
        },
        reload = {
            name = "Reload UI",
            type = "execute",
            func = function() ReloadUI(); end,
            order = 2,
        },
        general = generalopts,
        font = fontopts,
        range = rangeopts,
        heal = healopts,
        misc = miscopts,
        color = coloropts,
    },
}

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable(ADDON_NAME, options)

local ACD = LibStub('AceConfigDialog-3.0')
ACD:AddToBlizOptions(ADDON_NAME, ADDON_NAME)
