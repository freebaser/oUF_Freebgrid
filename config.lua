local ADDON_NAME, ns = ...
local mediapath = "Interface\\AddOns\\oUF_Freebgrid\\media\\"

-- These are just the defaults that are created as a base.
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

    lfdicon = true,

    frequent = false,
    multi = false,

    frequpdate = 0.5,
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

function ns:SetTex(v)
    if v then self.db.texture = v end
end

function ns:SetFont(v)
    if v then self.db.font = v end
end

function ns:SetOrientation(v)
    if v then self.db.orientation = v end
end

function ns:SetpOrientation(v)
    if v then self.db.porientation = v end
end

function ns:SetPoint(v)
    if v then self.db.point = v end
end

function ns:SetGrowth(v)
    if v then self.db.growth = v end
end

function ns:SetOutline(v)
    if v then self.db.outline = v end
end

----------------------
--      Locals      --
----------------------

local tekcheck = LibStub("tekKonfig-Checkbox")
local tekbutton = LibStub("tekKonfig-Button")
local tekslider = LibStub("tekKonfig-Slider")
local tekdropdown = LibStub("tekKonfig-Dropdown")
local GAP = 7
local SM

local function texfunc(frame)
    local texturedropdown, texturedropdowntext, texturedropdowncontainer = tekdropdown.new(frame, "Texture", "TOPRIGHT", frame, 0, 0)
    texturedropdowntext:SetText(ns.db.texture or ns.defaults.texture)
    texturedropdown.tiptext = "Change the unit's texture."

    local function OnClick(self)
        UIDropDownMenu_SetSelectedValue(texturedropdown, self.value)
        texturedropdowntext:SetText(self.value)
        ns:SetTex(self.value)
    end
    UIDropDownMenu_Initialize(texturedropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(texturedropdown) or ns.db.texture, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.textures) do
            info.text = name
            info.value = name
            info.func = OnClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function tex2func(frame)
    local texdropdown = frame:CreateScrollingDropdown("Texture", ns.textures)
    texdropdown.desc = "Change the unit's texture."
    texdropdown:SetPoint("TOPRIGHT", frame, -10, -10)
    texdropdown:SetValue(ns.db.texture or ns.defaults.texture)
    do
        function texdropdown:OnValueChanged(value)
            texdropdown:SetValue(value)
            ns.db.textureSM = ns.textures[value]
            ns.db.texture = value
        end

        local button_OnClick = texdropdown.button:GetScript("OnClick")
        texdropdown.button:SetScript("OnClick", function(self)
            button_OnClick(self)
            texdropdown.dropdown.list:Hide()

            local OnShow = texdropdown.dropdown.list:GetScript("OnShow")
			texdropdown.dropdown.list:SetScript("OnShow", function(self)
				OnShow(self)
			end)

			local OnVerticalScroll = texdropdown.dropdown.list.scrollFrame:GetScript("OnVerticalScroll")
			texdropdown.dropdown.list.scrollFrame:SetScript("OnVerticalScroll", function(self, delta)
				OnVerticalScroll(self, delta)
			end)

			button_OnClick(self)
			self:SetScript("OnClick", button_OnClick)
        end)
    end
end

local function fontfunc(frame)
    local fontdropdown, fontdropdowntext, fontdropdowncontainer = tekdropdown.new(frame, "Font", "TOPRIGHT", frame, 0, -50)
    fontdropdowntext:SetText(ns.db.font or ns.defaults.font)
    fontdropdown.tiptext = "Change the unit's font."

    local function FontOnClick(self)
        UIDropDownMenu_SetSelectedValue(fontdropdown, self.value)
        fontdropdowntext:SetText(self.value)
        ns:SetFont(self.value)
    end
    UIDropDownMenu_Initialize(fontdropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(fontdropdown) or ns.db.font, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.fonts) do
            info.text = name
            info.value = name
            info.func = FontOnClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function font2func(frame)
    local fontdropdown = frame:CreateScrollingDropdown("Font", ns.fonts)
    fontdropdown.desc = "CChange the unit's font."
    fontdropdown:SetPoint("TOPRIGHT", frame, -10, -60)
    fontdropdown:SetValue(ns.db.font or ns.defaults.font)
    do
        function fontdropdown:OnValueChanged(value)
            fontdropdown:SetValue(value)
            ns.db.fontSM = ns.fonts[value]
            ns.db.font = value
        end

        local button_OnClick = fontdropdown.button:GetScript("OnClick")
        fontdropdown.button:SetScript("OnClick", function(self)
            button_OnClick(self)
            fontdropdown.dropdown.list:Hide()

            local OnShow = fontdropdown.dropdown.list:GetScript("OnShow")
			fontdropdown.dropdown.list:SetScript("OnShow", function(self)
				OnShow(self)
			end)

			local OnVerticalScroll = fontdropdown.dropdown.list.scrollFrame:GetScript("OnVerticalScroll")
			fontdropdown.dropdown.list.scrollFrame:SetScript("OnVerticalScroll", function(self, delta)
				OnVerticalScroll(self, delta)
			end)

			button_OnClick(self)
			self:SetScript("OnClick", button_OnClick)
        end)
    end
end

local function outlinefunc(frame)
    local outlinedropdown, outlinedropdowntext, outlinedropdowncontainer = tekdropdown.new(frame, "Outline", "TOPRIGHT", frame, 0, -100)
    outlinedropdowntext:SetText(ns.db.outline or ns.defaults.outline)
    outlinedropdown.tiptext = "Change the font outline."

    local function OutlineOnClick(self)
        UIDropDownMenu_SetSelectedValue(outlinedropdown, self.value)
        outlinedropdowntext:SetText(self.value)
        ns:SetOutline(self.value)
    end
    UIDropDownMenu_Initialize(outlinedropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(outlinedropdown) or ns.db.outline, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.outline) do
            info.text = name
            info.value = name
            info.func = OutlineOnClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function orientationfunc(frame)
    local orientationdropdown, orientationdropdowntext, orientationdropdowncontainer = tekdropdown.new(frame, "Statusbar Orientation", "TOPRIGHT", frame, 0, -150)
    orientationdropdowntext:SetText(ns.db.orientation or ns.defaults.orientation)
    orientationdropdown.tiptext = "Change the orientation of the statusbars."

    local function OrientationOnClick(self)
        UIDropDownMenu_SetSelectedValue(orientationdropdown, self.value)
        orientationdropdowntext:SetText(self.value)
        ns:SetOrientation(self.value)
    end

    UIDropDownMenu_Initialize(orientationdropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(orientationdropdown) or ns.db.orientation, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.orientation) do
            info.text = name
            info.value = name
            info.func = OrientationOnClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function porientationfunc(frame)
    local porientationdropdown, porientationdropdowntext, porientationdropdowncontainer = tekdropdown.new(frame, "Powerbar Orientation", "TOPRIGHT", frame, -10, -235)
    porientationdropdowntext:SetText(ns.db.porientation or ns.defaults.porientation)
    porientationdropdown.tiptext = "Change the orientation of the powerbars."

    local function OrientationOnClick(self)
        UIDropDownMenu_SetSelectedValue(porientationdropdown, self.value)
        porientationdropdowntext:SetText(self.value)
        ns:SetpOrientation(self.value)
    end

    UIDropDownMenu_Initialize(porientationdropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(porientationdropdown) or ns.db.porientation, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.orientation) do
            info.text = name
            info.value = name
            info.func = OrientationOnClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function pointfunc(frame)
    local pointdropdown, pointdropdowntext, pointdropdowncontainer = tekdropdown.new(frame, "Point Direction", "TOPRIGHT", frame, 0, -200)
    pointdropdowntext:SetText(ns.db.point or ns.defaults.point)
    pointdropdown.tiptext = "Set the point to have additional units added."

    local function PointClick(self)
        UIDropDownMenu_SetSelectedValue(pointdropdown, self.value)
        pointdropdowntext:SetText(self.value)
        ns:SetPoint(self.value)
    end

    UIDropDownMenu_Initialize(pointdropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(pointdropdown) or ns.db.point, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.point) do
            info.text = name
            info.value = name
            info.func = PointClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

local function growthfunc(frame)
    local growthdropdown, growthdropdowntext, growthdropdowncontainer = tekdropdown.new(frame, "Growth Direction", "TOPRIGHT", frame, 0, -250)
    growthdropdowntext:SetText(ns.db.growth or ns.defaults.growth)
    growthdropdown.tiptext = "Set the growth direction for additional groups."

    local function GrowthOnClick(self)
        UIDropDownMenu_SetSelectedValue(growthdropdown, self.value)
        growthdropdowntext:SetText(self.value)
        ns:SetGrowth(self.value)
    end

    UIDropDownMenu_Initialize(growthdropdown, function()
        local selected, info = UIDropDownMenu_GetSelectedValue(growthdropdown) or ns.db.growth, UIDropDownMenu_CreateInfo()

        for name in pairs(ns.growth) do
            info.text = name
            info.value = name
            info.func = GrowthOnClick
            info.checked = name == selected
            UIDropDownMenu_AddButton(info)
        end
    end)
end

-----------------------
--      Panel 1      --
-----------------------

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = ADDON_NAME
frame:Hide()
frame:SetScript("OnShow", function(frame)
    SM = LibStub("LibSharedMedia-3.0", true)
    if SM then
        for font, path in pairs(ns.fonts) do
            SM:Register("font", font, path)
        end

        for tex, path in pairs(ns.textures) do
            SM:Register("statusbar", tex, path)
        end

        ns.fonts = {}
        for i, v in pairs(SM:List("font")) do
            table.insert(ns.fonts, v)
            ns.fonts[v] = SM:Fetch("font", v)
        end
        table.sort(ns.fonts)

        ns.textures = {}
        for i, v in pairs(SM:List("statusbar")) do
            table.insert(ns.textures, v)
            ns.textures[v] = SM:Fetch("statusbar", v)
        end
        table.sort(ns.textures)
    end

    local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "oUF_Freebgrid", "General settings for the oUF_Freebgrid.")

    local lockpos = tekcheck.new(frame, nil, "Unlock", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, 0)
    lockpos.tiptext = "Unlocks headers to be moved."
    local checksound = lockpos:GetScript("OnClick")
    lockpos:SetScript("OnClick", function() ns:Movable() end)
    lockpos:SetChecked(not ns.db.locked)

    --	local disableomf = tekcheck.new(frame, nil, "Disable oMF", "LEFT", lockpos, "RIGHT", 50, 0)
    --	disableomf:SetScript("OnClick", function(self) checksound(self); ns.db.disableomf = not ns.db.disableomf; end)
    --	disableomf:SetChecked(ns.db.disableomf)

    local scaleslider, scaleslidertext, scalecontainer = tekslider.new(frame, string.format("Scale: %.2f", ns.db.scale or ns.defaults.scale), 0.5, 2, "TOPLEFT", lockpos, "BOTTOMLEFT", 0, -GAP)
    scaleslider.tiptext = "Set the units scale."
    scaleslider:SetValue(ns.db.scale or ns.defaults.scale)
    scaleslider:SetValueStep(.05)
    scaleslider:SetScript("OnValueChanged", function(self)
        ns.db.scale = self:GetValue()
        scaleslidertext:SetText(string.format("Scale: %.2f", ns.db.scale or ns.defaults.scale))
    end)

    local widthslider, widthslidertext, widthcontainer = tekslider.new(frame, string.format("Width: %d", ns.db.width or ns.defaults.width), 20, 100, "TOPLEFT", scaleslider, "BOTTOMLEFT", 0, -GAP)
    widthslider.tiptext = "Set the width of units."
    widthslider:SetValue(ns.db.width or ns.defaults.width)
    widthslider:SetValueStep(1)
    widthslider:SetScript("OnValueChanged", function(self)
        ns.db.width = self:GetValue()
        widthslidertext:SetText(string.format("Width: %d", ns.db.width or ns.defaults.width))
    end)

    local heightslider, heightslidertext, heightcontainer = tekslider.new(frame, string.format("Height: %d", ns.db.height or ns.defaults.height), 20, 100, "TOPLEFT", widthslider, "BOTTOMLEFT", 0, -GAP)
    heightslider.tiptext = "Set the height of units."
    heightslider:SetValue(ns.db.height or ns.defaults.height)
    heightslider:SetValueStep(1)
    heightslider:SetScript("OnValueChanged", function(self)
        ns.db.height = self:GetValue()
        heightslidertext:SetText(string.format("Height: %d", ns.db.height or ns.defaults.height))
    end)

    local fontslider, fontslidertext, fontcontainer = tekslider.new(frame, string.format("Font Size: %d", ns.db.fontsize or ns.defaults.fontsize), 10, 30, "TOPLEFT", heightslider, "BOTTOMLEFT", 0, -GAP)
    fontslider.tiptext = "Set the font size."
    fontslider:SetValue(ns.db.fontsize or ns.defaults.fontsize)
    fontslider:SetValueStep(1)
    fontslider:SetScript("OnValueChanged", function(self)
        ns.db.fontsize = self:GetValue()
        fontslidertext:SetText(string.format("Font Size: %d", ns.db.fontsize or ns.defaults.fontsize))
    end)

    local inRangeslider, inRangeslidertext, inRangecontainer = tekslider.new(frame, string.format("In Range Alpha: %.2f", ns.db.inRange or ns.defaults.inRange), 0, 1, "TOPLEFT", fontslider, "BOTTOMLEFT", 0, -GAP)
    inRangeslider.tiptext = "Set the alpha of units in range."
    inRangeslider:SetValue(ns.db.inRange or ns.defaults.inRange)
    inRangeslider:SetValueStep(.05)
    inRangeslider:SetScript("OnValueChanged", function(self)
        ns.db.inRange = self:GetValue()
        inRangeslidertext:SetText(string.format("In Range Alpha: %.2f", ns.db.inRange or ns.defaults.inRange))
    end)

    local ooRangeslider, ooRangeslidertext, ooRangecontainer = tekslider.new(frame, string.format("Out of Range Alpha: %.2f", ns.db.outsideRange or ns.defaults.outsideRange), 0, 1, "TOPLEFT", inRangeslider, "BOTTOMLEFT", 0, -GAP)
    ooRangeslider.tiptext = "Set the alpha of units out of range."
    ooRangeslider:SetValue(ns.db.outsideRange or ns.defaults.outsideRange)
    ooRangeslider:SetValueStep(.05)
    ooRangeslider:SetScript("OnValueChanged", function(self)
        ns.db.outsideRange = self:GetValue()
        ooRangeslidertext:SetText(string.format("Out of Range Alpha: %.2f", ns.db.outsideRange or ns.defaults.outsideRange))
    end)

    local iconsizeslider, iconsizeslidertext, iconsizecontainer = tekslider.new(frame, string.format("Icon Size: %d", ns.db.iconsize or ns.defaults.iconsize), 8, 20, "TOPLEFT", ooRangeslider, "BOTTOMLEFT", 0, -GAP)
    iconsizeslider.tiptext = "Set the size of various icons. Raid symbols, Party leader, etc."
    iconsizeslider:SetValue(ns.db.iconsize or ns.defaults.iconsize)
    iconsizeslider:SetValueStep(1)
    iconsizeslider:SetScript("OnValueChanged", function(self)
        ns.db.iconsize = self:GetValue()
        iconsizeslidertext:SetText(string.format("Icon Size: %d", ns.db.iconsize or ns.defaults.iconsize))
    end)

    local debuffsizeslider, debuffsizeslidertext, debuffsizecontainer = tekslider.new(frame, string.format("Aura Size: %d", ns.db.debuffsize or ns.defaults.debuffsize), 8, 30, "TOPLEFT", iconsizeslider, "BOTTOMLEFT", 0, -GAP)
    debuffsizeslider.tiptext = "Set the size of auras."
    debuffsizeslider:SetValue(ns.db.debuffsize or ns.defaults.debuffsize)
    debuffsizeslider:SetValueStep(1)
    debuffsizeslider:SetScript("OnValueChanged", function(self)
        ns.db.debuffsize = self:GetValue()
        debuffsizeslidertext:SetText(string.format("Debuff Size: %d", ns.db.debuffsize or ns.defaults.debuffsize))
    end) 

    local numColslider, numColslidertext, numColcontainer = tekslider.new(frame, string.format("Number of groups: %d", ns.db.numCol or ns.defaults.numCol), 1, 8, "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 40)
    numColslider.tiptext = "Set the number of groups."
    numColslider:SetValue(ns.db.numCol or ns.defaults.numCol)
    numColslider:SetValueStep(1)
    numColslider:SetScript("OnValueChanged", function(self)
        ns.db.numCol = self:GetValue()
        numColslidertext:SetText(string.format("Number of groups: %d", ns.db.numCol or ns.defaults.numCol))
    end)

    local numUnitsslider, numUnitsslidertext, numUnitscontainer = tekslider.new(frame, string.format("Units per group: %d", ns.db.numUnits or ns.defaults.numUnits), 1, 40, "BOTTOMLEFT", numColslider, "TOPLEFT", 0, GAP)
    numUnitsslider.tiptext = "Set the number of units per group."
    numUnitsslider:SetValue(ns.db.numUnits or ns.defaults.numUnits)
    numUnitsslider:SetValueStep(1)
    numUnitsslider:SetScript("OnValueChanged", function(self)
        ns.db.numUnits = self:GetValue()
        numUnitsslidertext:SetText(string.format("Units per group: %d", ns.db.numUnits or ns.defaults.numUnits))
    end)

    frame.CreateScrollingDropdown = LibStub("freeb-ScrollingDropdown").CreateScrollingDropdown

    tex2func(frame)
    font2func(frame)
    outlinefunc(frame)
    orientationfunc(frame)
    pointfunc(frame)
    growthfunc(frame)

    local reload = tekbutton.new_small(frame)
    reload:SetPoint("BOTTOMRIGHT", -16, 16)
    reload:SetText("Reload")
    reload.tiptext = "Reload UI to apply settings"
    reload:SetScript("OnClick", function() ReloadUI() end)

    frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)

----------------------
--      Panel 2     --
----------------------

local f = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
f.name = "More setting..."
f.parent = ADDON_NAME
f:Hide()
f:SetScript("OnShow", function(f)
    local ns = ns

    local solo = tekcheck.new(f, nil, "Show player when solo.", "BOTTOMLEFT", f, "TOPLEFT", 10, -40)
    local checksound = solo:GetScript("OnClick")
    solo:SetScript("OnClick", function(self) checksound(self); ns.db.solo = not ns.db.solo; end)
    solo:SetChecked(ns.db.solo)

    local party = tekcheck.new(f, nil, "Show party.", "TOPLEFT", solo, "BOTTOMLEFT", 0, -GAP)
    party:SetScript("OnClick", function(self) checksound(self); ns.db.partyOn = not ns.db.partyOn; end)
    party:SetChecked(ns.db.partyOn)

    local player = tekcheck.new(f, nil, "Show self in group.", "TOPLEFT", party, "BOTTOMLEFT", 0, -GAP)
    player:SetScript("OnClick", function(self) checksound(self); ns.db.player = not ns.db.player; end)
    player:SetChecked(ns.db.player)

    --	local framebg = tekcheck.new(f, nil, "Show the frame background.", "TOPLEFT", player, "BOTTOMLEFT", 0, -GAP)
    --	framebg:SetScript("OnClick", function(self) checksound(self); ns.db.framebg = not ns.db.framebg; end)
    --	framebg:SetChecked(ns.db.framebg)

    --	local blizzparty = tekcheck.new(f, nil, "Show the Blizzard party frames.", "TOPLEFT", player, "BOTTOMLEFT", 0, -GAP)
    --	blizzparty:SetScript("OnClick", function(self) checksound(self); ns.db.showBlizzParty = not ns.db.showBlizzParty; end)
    --	blizzparty:SetChecked(ns.db.showBlizzParty)

    local lfdicon = tekcheck.new(f, nil, "Show the LFD role icon.", "TOPLEFT", player, "BOTTOMLEFT", 0, -GAP)
    lfdicon:SetScript("OnClick", function(self) checksound(self); ns.db.lfdicon = not ns.db.lfdicon; end)
    lfdicon:SetChecked(ns.db.lfdicon)

    --local frequent = tekcheck.new(f, nil, "Enable frequent tag updates.", "TOPLEFT", lfdicon, "BOTTOMLEFT", 0, -GAP)
    --frequent:SetScript("OnClick", function(self) checksound(self); ns.db.frequent = not ns.db.frequent; end)
    --frequent:SetChecked(ns.db.frequent)

    local reversecolors = tekcheck.new(f, nil, "Reverse colors.", "TOPLEFT", lfdicon, "BOTTOMLEFT", 0, -GAP)
    reversecolors:SetScript("OnClick", function(self) checksound(self); ns.db.reversecolors = not ns.db.reversecolors; end)
    reversecolors:SetChecked(ns.db.reversecolors)

    local pets = tekcheck.new(f, nil, "Enable Party/Raid pets.", "TOPLEFT", reversecolors, "BOTTOMLEFT", 0, -GAP)
    pets:SetScript("OnClick", function(self) checksound(self); ns.db.pets = not ns.db.pets; end)
    pets:SetChecked(ns.db.pets)

    local MT = tekcheck.new(f, nil, "Enable MainTanks.", "TOPLEFT", pets, "BOTTOMLEFT", 0, -GAP)
    MT:SetScript("OnClick", function(self) checksound(self); ns.db.MT = not ns.db.MT; end)
    MT:SetChecked(ns.db.MT)

    --	local MTT = tekcheck.new(f, nil, "Enable MT taragets.", "TOPLEFT", MT, "BOTTOMLEFT", 0, -GAP)
    --	MTT:SetScript("OnClick", function(self) checksound(self); ns.db.MTT = not ns.db.MTT; end)
    --	MTT:SetChecked(ns.db.MTT)

    local showname = tekcheck.new(f, nil, "Always show names.", "TOPLEFT", MT, "BOTTOMLEFT", 0, -GAP)
    showname:SetScript("OnClick", function(self) checksound(self); ns.db.showname = not ns.db.showname; end)
    showname:SetChecked(ns.db.showname)

    local multi = tekcheck.new(f, nil, "Spawn multiple headers.", "TOPLEFT", showname, "BOTTOMLEFT", 0, -GAP)
    multi:SetScript("OnClick", function(self) checksound(self); ns.db.multi = not ns.db.multi; end)
    multi:SetChecked(ns.db.multi)

    local healgroup = LibStub("tekKonfig-Group").new(f, "HealPrediction Settings")
    healgroup:SetHeight(190)
    healgroup:SetWidth(180)
    healgroup:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -15)

    local healcommtext = tekcheck.new(f, nil, "Enable heal text.", "TOPLEFT", healgroup, "TOPLEFT", 15, -GAP)
    healcommtext:SetScript("OnClick", function(self) checksound(self); ns.db.healcommtext = not ns.db.healcommtext; end)
    healcommtext:SetChecked(ns.db.healcommtext)

    local healcommbar = tekcheck.new(f, nil, "Enable heal bar.", "TOPLEFT", healcommtext, "BOTTOMLEFT", 0, -GAP)
    healcommbar:SetScript("OnClick", function(self) checksound(self); ns.db.healcommbar = not ns.db.healcommbar; end)
    healcommbar:SetChecked(ns.db.healcommbar)

    local healcommoverflow = tekcheck.new(f, nil, "Enable overflow.", "TOPLEFT", healcommbar, "BOTTOMLEFT", 0, -GAP)
    healcommoverflow:SetScript("OnClick", function(self) checksound(self); ns.db.healcommoverflow = not ns.db.healcommoverflow; end)
    healcommoverflow:SetChecked(ns.db.healcommoverflow)

    local healothersonly = tekcheck.new(f, nil, "Others' heals only.", "TOPLEFT", healcommoverflow, "BOTTOMLEFT", 0, -GAP)
    healothersonly:SetScript("OnClick", function(self) checksound(self); ns.db.healothersonly = not ns.db.healothersonly; end)
    healothersonly:SetChecked(ns.db.healothersonly)

    local healalphaslider, healalphaslidertext, healalphacontainer = tekslider.new(f, string.format("Heal bar alpha: %.2f", ns.db.healalpha or ns.defaults.healalpha), 0, 1, "TOPLEFT", healothersonly, "BOTTOMLEFT", 0, -GAP)
    healalphaslider.tiptext = "Set the alpha of the heal bar."
    healalphaslider:SetValue(ns.db.healalpha or ns.defaults.healalpha)
    healalphaslider:SetValueStep(.05)
    healalphaslider:SetScript("OnValueChanged", function(self)
        ns.db.healalpha = self:GetValue()
        healalphaslidertext:SetText(string.format("Heal bar alpha: %.2f", ns.db.healalpha or ns.defaults.healalpha))
    end)

    --[[local resgroup = LibStub("tekKonfig-Group").new(f, "ResComm Settings")
    resgroup:SetHeight(85)
    resgroup:SetWidth(180)
    resgroup:SetPoint("TOPRIGHT", healgroup, "BOTTOMRIGHT", 0, -GAP-2)

    local rescomm = tekcheck.new(f, nil, "Enable ResComm.", "TOPLEFT", resgroup, "TOPLEFT", 15, -GAP)
    rescomm:SetScript("OnClick", function(self) checksound(self); ns.db.rescomm = not ns.db.rescomm; end)
    rescomm:SetChecked(ns.db.rescomm)

    local rescommalphaslider, rescommalphaslidertext, rescommalphacontainer = tekslider.new(f, string.format("ResComm alpha: %.2f", ns.db.rescommalpha or ns.defaults.rescommalpha), 0, 1, "TOPLEFT", rescomm, "BOTTOMLEFT", 0, -GAP)
    rescommalphaslider.tiptext = "Set the alpha of the Rescomm statusbar."
    rescommalphaslider:SetValue(ns.db.rescommalpha or ns.defaults.rescommalpha)
    rescommalphaslider:SetValueStep(.05)
    rescommalphaslider:SetScript("OnValueChanged", function(self)
        ns.db.rescommalpha = self:GetValue()
        rescommalphaslidertext:SetText(string.format("Rescomm alpha: %.2f", ns.db.rescommalpha or ns.defaults.rescommalpha))
    end)]]

    local powerbar = tekcheck.new(f, nil, "Enable Powerbars.", "TOPLEFT", healgroup, "BOTTOMLEFT", 15, -GAP)
    powerbar:SetScript("OnClick", function(self) checksound(self); ns.db.powerbar = not ns.db.powerbar; end)
    powerbar:SetChecked(ns.db.powerbar)

    local powerbarsizeslider, powerbarsizeslidertext, powerbarsizecontainer = tekslider.new(f, string.format("Powerbar size: %.2f", ns.db.powerbarsize or ns.defaults.powerbarsize), .02, .30, "TOPLEFT", powerbar, "BOTTOMLEFT", 0, -65)
    powerbarsizeslider.tiptext = "Set the size of the powerbars."
    powerbarsizeslider:SetValue(ns.db.powerbarsize or ns.defaults.powerbarsize)
    powerbarsizeslider:SetValueStep(.02)
    powerbarsizeslider:SetScript("OnValueChanged", function(self)
        ns.db.powerbarsize = self:GetValue()
        powerbarsizeslidertext:SetText(string.format("Powerbar size: %.2f", ns.db.powerbarsize or ns.defaults.powerbarsize))
    end)

    local frequpdateslider, frequpdateslidertext, frequpdatecontainer = tekslider.new(f, string.format("Tag frequency: %.2f", ns.db.frequpdate or ns.defaults.frequpdate), 0.1, 1, "TOPLEFT", powerbarsizeslider, "BOTTOMLEFT", 0, -GAP-8)
    frequpdateslider.tiptext = "Set the update frequency of Tag Indicators."
    frequpdateslider:SetValue(ns.db.frequpdate or ns.defaults.frequpdate)
    frequpdateslider:SetValueStep(.1)
    frequpdateslider:SetScript("OnValueChanged", function(self)
        ns.db.frequpdate = self:GetValue()
        frequpdateslidertext:SetText(string.format("Tag frequency: %.2f", ns.db.frequpdate or ns.defaults.frequpdate))
    end)

    local symbolsizeslider, symbolsizeslidertext, symbolsizecontainer = tekslider.new(f, string.format("Symbol size: %d", ns.db.symbolsize or ns.defaults.symbolsize), 8, 20, "BOTTOMLEFT", f, "BOTTOMLEFT", 15, GAP)
    symbolsizeslider.tiptext = "Size of the bottom right indicator."
    symbolsizeslider:SetValue(ns.db.symbolsize or ns.defaults.symbolsize)
    symbolsizeslider:SetValueStep(1)
    symbolsizeslider:SetScript("OnValueChanged", function(self)
        ns.db.symbolsize = self:GetValue()
        symbolsizeslidertext:SetText(string.format("Symbol size: %d", ns.db.symbolsize or ns.defaults.symbolsize))
    end)

    local indicatorsizeslider, indicatorsizeslidertext, indicatorsizecontainer = tekslider.new(f, string.format("Indicator size: %d", ns.db.indicatorsize or ns.defaults.indicatorsize), 4, 20, "BOTTOMLEFT", symbolsizeslider, "TOPLEFT", 0, GAP)
    indicatorsizeslider.tiptext = "Size of the corner indicators."
    indicatorsizeslider:SetValue(ns.db.indicatorsize or ns.defaults.indicatorsize)
    indicatorsizeslider:SetValueStep(1)
    indicatorsizeslider:SetScript("OnValueChanged", function(self)
        ns.db.indicatorsize = self:GetValue()
        indicatorsizeslidertext:SetText(string.format("Indicator size: %d", ns.db.indicatorsize or ns.defaults.indicatorsize))
    end)

    local spacingslider, spacingslidertext, spacingcontainer = tekslider.new(f, string.format("Spacing: %d", ns.db.spacing or ns.defaults.spacing), 0, 30, "BOTTOMLEFT", indicatorsizeslider, "TOPLEFT", 0, GAP)
    spacingslider.tiptext = "Set the amount of space between units."
    spacingslider:SetValue(ns.db.spacing or ns.defaults.spacing)
    spacingslider:SetValueStep(1)
    spacingslider:SetScript("OnValueChanged", function(self)
        ns.db.spacing = self:GetValue()
        spacingslidertext:SetText(string.format("Spacing: %d", ns.db.spacing or ns.defaults.spacing))
    end)

    porientationfunc(f)

    local reload = tekbutton.new_small(f)
    reload:SetPoint("BOTTOMRIGHT", -16, 16)
    reload:SetText("Reload")
    reload.tiptext = "Reload UI to apply settings"
    reload:SetScript("OnClick", function() ReloadUI() end)

    f:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(f)
