if not oUF_Freebgrid then return end

-- These setting are only used if "Disable oMF" is checked.
oUF_Freebgrid.setpoint = {

	raid = {
		position = {"LEFT", UIParent, "LEFT", 8, 0},
	},
	
	pet = {
		position = {"TOPLEFT", "Raid_Freebgrid", "TOPRIGHT", 5, 0},
	},
	
	mt = {
		position = {"TOPLEFT", UIParent, "TOPLEFT", 8, -25},
	},
}