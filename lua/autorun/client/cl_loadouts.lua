if CLIENT then
	include("loadouts_config.lua")
	surface.CreateFont("WeaponCategory", {
		font = "Arial",
		size = 20,
		weight = 1000,
		antialias = true,
	})
	net.Receive("loadout_set", function ()
		if loadouts.debug then
			local db = loadouts.loadoutsdebug
			local fun = net.ReadString()
			local tbl = net.ReadTable()
			chat.AddText(loadouts.color.hotred, db, loadouts.color.white, fun)
			for i = 1, #tbl do
				chat.AddText(loadouts.color.red, db, loadouts.color.white, tbl[i])
			end
		else
			local str1 = loadouts.loadouts
			local str2 = net.ReadString()
			local str3 = net.ReadString()
			chat.AddText(loadouts.color.hotpink, str1, loadouts.color.white, str2)
			chat.AddText(loadouts.color.hotpink, str1, loadouts.color.white, str3)
		end
	end);
	net.Receive("loadout_cleared", function ()
		chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.disabled)
	end);
	concommand.Add("loadouts_info", function ()
		chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.checkinformation)
		print("Version: " .. loadouts.version)
		print("Created By: " .. loadouts.creator .. " (" .. loadouts.creatorid .. ")")
		print("Last Updated: " .. loadouts.lastupdated)
	end);
	local guicanopen = true
	hook.Add("Think", "loadout_keyBind", function ()
		if input.IsKeyDown(loadouts.keyBind) && guicanopen then
			guicanopen = false
			openLoadoutMenu()
		elseif !input.IsKeyDown(loadouts.keyBind) && !guicanopen then
			guicanopen = true
		end
	end);
	function openLoadoutMenu()
		local lp = LocalPlayer()
		local pC, sC, gC
		if !lp:CanUseLoadouts() then
			chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, loadouts.NoAccess)
			return;
		end
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
			local tbl = {}
			tbl[1] = pC
			tbl[2] = sC
			tbl[3] = gC
			net.Start("loadout_update")
				net.WriteTable(tbl)
			net.SendToServer()
			window:Close()
		end
		local bDisable = vgui.Create("DButton", window)
		bDisable:SetText("Disable")
		bDisable:SetPos(10, 265)
		bDisable:SetSize(80, 30)
		bDisable:SetTooltip("Disables your loadout.")
		bDisable.DoClick = function ()
			net.Start("loadout_update")
				net.WriteTable(nil)
			net.SendToServer()
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
				pC = class
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
				sC = class
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
				gC = class
				chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, "Selected " .. name .. "!")
			end
			scrollGrenades:AddPanel(bWeapon)
		end
	end
	net.Receive("loadout_open", function ()
		openLoadoutMenu()
	end);
	concommand.Add("loadout_open", function ()
		openLoadoutMenu()
	end);
	concommand.Add("loadouts_view_loadout", function ()
		net.Start("loadouts_getinfo")
		net.SendToServer()
	end);
	net.Receive("loadout_given", function ()
		str1 = net.ReadString()
		chat.AddText(loadouts.color.hotpink, loadouts.loadouts, loadouts.color.white, str1)
	end);
end