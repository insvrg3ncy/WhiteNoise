-- White Noise - Team Setup System (Server)

if SERVER then
	wn = wn or {}
	
	-- Team definitions
	wn.Teams = wn.Teams or {}
	
	teams = {
		[0] = {
			color = Color(255, 255, 255),
			name = "Team 1",
		},
		[1] = {
			color = Color(240, 240, 240),
			name = "Team 2",
		}
	}
	
	local team_GetPlayers = team.GetPlayers
	function wn:BalancedChoice(first, second)
		local team0, team1 = team_GetPlayers(first), team_GetPlayers(second)
		return (#team0 > #team1 and second) or (#team1 > #team0 and first) or first
	end
	
	local player_GetAll = player.GetAll
	function wn:AutoBalance()
		local mode = CurrentRound()
		
		if mode.OverrideBalance and mode:OverrideBalance() then return end
		
		for i, ply in ipairs(player_GetAll()) do
			if ply:Team() == TEAM_SPECTATOR then continue end
			ply:SetTeam(TEAM_UNASSIGNED)
		end
		
		for i, ply in RandomPairs(player_GetAll()) do
			if ply:Team() == TEAM_SPECTATOR then continue end
			ply:SetTeam(wn:BalancedChoice(0, 1))
		end
	end
	
	-- Setup teams
	function wn.SetupTeams()
		-- Clear existing teams (except default ones)
		for i = 3, 100 do
			if team.GetName(i) then
				team.SetUp(i, "", Color(255, 255, 255))
			end
		end
		
		-- Setup custom teams
		for teamId, teamData in pairs(wn.Teams) do
			team.SetUp(teamId, teamData.name, teamData.color)
		end
	end
	
	-- Register team
	function wn.RegisterTeam(teamId, teamData)
		if not teamId or not teamData then return false end
		
		wn.Teams[teamId] = teamData
		team.SetUp(teamId, teamData.name, teamData.color)
		
		return true
	end
	
	-- Initialize teams on map load
	hook.Add("InitPostEntity", "WN_SetupTeams", function()
		wn.SetupTeams()
	end)
end
