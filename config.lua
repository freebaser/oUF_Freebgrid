if not oUF_Freebgrid then return end

-- These are just the defaults that are created as a base.
FreebgridDefaults = {
	locked = true,
	
	scale = 1.0,
	width = 42,
	height = 42,
    
	powerbar = false,
	powerbarsize = 0.08,
    
	reversecolors = false,
	
	iconsize = 12,
	debuffsize = 18,
	fontsize = 14,
	
	inRange = 1,
	outsideRange = 0.4,
	
	texture = "gradient",
	font = "calibri",
	
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
	healonlymy = false,
	healalpha = 0.4, 
    
	rescomm =  true,
	rescommalpha = 0.6,
	
	showname = false,
	
}

oUF_Freebgrid.orientation = {
	["VERTICAL"] = "VERTICAL",
	["HORIZONTAL"] = "HORIZONTAL",
}

oUF_Freebgrid.point = {
	["TOP"] = "TOP",
	["RIGHT"] = "RIGHT",
	["BOTTOM"] = "BOTTOM",
	["LEFT"] = "LEFT",
}

oUF_Freebgrid.growth = {
	["UP"] = "UP",
	["RIGHT"] = "RIGHT",
	["DOWN"] = "DOWN",
	["LEFT"] = "LEFT",
}

function oUF_Freebgrid:SetTex(v)
	if v then self.db.texture = v end
end

function oUF_Freebgrid:SetFont(v)
	if v then self.db.font = v end
end

function oUF_Freebgrid:SetOrientation(v)
	if v then self.db.orientation = v end
end

function oUF_Freebgrid:SetPoint(v)
	if v then self.db.point = v end
end

function oUF_Freebgrid:SetGrowth(v)
	if v then self.db.growth = v end
end

----------------------
--      Locals      --
----------------------

local tekcheck = LibStub("tekKonfig-Checkbox")
local tekbutton = LibStub("tekKonfig-Button")
local tekslider = LibStub("tekKonfig-Slider")
local tekdropdown = LibStub("tekKonfig-Dropdown")
local GAP = 7

local function texfunc(frame)
	local texturedropdown, texturedropdowntext, texturedropdowncontainer = tekdropdown.new(frame, "Texture", "TOPRIGHT", frame, 0, 0)
	texturedropdowntext:SetText(oUF_Freebgrid.db.texture or FreebgridDefaults.texture)
	texturedropdown.tiptext = "Change the unit's texture."

	local function OnClick(self)
		UIDropDownMenu_SetSelectedValue(texturedropdown, self.value)
		texturedropdowntext:SetText(self.value)
		oUF_Freebgrid:SetTex(self.value)
	end
	UIDropDownMenu_Initialize(texturedropdown, function()
		local selected, info = UIDropDownMenu_GetSelectedValue(texturedropdown) or oUF_Freebgrid.db.texture, UIDropDownMenu_CreateInfo()

		for name in pairs(oUF_Freebgrid.textures) do
			info.text = name
			info.value = name
			info.func = OnClick
			info.checked = name == selected
			UIDropDownMenu_AddButton(info)
		end
	end)
end

local function fontfunc(frame)
	local fontdropdown, fontdropdowntext, fontdropdowncontainer = tekdropdown.new(frame, "Font", "TOPRIGHT", frame, 0, -50)
	fontdropdowntext:SetText(oUF_Freebgrid.db.font or FreebgridDefaults.font)
	fontdropdown.tiptext = "Change the unit's font."

	local function FontOnClick(self)
		UIDropDownMenu_SetSelectedValue(fontdropdown, self.value)
		fontdropdowntext:SetText(self.value)
		oUF_Freebgrid:SetFont(self.value)
	end
	UIDropDownMenu_Initialize(fontdropdown, function()
		local selected, info = UIDropDownMenu_GetSelectedValue(fontdropdown) or oUF_Freebgrid.db.font, UIDropDownMenu_CreateInfo()

		for name in pairs(oUF_Freebgrid.fonts) do
			info.text = name
			info.value = name
			info.func = FontOnClick
			info.checked = name == selected
			UIDropDownMenu_AddButton(info)
		end
	end)
end

local function orientationfunc(frame)
	local orientationdropdown, orientationdropdowntext, orientationdropdowncontainer = tekdropdown.new(frame, "Statusbar Orientation", "TOPRIGHT", frame, 0, -100)
	orientationdropdowntext:SetText(oUF_Freebgrid.db.orientation or FreebgridDefaults.orientation)
	orientationdropdown.tiptext = "Change the orientation of the statusbars."

	local function OrientationOnClick(self)
		UIDropDownMenu_SetSelectedValue(orientationdropdown, self.value)
		orientationdropdowntext:SetText(self.value)
		oUF_Freebgrid:SetOrientation(self.value)
	end

	UIDropDownMenu_Initialize(orientationdropdown, function()
		local selected, info = UIDropDownMenu_GetSelectedValue(orientationdropdown) or oUF_Freebgrid.db.orientation, UIDropDownMenu_CreateInfo()

		for name in pairs(oUF_Freebgrid.orientation) do
			info.text = name
			info.value = name
			info.func = OrientationOnClick
			info.checked = name == selected
			UIDropDownMenu_AddButton(info)
		end
	end)
end

local function pointfunc(frame)
	local pointdropdown, pointdropdowntext, pointdropdowncontainer = tekdropdown.new(frame, "Point Direction", "TOPRIGHT", frame, 0, -150)
	pointdropdowntext:SetText(oUF_Freebgrid.db.point or FreebgridDefaults.point)
	pointdropdown.tiptext = "Set the point to have additional units added."

	local function PointClick(self)
		UIDropDownMenu_SetSelectedValue(pointdropdown, self.value)
		pointdropdowntext:SetText(self.value)
		oUF_Freebgrid:SetPoint(self.value)
	end

	UIDropDownMenu_Initialize(pointdropdown, function()
		local selected, info = UIDropDownMenu_GetSelectedValue(pointdropdown) or oUF_Freebgrid.db.point, UIDropDownMenu_CreateInfo()

		for name in pairs(oUF_Freebgrid.point) do
			info.text = name
			info.value = name
			info.func = PointClick
			info.checked = name == selected
			UIDropDownMenu_AddButton(info)
		end
	end)
end

local function growthfunc(frame)
	local growthdropdown, growthdropdowntext, growthdropdowncontainer = tekdropdown.new(frame, "Growth Direction", "TOPRIGHT", frame, 0, -200)
	growthdropdowntext:SetText(oUF_Freebgrid.db.growth or FreebgridDefaults.growth)
	growthdropdown.tiptext = "Set the growth direction for additional groups."

	local function GrowthOnClick(self)
		UIDropDownMenu_SetSelectedValue(growthdropdown, self.value)
		growthdropdowntext:SetText(self.value)
		oUF_Freebgrid:SetGrowth(self.value)
	end

	UIDropDownMenu_Initialize(growthdropdown, function()
		local selected, info = UIDropDownMenu_GetSelectedValue(growthdropdown) or oUF_Freebgrid.db.growth, UIDropDownMenu_CreateInfo()

		for name in pairs(oUF_Freebgrid.growth) do
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
frame.name = "oUF_Freebgrid"
frame:Hide()
frame:SetScript("OnShow", function(frame)
	local oUF_Freebgrid = oUF_Freebgrid
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "oUF_Freebgrid", "General settings for the oUF_Freebgrid.")

	local lockpos = tekcheck.new(frame, nil, "Unlock", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, 0)
	lockpos.tiptext = "Unlocks headers to be moved."
	local checksound = lockpos:GetScript("OnClick")
	lockpos:SetScript("OnClick", function() OUF_FREEBGRIDMOVABLE() end)
	lockpos:SetChecked(not oUF_Freebgrid.db.locked)

	local scaleslider, scaleslidertext, scalecontainer = tekslider.new(frame, string.format("Scale: %.2f", oUF_Freebgrid.db.scale or FreebgridDefaults.scale), 0.5, 2, "TOPLEFT", lockpos, "BOTTOMLEFT", 0, -GAP)
	scaleslider.tiptext = "Set the units scale."
	scaleslider:SetValue(oUF_Freebgrid.db.scale or FreebgridDefaults.scale)
	scaleslider:SetValueStep(.05)
	scaleslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.scale = self:GetValue()
		scaleslidertext:SetText(string.format("Scale: %.2f", oUF_Freebgrid.db.scale or FreebgridDefaults.scale))
	end)
	
	local widthslider, widthslidertext, widthcontainer = tekslider.new(frame, string.format("Width: %d", oUF_Freebgrid.db.width or FreebgridDefaults.width), 20, 100, "TOPLEFT", scaleslider, "BOTTOMLEFT", 0, -GAP)
	widthslider.tiptext = "Set the width of units."
	widthslider:SetValue(oUF_Freebgrid.db.width or FreebgridDefaults.width)
	widthslider:SetValueStep(1)
	widthslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.width = self:GetValue()
		widthslidertext:SetText(string.format("Width: %d", oUF_Freebgrid.db.width or FreebgridDefaults.width))
	end)
	
	local heightslider, heightslidertext, heightcontainer = tekslider.new(frame, string.format("Height: %d", oUF_Freebgrid.db.height or FreebgridDefaults.height), 20, 100, "TOPLEFT", widthslider, "BOTTOMLEFT", 0, -GAP)
	heightslider.tiptext = "Set the height of units."
	heightslider:SetValue(oUF_Freebgrid.db.height or FreebgridDefaults.height)
	heightslider:SetValueStep(1)
	heightslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.height = self:GetValue()
		heightslidertext:SetText(string.format("Height: %d", oUF_Freebgrid.db.height or FreebgridDefaults.height))
	end)
	
	local fontslider, fontslidertext, fontcontainer = tekslider.new(frame, string.format("Font Size: %d", oUF_Freebgrid.db.fontsize or FreebgridDefaults.fontsize), 10, 30, "TOPLEFT", heightslider, "BOTTOMLEFT", 0, -GAP)
	fontslider.tiptext = "Set the font size."
	fontslider:SetValue(oUF_Freebgrid.db.fontsize or FreebgridDefaults.fontsize)
	fontslider:SetValueStep(1)
	fontslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.fontsize = self:GetValue()
		fontslidertext:SetText(string.format("Font Size: %d", oUF_Freebgrid.db.fontsize or FreebgridDefaults.fontsize))
	end)
	
	local inRangeslider, inRangeslidertext, inRangecontainer = tekslider.new(frame, string.format("In Range Alpha: %.2f", oUF_Freebgrid.db.inRange or FreebgridDefaults.inRange), 0, 1, "TOPLEFT", fontslider, "BOTTOMLEFT", 0, -GAP)
	inRangeslider.tiptext = "Set the alpha of units in range."
	inRangeslider:SetValue(oUF_Freebgrid.db.inRange or FreebgridDefaults.inRange)
	inRangeslider:SetValueStep(.05)
	inRangeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.inRange = self:GetValue()
		inRangeslidertext:SetText(string.format("In Range Alpha: %.2f", oUF_Freebgrid.db.inRange or FreebgridDefaults.inRange))
	end)
	
	local ooRangeslider, ooRangeslidertext, ooRangecontainer = tekslider.new(frame, string.format("Out of Range Alpha: %.2f", oUF_Freebgrid.db.outsideRange or FreebgridDefaults.outsideRange), 0, 1, "TOPLEFT", inRangeslider, "BOTTOMLEFT", 0, -GAP)
	ooRangeslider.tiptext = "Set the alpha of units out of range."
	ooRangeslider:SetValue(oUF_Freebgrid.db.outsideRange or FreebgridDefaults.outsideRange)
	ooRangeslider:SetValueStep(.05)
	ooRangeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.outsideRange = self:GetValue()
		ooRangeslidertext:SetText(string.format("Out of Range Alpha: %.2f", oUF_Freebgrid.db.outsideRange or FreebgridDefaults.outsideRange))
	end)
	
	local iconsizeslider, iconsizeslidertext, iconsizecontainer = tekslider.new(frame, string.format("Icon Size: %d", oUF_Freebgrid.db.iconsize or FreebgridDefaults.iconsize), 8, 20, "TOPLEFT", ooRangeslider, "BOTTOMLEFT", 0, -GAP)
	iconsizeslider.tiptext = "Set the size of various icons. Raid symbols, Party leader, etc."
	iconsizeslider:SetValue(oUF_Freebgrid.db.iconsize or FreebgridDefaults.iconsize)
	iconsizeslider:SetValueStep(1)
	iconsizeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.iconsize = self:GetValue()
		iconsizeslidertext:SetText(string.format("Icon Size: %d", oUF_Freebgrid.db.iconsize or FreebgridDefaults.iconsize))
	end)
	
	local debuffsizeslider, debuffsizeslidertext, debuffsizecontainer = tekslider.new(frame, string.format("Debuff Size: %d", oUF_Freebgrid.db.debuffsize or FreebgridDefaults.debuffsize), 8, 30, "TOPLEFT", iconsizeslider, "BOTTOMLEFT", 0, -GAP)
	debuffsizeslider.tiptext = "Set the size of debuffs."
	debuffsizeslider:SetValue(oUF_Freebgrid.db.debuffsize or FreebgridDefaults.debuffsize)
	debuffsizeslider:SetValueStep(1)
	debuffsizeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.debuffsize = self:GetValue()
		debuffsizeslidertext:SetText(string.format("Debuff Size: %d", oUF_Freebgrid.db.debuffsize or FreebgridDefaults.debuffsize))
	end)
    
	local spacingslider, spacingslidertext, spacingcontainer = tekslider.new(frame, string.format("Spacing: %d", oUF_Freebgrid.db.spacing or FreebgridDefaults.spacing), 0, 30, "TOPRIGHT", frame, -40, -265)
	spacingslider.tiptext = "Set the amount of space between units."
	spacingslider:SetValue(oUF_Freebgrid.db.spacing or FreebgridDefaults.spacing)
	spacingslider:SetValueStep(1)
	spacingslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.spacing = self:GetValue()
		spacingslidertext:SetText(string.format("Spacing: %d", oUF_Freebgrid.db.spacing or FreebgridDefaults.spacing))
	end)
	
	local numColslider, numColslidertext, numColcontainer = tekslider.new(frame, string.format("Number of groups: %d", oUF_Freebgrid.db.numCol or FreebgridDefaults.numCol), 1, 8, "TOPLEFT", spacingslider, "BOTTOMLEFT", 0, -GAP)
	numColslider.tiptext = "Set the number of groups."
	numColslider:SetValue(oUF_Freebgrid.db.numCol or FreebgridDefaults.numCol)
	numColslider:SetValueStep(1)
	numColslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.numCol = self:GetValue()
		numColslidertext:SetText(string.format("Number of groups: %d", oUF_Freebgrid.db.numCol or FreebgridDefaults.numCol))
	end)
    
	local numUnitsslider, numUnitsslidertext, numUnitscontainer = tekslider.new(frame, string.format("Units per group: %d", oUF_Freebgrid.db.numUnits or FreebgridDefaults.numUnits), 1, 40, "TOPLEFT", numColslider, "BOTTOMLEFT", 0, -GAP)
	numUnitsslider.tiptext = "Set the number of units per group."
	numUnitsslider:SetValue(oUF_Freebgrid.db.numUnits or FreebgridDefaults.numUnits)
	numUnitsslider:SetValueStep(1)
	numUnitsslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.numUnits = self:GetValue()
		numUnitsslidertext:SetText(string.format("Units per group: %d", oUF_Freebgrid.db.numUnits or FreebgridDefaults.numUnits))
	end)
    
	texfunc(frame)
	fontfunc(frame)
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
f.parent = "oUF_Freebgrid"
f:Hide()
f:SetScript("OnShow", function(f)
	local oUF_Freebgrid = oUF_Freebgrid

	local solo = tekcheck.new(f, nil, "Show player when solo.", "BOTTOMLEFT", f, "TOPLEFT", 10, -40)
	local checksound = solo:GetScript("OnClick")
	solo:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.solo = not oUF_Freebgrid.db.solo; end)
	solo:SetChecked(oUF_Freebgrid.db.solo)
	
	local party = tekcheck.new(f, nil, "Show when in a party.", "TOPLEFT", solo, "BOTTOMLEFT", 0, -GAP)
	party:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.partyOn = not oUF_Freebgrid.db.partyOn; end)
	party:SetChecked(oUF_Freebgrid.db.partyOn)
	
	local player = tekcheck.new(f, nil, "Show the player frame.", "TOPLEFT", party, "BOTTOMLEFT", 0, -GAP)
	player:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.player = not oUF_Freebgrid.db.player; end)
	player:SetChecked(oUF_Freebgrid.db.player)
	
	local framebg = tekcheck.new(f, nil, "Show the frame background.", "TOPLEFT", player, "BOTTOMLEFT", 0, -GAP)
	framebg:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.framebg = not oUF_Freebgrid.db.framebg; end)
	framebg:SetChecked(oUF_Freebgrid.db.framebg)
	
	local blizzparty = tekcheck.new(f, nil, "Show the Blizzard party frames.", "TOPLEFT", framebg, "BOTTOMLEFT", 0, -GAP)
	blizzparty:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.showBlizzParty = not oUF_Freebgrid.db.showBlizzParty; end)
	blizzparty:SetChecked(oUF_Freebgrid.db.showBlizzParty)
    
	local reversecolors = tekcheck.new(f, nil, "Reverse the health and bg colors.", "TOPLEFT", blizzparty, "BOTTOMLEFT", 0, -GAP)
	reversecolors:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.reversecolors = not oUF_Freebgrid.db.reversecolors; end)
	reversecolors:SetChecked(oUF_Freebgrid.db.reversecolors)
    
	local healgroup = LibStub("tekKonfig-Group").new(f, "HealComm Settings")
	healgroup:SetHeight(190)
	healgroup:SetWidth(180)
	healgroup:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -15)
    
	local healcommtext = tekcheck.new(f, nil, "Enable heal text.", "TOPLEFT", healgroup, "TOPLEFT", 15, -GAP)
	healcommtext:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.healcommtext = not oUF_Freebgrid.db.healcommtext; end)
	healcommtext:SetChecked(oUF_Freebgrid.db.healcommtext)
    
	local healcommbar = tekcheck.new(f, nil, "Enable heal bar.", "TOPLEFT", healcommtext, "BOTTOMLEFT", 0, -GAP)
	healcommbar:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.healcommbar = not oUF_Freebgrid.db.healcommbar; end)
	healcommbar:SetChecked(oUF_Freebgrid.db.healcommbar)

	local healcommoverflow = tekcheck.new(f, nil, "Enable heal bar overflow.", "TOPLEFT", healcommbar, "BOTTOMLEFT", 0, -GAP)
	healcommoverflow:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.healcommoverflow = not oUF_Freebgrid.db.healcommoverflow; end)
	healcommoverflow:SetChecked(oUF_Freebgrid.db.healcommoverflow)
    
	local healonlymy = tekcheck.new(f, nil, "Only show my heals.", "TOPLEFT", healcommoverflow, "BOTTOMLEFT", 0, -GAP)
	healonlymy:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.healonlymy = not oUF_Freebgrid.db.healonlymy; end)
	healonlymy:SetChecked(oUF_Freebgrid.db.healonlymy)
    
	local healalphaslider, healalphaslidertext, healalphacontainer = tekslider.new(f, string.format("Heal bar alpha: %.2f", oUF_Freebgrid.db.healalpha or FreebgridDefaults.healalpha), 0, 1, "TOPLEFT", healonlymy, "BOTTOMLEFT", 0, -GAP)
	healalphaslider.tiptext = "Set the alpha of the heal bar."
	healalphaslider:SetValue(oUF_Freebgrid.db.healalpha or FreebgridDefaults.healalpha)
	healalphaslider:SetValueStep(.05)
	healalphaslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.healalpha = self:GetValue()
		healalphaslidertext:SetText(string.format("Heal bar alpha: %.2f", oUF_Freebgrid.db.healalpha or FreebgridDefaults.healalpha))
	end)
    
	local resgroup = LibStub("tekKonfig-Group").new(f, "ResComm Settings")
	resgroup:SetHeight(85)
	resgroup:SetWidth(180)
	resgroup:SetPoint("TOPRIGHT", healgroup, "BOTTOMRIGHT", 0, -GAP-2)
    
	local rescomm = tekcheck.new(f, nil, "Enable ResComm.", "TOPLEFT", resgroup, "TOPLEFT", 15, -GAP)
	rescomm:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.rescomm = not oUF_Freebgrid.db.rescomm; end)
	rescomm:SetChecked(oUF_Freebgrid.db.rescomm)
    
	local rescommalphaslider, rescommalphaslidertext, rescommalphacontainer = tekslider.new(f, string.format("ResComm alpha: %.2f", oUF_Freebgrid.db.rescommalpha or FreebgridDefaults.rescommalpha), 0, 1, "TOPLEFT", rescomm, "BOTTOMLEFT", 0, -GAP)
	rescommalphaslider.tiptext = "Set the alpha of the Rescomm statusbar."
	rescommalphaslider:SetValue(oUF_Freebgrid.db.rescommalpha or FreebgridDefaults.rescommalpha)
	rescommalphaslider:SetValueStep(.05)
	rescommalphaslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.rescommalpha = self:GetValue()
		rescommalphaslidertext:SetText(string.format("Rescomm alpha: %.2f", oUF_Freebgrid.db.rescommalpha or FreebgridDefaults.rescommalpha))
	end)
    
	local powerbar = tekcheck.new(f, nil, "Enable Powerbars.", "TOPLEFT", resgroup, "BOTTOMLEFT", 15, -GAP)
	powerbar:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.powerbar = not oUF_Freebgrid.db.powerbar; end)
	powerbar:SetChecked(oUF_Freebgrid.db.powerbar)
    
	local powerbarsizeslider, powerbarsizeslidertext, powerbarsizecontainer = tekslider.new(f, string.format("Powerbar size: %.2f", oUF_Freebgrid.db.powerbarsize or FreebgridDefaults.powerbarsize), .02, .30, "TOPLEFT", powerbar, "BOTTOMLEFT", 0, -GAP)
	powerbarsizeslider.tiptext = "Set the size of the powerbars."
	powerbarsizeslider:SetValue(oUF_Freebgrid.db.powerbarsize or FreebgridDefaults.powerbarsize)
	powerbarsizeslider:SetValueStep(.02)
	powerbarsizeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.powerbarsize = self:GetValue()
		powerbarsizeslidertext:SetText(string.format("Powerbar size: %.2f", oUF_Freebgrid.db.powerbarsize or FreebgridDefaults.powerbarsize))
	end)
    
	local pets = tekcheck.new(f, nil, "Enable Party/Raid pets.", "TOPLEFT", reversecolors, "BOTTOMLEFT", 0, -GAP)
	pets:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.pets = not oUF_Freebgrid.db.pets; end)
	pets:SetChecked(oUF_Freebgrid.db.pets)
    
	local MT = tekcheck.new(f, nil, "Enable MainTanks.", "TOPLEFT", pets, "BOTTOMLEFT", 0, -GAP)
	MT:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.MT = not oUF_Freebgrid.db.MT; end)
	MT:SetChecked(oUF_Freebgrid.db.MT)
    
	local MTT = tekcheck.new(f, nil, "Enable MT taragets.", "TOPLEFT", MT, "BOTTOMLEFT", 0, -GAP)
	MTT:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.MTT = not oUF_Freebgrid.db.MTT; end)
	MTT:SetChecked(oUF_Freebgrid.db.MTT)
	
	local showname = tekcheck.new(f, nil, "Always show names.", "TOPLEFT", MTT, "BOTTOMLEFT", 0, -GAP)
	showname:SetScript("OnClick", function(self) checksound(self); oUF_Freebgrid.db.showname = not oUF_Freebgrid.db.showname; end)
	showname:SetChecked(oUF_Freebgrid.db.showname)
    
	local symbolsizeslider, symbolsizeslidertext, symbolsizecontainer = tekslider.new(f, string.format("Symbol size: %d", oUF_Freebgrid.db.symbolsize or FreebgridDefaults.symbolsize), 8, 20, "BOTTOMLEFT", f, "BOTTOMLEFT", 15, GAP)
	symbolsizeslider.tiptext = "Size of the bottom right indicator."
	symbolsizeslider:SetValue(oUF_Freebgrid.db.symbolsize or FreebgridDefaults.symbolsize)
	symbolsizeslider:SetValueStep(1)
	symbolsizeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.symbolsize = self:GetValue()
		symbolsizeslidertext:SetText(string.format("Symbol size: %d", oUF_Freebgrid.db.symbolsize or FreebgridDefaults.symbolsize))
	end)
    
	local indicatorsizeslider, indicatorsizeslidertext, indicatorsizecontainer = tekslider.new(f, string.format("Indicator size: %d", oUF_Freebgrid.db.indicatorsize or FreebgridDefaults.indicatorsize), 4, 20, "BOTTOMLEFT", symbolsizeslider, "TOPLEFT", 0, GAP)
	indicatorsizeslider.tiptext = "Size of the corner indicators."
	indicatorsizeslider:SetValue(oUF_Freebgrid.db.indicatorsize or FreebgridDefaults.indicatorsize)
	indicatorsizeslider:SetValueStep(1)
	indicatorsizeslider:SetScript("OnValueChanged", function(self)
		oUF_Freebgrid.db.indicatorsize = self:GetValue()
		indicatorsizeslidertext:SetText(string.format("Indicator size: %d", oUF_Freebgrid.db.indicatorsize or FreebgridDefaults.indicatorsize))
	end)
    
	local reload = tekbutton.new_small(f)
	reload:SetPoint("BOTTOMRIGHT", -16, 16)
	reload:SetText("Reload")
	reload.tiptext = "Reload UI to apply settings"
	reload:SetScript("OnClick", function() ReloadUI() end)

	f:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(f)
