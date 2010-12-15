--[[--------------------------------------------------------------------
	Based on tekKonfig-Dropdown by Tekkub.
	Requires LibStub.
----------------------------------------------------------------------]]

local MINOR_VERSION = tonumber(("$Revision: 28 $"):match("%d+"))

local lib, oldminor = LibStub:NewLibrary("freeb-Dropdown", MINOR_VERSION)
if not lib then return end

local function Frame_OnEnter(self)
	if self.desc then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.desc, nil, nil, nil, nil, true)
	end
end

local function Button_OnEnter(self)
	return Frame_OnEnter(self:GetParent():GetParent())
end

local function OnLeave()
	GameTooltip:Hide()
end

local function OnClick(self)
	PlaySound("igMainMenuOptionCheckBoxOn")
	ToggleDropDownMenu(nil, nil, self:GetParent())
end

local function OnHide()
	CloseDropDownMenus()
end

local function GetValue(self)
	return UIDropDownMenu_GetSelectedValue(self.dropdown) or self.valueText:GetText()
end

local function SetValue(self, value, text)
	self.valueText:SetText(text or value)
	UIDropDownMenu_SetSelectedValue(self.dropdown, value or "UNKNOWN")
end

local i = 0
function lib.CreateDropdown(parent, name, init)
	i = i + 1

	local frame = CreateFrame("Frame", nil, parent)
	frame:SetHeight(42)
	frame:SetWidth(150)
	frame:EnableMouse(true)
	frame:SetScript("OnEnter", Frame_OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnHide", OnHide)

	local dropdown = CreateFrame("Frame", "PhanxConfigDropdown" .. i, frame)
	dropdown:SetPoint("TOPLEFT", frame, -16, -14)
	dropdown:SetPoint("TOPRIGHT", frame, 16, -14)
	dropdown:SetHeight(32)

	local ltex = dropdown:CreateTexture(dropdown:GetName() .. "Left", "ARTWORK")
	ltex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	ltex:SetTexCoord(0, 0.1953125, 0, 1)
	ltex:SetPoint("TOPLEFT", dropdown, 0, 17)
	ltex:SetWidth(25)
	ltex:SetHeight(64)

	local rtex = dropdown:CreateTexture(nil, "BORDER")
	rtex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	rtex:SetTexCoord(0.8046875, 1, 0, 1)
	rtex:SetPoint("TOPRIGHT", dropdown, 0, 17)
	rtex:SetWidth(25)
	rtex:SetHeight(64)

	local mtex = dropdown:CreateTexture(nil, "BORDER")
	mtex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	mtex:SetTexCoord(0.1953125, 0.8046875, 0, 1)
	mtex:SetPoint("LEFT", ltex, "RIGHT")
	mtex:SetPoint("RIGHT", rtex, "LEFT")
	mtex:SetHeight(64)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 20, 0)
	label:SetPoint("BOTTOMRIGHT", dropdown, "TOPRIGHT", -20, 0)
	label:SetJustifyH("LEFT")
	label:SetText(name)

	local value = dropdown:CreateFontString(dropdown:GetName() .. "Text", "OVERLAY", "GameFontHighlightSmall")
	value:SetPoint("LEFT", ltex, 26, 2)
	value:SetPoint("RIGHT", rtex, -43, 2)
	value:SetJustifyH("LEFT")
	value:SetHeight(10)

	local button = CreateFrame("Button", nil, dropdown)
	button:SetPoint("TOPRIGHT", rtex, -16, -18)
	button:SetWidth(24)
	button:SetHeight(24)
	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnClick", OnClick)

	button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:GetHighlightTexture():SetBlendMode("ADD")

	frame.button = button
	frame.dropdown = dropdown
	frame.labelText = label
	frame.valueText = value

	frame.GetValue = GetValue
	frame.SetValue = SetValue

	if init then
		UIDropDownMenu_Initialize(dropdown, init)
	end

	return frame
end
