--[[
	oUF_MoveableFrames
	
	Written By:  Derkyle
	
	Allows users to move custom oUF layout frames
	
	Striped and modified by Freebaser to work with oUF_Freebgrid
--]]

local _, ns = ...
local oUF = ns.oUF

local headerlist = {}

oUF_Freebgrid_locked = true

local function SaveLayout(frame)

	if frame == nil then
		return
	end

	local opt = oUF_Freebgrid[frame] or nil;

	if opt == nil then 
		oUF_Freebgrid[frame] = {};
		opt = oUF_Freebgrid[frame];
	end

	local f = getglobal(frame);
	local scale = f:GetEffectiveScale();
	opt.PosX = f:GetLeft() * scale;
	opt.PosY = f:GetTop() * scale;

end

local function RestoreLayout(frame)
	
	if frame == nil then return end

	local f = getglobal(frame);
	local opt = oUF_Freebgrid[frame] or nil;

	if opt == nil then return end

	local x = opt.PosX;
	local y = opt.PosY;
	local s = f:GetEffectiveScale();

		if x == nil or y == nil then
		f:ClearAllPoints();
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
		return 
		end

	--calculate the scale
	x,y = x/s,y/s;

	--set the location
	f:ClearAllPoints();
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);

end

function oUF_Freebgrid_HEADER(frame, desc, ofsx, ofsy)
	if frame == nil then return end
	if oUF_Freebgrid == nil then oUF_Freebgrid = {} end
	
	local frameName
	
	if type(frame) == "string" then
		frameName = frame
	elseif type(frame) == "table" then
		frameName = frame:GetName()
	end
	
	if frameName == nil then
		return
	end
	
	frameName = frameName.."AnchorFrm"
	
	if oUF_Freebgrid[frameName] == nil then
		oUF_Freebgrid[frameName] = {}
		oUF_Freebgrid[frameName].PosX = ofsx
		oUF_Freebgrid[frameName].PosY = ofsy
	end
	
	headerlist[frameName] = true

	--create the anchor
	local frameAnchor = CreateFrame("Frame", frameName, UIParent)
	
	frameAnchor:SetWidth(25)
	frameAnchor:SetHeight(25)
	frameAnchor:SetMovable(true)
	frameAnchor:SetClampedToScreen(true)
	frameAnchor:EnableMouse(true)
	frameAnchor.desc = desc or frameName --store the description
	
	frameAnchor:ClearAllPoints()
	frameAnchor:SetPoint("CENTER", UIParent, "CENTER", oUF_Freebgrid[frameName].PosX, oUF_Freebgrid[frameName].PosY)
	frameAnchor:SetFrameStrata("DIALOG")
	
	frameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frameAnchor:SetBackdropColor(0.75,0,0,1)
	frameAnchor:SetBackdropBorderColor(0.75,0,0,1)

	frameAnchor:SetScript("OnLeave",function(self)
		GameTooltip:Hide()
	end)

	frameAnchor:SetScript("OnEnter",function(self)
	
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(OUF_Freebgrid_TipAnchor(self))
		GameTooltip:ClearLines()

		GameTooltip:AddLine(self:GetName())
		GameTooltip:AddLine(self.desc)
		GameTooltip:Show()
	end)

	frameAnchor:SetScript("OnMouseDown", function(frame, button)
		if frame:IsMovable() then
			frame.isMoving = true
			frame:StartMoving()
		end
	end)

	frameAnchor:SetScript("OnMouseUp", function(frame, button) 
		if( frame.isMoving ) then
			frame.isMoving = nil
			frame:StopMovingOrSizing()
			SaveLayout(frame:GetName())
		end
	end)
	
	frameAnchor:Hide() -- hide it by default
			
	--setpoint to the newly created anchor
	getglobal(frame):ClearAllPoints()
	getglobal(frame):SetPoint("TOP", frameAnchor, "BOTTOM", 0, 0)

	--just in case on load up (call me anal but it's better to be safe then sorry)
	RestoreLayout(frameName)
end

--tooltip position correction
function OUF_Freebgrid_TipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end

local eventFrame = CreateFrame("Frame", nil, UIParent)
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		if oUF_Freebgrid == nil then oUF_Freebgrid = {} end
		
		--HEADERS: Restore custom header positions
		for i, value in pairs(headerlist) do
			RestoreLayout(i)
		end
		
	end
end)

local function SlashCommand(cmd)
	if oUF_Freebgrid_locked then
		oUF_Freebgrid_locked = false
		for i, value in pairs(headerlist) do
			getglobal(i):Show()
		end
		DEFAULT_CHAT_FRAME:AddMessage("Freebgrid is now [UNLOCKED].")
	else
		oUF_Freebgrid_locked = true
		for i, value in pairs(headerlist) do
			getglobal(i):Hide()
		end
		DEFAULT_CHAT_FRAME:AddMessage("Freebgrid is now [LOCKED].")
	end
	return true
end

SLASH_OUF_FREEBGRID1 = "/freeb";
SlashCmdList["OUF_FREEBGRID"] = SlashCommand;