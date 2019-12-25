AddCSLuaFile()
loadouts = {}
loadouts.color = {}
loadouts.color.red = Color(255, 0, 0)
loadouts.color.hotred = Color(255, 60, 60)
loadouts.color.hotpink = Color(255, 105, 180)
loadouts.color.white = Color(255, 255, 255)
loadouts.color.primarybox = Color(42, 42, 120, 95)
loadouts.color.secondarybox = Color(42, 42, 120, 95)
loadouts.color.grenadebox = Color(42, 42, 120, 95)
loadouts.missing = {}
loadouts.missing.primary = "Please select a valid primary weapon."
loadouts.missing.seconday = "Please select a valid secondary weapon."
loadouts.missing.grenade = "Please select a valid grenade."
loadouts.loadouts = "[LOADOUTS]: "
loadouts.loadoutsdebug = "[LOADOUT DEBUG]: "
loadouts.disabled = "Disabled your loadouts! Submit new ones to enable again."
loadouts.windowtitle = "Supporter+ Loadouts!"
loadouts.checkinformation = "Check your console for information!"
loadouts.loadoutreceived = "Loadout Received!"
loadouts.NoAccess = "You cant use the loadout menu!"
loadouts.creator = "Zero"
loadouts.creatorid = "STEAM_0:0:1363780"
loadouts.version = "0.01"
loadouts.lastupdated = "12/24/2019 (MM/DD/YYYY)"
loadouts.whitelist = {"supporter", "tttsupporter", "vip", "tttvip", "admin", "senioradmin", "superadmin"}
loadouts.debug = true // Are we debugging shit or is it fucking working?
loadouts.txtcmd = "!loadouts"
loadouts.txtprintcmds = {"!printloadout", "!loadoutprint"}
loadouts.keyBind = KEY_F6

-- Primary weapons. Format: Name = Class
loadouts.primary = {
	["M16"] = "weapon_ttt_m16",
	["HK-416"] = "weapon_ttt_hk416",
	["Shotgun"] = "weapon_zm_shotgun",
	["Mac10"] = "weapon_zm_mac10",
	["MP5"] = "weapon_ttt_mp5",
	["Scout"] = "weapon_zm_rifle",
}

-- Secondary weapons. Format: Name = Class
loadouts.secondary = {
	["Five Seven"] = "weapon_zm_pistol",
	["Glock"] = "weapon_ttt_glock",
	["Deagle"] = "weapon_zm_revolver",
}

-- Extra weapons. Format: Name = Class
loadouts.grenades = {
	["Incendinary"] = "weapon_zm_molotov",
	["Discombobulator"] = "weapon_ttt_confgrenade",
	["Smoke"] = "weapon_ttt_smokegrenade",
}

-- Weapon icons. Format: Class = Path to material
loadouts.icons = {
	["weapon_ttt_hk416"] = "vgui/ttt/gfl_icon_hk416",
	["weapon_ttt_mp5"] = "vgui/ttt/icon_mp5",
	["weapon_ttt_m16"] = "vgui/ttt/icon_m16",
	["weapon_zm_shotgun"] = "vgui/ttt/icon_shotgun",
	["weapon_zm_sledge"] = "vgui/ttt/icon_m249",
	["weapon_zm_mac10"] = "vgui/ttt/icon_mac",
	["weapon_zm_rifle"] = "vgui/ttt/icon_scout",
	["weapon_zm_pistol"] = "vgui/ttt/icon_pistol",
	["weapon_ttt_glock"] = "vgui/ttt/icon_glock",
	["weapon_zm_revolver"] = "vgui/ttt/icon_deagle",
	["weapon_zm_molotov"] = "vgui/ttt/gfl_icon_molotov",
	["weapon_ttt_confgrenade"] = "vgui/ttt/gfl_icon_discombob",
	["weapon_ttt_smokegrenade"] = "vgui/ttt/gfl_icon_smoke",
}

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:CanUseLoadouts()
	if #loadouts.whitelist == 0 then return true; end
	local plygroup = string.lower(self:GetUserGroup())
	for _, group in ipairs(loadouts.whitelist) do
		if plygroup == string.lower(group) then
			return true;
		end
	end
	return false;
end
