-- White Noise - Anti-AFK System (Server)

if SERVER then
	wn = wn or {}
	wn.AntiAFK = wn.AntiAFK or {}
	
	-- AFK detection settings
	wn.AntiAFK.AFKTime = 300 -- 5 minutes
	wn.AntiAFK.CheckInterval = 30 -- Check every 30 seconds
	
	-- Player AFK data
	wn.AntiAFK.PlayerData = wn.AntiAFK.PlayerData or {}
	
	-- Initialize player data
	function wn.AntiAFK:InitPlayer(ply)
		if not IsValid(ply) then return end
		
		local steamid = ply:SteamID64()
		self.PlayerData[steamid] = {
			lastPos = ply:GetPos(),
			lastMove = CurTime(),
			isAFK = false
		}
	end
	
	-- Check if player is AFK
	function wn.AntiAFK:CheckPlayer(ply)
		if not IsValid(ply) then return end
		if not ply:Alive() then return end
		
		local steamid = ply:SteamID64()
		local data = self.PlayerData[steamid]
		
		if not data then
			self:InitPlayer(ply)
			return
		end
		
		local currentPos = ply:GetPos()
		local moved = currentPos:Distance(data.lastPos) > 10
		
		if moved then
			data.lastPos = currentPos
			data.lastMove = CurTime()
			data.isAFK = false
		else
			local timeSinceMove = CurTime() - data.lastMove
			
			if timeSinceMove > self.AFKTime and not data.isAFK then
				data.isAFK = true
				ply:SetNWBool("WN_IsAFK", true)
				hook.Call("WN_OnPlayerAFK", nil, ply)
			end
		end
	end
	
	-- Check all players
	function wn.AntiAFK:CheckAll()
		for _, ply in ipairs(player.GetAll()) do
			self:CheckPlayer(ply)
		end
	end
	
	-- Initialize on player spawn
	hook.Add("PlayerSpawn", "WN_AntiAFK_Init", function(ply)
		wn.AntiAFK:InitPlayer(ply)
	end)
	
	-- Initialize on player connect
	hook.Add("PlayerInitialSpawn", "WN_AntiAFK_InitConnect", function(ply)
		wn.AntiAFK:InitPlayer(ply)
	end)
	
	-- Check timer
	timer.Create("WN_AntiAFK_Check", wn.AntiAFK.CheckInterval, 0, function()
		wn.AntiAFK:CheckAll()
	end)
end
