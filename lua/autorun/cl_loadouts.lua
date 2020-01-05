if CLIENT then
	local p = CreateConVar("loadouts_primary", "none", FCVAR_USERINFO);
	local s = CreateConVar("loadouts_secondary", "none", FCVAR_USERINFO);
	local g = CreateConVar("loadouts_grenade", "none", FCVAR_USERINFO);
	local p = CreateClientConVar("loadouts_primary", "none", true, true);
	local s = CreateClientConVar("loadouts_secondary", "none", true, true);
	local g = CreateClientConVar("loadouts_grenade", "none", true, true);
	include("sh_loadouts_config.lua");
	surface.CreateFont("WeaponCategory", {
		font = "Arial",
		size = 20,
		weight = 1000,
		antialias = true,
	})
	function openLoadoutMenu()
		local lp = LocalPlayer()
		if !lp:CanUseLoadouts() then
			chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.NoAccess)
			return;
		end
		lp:ConCommand("loadouts_primary none")
		lp:ConCommand("loadouts_secondary none")
		lp:ConCommand("loadouts_grenade none")
		if IsValid(loadouts.window) then return; end
		loadouts.window = vgui.Create("DFrame")
		loadouts.window:SetSize(500, 300)
		loadouts.window:Center()
		loadouts.window:SetTitle(loadouts.windowtitle)
		loadouts.window:MakePopup()
		loadouts.window.Paint = function (self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(20, 20, 20, 250))
			-- Primary Area
			draw.RoundedBox(0, 10, 30, w - 30, 30, loadouts.color.primarybox)
			draw.RoundedBox(0, 10, 65, w - 30, 75, loadouts.color.primarybox)
			-- Secondary Area
			draw.RoundedBox(0, 10, 150, w / 2.3, 30, loadouts.color.secondarybox)
			draw.RoundedBox(0, 10, 185, w / 2.3, 75, loadouts.color.secondarybox)
			-- Grenade Area
			draw.RoundedBox(0, 263, 150, w / 2.3, 30, loadouts.color.grenadebox)
			draw.RoundedBox(0, 263, 185, w / 2.3, 75, loadouts.color.grenadebox)
		end
		local window = loadouts.window
		local bSubmit = vgui.Create("DButton", window)
		bSubmit:SetText("Submit")
		bSubmit:SetPos(400, 265)
		bSubmit:SetSize(80, 30)
		bSubmit:SetToolTip("Confirm your loadout weapons.")
		bSubmit.DoClick = function ()
			chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.loadoutupdated)
			window:Close()
		end
		local bDisable = vgui.Create("DButton", window)
		bDisable:SetText("Disable")
		bDisable:SetPos(10, 265)
		bDisable:SetSize(80, 30)
		bDisable:SetTooltip("Disables your loadout.")
		bDisable.DoClick = function ()
			lp:ConCommand("loadouts_primary none")
			lp:ConCommand("loadouts_secondary none")
			lp:ConCommand("loadouts_grenade none")
			chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.disabled)
			window:Close()
		end
		local bPrimary = vgui.Create("DLabel", window)
		bPrimary:SetPos(20, 37) 
		bPrimary:SetColor(loadouts.color.white) 
		bPrimary:SetFont("WeaponCategory")
		bPrimary:SetText("Primary") 
		bPrimary:SizeToContents()
		local scrollPrimary = vgui.Create("DHorizontalScroller", window)
		scrollPrimary:SetSize(window:GetWide() - 30, 65)
		scrollPrimary:SetPos(15, 70)
		for name, class in pairs(loadouts.primary) do
			local bWeapon = vgui.Create("DImageButton", window)
			bWeapon:SetSize(64, 64)
			bWeapon:SetImage(loadouts.icons[class] || "vgui/ttt/icon_nades.vtf") 
			bWeapon:SetTooltip(name)
			bWeapon.DoClick = function ()
				surface.PlaySound("buttons/button14.wav")
				lp:ConCommand("loadouts_primary " .. class)
				chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, "Selected " .. name .. "!")
			end
			scrollPrimary:AddPanel(bWeapon)
		end
		local bSecondary = vgui.Create("DLabel", window)
		bSecondary:SetPos(20, 157) 
		bSecondary:SetColor(loadouts.color.white) 
		bSecondary:SetFont("WeaponCategory")
		bSecondary:SetText("Secondary") 
		bSecondary:SizeToContents() 
		local scrollSecondary = vgui.Create("DHorizontalScroller", window)
		scrollSecondary:SetSize(window:GetWide() / 2 - 45, 65)
		scrollSecondary:SetPos(15, 190)
		for name, class in pairs(loadouts.secondary) do
			local bWeapon = vgui.Create("DImageButton", window)
			bWeapon:SetSize(64, 64)
			bWeapon:SetImage(loadouts.icons[class] || "vgui/ttt/icon_nades.vtf") 
			bWeapon:SetTooltip(name)
			bWeapon.DoClick = function()
				surface.PlaySound("buttons/button14.wav")
				lp:ConCommand("loadouts_secondary " .. class)
				chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, "Selected " .. name .. "!")
			end
			scrollSecondary:AddPanel(bWeapon)
		end
		local bGrenade = vgui.Create("DLabel", window)
		bGrenade:SetPos(275, 157) 
		bGrenade:SetColor(loadouts.color.white)
		bGrenade:SetFont("WeaponCategory")
		bGrenade:SetText("Grenade") 
		bGrenade:SizeToContents()
		
		local scrollGrenades = vgui.Create("DHorizontalScroller", window)
		scrollGrenades:SetSize(window:GetWide() / 2 - 45, 65)
		scrollGrenades:SetPos(270, 190)
		
		for name, class in pairs(loadouts.grenades) do
			local bWeapon = vgui.Create("DImageButton", window)
			bWeapon:SetSize(64, 64)
			bWeapon:SetImage(loadouts.icons[class] || "vgui/ttt/icon_nades.vtf") 
			bWeapon:SetTooltip(name)
			bWeapon.DoClick = function()
				surface.PlaySound("buttons/button14.wav")
				lp:ConCommand("loadouts_grenade " .. class)
				chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, "Selected " .. name .. "!")
			end
			scrollGrenades:AddPanel(bWeapon)
		end
	end
	net.Receive("loadout_open", function ()
		openLoadoutMenu()
	end);
	net.Receive("loadouts_getinfo", function ()
		local db = loadouts.printloadout
		local weps = net.ReadTable()
		local tbl = {"Primary: ", "Secondary: ", "Grenade: "}
		for i = 1, #weps do
			chat.AddText(loadouts.color.red, db, loadouts.color.white, tbl[i] .. weps[i])
		end
	end);
	concommand.Add("loadouts_info", function ()
		print("Version: " .. loadouts.version)
		print("Created By: " .. loadouts.creator .. " (" .. loadouts.creatorid .. ")")
		print("Last Updated: " .. loadouts.lastupdated)
		chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.checkinformation)
	end);
	concommand.Add("loadout_open", function ()
		openLoadoutMenu()
	end);
	concommand.Add("loadouts_view_loadout", function ()
		net.Start("loadouts_getinfo")
		net.SendToServer()
	end);
	hook.Add("Think", "loadout_keyBind", function ()
		if input.IsKeyDown(loadouts.keyBind) && guicanopen then
			guicanopen = false
			openLoadoutMenu()
		elseif !input.IsKeyDown(loadouts.keyBind) && !guicanopen then
			guicanopen = true
		end
	end);
end
