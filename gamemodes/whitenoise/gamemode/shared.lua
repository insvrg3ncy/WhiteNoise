GM.Name = "White Noise"
GM.Author = "WhiteNoise Team"
GM.Email = "N/A"
GM.Website = "N/A"
wn.Version = "Beta 1.0"

team.SetUp(0, "Players", Color(255, 255, 255))
team.SetUp(1, "Players2", Color(240, 240, 240))
team.SetUp(2, "Players3", Color(220, 220, 220))

DeriveGamemode("sandbox")

local spawn = {"PlayerGiveSWEP", "PlayerSpawnEffect", "PlayerSpawnNPC", "PlayerSpawnObject", "PlayerSpawnProp", "PlayerSpawnRagdoll", "PlayerSpawnSENT", "PlayerSpawnSWEP", "PlayerSpawnVehicle"}

local blur = Material("pp/blurscreen")
local wn_potatopc
function wn.DrawBlur(panel, amount, passes, alpha)
	if is3d2d then return end
	amount = amount or 5
	wn_potatopc = wn_potatopc or wn.ConVars.potatopc

	if(wn_potatopc:GetBool())then
		surface.SetDrawColor(255, 255, 255, alpha or (amount * 20))
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255, alpha or 125)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

		local x, y = panel:LocalToScreen(0, 0)

		for i = -(passes or 0.2), 1, 0.2 do
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()
			
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end
end

local function BlockSpawn(ply, ent)
	if game.SinglePlayer() or ply:IsAdmin() then return true end

	return false
end

for _, v in ipairs(spawn) do
	hook.Add(v, "BlockSpawn", BlockSpawn)
end

hook.Add( "PlayerNoClip", "FeelFreeToTurnItOff", function( ply, desiredState )
	if ( desiredState == false ) then
		return true
	elseif ( ply:IsAdmin() ) then
		return true
	end

	return false
end )

if CLIENT then
	hook.Add( "PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
		if ( string.find( bind, "+menu" ) ) then
			--return true
		end
	end )

	hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
		if ( not LocalPlayer():IsAdmin()) then
			return false
		end
	end )
	
	-- Блокируем Q-меню (Context Menu) для не-админов
	hook.Add( "ContextMenuOpen", "WN_BlockContextMenu", function()
		if not LocalPlayer():IsAdmin() then
			return false
		end
	end )
end

local player_GetAll = player.GetAll
local team_GetAllTeams = team.GetAllTeams

function wn:CheckTeams()
	local tbl = {}
	for i, info in pairs(team_GetAllTeams()) do
		tbl[i] = {}
	end

	for _, ply in pairs(player_GetAll()) do
		tbl[ply:Team()][#tbl[ply:Team()] + 1] = ply
	end
	return tbl
end

function wn:CheckAliveTeams(incapacitatedcheck)
	local tbl = {}

	for i, info in pairs(team_GetAllTeams()) do
		if i == TEAM_UNASSIGNED or i == TEAM_SPECTATOR then continue end
		tbl[i] = {}
	end

	for _, ply in ipairs(player_GetAll()) do
		if not ply:Alive() then continue end
		if incapacitatedcheck and ply.organism and ply.organism.incapacitated then continue end

		tbl[ply:Team() or 0] = tbl[ply:Team() or 0] or {}
		tbl[ply:Team()][(#tbl[ply:Team() or 0] or 0) + 1] = ply
	end

	return tbl
end

function wn:CheckAlive(incapacitatedcheck)
	local tbl = {}
	for _, ply in ipairs(player_GetAll()) do
		if not ply:Alive() then continue end
		if incapacitatedcheck and ply.organism and ply.organism.incapacitated then continue end
		tbl[#tbl + 1] = ply
	end
	return tbl
end

function wn:CheckPlaying()
	local tbl = {}
	for _, ply in ipairs(player_GetAll()) do
		if ply:Team() == TEAM_SPECTATOR then continue end
		if not ply:Alive() then continue end
		
		tbl[#tbl + 1] = ply
	end
	return tbl
end

function GM:HandlePlayerLanding( ply, velocity, WasOnGround )
	if SERVER then return end
	if ply == LocalPlayer() and ply == GetViewEntity() then return end

	if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end

	if ( ply:IsOnGround() && !WasOnGround ) then
		ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_LAND, true )
	end
end

function GM:GrabEarAnimation(ply)
	wn.earanim(ply)
end
