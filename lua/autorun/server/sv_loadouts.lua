if SERVER then
	resource.AddWorkshop("1953228978");
	util.AddNetworkString("loadouts_getinfo");
	util.AddNetworkString("loadout_open");
	util.AddNetworkString("loadout_given");
	include("loadouts_config.lua")
	hook.Add("TTTBeginRound", "QueryWeapons", function ()
		timer.Simple(0, function ()
			for k, v in ipairs(player.GetHumans()) do
				local p = v:GetInfo("loadouts_primary", "none")
				local s = v:GetInfo("loadouts_secondary", "none")
				local g = v:GetInfo("loadouts_grenade", "none")
				-- The commandments of loadouts
				if v:CanUseLoadouts() && !v:IsSpec() then
					v:StripWeapons()
					if p != "none" then
						v:Give(p)
					end
					if s != "none" then
						v:Give(s)
					end
					if g != "none" then
						v:Give(g)
					end
					v:Give("weapon_zm_improvised")
					v:Give("weapon_ttt_unarmed")
					v:Give("weapon_zm_carry")
					if v:IsDetective() then
						v:Give("weapon_ttt_wtester")
					end
					net.Start("loadout_given")
						net.WriteString(loadouts.loadoutreceived)
					net.Send(v)
				end
			end
		end);
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
			local p = ply:GetInfo("loadouts_primary", "none")
			local s = ply:GetInfo("loadouts_secondary", "none")
			local g = ply:GetInfo("loadouts_grenade", "none")
			local tbl = {p, s, g}
			timer.Simple(0, function ()
				net.Start("loadouts_getinfo")
					net.WriteTable(tbl)
				net.Send(ply)
			end);
		end
	end);
end
