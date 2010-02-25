if not oUF_Freebgrid then return end

FreebgridDefaults = {
	locked = true,
	
	scale = 1.0,
	width = 42,
	height = 42,
	
	iconsize = 12,
	debuffsize = 18,
	fontsize = 14,
	
	inRange = 1,
	outsideRange = 0.4,
	
	texture = "gradient",
	font = "calibri",
	
}

function oUF_Freebgrid:SetTex(v)
	if v then self.db.texture = v end
end

function oUF_Freebgrid:SetFont(v)
	if v then self.db.font = v end
end

----------------------
--      Locals      --
----------------------

local tekcheck = LibStub("tekKonfig-Checkbox")
local tekbutton = LibStub("tekKonfig-Button")
local tekslider = LibStub("tekKonfig-Slider")
local tekdropdown = LibStub("tekKonfig-Dropdown")
local GAP = 8

---------------------
--      Panel1      --
---------------------

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "oUF_Freebgrid"
frame:Hide()
frame:SetScript("OnShow", function(frame)
	local oUF_Freebgrid = oUF_Freebgrid
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "oUF_Freebgrid", "General settings for the oUF_Freebgrid.")

	local lockpos = tekcheck.new(frame, nil, "Unlock", "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	lockpos.tiptext = "Unlocks headers to be moved."
	local checksound = lockpos:GetScript("OnClick")
	lockpos:SetScript("OnClick", function() OUF_FREEBGRIDMOVABLE() end)
	lockpos:SetChecked(not oUF_Freebgrid.db.locked)

	------------------------------------------------------------------------------------------

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

	--------------------------------------------------------------------------------------
	local texturedropdown, texturedropdowntext, texturedropdowncontainer = tekdropdown.new(frame, "Texture", "TOPRIGHT", frame, 0, -40)
	texturedropdowntext:SetText(oUF_Freebgrid.db.texture or FreebgridDefaults.texture)
	texturedropdown.tiptext = "Change the unit's texture."

	local function OnClick()
		UIDropDownMenu_SetSelectedValue(texturedropdown, this.value)
		texturedropdowntext:SetText(this.value)
		oUF_Freebgrid:SetTex(this.value)
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
	
	local fontdropdown, fontdropdowntext, fontdropdowncontainer = tekdropdown.new(frame, "Font", "TOPRIGHT", frame, 0, -85)
	fontdropdowntext:SetText(oUF_Freebgrid.db.font or FreebgridDefaults.font)
	fontdropdown.tiptext = "Change the unit's font."

	local function FontOnClick()
		UIDropDownMenu_SetSelectedValue(fontdropdown, this.value)
		fontdropdowntext:SetText(this.value)
		oUF_Freebgrid:SetFont(this.value)
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
	
	local reload = tekbutton.new_small(frame)
	reload:SetPoint("BOTTOMRIGHT", -16, 16)
	reload:SetText("Reload")
	reload.tiptext = "Reload UI to apply settings"
	reload:SetScript("OnClick", function() ReloadUI() end)

	frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(frame)

---------------------
--      Panel2     --
---------------------

local f = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
f.name = "More setting..."
f.parent = "oUF_Freebgrid"
f:Hide()
f:SetScript("OnShow", function(f)

	local reload = tekbutton.new_small(f)
	reload:SetPoint("BOTTOMRIGHT", -16, 16)
	reload:SetText("Reload")
	reload.tiptext = "Reload UI to apply settings"
	reload:SetScript("OnClick", function() ReloadUI() end)

	f:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(f)
