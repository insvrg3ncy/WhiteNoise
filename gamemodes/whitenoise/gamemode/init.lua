wn = wn or {}
hg = hg or {}
wn.ROUND_STATE = wn.ROUND_STATE or 0
--0 = players can join, 1 = round is active, 2 = endround

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
AddCSLuaFile("loader.lua")
include("loader.lua")

local PLAYER = FindMetaTable("Player")
function PLAYER:CanSpawn()
	return ( CurrentRound and CurrentRound() and CurrentRound().CanSpawn and CurrentRound():CanSpawn(self)) or (wn.ROUND_STATE == 0)
end

util.AddNetworkString("Player_Spect")

function PLAYER:GiveEquipment(team_)
end

local default_spawns = {
	"info_player_deathmatch", "info_player_combine", "info_player_rebel",
	"info_player_counterterrorist", "info_player_terrorist", "info_player_axis",
	"info_player_allies", "gmod_player_start", "info_player_teamspawn",
	"ins_spawnpoint", "aoc_spawnpoint", "dys_spawn_point", "info_player_pirate",
	"info_player_viking", "info_player_knight", "diprip_start_team_blue", "diprip_start_team_red",
	"info_player_red", "info_player_blue", "info_player_coop", "info_player_human", "info_player_zombie",
	"info_player_zombiemaster", "info_player_fof", "info_player_desperado", "info_player_vigilante", "info_survivor_rescue"
}

local vecup = Vector(0, 0, 64)

local spawners = {}

local function getRandSpawn()
	spawners = {}

	if #wn.GetMapPoints( "Spawnpoint" ) > 0 then
		for k, v in RandomPairs(wn.GetMapPoints( "Spawnpoint" )) do
			spawners[#spawners + 1] = v.pos
		end
	else
		for i, ent in RandomPairs(ents.FindByClass("info_player_start")) do
			spawners[#spawners + 1] = ent:GetPos()
		end
		
		for i, str in ipairs(default_spawns) do
			for k, v in RandomPairs(ents.FindByClass(str)) do
				spawners[#spawners + 1] = v:GetPos()
			end
		end
	end
end

getRandSpawn()

hook.Add("InitPostEntity", "wn_spawn_reset", function()
	getRandSpawn()
end)

hook.Add("WN_PreRoundStart", "reset_spawns", function()
	wn.ctspawn = nil
	wn.tspawn = nil
end)

function wn:GetTeamSpawn(ply)
	local team_ = ply:Team()

	local team0spawns, team1spawns = CurrentRound():GetTeamSpawn()
	
	if !team0spawns or !next(team0spawns) then
		team0spawns = {wn:GetRandomSpawn()}
	end

	if !team1spawns or !next(team1spawns) then
		team1spawns = {wn:GetRandomSpawn()}
	end

	local pos
	
	if team_ == 0 then
		if !wn.tspawn then
			wn.tspawn = table.Random(team0spawns)
			pos = wn.tspawn
		else
			pos = hg.tpPlayer(wn.tspawn, ply, math.Clamp(ply:EntIndex() % 24 + 1, 1, 24), 0)
		end

		return pos
	else
		if !wn.ctspawn then
			wn.ctspawn = table.Random(team1spawns)
			pos = wn.ctspawn
		else
			pos = hg.tpPlayer(wn.ctspawn, ply, math.Clamp(ply:EntIndex() % 24 + 1, 1, 24), 0)
		end

		return pos
	end
end

function wn:GetRandomSpawn()
	if #spawners == 0 then
		getRandSpawn()
	end

	return table.Random(spawners)
end

function GM:PlayerSpawn(ply)
	ply:SetCustomCollisionCheck(true)
	ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	
	if ply:Team() == TEAM_SPECTATOR then
		ply:Spectate(OBS_MODE_ROAMING)
		return
	end

	local pos = wn:GetTeamSpawn(ply)
	if pos then
		ply:SetPos(pos)
	end

	ply:GiveEquipment(ply:Team())
end

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(TEAM_UNASSIGNED)
end

function GM:PlayerSelectSpawn(ply)
	return nil
end

function GM:PlayerSetModel(ply)
	local cl_playermodel = ply:GetInfo("cl_playermodel")
	local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
	util.PrecacheModel(modelname)
	ply:SetModel(modelname)
end

function GM:PlayerLoadout(ply)
	return true
end

function GM:PlayerDeath(ply, inflictor, attacker)
	ply:SetNWBool("Spectating", true)
	
	net.Start("Player_Spect")
	net.WriteEntity(ply)
	net.WriteEntity(ply)
	net.WriteInt(1, 4)
	net.Send(ply)
end

function GM:PlayerDeathThink(ply)
	if ply:GetNWBool("Spectating", false) then
		if ply:KeyPressed(IN_ATTACK) then
			ply:Spectate(OBS_MODE_IN_EYE)
			ply:SpectateEntity(ply:GetObserverTarget())
		elseif ply:KeyPressed(IN_ATTACK2) then
			ply:Spectate(OBS_MODE_CHASE)
			ply:SpectateEntity(ply:GetObserverTarget())
		elseif ply:KeyPressed(IN_JUMP) then
			local players = wn:CheckAlive()
			if #players > 0 then
				ply:SpectateEntity(table.Random(players))
			end
		end
	end
end

function GM:PlayerDisconnected(ply)
	-- Cleanup on disconnect
end

function GM:GetFallDamage(ply, speed)
	return 0
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	return true
end

function GM:EntityTakeDamage(target, dmg)
	return true
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	return true
end

function GM:PlayerHurt(victim, attacker, healthremaining, damage)
	-- Handle player hurt
end

function GM:PlayerCanPickupWeapon(ply, wep)
	return true
end

function GM:PlayerCanPickupItem(ply, item)
	return true
end

function GM:PlayerUse(ply, ent)
	return true
end

function GM:CanPlayerSuicide(ply)
	return false
end

function GM:PlayerSay(ply, text, teamchat)
	return text
end

function GM:ShowHelp(ply)
	-- Show help menu
end

function GM:ShowTeam(ply)
	-- Show team menu
end

function GM:ShowSpare1(ply)
	-- Show spare menu 1
end

function GM:ShowSpare2(ply)
	-- Show spare menu 2
end
