local _, ns = ...
local oUF = ns.oUF or oUF
--[[
	This is a stripped and modified oUF MovableFrames to fit my needs.
	-- freebaser
]]--
local _DB
local _LOCK

local round = function(n)
	return math.floor(n * 1e5 + .5) / 1e5
end

local getPoint = function(obj)
	local UIx, UIy = UIParent:GetCenter()
	local Ox, Oy = obj:GetCenter()

	-- Frame doesn't really have a positon yet.
	if(not Ox) then return end

	local UIS = UIParent:GetEffectiveScale()
	local OS = obj:GetEffectiveScale()

	local UIWidth, UIHeight = UIParent:GetRight(), UIParent:GetTop()

	local LEFT = UIWidth / 3
	local RIGHT = UIWidth * 2 / 3

	local point, x, y
	if(Ox >= RIGHT) then
		point = 'RIGHT'
		x = obj:GetRight() - UIWidth
	elseif(Ox <= LEFT) then
		point = 'LEFT'
		x = obj:GetLeft()
	else
		x = Ox - UIx
	end

	local BOTTOM = UIHeight / 3
	local TOP = UIHeight * 2 / 3

	if(Oy >= TOP) then
		point = 'TOP' .. (point or '')
		y = obj:GetTop() - UIHeight
	elseif(Oy <= BOTTOM) then
		point = 'BOTTOM' .. (point or '')
		y = obj:GetBottom()
	else
		if(not point) then point = 'CENTER' end
		y = Oy - UIy
	end

	return string.format(
		'%s\031%s\031%d\031%d',
		point, 'UIParent', round(x * UIS / OS),  round(y * UIS / OS)
	)
end

local function restorePosition(anchor)
	local style, identifier  = "Freebgrid", anchor:GetName()
	-- We've not saved any custom position for this style.
	if(not _DB[style] or not _DB[style][identifier]) then return end

	local scale = anchor:GetScale()
	local SetPoint = getmetatable(anchor).__index.SetPoint;

	-- Hah, a spot you have to use semi-colon!
	-- Guess I've never experienced that as these are usually wrapped in do end
	-- statements.
	(anchor).SetPoint = restorePosition;
	(anchor):ClearAllPoints();

	-- damn it Blizzard, _how_ did you manage to get the input of this function
	-- reversed. Any sane person would implement this as: split(str, dlm, lim);
	local point, parentName, x, y = string.split('\031', _DB[style][identifier])
	SetPoint(anchor, point, parentName, point, x / scale, y / scale)
end

local savePosition = function(anchor)
	local style, identifier  = "Freebgrid", anchor:GetName()
	if(not _DB[style]) then _DB[style] = {} end
	
	_DB[style][identifier] = getPoint(anchor)
end

local setframe
do
	local OnDragStart = function(self)
		self:StartMoving()
	end

	local OnDragStop = function(self)
		self:StopMovingOrSizing()
		savePosition(self)
	end
	
	setframe = function(frame)
		frame:SetHeight(oUF_Freebgrid.db.height)
		frame:SetWidth(oUF_Freebgrid.db.width)
		frame:SetScale(oUF_Freebgrid.db.scale)
		frame:SetFrameStrata"TOOLTIP"
		frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background";})
		frame:EnableMouse(true)
		frame:SetMovable(true)
		frame:SetClampedToScreen(true)
		frame:RegisterForDrag"LeftButton"
		frame:SetBackdropBorderColor(0, .9, 0)
		frame:SetBackdropColor(0, .9, 0)
		frame:Hide()

		frame:SetScript("OnDragStart", OnDragStart)
		frame:SetScript("OnDragStop", OnDragStop)
		
		frame.name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.name:SetPoint"CENTER"
		frame.name:SetJustifyH"CENTER"
		frame.name:SetFont(GameFontNormal:GetFont(), 12)
		frame.name:SetTextColor(1, 1, 1)
		
		return frame
	end
end

local _LOCK
local anchorpool = {}
local anchors = function()
	local raidframe = CreateFrame("Frame", "oUF_FreebgridRaidFrame", UIParent)
	setframe(raidframe)
	raidframe.name:SetText("Raid")
	raidframe:SetPoint("LEFT", UIParent, "LEFT", 8, 0)
	anchorpool["oUF_FreebgridRaidFrame"] = raidframe
	
	local petframe = CreateFrame("Frame", "oUF_FreebgridPetFrame", UIParent)
	setframe(petframe)
	petframe.name:SetText("Pet")
	petframe:SetPoint("LEFT", UIParent, "LEFT", 250, 0)
	anchorpool["oUF_FreebgridPetFrame"] = petframe
	
	local mtframe = CreateFrame("Frame", "oUF_FreebgridMTFrame", UIParent)
	setframe(mtframe)
	mtframe.name:SetText("MT")
	mtframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -25)
	anchorpool["oUF_FreebgridMTFrame"] = mtframe
end

do
	local frame = CreateFrame"Frame"
	frame:SetScript("OnEvent", function(self)
		return self[event](self)
	end)

	function frame:VARIABLES_LOADED()
		-- I honestly don't trust the load order of SVs.
		_DB = Freebgridomf or {}
		Freebgridomf = _DB
		
		anchors()
		-- Got to catch them all!
		for _, frame in next, anchorpool do
			restorePosition(frame)
		end

		self:UnregisterEvent"VARIABLES_LOADED"
		self.VARIABLES_LOADED = nil
	end
	frame:RegisterEvent"VARIABLES_LOADED"

	function frame:PLAYER_REGEN_DISABLED()
		if(_LOCK) then
			print("Anchors hidden due to combat.")
			for k, frame in next, anchorpool do
				frame:Hide()
			end
			_LOCK = nil
		end
	end
	frame:RegisterEvent"PLAYER_REGEN_DISABLED"
end

OUF_FREEBGRIDMOVABLE = function()
	if(InCombatLockdown()) then
		return print"Frames cannot be moved while in combat. Bailing out."
	end
	
	if(not _LOCK) then
		for k, frame in next, anchorpool do
			frame:Show()
		end
		_LOCK = true
	else
		for k, frame in next, anchorpool do
			frame:Hide()
		end
		_LOCK = nil
	end
end