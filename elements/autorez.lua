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
        combat = GetSpellInfo(20707),
    },

    ["Priest"] = {
        ooc = GetSpellInfo(2006),
    },
}

local body = ""
local function macroBody(class)
    local combatspell = classList[class].combat
    local oocspell = classList[class].ooc
    
    
    if combatspell then
        body = "/cast [combat,help,dead,@mouseover] " .. combatspell .. "; "
        
        if oocspell then
            body = body .. "[help,dead,@mouseover] " .. oocspell .. "; "    
        end
    elseif oocspell then
        body = "/cast [help,dead,@mouseover] " .. oocspell .. "; "
    end

    body = body .. "\n/tar [nodead,@mouseover]"
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
        updateMacro()

        if not IsAddOnLoaded("Clique") then
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
