local parent, ns = ...
local oUF = ns.oUF or oUF

local macroName = "FreebAutoRez"
local macroid

local classList = {
    ["DRUID"] = {
        combat = GetSpellInfo(20484), -- Rebirth
        ooc = GetSpellInfo(50769), -- Revive    
    },

    ["WARLOCK"] = {
        combat = GetSpellInfo(6203),
        ooc = GetSpellInfo(6203),
    },

    ["PRIEST"] = {
        ooc = GetSpellInfo(2006),
    },

    ["SHAMAN"] = {
        ooc = GetSpellInfo(2008),
    },

    ["PALADIN"] = {
        ooc = GetSpellInfo(7328),
    },

    ["DEATHKNIGHT"] = {
        combat = GetSpellInfo(61999),
    }
}

local body = ""
local function macroBody(class)
    local combatspell = classList[class].combat
    local oocspell = classList[class].ooc
   
    body = "/tar [nocombat,nodead,@mouseover]\n/stopmacro [nodead,@mouseover]\n"
    if combatspell then
        body = body .. "/cast [combat,help,dead,@mouseover] " .. combatspell .. "; "
        
        if oocspell then
            body = body .. "[help,dead,@mouseover] " .. oocspell .. "; "
        end

        if class == "WARLOCK" then
            body = body .. "\n/cast Create Soulstone\n "
        end
    elseif oocspell then
        body = "/cast [help,dead,@mouseover] " .. oocspell .. "; "
    end

    --body = body .. "\n/say test"
end

local function updateMacro()
    macroid = GetMacroIndexByName(macroName)
    
    if macroid > 0 then
        EditMacro(macroid, nil, nil, body)
    else
        macroid = CreateMacro(macroName, 1, body)
    end
end


local Enable = function(self)
    local _, class = UnitClass("player")
    if not class then return end

    if classList[class] then
        macroBody(class)

        if IsAddOnLoaded("Clique") then
            updateMacro()
        else
            self:SetAttribute("type1", "macro")
            self:SetAttribute("macrotext1", body)
        end
    end
end

local Disable = function(self)
    if not IsAddOnLoaded("Clique") then
        self:SetAttribute("type1", nil)
        self:SetAttribute("macrotext1", nil)
    end
end

oUF:AddElement('freebAutoRez', nil, Enable, Disable)
