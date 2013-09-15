local ADDON_NAME, ns = "oUF_Freebgrid", Freebgrid_NS

local indicator = ns.mediapath.."squares.ttf"
local symbols = ns.mediapath.."PIZZADUDEBULLETS.ttf"

ns.outline = {
	["None"] = "None",
	["OUTLINE"] = "OUTLINE",
	["THINOUTLINE"] = "THINOUTLINE",
	["MONOCHROME"] = "MONOCHROME",
	["OUTLINEMONO"] = "OUTLINEMONOCHROME",
}

ns.orientation = {
	["VERTICAL"] = "VERTICAL",
	["HORIZONTAL"] = "HORIZONTAL",
}

local function updateFonts(object)
	object.Name:SetFont(ns.db.fontPath, ns.db.fontsize, ns.db.outline)
	object.Name:SetWidth(ns.db.width)
	object.AFKtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
	object.AFKtext:SetWidth(ns.db.width)
	object.AuraStatusCen:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
	object.AuraStatusCen:SetWidth(ns.db.width)
	object.Healtext:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline) 
	object.Healtext:SetWidth(ns.db.width)
	if object.freebCluster then
		object.freebCluster:SetTextColor(ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b)
		object.freebCluster:SetFont(ns.db.fontPath, ns.db.fontsizeEdge, ns.db.outline)
		object.freebCluster:SetWidth(ns.db.width)
	end
end

local function updateIndicators(object)
	object.AuraStatusTL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
	object.AuraStatusTR:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
	object.AuraStatusBL:SetFont(indicator, ns.db.indicatorsize, "THINOUTLINE")
	object.AuraStatusBR:SetFont(symbols, ns.db.symbolsize, "THINOUTLINE")
end

local function updateIcons(object)
	object.Leader:SetSize(ns.db.leadersize, ns.db.leadersize)
	object.Assistant:SetSize(ns.db.leadersize, ns.db.leadersize)
	object.MasterLooter:SetSize(ns.db.leadersize, ns.db.leadersize)
	object.RaidIcon:SetSize(ns.db.leadersize+2, ns.db.leadersize+2)
	object.ReadyCheck:SetSize(ns.db.leadersize, ns.db.leadersize)
	object.freebAuras.button:SetSize(ns.db.aurasize, ns.db.aurasize)
	object.freebAuras.size = ns.db.aurasize
end

local function updateHealbar(object)
	if not object.myHealPredictionBar then return end

	object.myHealPredictionBar:ClearAllPoints()
	object.otherHealPredictionBar:ClearAllPoints()

	if ns.db.orientation == "VERTICAL" then
		if ns.db.hpreversed then
			object.myHealPredictionBar:SetPoint("TOPLEFT", object.Health:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
			object.myHealPredictionBar:SetPoint("TOPRIGHT", object.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			object.myHealPredictionBar:SetReverseFill(true)

			object.otherHealPredictionBar:SetPoint("TOPLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
			object.otherHealPredictionBar:SetPoint("TOPRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			object.otherHealPredictionBar:SetReverseFill(true)
		else
			object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
			object.myHealPredictionBar:SetPoint("BOTTOMRIGHT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			object.myHealPredictionBar:SetReverseFill(false)

			object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
			object.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			object.otherHealPredictionBar:SetReverseFill(false)
		end
		object.myHealPredictionBar:SetSize(0, ns.db.height)
		object.myHealPredictionBar:SetOrientation"VERTICAL"

		object.otherHealPredictionBar:SetSize(0, ns.db.height)
		object.otherHealPredictionBar:SetOrientation"VERTICAL"
	else
		if ns.db.hpreversed then
			object.myHealPredictionBar:SetPoint("TOPRIGHT", object.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
			object.myHealPredictionBar:SetPoint("BOTTOMRIGHT", object.Health:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
			object.myHealPredictionBar:SetReverseFill(true)

			object.otherHealPredictionBar:SetPoint("TOPRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPLEFT", 0, 0)
			object.otherHealPredictionBar:SetPoint("BOTTOMRIGHT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
			object.otherHealPredictionBar:SetReverseFill(true)
		else
			object.myHealPredictionBar:SetPoint("TOPLEFT", object.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			object.myHealPredictionBar:SetPoint("BOTTOMLEFT", object.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			object.myHealPredictionBar:SetReverseFill(false)

			object.otherHealPredictionBar:SetPoint("TOPLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			object.otherHealPredictionBar:SetPoint("BOTTOMLEFT", object.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			object.otherHealPredictionBar:SetReverseFill(false)
		end
		object.myHealPredictionBar:SetSize(ns.db.width, 0)
		object.myHealPredictionBar:SetOrientation"HORIZONTAL"

		object.otherHealPredictionBar:SetSize(ns.db.width, 0)
		object.otherHealPredictionBar:SetOrientation"HORIZONTAL"
	end

	object.myHealPredictionBar:SetStatusBarColor(ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a)
	object.otherHealPredictionBar:SetStatusBarColor(ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a)
end

local updateCluster = function(object)
	if ns.db.cluster.enabled then
		object:EnableElement('freebCluster')
	else
		object:DisableElement('freebCluster') 
	end
end

local lockprint
local function updateObjects()
	if(InCombatLockdown()) then
		ns:RegisterEvent("PLAYER_REGEN_ENABLED")
		if not lockprint then
			lockprint = true
			print("Your in combat silly. Delaying updates until combat ends.")
		end
		return
	end

	for _, object in next, ns._Objects do
		object:SetSize(ns.db.width, ns.db.height)
		--object:SetScale(ns.db.scale)

		object.freebarrow:SetScale(ns.db.arrowscale)

		ns:UpdateHealth(object.Health)
		ns:UpdatePower(object.Power)
		if UnitExists(object.unit) then
			object.Health:ForceUpdate()
			object.Power:ForceUpdate()
		end
		updateFonts(object)
		updateIndicators(object)
		updateIcons(object)
		updateHealbar(object)
		updateCluster(object)

		ns:UpdateName(object.Name, object.unit)

		if ns.db.smooth then
			object:EnableElement('freebSmooth')
		else
			object:DisableElement('freebSmooth')
		end

		if ns.db.autorez then
			object:EnableElement('freebAutoRez')
		else
			object:DisableElement('freebAutoRez')
		end
	end

	ns:scaleRaid()

	_G["oUF_FreebgridRaidFrame"]:SetSize(ns.db.width, ns.db.height)
	_G["oUF_FreebgridPetFrame"]:SetSize(ns.db.width, ns.db.height)
	_G["oUF_FreebgridMTFrame"]:SetSize(ns.db.width, ns.db.height)
end

function ns:PLAYER_REGEN_ENABLED()
	lockprint = nil
	updateObjects()

	ns:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

local SM = LibStub("LibSharedMedia-3.0", true)
local fonts = SM:List("font")
local statusbars = SM:List("statusbar")

local generalopts = {
	type = "group", name = "General", order = 1,
	args = {
		scale = {
			name = "Scale",
			type = "range",
			order = 1,
			min = 0.25,
			max = 2.0,
			step = .05,
			get = function(info) return ns.db.scale end,
			set = function(info,val) ns.db.scale = val; updateObjects() end,
		},
		scalegroup = {
			type = "group", name = "Scale on Raid size", order = 2, inline = true,
			args = {
				scaleYes = {
					name = "Enable",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.scaleYes end,
					set = function(info,val) ns.db.scaleYes = val; updateObjects() end,
				},
				scale25 = {
					name = "25 man",
					type = "range",
					order = 2,
					desc = "Scale of the frames when more than 10 members.", 
					min = 0.25,
					max = 2.0,
					step = .05,
					disabled = function(info) return not ns.db.scaleYes end,
					get = function(info) return ns.db.scale25 end,
					set = function(info,val) ns.db.scale25 = val; updateObjects() end,
				},
				scale40 = {
					name = "40 man",
					type = "range",
					order = 3,
					desc = "Scale of the frames when more than 25 members.",
					min = 0.25,
					max = 2.0,
					step = .05,
					disabled = function(info) return not ns.db.scaleYes end,
					get = function(info) return ns.db.scale40 end,
					set = function(info,val) ns.db.scale40 = val; updateObjects() end,
				},
			},
		},
		width = {
			name = "Width",
			type = "range",
			order = 4,
			min = 20,
			max = 150,
			step = 1,
			get = function(info) return ns.db.width end,
			set = function(info,val) ns.db.width = val; wipe(ns.nameCache); updateObjects() end,
		},
		height = {
			name = "Height",
			type = "range",
			order = 5,
			min = 20,
			max = 150,
			step = 1,
			get = function(info) return ns.db.height end,
			set = function(info,val) ns.db.height = val; updateObjects() end,
		},
		spacing = {
			name = "Space between units",
			type = "range",
			order = 6,
			min = 0,
			max = 30,
			step = 1,
			get = function(info) return ns.db.spacing end,
			set = function(info,val) ns.db.spacing = val; end,
		}, 
		raid = {
			name = "Raid",
			type = "group",
			order = 7,
			inline = true,
			args = {
				horizontal = {
					name = "Horizontal groups",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.horizontal end,
					set = function(info,val)
						if(val == true and (ns.db.growth ~= "UP" or ns.db.growth ~= "DOWN")) then
							ns.db.growth = "UP"
						elseif(val == false and (ns.db.growth ~= "RIGHT" or ns.db.growth ~= "LEFT")) then
							ns.db.growth = "RIGHT"
						end
						ns.db.horizontal = val; 
					end,
				},
				growth = {
					name = "Growth Direction",
					type = "select",
					order = 2,
					values = function(info,val) 
						info = ns.db.growth
						if not ns.db.horizontal then
							return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
						else
							return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
						end
					end,
					get = function(info) return ns.db.growth end,
					set = function(info,val) ns.db.growth = val; end,
				},
				groups = {
					name = "Number of groups",
					type = "range",
					order = 3,
					min = 1,
					max = 8,
					step = 1,
					get = function(info) return ns.db.numCol end,
					set = function(info,val) ns.db.numCol = val; end,
				},
				multi = {
					name = "Multiple headers",
					type = "toggle",
					desc = "Use multiple headers for better group sorting. Note: This disables units per group and sets it to 5.",
					order = 5,
					get = function(info) return ns.db.multi end,
					set = function(info,val) ns.db.multi = val 
						if val == true then
							ns.db.sortClass = false
							ns.db.sortName = false
						end
					end,
				},
				units = {
					name = "Units per group",
					type = "range",
					order = 4,
					min = 1,
					max = 40,
					step = 1,
					disabled = function(info) 
						if ns.db.multi then return true end 
					end,
					get = function(info) return ns.db.numUnits end,
					set = function(info,val) ns.db.numUnits = val; end,
				},
				sortName = {
					name = "Sort by Name",
					type = "toggle",
					order = 6,
					get = function(info) return ns.db.sortName end,
					set = function(info,val) ns.db.sortName = val 
						if val == true then
							ns.db.multi = false
						end
					end,
				},
				sortClass = {
					name = "Sort by Class",
					type = "toggle",
					order = 7,
					get = function(info) return ns.db.sortClass end,
					set = function(info,val) ns.db.sortClass = val
						if val == true then
							ns.db.multi = false
						end
					end,
				},
				classOrder = {
					name = "Class Order",
					type = "input",
					desc = "Uppercase English class names separated by a comma. \n { CLASS[,CLASS]... }",
					order = 8,
					disabled = function() if not ns.db.sortClass then return true end end,
					get = function(info) return ns.db.classOrder end,
					set = function(info,val) ns.db.classOrder = tostring(val) end,
				},
				resetClassOrder = {
					name = "Reset Class Order",
					type = "execute",
					order = 9,
					disabled = function() if not ns.db.sortClass then return true end end,
					func = function() ns.db.classOrder = ns.defaults.classOrder end,
				},
			},
		},
		pets = {
			name = "Pets",
			type = "group",
			order = 11,
			inline = true,
			args = {
				pethorizontal = {
					name = "Horizontal groups",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.pethorizontal end,
					set = function(info,val)
						if(val == true and (ns.db.petgrowth ~= "UP" or ns.db.petgrowth ~= "DOWN")) then
							ns.db.petgrowth = "UP"
						elseif(val == false and (ns.db.petgrowth ~= "RIGHT" or ns.db.petgrowth ~= "LEFT")) then
							ns.db.petgrowth = "RIGHT"
						end
						ns.db.pethorizontal = val; 
					end,
				},
				petgrowth = {
					name = "Growth Direction",
					type = "select",
					order = 2,
					values = function(info,val) 
						info = ns.db.petgrowth
						if not ns.db.pethorizontal then
							return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
						else
							return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
						end
					end,
					get = function(info) return ns.db.petgrowth end,
					set = function(info,val) ns.db.petgrowth = val; end,
				},
				petunits = {
					name = "Units per group",
					type = "range",
					order = 3,
					min = 1,
					max = 40,
					step = 1,
					get = function(info) return ns.db.petUnits end,
					set = function(info,val) ns.db.petUnits = val; end,
				},
			},
		},
		MT = {
			name = "MainTanks",
			type = "group",
			inline = true,
			order = 16,
			args= {
				MThorizontal = {
					name = "Horizontal groups",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.MThorizontal end,
					set = function(info,val)
						if(val == true and (ns.db.MTgrowth ~= "UP" or ns.db.MTgrowth ~= "DOWN")) then
							ns.db.MTgrowth = "UP"
						elseif(val == false and (ns.db.MTgrowth ~= "RIGHT" or ns.db.MTgrowth ~= "LEFT")) then
							ns.db.MTgrowth = "RIGHT"
						end
						ns.db.MThorizontal = val; 
					end,
				},
				MTgrowth = {
					name = "Growth Direction",
					type = "select",
					order = 2,
					values = function(info,val) 
						info = ns.db.MTgrowth
						if not ns.db.MThorizontal then
							return { ["LEFT"] = "LEFT", ["RIGHT"] = "RIGHT" }
						else
							return { ["UP"] = "UP", ["DOWN"] = "DOWN" }
						end
					end,
					get = function(info) return ns.db.MTgrowth end,
					set = function(info,val) ns.db.MTgrowth = val; end,
				},
				MTunits = {
					name = "Units per group",
					type = "range",
					order = 3,
					min = 1,
					max = 40,
					step = 1,
					get = function(info) return ns.db.MTUnits end,
					set = function(info,val) ns.db.MTUnits = val; end,
				},
			},
		},
	},
}

local statusbaropts = {
	type = "group", name = "StatusBars", order = 2,
	args = {
		statusbargroup = { 
			type = "group", name = "Statusbar Texture", inline = true, order = 1,
			args = {
				statusbar = {
					name = "Statusbar",
					type = "select",
					order = 1,
					itemControl = "DDI-Statusbar",
					values = statusbars,
					get = function(info) 
						for i, v in next, statusbars do
							if v == ns.db.texture then return i end
						end
					end,
					set = function(info, val) ns.db.texture = statusbars[val]; 
						ns.db.texturePath = SM:Fetch("statusbar",statusbars[val]); 
						updateObjects() 
					end,
				},
				orientation = {
					name = "Health Orientation",
					type = "select",
					order = 2,
					values = ns.orientation,
					get = function(info) return ns.db.orientation end,
					set = function(info,val) ns.db.orientation = val; updateObjects() end,
				},
				hpreversed = {
					name = "Reverse fill direction",
					type = "toggle",
					order = 3,
					get = function(info) return ns.db.hpreversed end,
					set = function(info,val) ns.db.hpreversed = val;
						updateObjects(); 
					end,
				},
			},
		},
		powerbar = {
			name = "Power Bar",
			type = "group",
			order = 2,
			inline = true,
			args = {
				power = {
					name = "Enable PowerBars",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.powerbar end,
					set = function(info,val) ns.db.powerbar = val; updateObjects() end,
				},
				porientation = {
					name = "PowerBar Orientation",
					type = "select",
					order = 2,
					values = ns.orientation,
					get = function(info) return ns.db.porientation end,
					set = function(info,val) ns.db.porientation = val; updateObjects() end,
				},
				ppreversed = {
					name = "Reverse fill direction",
					type = "toggle",
					order = 3,
					get = function(info) return ns.db.ppreversed end,
					set = function(info,val) ns.db.ppreversed = val;
						updateObjects(); 
					end,
				},

				psize = {
					name = "PowerBar size",
					type = "range",
					order = 4,
					min = .02,
					max = .30,
					step = .02,
					get = function(info) return ns.db.powerbarsize end,
					set = function(info,val) ns.db.powerbarsize = val; updateObjects() end,
				},
			},
		},
		altpower = {
			name = "Alt Power",
			type = "group",
			order = 3,
			inline = true,
			args = {
				text = {
					name = "Alt Power text",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.altpower end,
					set = function(info,val) ns.db.altpower = val end,
				},
			},
		},
	},
}

local fontopts = {
	type = "group", name = "Font", order = 3,
	args = {
		font = {
			name = "Font",
			type = "select",
			order = 1,
			itemControl = "DDI-Font",
			values = fonts,
			get = function(info)
				for i, v in next, fonts do
					if v == ns.db.font then return i end
				end
			end,
			set = function(info, val) ns.db.font = fonts[val];
				ns.db.fontPath = SM:Fetch("font",fonts[val]);
				wipe(ns.nameCache); updateObjects() 
			end,
		},
		outline = {
			name = "Font Flag",
			type = "select",
			order = 2,
			values = ns.outline,
			get = function(info) 
				if not ns.db.outline then
					return "None"
				else
					return ns.db.outline
				end
			end,
			set = function(info,val) 
				if val == "None" then
					ns.db.outline = nil
				else
					ns.db.outline = val
				end
				updateObjects()
			end,
		},
		fontsize = {
			name = "Font Size",
			type = "range",
			order = 3,
			min = 8,
			max = 32,
			step = 1,
			get = function(info) return ns.db.fontsize end,
			set = function(info,val) ns.db.fontsize = val; wipe(ns.nameCache); updateObjects() end,
		},
		fontsizeEdge = {
			name = "Edge Font Size",
			type = "range",
			order = 4,
			desc = "Size of the Top and Bottom font strings",
			min = 8,
			max = 32,
			step = 1,
			get = function(info) return ns.db.fontsizeEdge  end,
			set = function(info,val) ns.db.fontsizeEdge = val; wipe(ns.nameCache); updateObjects() end,
		},
	},
}

local rangeopts = {
	type = "group", name = "Range", order = 4, width = "half",
	args = {
		oor = {
			name = "Out of range alpha",
			type = "range",
			order = 4,
			min = 0,
			max = 1,
			step = .1,
			get = function(info) return ns.db.outsideRange end,
			set = function(info,val) ns.db.outsideRange = val end,
		},

		rangegroup = { 
			type = "group", name = "Range", inline = true, order = 1,
			args = {
				arrow = {
					name = "Enable range arrow",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.arrow end,
					set = function(info,val) ns.db.arrow = val end,
				},
				arrowscale = {
					name = "Arrow Scale",
					type = "range",
					order = 2,
					min = 0.5,
					max = 3,
					step = .1,
					get = function(info) return ns.db.arrowscale end,
					set = function(info,val) ns.db.arrowscale = val; updateObjects() end,
				},
				mouseover = {
					name = "Only show on mouseover",
					type = "toggle",
					order = 3,
					disabled = function(info) if not ns.db.arrow then return true end end,
					get = function(info) return ns.db.arrowmouseover end,
					set = function(info,val) ns.db.arrowmouseover = val end,
				},
				mouseoveralways = {
					name = "Always show on mouseover",
					type = "toggle",
					order = 4,
					desc = "Show arrow regardless of range on mouseover.",
					disabled = function(info) if not ns.db.arrow then return true end end,
					get = function(info) return ns.db.arrowmouseoveralways end,
					set = function(info,val) ns.db.arrowmouseoveralways = val end,
				},
			},
		},
	},
}

local healopts = {
	type = "group", name = "HealPrediction", order = 5,
	args = {
		healtext = {
			type = "group",
			name = "Heal Text",
			order = 1,
			inline = true,
			args = {
				text = {
					name = "Incoming heal text",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.healtext end,
					set = function(info,val) ns.db.healtext= val end,
				},
			},
		},
		healbar = {
			type = "group",
			name = "Heal Bar",
			order = 2,
			inline = true,
			args = {
				bar = {
					name = "Incoming heal bar",
					type = "toggle",
					order = 2,
					get = function(info) return ns.db.healbar end,
					set = function(info,val) ns.db.healbar = val end,
				},
				myheal = {
					name = "My Heal Color",
					type = "color",
					order = 3,
					hasAlpha = true,
					get = function(info) return ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a  end,
					set = function(info,r,g,b,a) ns.db.myhealcolor.r, ns.db.myhealcolor.g, ns.db.myhealcolor.b, ns.db.myhealcolor.a = r,g,b,a;
						updateObjects(); 
					end,
				},
				otherheal = {
					name = "Other Heal Color",
					type = "color",
					order = 4,
					hasAlpha = true,
					get = function(info) return ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a  end,
					set = function(info,r,g,b,a) ns.db.otherhealcolor.r, ns.db.otherhealcolor.g, ns.db.otherhealcolor.b, ns.db.otherhealcolor.a = r,g,b,a;
						updateObjects(); 
					end,
				},
				overflow = {
					name = "Heal overflow",
					type = "toggle",
					order = 6,
					get = function(info) return ns.db.healoverflow end,
					set = function(info,val) ns.db.healoverflow = val end,
				},
				others = {
					name = "Others' heals only",
					type = "toggle",
					order = 7,
					get = function(info) return ns.db.healothersonly end,
					set = function(info,val) ns.db.healothersonly = val end,
				}, 
			},
		},
		hptext = {
			type = "group",
			name = "Health Text",
			order = 8,
			inline = true,
			args = {
				deficit = {
					name = "Show missing health",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.deficit end,
					set = function(info,val) ns.db.deficit = val 
						if val == true then
							ns.db.perc = false
							ns.db.actual = false
						end
					end,
				},
				perc = {
					name = "Show health percentage",
					type = "toggle",
					order = 2,
					get = function(info) return ns.db.perc end,
					set = function(info,val) ns.db.perc = val 
						if val == true then
							ns.db.deficit = false
							ns.db.actual = false
						end
					end,
				},
				actual = {
					name = "Show actual health",
					type = "toggle",
					order = 3,
					get = function(info) return ns.db.actual end,
					set = function(info,val) ns.db.actual = val 
						if val == true then
							ns.db.deficit = false
							ns.db.perc = false
						end
					end,
				},
			},
		},
	},
}

local miscopts = {
	type = "group", name = "Miscellaneous", order = 6,
	args = {
		checkgroup = { 
			type = "group", name = "Checks", inline = true, order = 1,
			args = {
				party = {
					name = "Show when in a party",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.party end,
					set = function(info,val) ns.db.party = val; end,
				},
				solo = {
					name = "Show player when solo",
					type = "toggle",
					order = 2,
					get = function(info) return ns.db.solo end,
					set = function(info,val) ns.db.solo = val; end,
				},
				player = {
					name = "Show self in group",
					type = "toggle",
					order = 3,
					get = function(info) return ns.db.player end,
					set = function(info,val) ns.db.player = val; end,
				},
				pets = {
					name = "Show party/raid pets",
					type = "toggle",
					order = 4,
					get = function(info) return ns.db.pets end,
					set = function(info,val) ns.db.pets = val end,
				},
				MT = {
					name = "MainTanks",
					type = "toggle",
					order = 5,
					get = function(info) return ns.db.MT end,
					set = function(info,val) ns.db.MT = val end,
				},
				omfChar = {
					name = "Save position per character",
					type = "toggle",
					order = 6,
					get = function(info) return ns.db.omfChar end,
					set = function(info,val) ns.db.omfChar = val end,
				},
				role = {
					name = "Role icon",
					type = "toggle",
					order = 7,
					get = function(info) return ns.db.roleicon end,
					set = function(info,val) ns.db.roleicon = val end,
				},
				tborder = {
					name = "Show target border",
					type = "toggle",
					order = 8,
					get = function(info) return ns.db.tborder end,
					set = function(info,val) ns.db.tborder = val end,
				},
				fborder = {
					name = "Show focus border",
					type = "toggle",
					order = 9,
					get = function(info) return ns.db.fborder end,
					set = function(info,val) ns.db.fborder = val end,
				},
				afk = {
					name = "AFK flag/timer",
					type = "toggle",
					order = 10,
					get = function(info) return ns.db.afk end,
					set = function(info,val) ns.db.afk = val end,
				},
				highlight = {
					name = "Mouseover highlight",
					type = "toggle",
					order = 11,
					get = function(info) return ns.db.highlight end,
					set = function(info,val) ns.db.highlight = val end,
				},
				dispel = {
					name = "Dispel icons",
					type = "toggle",
					desc = "Show auras as icons that can be dispelled by you",
					order = 12,
					get = function(info) return ns.db.dispel end,
					set = function(info,val) ns.db.dispel = val end,
				},
				tooltip = {
					name = "Show unit tooltip",
					type = "toggle",
					order = 13,
					get = function(info) return ns.db.tooltip end,
					set = function(info,val) ns.db.tooltip = val end,
				},
				smooth = {
					name = "Smooth Update",
					type = "toggle",
					order = 14,
					get = function(info) return ns.db.smooth end,
					set = function(info,val) ns.db.smooth = val; updateObjects() end,
				},
				hidemenu = {
					name = "Hide Unit menu",
					type = "toggle",
					order = 15,
					desc = "Prevent toggling the unit menu in combat.",
					get = function(info) return ns.db.hidemenu end,
					set = function(info,val) ns.db.hidemenu = val; end,
				},
				autorez = {
					name = "Auto Resurrection",
					type = "toggle",
					order = 16,
					desc = "Auto cast resurrection or battle rez on middle click when the unit is dead. |cffFF0000Does not work with Clique enabled.|r",
					get = function(info) return ns.db.autorez end,
					set = function(info,val) ns.db.autorez = val; updateObjects() end,
				},
			},
		},
		slidersgroup = {
			type = "group", name = "Sliders", inline = true, order = 2,
			args = {
				indicator = {
					name = "Indicator size",
					type = "range",
					order = 16,
					min = 4,
					max = 20,
					step = 1,
					get = function(info) return ns.db.indicatorsize end,
					set = function(info,val) ns.db.indicatorsize = val; updateObjects() end,
				},
				symbol = {
					name = "Bottom right indicator size",
					type = "range",
					order = 17,
					min = 8,
					max = 20,
					step = 1,
					get = function(info) return ns.db.symbolsize end,
					set = function(info,val) ns.db.symbolsize = val; updateObjects() end,
				},
				icon = {
					name = "Leader, raid, role icon size",
					type = "range",
					order = 18,
					min = 8,
					max = 20,
					step = 1,
					get = function(info) return ns.db.leadersize end,
					set = function(info,val) ns.db.leadersize = val; updateObjects() end,
				},
				aura = {
					name = "Aura size",
					type = "range",
					order = 19,
					min = 8,
					max = 30,
					step = 1,
					get = function(info) return ns.db.aurasize end,
					set = function(info,val) ns.db.aurasize = val; updateObjects() end,
				},
			},
		},
	},
}

local coloropts = {
	type = "group", name = "Colors", order = 7,
	args = {
		HP = {
			name = "Health Bar",
			type = "group",
			order = 1,
			inline = true,
			args = {
				reverse = {
					name = "Reverse health colors",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.reversecolors end,
					set = function(info,val) ns.db.reversecolors = val;
						if ns.db.definecolors and val == true then
							ns.db.definecolors = false
						end
						ns:Colors(); updateObjects(); 
					end,
				},
				hpinverted = {
					name = "Invert health and bg",
					type = "toggle",
					order = 2,
					desc = "Does not play nice with the Heal Bar",
					get = function(info) return ns.db.hpinverted end,
					set = function(info,val) ns.db.hpinverted = val;
						updateObjects(); 
					end,
				},
				hpdefine = {
					type = "group",
					name = "Define HP color",
					order = 3,
					inline = true,
					args = {
						definecolors = {
							name = "Health define colors",
							type = "toggle",
							order = 2,
							get = function(info) return ns.db.definecolors end,
							set = function(info,val) ns.db.definecolors = val;
								if ns.db.reversecolors and val == true then
									ns.db.reversecolors = false
								end
								ns:Colors(); updateObjects(); 
							end,
						},
						hpcolor = {
							name = "Health color",
							type = "color",
							order = 3,
							hasAlpha = false,
							get = function(info) return ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b, ns.db.hpcolor.a end,
							set = function(info,r,g,b,a) ns.db.hpcolor.r, ns.db.hpcolor.g, ns.db.hpcolor.b, ns.db.hpcolor.a = r,g,b,a;
								ns:Colors(); updateObjects(); 
							end,
						},
						hpbgcolor = {
							name = "Health background color",
							type = "color",
							order = 4,
							hasAlpha = true,
							get = function(info) return ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b, ns.db.hpbgcolor.a end,
							set = function(info,r,g,b,a) ns.db.hpbgcolor.r, ns.db.hpbgcolor.g, ns.db.hpbgcolor.b, ns.db.hpbgcolor.a = r,g,b,a;
								ns:Colors(); updateObjects(); 
							end,
						},
						colorSmooth = {
							name = "Smooth Gradient",
							type = "toggle",
							order = 5,
							disabled = function(info) return not ns.db.definecolors end,
							get = function(info) return ns.db.colorSmooth end,
							set = function(info,val) ns.db.colorSmooth = val;
								if ns.db.hpinverted and val == true then
									ns.db.hpinverted = false
								end
								updateObjects(); 
							end,
						},
						gradient = {
							name = "Low health color",
							type = "color",
							order = 6,
							hasAlpha = false,
							get = function(info) return ns.db.gradient.r, ns.db.gradient.g, ns.db.gradient.b, ns.db.gradient.a end,
							set = function(info,r,g,b,a) ns.db.gradient.r, ns.db.gradient.g, ns.db.gradient.b, ns.db.gradient.a = r,g,b,a;
								updateObjects(); 
							end,
						},
					},
				},
			},
		},
		PP = {
			name = "Power Bar",
			type = "group",
			order = 2,
			inline = true,
			args = {
				powerclass = {
					name = "Color power by class",
					type = "toggle",
					order = 1,
					get = function(info) return ns.db.powerclass end,
					set = function(info,val) ns.db.powerclass = val; updateObjects(); 
						if ns.db.powerdefinecolors and val == true then
							ns.db.powerdefinecolors = false
						end
						ns:Colors(); updateObjects();
					end,
				},
				ppinverted = {
					name = "Invert power and bg",
					type = "toggle",
					order = 2,
					get = function(info) return ns.db.ppinverted end,
					set = function(info,val) ns.db.ppinverted = val;
						updateObjects(); 
					end,
				},
				ppdefine = {
					type = "group",
					name = "Define Power color",
					order = 3,
					inline = true,
					args = {
						powerdefinecolors = {
							name = "Power define colors",
							type = "toggle",
							order = 2,
							get = function(info) return ns.db.powerdefinecolors end,
							set = function(info,val) ns.db.powerdefinecolors = val;
								if ns.db.powerclass and val == true then
									ns.db.powerclass = false
								end
								ns:Colors(); updateObjects(); 
							end,
						},
						powercolor = {
							name = "Power color",
							type = "color",
							order = 3,
							hasAlpha = false,
							get = function(info) return ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b, ns.db.powercolor.a end,
							set = function(info,r,g,b,a) ns.db.powercolor.r, ns.db.powercolor.g, ns.db.powercolor.b, ns.db.powercolor.a = r,g,b,a; 
								ns:Colors(); updateObjects(); 
							end,
						},
						powerbgcolor = {
							name = "Power background color",
							type = "color",
							order = 4,
							hasAlpha = true,
							get = function(info) return ns.db.powerbgcolor.r, ns.db.powerbgcolor.g, ns.db.powerbgcolor.b, ns.db.powerbgcolor.a end,
							set = function(info,r,g,b,a) ns.db.powerbgcolor.r, ns.db.powerbgcolor.g, ns.db.powerbgcolor.b, ns.db.powerbgcolor.a = r,g,b,a;
								ns:Colors(); updateObjects(); 
							end,
						},
					},
				},
			},
		},
	},
}

local clusteropts = {
	type = "group", name = "Cluster", order = 8, width = "half",
	--clustergroup = { 
	--type = "group", name = "Cluster", inline = true, order = 1,
	args = {
		enabled = {
			name = "Enable Cluster Heal",
			type = "toggle",
			order = 1,
			desc = "This will put a number in the right corner of the unit indicating how many units are in range and below a certain health.",
			get = function(info) return ns.db.cluster.enabled end,
			set = function(info,val) ns.db.cluster.enabled = val; 
				updateObjects(); 
			end,
		},
		range = {
			name = "Range",
			type = "range",
			order = 2,
			min = 5,
			max = 40,
			step = 1,
			get = function(info) return ns.db.cluster.range end,
			set = function(info,val) ns.db.cluster.range = val; updateObjects(); end,
		},
		perc = {
			name = "Percent HP",
			type = "range",
			order = 3,
			min = 10,
			max = 100,
			step = 5,
			get = function(info) return ns.db.cluster.perc end,
			set = function(info,val) ns.db.cluster.perc = val; updateObjects(); end,
		},
		freq = {
			name = "Scan Timer",
			type = "range",
			order = 4,
			desc = "Set how often to scan in milliseconds.",
			min = 100,
			max = 1000,
			step = 50,
			get = function(info) return ns.db.cluster.freq end,
			set = function(info,val) ns.db.cluster.freq = val; updateObjects(); end,
		},
		textcolor = {
			name = "Text color",
			type = "color",
			order = 5,
			hasAlpha = false,
			get = function(info) return ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b, ns.db.cluster.textcolor.a end,
			set = function(info,r,g,b,a) ns.db.cluster.textcolor.r, ns.db.cluster.textcolor.g, ns.db.cluster.textcolor.b, ns.db.cluster.textcolor.a = r,g,b,a; 
				updateObjects(); 
			end,
		},
	},
	--},
}

local options = {
	type = "group", name = ADDON_NAME,
	args = {
		unlock = {
			name = "Toggle anchors",
			type = "execute",
			func = function() ns:Movable(); end,
			order = 1,
		},
		reload = {
			name = "Reload UI",
			type = "execute",
			desc = "Most options require a ReloadUI() to take effect.",
			func = function() ReloadUI(); end,
			order = 2,
		},
		general = generalopts,
		statusbar = statusbaropts,
		font = fontopts,
		range = rangeopts,
		heal = healopts,
		misc = miscopts,
		color = coloropts,
		cluster = clusteropts,
	},
}

local AceConfig = LibStub("AceConfig-3.0")
AceConfig:RegisterOptionsTable(ADDON_NAME, options)

local ACD = LibStub('AceConfigDialog-3.0')
ACD:AddToBlizOptions(ADDON_NAME, ADDON_NAME)

InterfaceOptions_AddCategory(ns.movableopt)
LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)
