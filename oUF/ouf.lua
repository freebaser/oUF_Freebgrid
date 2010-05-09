local parent, ns = ...
local global = GetAddOnMetadata(parent, 'X-oUF')
local _VERSION = GetAddOnMetadata(parent, 'version')

local function argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end

local print = function(...) print("|cff33ff99oUF:|r", ...) end
local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end
local dummy = function() end

-- Colors
local colors = {
	happiness = {
		[1] = {1, 0, 0}, -- need.... | unhappy
		[2] = {1, 1, 0}, -- new..... | content
		[3] = {0, 1, 0}, -- colors.. | happy
	},
	smooth = {
		1, 0, 0,
		1, 1, 0,
		0, 1, 0
	},
	disconnected = {.6, .6, .6},
	tapped = {.6,.6,.6},
	class = {},
	reaction = {},
}

-- We do this because people edit the vars directly, and changing the default
-- globals makes SPICE FLOW!
if(IsAddOnLoaded'!ClassColors' and CUSTOM_CLASS_COLORS) then
	local updateColors = function()
		for eclass, color in next, CUSTOM_CLASS_COLORS do
			colors.class[eclass] = {color.r, color.g, color.b}
		end

		local oUF = ns.oUF or _G[parent]
		if(oUF) then
			for _, obj in next, oUF.objects do
				obj:UpdateAllElements("CUSTOM_CLASS_COLORS")
			end
		end
	end

	updateColors()
	CUSTOM_CLASS_COLORS:RegisterCallback(updateColors)
else
	for eclass, color in next, RAID_CLASS_COLORS do
		colors.class[eclass] = {color.r, color.g, color.b}
	end
end

for eclass, color in next, FACTION_BAR_COLORS do
	colors.reaction[eclass] = {color.r, color.g, color.b}
end

-- add-on object
local oUF = {}
local event_metatable = {
	__call = function(funcs, self, ...)
		for _, func in next, funcs do
			func(self, ...)
		end
	end,
}

local styles, style = {}
local callback, units, objects = {}, {}, {}

local select  = select
local UnitExists = UnitExists

local conv = {
	['playerpet'] = 'pet',
	['playertarget'] = 'target',
}
local elements = {}

local enableTargetUpdate = function(object)
	-- updating of "invalid" units.
	local OnTargetUpdate
	do
		local timer = 0
		OnTargetUpdate = function(self, elapsed)
			if(not self.unit) then
				return
			elseif(timer >= .5) then
				self:UpdateAllElements'OnTargetUpdate'
				timer = 0
			end

			timer = timer + elapsed
		end
	end

	object:SetScript("OnUpdate", OnTargetUpdate)
end

-- Events
local OnEvent = function(self, event, ...)
	if(not self:IsShown()) then return end
	return self[event](self, event, ...)
end

local iterateChildren = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)

		if(type(obj) == 'table' and obj.isChild) then
			local unit = SecureButton_GetModifiedUnit(obj)
			local subUnit = conv[unit] or unit
			units[subUnit] = obj
			obj.unit = subUnit
			obj:UpdateAllElements"PLAYER_ENTERING_WORLD"
		end
	end
end

local OnAttributeChanged = function(self, name, value)
	if(name == "unit" and value) then
		units[value] = self

		if(self.unit and self.unit == value) then
			return
		else
			if(self.hasChildren) then
				iterateChildren(self:GetChildren())
			end

			self.unit = SecureButton_GetModifiedUnit(self)
			self.id = value:match"^.-(%d+)"
			self:UpdateAllElements"PLAYER_ENTERING_WORLD"
		end
	end
end

do
	local HandleFrame = function(baseName)
		local frame
		if(type(baseName) == 'string') then
			frame = _G[baseName]
		else
			frame = baseName
		end

		if(frame) then
			frame:UnregisterAllEvents()
			frame.Show = dummy
			frame:Hide()

			local health = frame.healthbar
			if(health) then
				health:UnregisterAllEvents()
			end

			local power = frame.manabar
			if(power) then
				power:UnregisterAllEvents()
			end

			local spell = frame.spellbar
			if(spell) then
				spell:UnregisterAllEvents()
			end
		end
	end

	function oUF:DisableBlizzard(unit, object)
		if(not unit) then return end

		local baseName
		if(unit == 'player') then
			HandleFrame(PlayerFrame)

			-- For the damn vehicle support:
			PlayerFrame:RegisterEvent('UNIT_ENTERING_VEHICLE')
			PlayerFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
			PlayerFrame:RegisterEvent('UNIT_EXITING_VEHICLE')
			PlayerFrame:RegisterEvent('UNIT_EXITED_VEHICLE')
		elseif(unit == 'pet') then
			baseName = PetFrame
		elseif(unit == 'target') then
			if(object) then
				object:RegisterEvent('PLAYER_TARGET_CHANGED', object.UpdateAllElements)
			end

			HandleFrame(TargetFrame)
			return HandleFrame(ComboFrame)
		elseif(unit == 'mouseover') then
			if(object) then
				return object:RegisterEvent('UPDATE_MOUSEOVER_UNIT', object.UpdateAllElements)
			end
		elseif(unit == 'focus') then
			if(object) then
				object:RegisterEvent('PLAYER_FOCUS_CHANGED', object.UpdateAllElements)
			end

			baseName = FocusFrame
		elseif(unit:match'%w+target') then
			if(unit == 'targettarget') then
				baseName = TargetFrameToT
			end

			enableTargetUpdate(object)
		elseif(unit:match'(boss)%d?$' == 'boss') then
			enableTargetUpdate(object)

			local id = unit:match'boss(%d)'
			if(id) then
				baseName = 'Boss' .. id .. 'TargetFrame'
			else
				for i=1, 3 do
					HandleFrame(('Boss%dTargetFrame'):format(i))
				end
			end
		elseif(unit:match'(party)%d?$' == 'party') then
			local id = unit:match'party(%d)'
			if(id) then
				baseName = 'PartyMemberFrame' .. id
			else
				for i=1, 4 do
					HandleFrame(('PartyMemberFrame%d'):format(i))
				end
			end
		end

		if(baseName) then
			return HandleFrame(baseName)
		end
	end
end

local frame_metatable = {
	__index = CreateFrame"Button"
}

for k, v in pairs{
	colors = colors;

	EnableElement = function(self, name, unit)
		argcheck(name, 2, 'string')
		argcheck(unit, 3, 'string', 'nil')

		local element = elements[name]
		if(not element) then return end

		local updateFunc = element.update
		local elementTable = self[name]
		if(type(elementTable) == 'table' and elementTable.Update) then
			updateFunc = elementTable.Update
		end

		if(element.enable(self, unit or self.unit)) then
			table.insert(self.__elements, updateFunc)
		end
	end,

	DisableElement = function(self, name)
		argcheck(name, 2, 'string')
		local element = elements[name]
		if(not element) then return end

		local updateFunc = element.update
		local elementTable = self[name]
		if(type(elementTable == 'table') and elementTable.Update) then
			updateFunc = elementTable.Update
		end

		for k, update in next, self.__elements do
			if(update == updateFunc) then
				table.remove(self.__elements, k)

				-- We need to run a new update cycle incase we knocked ourself out of sync.
				-- The main reason we do this is to make sure the full update is completed
				-- if an element for some reason removes itself _during_ the update
				-- progress.
				self:UpdateAllElements('DisableElement', name)
				break
			end
		end

		return element.disable(self)
	end,

	UpdateElement = function(self, name)
		argcheck(name, 2, 'string')
		local element = elements[name]
		if(not element) then return end

		local updateFunc = element.update
		local elementTable = self[name]
		if(type(elementTable == 'table') and elementTable.Update) then
			updateFunc = elementTable.Update
		end

		updateFunc(self, 'UpdateElement', self.unit)
	end,

	Enable = RegisterUnitWatch,
	Disable = function(self)
		UnregisterUnitWatch(self)
		self:Hide()
	end,

	UpdateAllElements = function(self, event)
		local unit = self.unit
		if(not UnitExists(unit)) then return end

		for _, func in next, self.__elements do
			func(self, event, unit)
		end
	end,
} do
	frame_metatable.__index[k] = v
end

do
	local RegisterEvent = frame_metatable.__index.RegisterEvent
	function frame_metatable.__index:RegisterEvent(event, func)
		argcheck(event, 2, 'string')

		if(type(func) == 'string' and type(self[func]) == 'function') then
			func = self[func]
		end

		local curev = self[event]
		if(curev and func) then
			if(type(curev) == 'function') then
				self[event] = setmetatable({curev, func}, event_metatable)
			else
				for _, infunc in next, curev do
					if(infunc == func) then return end
				end

				table.insert(curev, func)
			end
		elseif(self:IsEventRegistered(event)) then
			return
		else
			if(func) then
				self[event] = func
			elseif(not self[event]) then
				return error("Handler for event [%s] on unit [%s] does not exist.", event, self.unit or 'unknown')
			end

			RegisterEvent(self, event)
		end
	end
end

do
	local UnregisterEvent = frame_metatable.__index.UnregisterEvent
	function frame_metatable.__index:UnregisterEvent(event, func)
		argcheck(event, 2, 'string')

		local curev = self[event]
		if(type(curev) == 'table' and func) then
			for k, infunc in next, curev do
				if(infunc == func) then
					curev[k] = nil

					if(#curev == 0) then
						table.remove(curev, k)
						UnregisterEvent(self, event)
					end

					break
				end
			end
		else
			self[event] = nil
			UnregisterEvent(self, event)
		end
	end
end

local ColorGradient
do
	local inf = math.huge
	-- http://www.wowwiki.com/ColorGradient
	function ColorGradient(perc, ...)
		-- Translate divison by zeros into 0, so we don't blow select.
		-- We check perc against itself because we rely on the fact that NaN can't equal NaN.
		if(perc ~= perc or perc == inf) then perc = 0 end

		if perc >= 1 then
			local r, g, b = select(select('#', ...) - 2, ...)
			return r, g, b
		elseif perc <= 0 then
			local r, g, b = ...
			return r, g, b
		end

		local num = select('#', ...) / 3
		local segment, relperc = math.modf(perc*(num-1))
		local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

		return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
	end
end
frame_metatable.__index.ColorGradient = ColorGradient
oUF.ColorGradient = ColorGradient

local initObject = function(unit, style, styleFunc, ...)
	local num = select('#', ...)
	for i=1, num do
		local object = select(i, ...)

		object.__elements = {}
		object = setmetatable(object, frame_metatable)

		-- Attempt to guess what the header is set to spawn.
		local parent = object:GetParent()
		if(not unit) then
			if(parent:GetAttribute'showRaid') then
				unit = 'raid'
			elseif(parent:GetAttribute'showParty') then
				unit = 'party'
			end
		end

		-- Run it before the style function so they can override it.
		object:SetAttribute("*type1", "target")
		object.style = style

		if(num > 1) then
			if(i == 1) then
				object.hasChildren = true
			else
				object.isChild = true
			end
		end

		-- Register it early so it won't be executed after the layouts PEW, if they
		-- have one.
		object:RegisterEvent("PLAYER_ENTERING_WORLD", object.UpdateAllElements)

		styleFunc(object, unit)

		local height = object:GetAttribute'initial-height'
		local width = object:GetAttribute'initial-width'
		local scale = object:GetAttribute'initial-scale'
		local suffix = object:GetAttribute'unitsuffix'
		local combat = InCombatLockdown()

		if(height) then
			object:SetAttribute('initial-height', height)
			if(not combat) then object:SetHeight(height) end
		end

		if(width) then
			object:SetAttribute("initial-width", width)
			if(not combat) then object:SetWidth(width) end
		end

		if(scale) then
			object:SetAttribute("initial-scale", scale)
			if(not combat) then object:SetScale(scale) end
		end

		local showPlayer
		if(i == 1) then
			showPlayer = parent:GetAttribute'showPlayer' or parent:GetAttribute'showSolo'
		end

		if(suffix and suffix:match'target' and (i ~= 1 and not showPlayer)) then
			enableTargetUpdate(object)
		else
			object:SetScript("OnEvent", OnEvent)
		end

		object:SetScript("OnAttributeChanged", OnAttributeChanged)
		object:SetScript("OnShow", object.UpdateAllElements)

		for element in next, elements do
			object:EnableElement(element, unit)
		end

		for _, func in next, callback do
			func(object)
		end

		-- We could use ClickCastFrames only, but it will probably contain frames that
		-- we don't care about.
		table.insert(objects, object)
		_G.ClickCastFrames = ClickCastFrames or {}
		ClickCastFrames[object] = true
	end
end

local walkObject = function(object, unit)
	local style = object:GetParent().style or style
	local styleFunc = styles[style]

	return initObject(unit, style, styleFunc, object, object:GetChildren())
end

function oUF:RegisterInitCallback(func)
	table.insert(callback, func)
end

function oUF:RegisterMetaFunction(name, func)
	argcheck(name, 2, 'string')
	argcheck(func, 3, 'function', 'table')

	if(frame_metatable.__index[name]) then
		return
	end

	frame_metatable.__index[name] = func
end

function oUF:RegisterStyle(name, func)
	argcheck(name, 2, 'string')
	argcheck(func, 3, 'function', 'table')

	if(styles[name]) then return error("Style [%s] already registered.", name) end
	if(not style) then style = name end

	styles[name] = func
end

function oUF:SetActiveStyle(name)
	argcheck(name, 2, 'string')
	if(not styles[name]) then return error("Style [%s] does not exist.", name) end

	style = name
end

local getCondition
do
	local conditions = {
		raid40 = '[@raid26,exists] show;',
		raid25 = '[@raid11,exists] show;',
		raid10 = '[@raid6,exists] show;',
		raid = '[group:raid] show;',
		party = '[group:party] show;',
		solo = '[@player,exists,nogroup:party] show;',
	}

	function getCondition(...)
		local cond = ''

		for i=1, select('#', ...) do
			local short = select(i, ...)

			local condition = conditions[short]
			if(condition) then
				cond = cond .. condition
			end
		end

		return cond .. 'hide'
	end
end

local generateName = function(unit, ...)
	local name = 'oUF_' .. style:gsub('[^%a%d_]+', '')

	local raid, party, groupFilter
	for i=1, select('#', ...), 2 do
		local att, val = select(i, ...)
		if(att == 'showRaid') then
			raid = true
		elseif(att == 'showParty') then
			party = true
		elseif(att == 'groupFilter') then
			groupFilter = val
		end
	end

	local append
	if(raid) then
		if(groupFilter) then
			if(groupFilter:match'TANK') then
				append = 'MainTank'
			elseif(groupFilter:match'ASSIST') then
				append =  'MainAssist'
			else
				local _, count = groupFilter:gsub(',', '')
				if(count == 0) then
					append = groupFilter
				else
					append = 'Raid'
				end
			end
		else
			append = 'Raid'
		end
	elseif(party) then
		append = 'Party'
	elseif(unit) then
		append = unit:gsub("^%l", string.upper)
	end

	if(append) then
		name = name .. append
	end

	local base = name
	local i = 2
	while(_G[name]) do
		name = base .. i
		i = i + 1
	end

	return name
end

function oUF:SpawnHeader(overrideName, template, visibility, ...)
	if(not style) then return error("Unable to create frame. No styles have been registered.") end

	local name = overrideName or generateName(nil, ...)
	local header = CreateFrame('Frame', name, UIParent, template or 'SecureGroupHeaderTemplate')
	header.initialConfigFunction = walkObject
	header.style = style

	header:SetAttribute("template", "SecureUnitButtonTemplate")
	for i=1, select("#", ...), 2 do
		local att, val = select(i, ...)
		if(not att) then break end
		header:SetAttribute(att, val)
	end

	if(header:GetAttribute'showParty') then
		self:DisableBlizzard'party'
	end

	if(visibility) then
		local type, list = string.split(' ', visibility, 2)
		if(list and type == 'custom') then
			RegisterStateDriver(header, 'visibility', list)
		else
			local condition = getCondition(string.split(',', visibility))
			RegisterStateDriver(header, 'visibility', condition)
		end
	end

	return header
end

function oUF:Spawn(unit, overrideName)
	argcheck(unit, 2, 'string')
	if(not style) then return error("Unable to create frame. No styles have been registered.") end

	unit = unit:lower()

	local name = overrideName or generateName(unit)
	local object = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
	object.unit = unit
	object.id = unit:match"^.-(%d+)"

	units[unit] = object
	walkObject(object, unit)

	object:SetAttribute("unit", unit)
	RegisterUnitWatch(object)

	self:DisableBlizzard(unit, object)

	return object
end

function oUF:AddElement(name, update, enable, disable)
	argcheck(name, 2, 'string')
	argcheck(update, 3, 'function', 'nil')
	argcheck(enable, 4, 'function', 'nil')
	argcheck(disable, 5, 'function', 'nil')

	if(elements[name]) then return error('Element [%s] is already registered.', name) end
	elements[name] = {
		update = update;
		enable = enable;
		disable = disable;
	}
end

oUF.version = _VERSION
oUF.units = units
oUF.objects = objects
oUF.colors = colors

if(global) then
	if(parent ~= 'oUF' and global == 'oUF') then
		error("%s is doing it wrong and setting its global to oUF.", parent)
	else
		_G[global] = oUF
	end
end
ns.oUF = oUF
