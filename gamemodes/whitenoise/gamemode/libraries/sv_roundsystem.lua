-- White Noise - Round System (Server)
-- Полная система раундов адаптированная из zcity

if SERVER then
	local player_GetAll = player.GetAll
	wn.modes = wn.modes or {}
	
	local forcemodeconvar = CreateConVar("wn_forcemode", "", FCVAR_ARCHIVE)
	
	function wn:GetMode(round)
		if wn.modes[round] then return round end
		
		for name,mode in pairs(wn.modes) do
			if mode.Types and mode.Types[round] then
				return name
			end
		end
	end
	
	function CurrentRound()
		if IsValid(ents.FindByClass( "trigger_changelevel" )[1]) then
			wn.nextround = "coop"
			wn.CROUND = wn.CROUND or "coop"
			return wn.modes["coop"]
		end
		
		wn.CROUND = wn.CROUND or "homicide"
		if not wn.CROUND_SUBTYPE or (wn.LASTCROUND != wn.CROUND) then
			wn.CROUND_SUBTYPE = wn:GetMode(wn.CROUND)
			wn.LASTCROUND = wn.CROUND
		end
		local round = wn.CROUND_SUBTYPE
		
		return wn.modes[round], wn.CROUND
	end
	
	function NextRound(round)
		if IsValid(ents.FindByClass( "trigger_changelevel" )[1]) then
			wn.nextround = "coop"
		else
			wn.nextround = round
		end
	end
	
	function wn:PreRound()
		if ((((wn.Roundscount or 0) > 15) and !GetConVar("wn_dev"):GetBool()) or ( (player.GetCount() > 1) and wn.ROUND_STATE == 0 and wn.CheckRTVVotes() )) and !(wn.RoundsLeft and wn.CROUND == "cstrike") then
			wn.StartRTV(20)
			wn.ROUND_STATE = 0
			return
		end
		
		if wn.ROUND_STATE == 0 and #player_GetAll() > 1 then
			wn.END_TIME = nil
			
			wn.START_TIME = wn.START_TIME or CurTime() + (CurrentRound().start_time or 5)
			if wn.START_TIME < CurTime() then wn:RoundStart() end
		end
	end
	
	function wn:RoundThink()
		if wn.ROUND_STATE == 1 then
			if CurrentRound().RoundThink then CurrentRound():RoundThink(CurrentRound()) end
		end
	end
	
	hook.Add("CanListenOthers","RoundStartChat",function(output,input,isChat,teamonly,text)
		if wn.ROUND_STATE == 0 or wn.ROUND_STATE == 3 then return true, false end
	end)
	
	function wn:EndRound()
		wn.ROUND_STATE = 3
		wn.Roundscount = (wn.Roundscount or 0) + 1
		
		local mode, round = CurrentRound()
		
		net.Start("RoundInfo")
			net.WriteString(mode.name or "homicide")
			net.WriteInt(wn.ROUND_STATE, 4)
		net.Broadcast()
		
		CurrentRound():EndRound()
		hook.Run("WN_EndRound")
		wn.AddFade()
	end
	
	function wn:CheckWinner(tbl)
		local playerTable = table.Copy(tbl)
		for i, players in pairs(playerTable) do
			if table.Count(players) == 0 then
				playerTable[i] = nil
				continue
			end
			
			playerTable[i] = i
		end
		
		local winner = (table.Count(playerTable) == 1 and table.Random(playerTable)) or (table.Count(playerTable) == 0 and 3) or false
		local shouldendround = winner and true or nil
		return shouldendround, winner
	end
	
	wn.ROUND_TIME = wn.ROUND_TIME or 300
	
	function wn:ShouldRoundEnd()
		local time = wn.ROUND_TIME
		local shouldroundend = CurrentRound():ShouldRoundEnd()
		if shouldroundend ~= false then
			local boringround = (wn.ROUND_START + time) < CurTime()
			
			if boringround and CurrentRound().BoringRoundFunction then
				PrintMessage(HUD_PRINTTALK, "Stopping round because it was TOO boring.")
				
				CurrentRound():BoringRoundFunction()
			end
			
			return (shouldroundend and true) or (boringround)
		else
			return false
		end
	end
	
	function wn:EndRoundThink()
		if wn.ROUND_STATE == 1 and wn:ShouldRoundEnd() then wn:EndRound() end
		if wn.ROUND_STATE == 3 then
			wn.END_TIME = wn.END_TIME or (CurTime() + (CurrentRound().end_time or 5))
			if wn.END_TIME < CurTime() then
				wn.ROUND_STATE = 0
				
				hook.Run("WN_PreRoundStart")
				
				wn.CROUND = wn.nextround or "homicide"
				if CurrentRound().shouldfreeze then wn:Freeze() end
				
				local mode, round = CurrentRound()
				net.Start("RoundInfo")
					net.WriteString(mode.name or "homicide")
					net.WriteInt(wn.ROUND_STATE, 4)
				net.Broadcast()
				
				wn.UpdateRoundTime(CurrentRound().ROUND_TIME, CurTime(), CurTime() + (CurrentRound().start_time or 5))
				
				self:KillPlayers()
				self:AutoBalance()
				
				CurrentRound():Intermission()
				CurrentRound():GiveEquipment()
			end
		end
	end
	
	hook.Add("PlayerInitialSpawn", "wn_SendRoundInfo", function(ply)
		if wn.CROUND then
			local mode,round = CurrentRound()
			net.Start("RoundInfo")
				net.WriteString(mode.name or "homicide")
				net.WriteInt(wn.ROUND_STATE, 4)
			net.Send(ply)
		end
	end)
	
	util.AddNetworkString("RoundInfo")
	
	function wn:Think(time)
		if (wn.thinkTime or CurTime()) > time then return end
		wn.thinkTime = time + 1
		wn:PreRound()
		wn:RoundThink()
		wn:EndRoundThink()
	end
	
	hook.Add("Think", "wn-think", function() wn:Think(CurTime()) end)
	
	function wn:KillPlayers()
		local mode = CurrentRound()
		for i, ply in ipairs(player_GetAll()) do
			if ply:Team() == TEAM_SPECTATOR then continue end
			
			if ply:Alive() and mode.DontKillPlayer and mode:DontKillPlayer(ply) then
				continue
			end
			
			ply:KillSilent()
			ply:Spawn()
			wn.SetPlayerClass(ply)
		end
	end
	
	function wn:RoundStart()
		if CurrentRound().shouldfreeze then wn:Unfreeze() end
		
		wn.ROUND_STATE = 1
		wn.START_TIME = nil
		
		local mode, round = CurrentRound()
		
		wn.ROUND_BEGIN = CurTime()
		wn.UpdateRoundTime()
		
		net.Start("RoundInfo")
			net.WriteString(mode.name or "homicide")
			net.WriteInt(wn.ROUND_STATE, 4)
		net.Broadcast()
		
		if forcemodeconvar:GetString() != "" then
			forcemode = forcemodeconvar:GetString()
		end
		
		NextRound(forcemode ~= "random" and forcemode or "homicide")
		
		if CurrentRound().RoundStartPost then
			CurrentRound():RoundStartPost()
		end
		
		hook.Run("WN_StartRound")
	end
	
	function wn:Freeze()
		for _, ply in ipairs(player_GetAll()) do
			if ply:Team() == TEAM_SPECTATOR then continue end
			ply:Freeze(true)
		end
	end
	
	function wn:Unfreeze()
		for _, ply in ipairs(player_GetAll()) do
			ply:Freeze(false)
		end
	end
	
	function wn:AutoBalance()
		-- Auto balance teams
	end
	
	function wn:UpdateRoundTime(time, start, begin)
		wn.ROUND_TIME = time or wn.ROUND_TIME or 300
		wn.ROUND_START = start or CurTime()
		wn.ROUND_BEGIN = begin or CurTime()
		
		net.Start("updtime")
		net.WriteFloat(wn.ROUND_TIME)
		net.WriteFloat(wn.ROUND_START)
		net.WriteFloat(wn.ROUND_BEGIN)
		net.Broadcast()
	end
	
	function wn:AddFade()
		-- Fade screen effect
		net.Start("FadeScreen")
		net.Broadcast()
	end
	
	function wn:CheckRTVVotes()
		-- RTV (Rock The Vote) check
		return false
	end
	
	function wn:StartRTV(time)
		-- Start RTV
	end
	
	-- Create dev convar if not exists
	if not ConVarExists("wn_dev") then
		CreateConVar("wn_dev", "0", {FCVAR_ARCHIVE}, "White Noise developer mode")
	end
end
