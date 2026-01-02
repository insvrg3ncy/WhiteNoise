-- White Noise - Admin Tools (Server)

if SERVER then
	wn = wn or {}
	wn.AdminTools = wn.AdminTools or {}
	
	-- Admin commands
	concommand.Add("wn_giveweapon", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsAdmin() then return end
		
		if #args < 1 then
			ply:ChatPrint("Usage: wn_giveweapon <weapon_class> [target]")
			return
		end
		
		local wepClass = args[1]
		local target = ply
		
		if args[2] then
			target = player.GetBySteamID(args[2]) or player.GetBySteamID64(args[2])
			if not target then
				target = player.GetByName(args[2])
			end
		end
		
		if not IsValid(target) then
			ply:ChatPrint("Target not found!")
			return
		end
		
		if not target:Alive() then
			ply:ChatPrint("Target is not alive!")
			return
		end
		
		target:Give(wepClass)
		ply:ChatPrint("Gave " .. wepClass .. " to " .. target:Nick())
	end)
	
	concommand.Add("wn_sethealth", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsAdmin() then return end
		
		if #args < 2 then
			ply:ChatPrint("Usage: wn_sethealth <target> <health>")
			return
		end
		
		local target = player.GetBySteamID(args[1]) or player.GetBySteamID64(args[1])
		if not target then
			target = player.GetByName(args[1])
		end
		
		if not IsValid(target) then
			ply:ChatPrint("Target not found!")
			return
		end
		
		local health = tonumber(args[2])
		if not health then
			ply:ChatPrint("Invalid health value!")
			return
		end
		
		target:SetHealth(health)
		ply:ChatPrint("Set " .. target:Nick() .. "'s health to " .. health)
	end)
	
	concommand.Add("wn_setarmor", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsAdmin() then return end
		
		if #args < 2 then
			ply:ChatPrint("Usage: wn_setarmor <target> <armor>")
			return
		end
		
		local target = player.GetBySteamID(args[1]) or player.GetBySteamID64(args[1])
		if not target then
			target = player.GetByName(args[1])
		end
		
		if not IsValid(target) then
			ply:ChatPrint("Target not found!")
			return
		end
		
		local armor = tonumber(args[2])
		if not armor then
			ply:ChatPrint("Invalid armor value!")
			return
		end
		
		target:SetArmor(armor)
		ply:ChatPrint("Set " .. target:Nick() .. "'s armor to " .. armor)
	end)
	
	concommand.Add("wn_giverole", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsAdmin() then return end
		
		if #args < 2 then
			ply:ChatPrint("Usage: wn_giverole <target> <role>")
			return
		end
		
		local target = player.GetBySteamID(args[1]) or player.GetBySteamID64(args[1])
		if not target then
			target = player.GetByName(args[1])
		end
		
		if not IsValid(target) then
			ply:ChatPrint("Target not found!")
			return
		end
		
		local role = args[2]
		if wn.GiveRole(target, role) then
			ply:ChatPrint("Gave role " .. role .. " to " .. target:Nick())
		else
			ply:ChatPrint("Failed to give role!")
		end
	end)
end
