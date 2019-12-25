if SERVER then
	util.AddNetworkString("loadout_update");
	util.AddNetworkString("loadouts_getinfo");
	util.AddNetworkString("loadout_cleared");
	util.AddNetworkString("loadout_open");
	util.AddNetworkString("loadout_select_all");
	util.AddNetworkString("loadout_set");
	util.AddNetworkString("loadout_given");
	include("loadouts_config.lua")
	//if !sql.TableExists("loadouts") then
	//	sql.Query("CREATE TABLE loadouts(sid TEXT, primary TEXT, secondary TEXT, grenade TEXT)")
	//end
	local succ = sql.Query("CREATE TABLE loadouts(sid TEXT, primary TEXT, secondary TEXT, grenade TEXT)")
	if not succ then
	  print(sql.LastError())
	else
		print("TABLE CREATED SUCCESSFULLY")
	end

	hook.Add("TTTBeginRound", "QueryWeapons", function ()
		for k, v in ipairs(player.GetHumans()) do
			//local tbl = sql.Query("SELECT primary, secondary, grenade FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			//print(tostring(tbl[1]))
			//print(tostring(tbl[2]))
			//print(tostring(tbl[3]))
			local p = sql.Query("SELECT primary FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			local s = sql.Query("SELECT secondary FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			local g = sql.Query("SELECT grenade FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			////print(sql.LastError())
			////print(tostring(p))
			////print(tostring(s))
			////print(tostring(g))
			//local p = tbl[1]
			//local s = tbl[2]
			//local g = tbl[3]
			-- The 3 commandments of loadouts
			if v:CanUseLoadouts() && !v:IsSpec() && (p != "none" && s != "none" && g != "none") then
				v:StripWeapons()
				v:Give(p)
				v:Give(s)
				v:Give(g)
				net.Start("loadout_given")
					net.WriteString(loadouts.loadoutreceived)
				net.Send(v)
			end
		end
	end);

	net.Receive("loadout_update", function (_, ply)
		if !table.HasValue(loadouts.whitelist, string.lower(ply:GetUserGroup())) then return; end
		local weaps = net.ReadTable()
		local primary = sql.SQLStr(weaps[1])
		local secondary = sql.SQLStr(weaps[2])
		local grenade = sql.SQLStr(weaps[3])
		if !primary && !secondary && !grenade then
			sql.Query("UPDATE loadouts SET primary = 'none', secondary = 'none', grenade = 'none' WHERE sid = '" .. ply:SteamID() .. "'")
			net.Start("loadout_cleared")
			net.Send(ply)
			return;
		end
		if primary == nil then
			net.Start("loadout_select_all")
				net.WriteString("1")
			net.Send(ply)
			return;
		elseif secondary == nil then
			net.Start("loadout_select_all")
				net.WriteString("2")
			net.Send(ply)
			return;
		elseif grenade == nil then
			net.Start("loadout_select_all")
				net.WriteString("3")
			net.Send(ply)
			return;
		end
		sql.Query("UPDATE loadouts SET primary = '" .. primary .. "', SET secondary = '" .. secondary .. "', SET grenade = '" .. grenade .. "'' WHERE sid = '" .. ply:SteamID() .. "'")
		if !loadouts.debug then
			net.Start("loadout_set")
				net.WriteString("New Loadout Set!")
				net.WriteString("Received loadout weapons! Type " .. tostring(loadouts.txtcmd) .. " to change your loadout or disable them.")
			net.Send(ply)
		else
			net.Start("loadout_set")
				net.WriteString("Debug information:")
				net.WriteTable(weaps)
			net.Send(ply)
		end
	end);
	hook.Add("PlayerSay", "loadout_chatcmd", function (ply, txt, bTeam)
		local txt = string.lower(txt)
		if txt:lower() == loadouts.txtcmd:lower() then
			net.Start("loadout_open")
			net.Send(ply)
		end
	end);
	hook.Add("PlayerSay", "loadout_print", function (ply, txt, bTeam)
		local txt = string.lower(txt)
		if table.HasValue(loadouts.txtprintcmds, txt:lower()) then
			local p = sql.Query("SELECT primary FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			local s = sql.Query("SELECT secondary FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			local g = sql.Query("SELECT grenade FROM loadouts WHERE sid = '" .. v:SteamID() .. "'")
			local tbl = {p, s, g}
			net.Start("loadouts_getinfo")
				net.WriteTable(tbl)
			net.Send(ply)
		end
	end);
end
