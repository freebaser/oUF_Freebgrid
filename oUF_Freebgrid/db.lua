local ADDON_NAME, ns = ...

ns.mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"

ns.defaults = {
    scale = 1.0,
    width = 42,
    height = 42,
    texture = "gradient",
    texturePath = ns.mediapath.."gradient",
    font = "calibri",
    fontPath = ns.mediapath.."calibri.ttf",
    fontsize = 14,
    fontsizeEdge = 14,
    outline = nil,
    solo = false,
    player = true,
    party = true,
    numCol = 8,
    numUnits = 5,
    spacing = 5,
    orientation = "VERTICAL",
    porientation = "VERTICAL",
    horizontal = false,
    growth = "RIGHT",
    omfChar = false,
    reversecolors = false,
    definecolors = false,
    powerbar = false,
    powerbarsize = .08,
    outsideRange = .40,
    arrow = true,
    arrowmouseover = true,
    healtext = false,
    healbar = true,
    healoverflow = true,
    healothersonly = false,
    healalpha = .40,
    roleicon = false,
    pets = false,
    MT = false,
    indicatorsize = 6,
    symbolsize = 11,
    leadersize = 12,
    aurasize = 18,
    multi = false,
    deficit = true,
    hpcolor = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
    hpbgcolor = { r = 0.33, g = 0.33, b = 0.33, a = 1 },
    tborder = true,
    fborder = true,
    afk = true,
    highlight = true,
    dispel = true,
    powerclass = false,
}

function ns.InitDB()
    _G[ADDON_NAME.."DB"] = _G[ADDON_NAME.."DB"] or {}
    ns.db = _G[ADDON_NAME.."DB"]

    for k, v in pairs(ns.defaults) do
        if(type(_G[ADDON_NAME.."DB"][k]) == 'nil') then
            _G[ADDON_NAME.."DB"][k] = v
        end
    end
end

function ns.FlushDB()
    for i,v in pairs(ns.defaults) do if ns.db[i] == v and type(ns.db[i]) ~= "table" then ns.db[i] = nil end end
    --for i,v in pairs(ns.db) do ns.db[i] = nil end
end

