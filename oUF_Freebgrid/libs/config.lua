local ADDON_NAME, ns = "oUF_Freebgrid", Freebgrid_NS

local indicator = ns.mediapath.."squares.ttf"
local symbols = ns.mediapath.."PIZZADUDEBULLETS.ttf"

ns.outline = {
    ["None"] = "None",
    ["OUTLINE"] = "OUTLINE",
    ["THINOUTLINE"] = "THINOUTLINE",
    ["MONOCHROME"] = "MONOCHROME",
    ["OUTLINEMONO"] = "OUTLINEMONOCHROME",
}

ns.orientation = {
    ["VERTICAL"] = "VERTICAL",
    ["HORIZONTAL"] = "HORIZONTAL",
}

local function updateFonts(object)
    object.Name:SetFont(ns.db.fontPath, ns.db.fontsize, ns.db.outline)
    object.Name:SetWidth(ns.db.width)
    object.AFKtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
    object.AFKtext:SetWidth(ns.db.width)
    object.AuraStatusCen:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
    object.AuraStatusCen:SetWidth(ns.db.width)
    object.Healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
    object.Healtext:SetWidth(ns.db.width)
end

local function updateIndicators(object)
    object.AuraStatusTL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusTR:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusBL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
    object.AuraStatusBR:SetFont(symbols, ns.db.symbolsize, "THINOUTLINE")
end

local function updateIcons(object)
    object.Leader:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.MasterLooter:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.RaidIcon:SetSize(ns.db.leadersize+2, ns.db.leadersize+2)
    object.ReadyCheck:SetSize(ns.db.leadersize, ns.db.leadersize)
    object.freebAuras.button:SetSize(ns.db.aurasize, ns.db.aurasize)
    object.freebAuras.size = ns.db.aurasize
end

local lockprint
local function updateObjects()
    if(InCombatLockdown()) then
        ns:RegisterEvent("PLAYER_REGEN_ENABLED")
        if not lockprint then
            lockprint = true
            print("Your in combat silly. Delaying updates until combat ends.")
        end
        return
    end

    for _, object in next, ns._Objects do
        object:SetSize(ns.db.width, ns.db.height)
        object:SetScale(ns.db.scale)

        ns:UpdateHealth(object.Health)
        ns:UpdatePower(object.Power)
        if UnitExists(object.unit) then
            object.Health:ForceUpdate()
            object.Power:ForceUpdate()
        end 
        updateFonts(object)
        updateIndicators(object)
        updateIcons(object)

        ns:UpdateName(object.Name, object.unit)
    end

    _G["oUF_FreebgridRaidFrame"]:SetSize(ns.db.width, ns.db.height)
    _G["oUF_FreebgridPetFrame"]:SetSize(ns.db.width, ns.db.height)
    _G["oUF_FreebgridMTFrame"]:SetSize(ns.db.width, ns.db.height)
end

function ns:PLAYER_REGEN_ENABLED()
    lockprint = nil
    updateObjects()

    ns:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

local SM = LibStub("LibSharedMedia-3.0", true)
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
            set = function(info,val) ns.db.scale = val; updateObjects() end,
        },
        width = {
            name = "Width",
            type = "range",
            order = 2,
            min = 20,
            max = 150,
            step = 1,
            get = function(info) return ns.db.width end,
            set = function(info,val) ns.db.width = val; wipe(ns.nameCache); updateObjects() end,
        },
        height = {
            name = "Height",
            type = "range",
            order = 3,
            min = 20,
            max = 150,
            step = 1,
            get = function(info) return ns.db.height end,
            set = function(info,val) ns.db.height = val; updateObjects() end,
        },
        sort = {
            name = "Sorting",
            type = "header",
            order = 5,
        },
        horizontal = {
            name = "Horizontal groups",
            type = "toggle",
            order = 6,
            get = function(info) return ns.db.horizontal end,
            set = function(info,val)
                if(val == true and (ns.db.growth ~= "UP" or ns.db.growth ~= "DOWN")) then
                    ns.db.growth = "UP"
                elseif(val == false and (ns.db.growth ~= "RIGHT" or ns.db.growth ~= "LEFT")) then
                    ns.db.growth = "RIGHT"
                end
                ns.db.horizontal = val; 
            end,
        },
        growth ={
            name = "Growth Direction",
            type = "select",
            order = 7,
            values = function(info,val) 
                info = ns.db.growth
                if not ns.db.horizontal then
                    return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
                else
                    return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
                end
            end,
            get = function(info) return ns.db.growth end,
            set = function(info,val) ns.db.growth = val; end,
        },
        multi = {
            name = "Multiple headers",
            type = "toggle",
            desc = "Use multiple headers for better group sorting. Note: This disables units per group and sets it to 5.",
            order = 10,
            get = function(info) return ns.db.multi end,
            set = function(info,val) ns.db.multi = val end,
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
            set = function(info,val) ns.db.numUnits = val; end,
        },
        groups = {
            name = "Number of groups",
            type = "range",
            order = 9,
            min = 1,
            max = 8,
            step = 1,
            get = function(info) return ns.db.numCol end,
            set = function(info,val) ns.db.numCol = val; end,
        },
        spacing = {
            name = "Space between units",
            type = "range",
            order = 4,
            min = 0,
            max = 30,
            step = 1,
            get = function(info) return ns.db.spacing end,
            set = function(info,val) ns.db.spacing = val; end,
        }, 
    },
}

local statusbaropts = {
    type = "group", name = "StatusBars", order = 2,
    args = {
        statusbar = {
            name = "Statusbar",
            type = "select",
            order = 4,
            dialogControl = "LSM30_Statusbar",
            values = SM:HashTable("statusbar"),
            get = function(info) return ns.db.texture end,
            set = function(info, val) ns.db.texture = val; ns.db.texturePath = SM:Fetch("statusbar",val); updateObjects() end,
        },
        orientation = {
            name = "Health Orientation",
            type = "select",
            order = 5,
            values = ns.orientation,
            get = function(info) return ns.db.orientation end,
            set = function(info,val) ns.db.orientation = val; updateObjects() end,
        },
        powerbar = {
            name = "Power Bar",
            type = "header",
            order = 11,
        },
        power = {
            name = "Enable PowerBars",
            type = "toggle",
            order = 12,
            get = function(info) return ns.db.powerbar end,
            set = function(info,val) ns.db.powerbar = val; updateObjects() end,
        },
        porientation = {
            name = "PowerBar Orientation",
            type = "select",
            order = 13,
            values = ns.orientation,
            get = function(info) return ns.db.porientation end,
            set = function(info,val) ns.db.porientation = val; updateObjects() end,
        },
        psize = {
            name = "PowerBar size",
            type = "range",
            order = 14,
            min = .02,
            max = .30,
            step = .02,
            get = function(info) return ns.db.powerbarsize end,
            set = function(info,val) ns.db.powerbarsize = val; updateObjects() end,
        },
    },
}

local fontopts = {
    type = "group", name = "Font", order = 3,
    args = {
        font = {
            name = "Font",
            type = "select",
            order = 1,
            dialogControl = "LSM30_Font",
            values = SM:HashTable("font"),
            get = function(info) return ns.db.font end,
            set = function(info, val) ns.db.font = val; ns.db.fontPath = SM:Fetch("font",val); 
                wipe(ns.nameCache); updateObjects() 
            end,
        },
        outline = {
            name = "Font Flag",
            type = "select",
            order = 2,
            values = ns.outline,
            get = function(info) 
                if not ns.db.outline then
                    return "None"
                else
                    return ns.db.outline
                end
            end,
            set = function(info,val) 
                if val == "None" then
                    ns.db.outline = nil
                else
                    ns.db.outline = val
                end
                updateObjects()
            end,
        },
        fontsize = {
            name = "Font Size",
            type = "range",
            order = 3,
            min = 8,
            max = 32,
            step = 1,
            get = function(info) return ns.db.fontsize end,
            set = function(info,val) ns.db.fontsize = val; wipe(ns.nameCache); updateObjects() end,
        },
        fontsizeEdge = {
            name = "Edge Font Size",
            type = "range",
            order = 4,
            desc = "Size of the Top and Bottom font strings",
            min = 8,
            max = 32,
            step = 1,
            get = function(info) return ns.db.fontsizeEdge  end,
            set = function(info,val) ns.db.fontsizeEdge = val; wipe(ns.nameCache); updateObjects() end,
        },
    },
}

local rangeopts = {
    type = "group", name = "Range", order = 4,
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
            disabled = function(info) if not ns.db.arrow then return true end end,
            get = function(info) return ns.db.arrowmouseover end,
            set = function(info,val) ns.db.arrowmouseover = val end,
        },
    },
}

local healopts = {
    type = "group", name = "HealPrediction", order = 5,
    args = {
        text = {
            name = "Incoming heal text",
            type = "toggle",
            order = 1,
            get = function(info) return ns.db.healtext end,
            set = function(info,val) ns.db.healtext= val end,
        },
        bar = {
            name = "Incoming heal bar",
            type = "toggle",
            order = 2,
            get = function(info) return ns.db.healbar end,
            set = function(info,val) ns.db.healbar = val end,
        },
        overflow = {
            name = "Heal overflow",
            type = "toggle",
            order = 4,
            get = function(info) return ns.db.healoverflow end,
            set = function(info,val) ns.db.healoverflow = val end,
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
        deficit = {
            name = "Show missing health",
            type = "toggle",
            order = 6,
            get = function(info) return ns.db.deficit end,
            set = function(info,val) ns.db.deficit = val end,
        },
    },
}

local miscopts = {
    type = "group", name = "Miscellaneous", order = 6,
    args = {
        party = {
            name = "Show when in a party",
            type = "toggle",
            order = 1,
            get = function(info) return ns.db.party end,
            set = function(info,val) ns.db.party = val; end,
        },
        solo = {
            name = "Show player when solo",
            type = "toggle",
            order = 2,
            get = function(info) return ns.db.solo end,
            set = function(info,val) ns.db.solo = val; end,
        },
        player = {
            name = "Show self in group",
            type = "toggle",
            order = 3,
            get = function(info) return ns.db.player end,
            set = function(info,val) ns.db.player = val; end,
        },
        pets = {
            name = "Show party/raid pets",
            type = "toggle",
            order = 4,
            get = function(info) return ns.db.pets end,
            set = function(info,val) ns.db.pets = val end,
        },
        MT = {
            name = "MainTanks",
            type = "toggle",
            order = 5,
            get = function(info) return ns.db.MT end,
            set = function(info,val) ns.db.MT = val end,
        },
        omfChar = {
            name = "Save position per character",
            type = "toggle",
            order = 6,
            get = function(info) return ns.db.omfChar end,
            set = function(info,val) ns.db.omfChar = val end,
        },
        role = {
            name = "Role icon",
            type = "toggle",
            order = 7,
            get = function(info) return ns.db.roleicon end,
            set = function(info,val) ns.db.roleicon = val end,
        },
        tborder = {
            name = "Show target border",
            type = "toggle",
            order = 8,
            get = function(info) return ns.db.tborder end,
            set = function(info,val) ns.db.tborder = val end,
        },
        fborder = {
            name = "Show focus border",
            type = "toggle",
            order = 9,
            get = function(info) return ns.db.fborder end,
            set = function(info,val) ns.db.fborder = val end,
        },
        afk = {
            name = "AFK flag/timer",
            type = "toggle",
            order = 10,
            get = function(info) return ns.db.afk end,
            set = function(info,val) ns.db.afk = val end,
        },
        highlight = {
            name = "Mouseover highlight",
            type = "toggle",
            order = 11,
            get = function(info) return ns.db.highlight end,
            set = function(info,val) ns.db.highlight = val end,
        },
        dispel = {
            name = "Dispel icons",
            type = "toggle",
            desc = "Show auras as icons that can be dispelled by you",
            order = 12,
            get = function(info) return ns.db.dispel end,
            set = function(info,val) ns.db.dispel = val end,
        },
        indicator = {
            name = "Indicator size",
            type = "range",
            order = 15,
            min = 4,
            max = 20,
            step = 1,
            get = function(info) return ns.db.indicatorsize end,
            set = function(info,val) ns.db.indicatorsize = val; updateObjects() end,
        },
        symbol = {
            name = "Bottom right indicator size",
            type = "range",
            order = 16,
            min = 8,
            max = 20,
            step = 1,
            get = function(info) return ns.db.symbolsize end,
            set = function(info,val) ns.db.symbolsize = val; updateObjects() end,
        },
        icon = {
            name = "Leader, raid, role icon size",
            type = "range",
            order = 17,
            min = 8,
            max = 20,
            step = 1,
            get = function(info) return ns.db.leadersize end,
            set = function(info,val) ns.db.leadersize = val; updateObjects() end,
        },
        aura = {
            name = "Aura size",
            type = "range",
            order = 18,
            min = 8,
            max = 30,
            step = 1,
            get = function(info) return ns.db.aurasize end,
            set = function(info,val) ns.db.aurasize = val; updateObjects() end,
        },
    },
}

local coloropts = {
    type = "group", name = "Colors", order = 7,
    args = {
        reverse = {
            name = "Reverse health colors",
            type = "toggle",
            order = 1,
            --disabled = function(info) if ns.db.definecolors then return false end end,
            get = function(info) return ns.db.reversecolors end,
            set = function(info,val) ns.db.reversecolors = val;
                if ns.db.definecolors and val == true then
                    ns.db.definecolors = false
                end
                ns:Colors(); updateObjects(); end,
        },
        powerclass = {
            name = "Color power by class",
            type = "toggle",
            order = 2,
            get = function(info) return ns.db.powerclass end,
            set = function(info,val) ns.db.powerclass = val; updateObjects(); end,
        },
        definecolors = {
            name = "Use defined colors",
            type = "toggle",
            order = 3,
            get = function(info) return ns.db.definecolors end,
            set = function(info,val) ns.db.definecolors = val;
                if ns.db.reversecolors and val == true then
                    ns.db.reversecolors = false
                end
                ns:Colors(); updateObjects(); 
            end,
        },
        hpcolor = {
            name = "Health color",
            type = "color",
            order = 4,
            hasAlpha = false,
            get = function(info) return ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b, ns.db.hpcolor.a end,
            set = function(info,r,g,b,a) ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b, ns.db.hpcolor.a = r,g,b,a;
                ns:Colors(); updateObjects(); end,
        },
        hpbgcolor = {
            name = "Health background color",
            type = "color",
            order = 5,
            hasAlpha = false,
            get = function(info) return ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b, ns.db.hpbgcolor.a end,
            set = function(info,r,g,b,a) ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b, ns.db.hpbgcolor.a = r,g,b,a;
                ns:Colors(); updateObjects(); end,
        },
    },
}

local options = {
    type = "group", name = ADDON_NAME,
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
            desc = "Most options require a ReloadUI() to take effect.",
            func = function() ReloadUI(); end,
            order = 2,
        },
        general = generalopts,
        statusbar = statusbaropts,
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

InterfaceOptions_AddCategory(ns.movableopt)
LibStub("tekKonfig-AboutPanel").new(ADDON_NAME, ADDON_NAME)