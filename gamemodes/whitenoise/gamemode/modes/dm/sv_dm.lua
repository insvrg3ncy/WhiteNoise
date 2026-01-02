local MODE = MODE

MODE.name = "dm"
MODE.PrintName = "Deathmatch"
MODE.LootSpawn = false
MODE.GuiltDisabled = true
MODE.randomSpawns = true

MODE.ForBigMaps = false
MODE.Chance = 0.04

local radius = nil
local mapsize = 7500

util.AddNetworkString("wn_dm_start")
util.AddNetworkString("wn_dm_end")

function MODE:CanLaunch()
    return true
end

function MODE:Intermission()
	game.CleanUpMap()

	local poses = {}
	for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == TEAM_SPECTATOR then
			continue
		end
		
		ApplyAppearance(ply)
		ply:SetupTeam(0)
		table.insert(poses, ply:GetPos())
	end

	local centerpoint = Vector(0, 0, 0)
	for i, pos in ipairs(poses) do
		centerpoint:Add(pos)
	end
	centerpoint:Div(#poses)

	local dist = 0
	for i, pos in ipairs(poses) do
		local dist2 = pos:Distance(centerpoint)
		if dist < dist2 then
			dist = dist2
		end
	end

	zonepoint = centerpoint
	zonedistance = dist
	
	net.Start("wn_dm_start")
		net.WriteVector(zonepoint)
		net.WriteFloat(zonedistance)
	net.Broadcast()
end

function MODE:CheckAlivePlayers()
	local AlivePlyTbl = {}
	for _, ply in ipairs(player.GetAll()) do
		if not ply:Alive() then continue end
		if ply.organism and ply.organism.incapacitated then continue end
		AlivePlyTbl[#AlivePlyTbl + 1] = ply
	end
	return AlivePlyTbl
end

function MODE:ShouldRoundEnd()
	return (#wn:CheckAlive(true) <= 1)
end

-- Weapon tables (adapted from zbattle)
local tblweps = {
    "weapon_glock17",
    "weapon_cz75",
    "weapon_deagle",
    "weapon_ar15",
    "weapon_sr25",
    "weapon_ptrd",
    "weapon_mp7",
	"weapon_p90",
	"weapon_doublebarrel_short",
	"weapon_akm",
	"weapon_remington870",
	"weapon_m4a1",
	"weapon_mac11",
	"weapon_mp5",
	"weapon_m590a1",
	"weapon_draco",
	"weapon_uzi", 
	"weapon_tmp",
	"weapon_xm1014",
	"weapon_saiga12",
	"weapon_svd",
	"weapon_spas12",
	"weapon_hk416",
	"weapon_akmwreked",
	"weapon_hk_usp",
	"weapon_glock18c",
	"weapon_skorpion",
	"weapon_tec9",
	"weapon_sg552",
	"weapon_vector",
	"weapon_revolver2",
	"weapon_revolver357",
	"weapon_pkm",
	"weapon_ak74",
	"weapon_ak74u"
}

local tblatts = {
    {{"supressor4"},{"holo16","laser3"},{"holo15","laser1"},""},
    {{"supressor4"},{"supressor4"},""},
    "",
    {{"holo1","grip1","supressor2"},{"holo5","grip3","supressor2"},{"laser4","grip2"},{"laser4","supressor2"}},
    {{"holo1","laser2"},{"optic2"},{"holo8","supressor7"},{"holo5","supressor7"}},
    "",
    {{"holo1","supressor2"},{"holo5","supressor2"},{"laser4","supressor2"}},
	{{"holo15","supressor4"},{"laser1","supressor4"},{"holo14","supressor4"}},
	"",
	{{"holo6","supressor1"},{"holo4","laser1"},{"supressor1"}},
	"",
	{{"holo1","grip1","supressor2"},{"holo5","grip3","supressor2"},{"laser4","grip2"},{"laser4","supressor2"}},
	"",
	{{"supressor4"}},
	"",
	"",
	"",
	{{"optic8"},{"holo3"},{"holo4"}},
	"",
	"",
	{{"holo13"},{"holo6"},{"holo2"}},
	{{"supressor5"}},
	{{"holo1","grip1","supressor2"},{"holo5","grip3","supressor2"},{"laser4","grip2"},{"laser4","supressor2"}},
	"",
	{{"supressor3"}},
	{{"mag1","holo16"}},
	"",
	"",
	{{"optic8"},{"holo3"},{"holo4"}},
	{{"supressor4","holo3"},{"holo4"},{"holo7"}},
	"",
	"",
	"",
	"",
	"",
	""
}

local tblarmors = { 
    {"vest3","helmet1"},
    {"vest3","helmet1"},
    {"vest3","helmet1"},
    {"vest4","helmet1"},
    {"vest1","helmet1","nightvision1"},
    {},
    {"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1","mask1"},
	{"vest1","helmet1","nightvision1"},
	{"vest3","helmet1"},
	{"vest1","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest4","helmet1","mask1"},
	{"vest1","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1","mask1"},
	{"vest3","helmet1","mask1"},
	{"vest1","helmet1"},
	{"vest3","helmet1","mask1"},
	{"vest1","helmet1"},
	{"vest1","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest4","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest3","helmet1"},
	{"vest1","helmet1"},
	{"vest1","helmet1"},
	{"vest1","helmet1"},
	{"vest1","helmet1"},
}

local ammorandom = {
    3, 3, 3, 3, 3, 12, 3, 3, 6, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 4, 4, 3, 3, 4, 3, 3, 0, 3, 3, 3,
}

local function MakeDissolver( ent, position, dissolveType )
    local Dissolver = ents.Create( "env_entity_dissolver" )
    timer.Simple(5, function()
        if IsValid(Dissolver) then
            Dissolver:Remove()
        end
    end)

    Dissolver.Target = "dissolve"..ent:EntIndex()
    Dissolver:SetKeyValue( "dissolvetype", dissolveType )
    Dissolver:SetKeyValue( "magnitude", 0 )
    Dissolver:SetPos( position )
    Dissolver:SetPhysicsAttacker( ent )
    Dissolver:Spawn()

    ent:SetName( Dissolver.Target )
	ent:Fire("Open")
    Dissolver:Fire( "Dissolve", Dissolver.Target, 0 )
    Dissolver:Fire( "Kill", "", 0.1 )

    return Dissolver
end

function MODE:RoundStart()
	local mrand = math.random(#tblweps)
	local selectedAttachments = istable(tblatts[mrand]) and table.Random(tblatts[mrand]) or tblatts[mrand]

	for _, ply in player.Iterator() do
		if not ply:Alive() then continue end
		ply:SetSuppressPickupNotices(true)
		ply.noSound = true
		local hands = ply:Give("weapon_hands_sh")

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_sling"] = true
		ply:SetNetVar("Inventory",inv)
		
		local gun = ply:Give(tblweps[mrand])
		if not IsValid(gun) then continue end
		ply:GiveAmmo(gun:GetMaxClip1() * ammorandom[mrand],gun:GetPrimaryAmmoType(),true)

		hg.AddAttachmentForce(ply,gun,selectedAttachments)
		hg.AddArmor(ply, tblarmors[mrand])

		ply:Give("weapon_melee")
		ply:Give("weapon_hg_rgd_tpik")
		ply:Give("weapon_walkie_talkie")
		ply:Give("weapon_bandage_sh")
		ply:Give("weapon_tourniquet")
		ply:SelectWeapon("weapon_hands_sh")

		if ply.organism then
			ply.organism.recoilmul = 0.5
		end

		timer.Simple(0.1,function()
			ply.noSound = false
		end)

		ply:SetSuppressPickupNotices(false)
		wn.GiveRole(ply, "Fighter", Color(255, 255, 255))

		ply:SetNetVar("CurPluv", "pluvboss")
	end
end

hook.Add("Player Think","wn_dm_zone",function(ply)
	local rnd = CurrentRound()
	if not rnd or rnd.name != "dm" then return end
	if (wn.ROUND_START or CurTime()) + 20 > CurTime() then return end
	
	local pos = zonepoint
	local radius = MODE.GetZoneRadius()
	local radiussqr = radius * radius
	
	if ply:Alive() and (pos:DistToSqr(ply:GetPos()) > radiussqr) then
		if IsValid(ply.FakeRagdoll) then
			MakeDissolver(ply.FakeRagdoll,ply.FakeRagdoll:GetPos(),0)
		else
			hg.LightStunPlayer(ply)
		end
	end
end)

function MODE:GiveWeapons()
end

function MODE:GiveEquipment()
end

function MODE:RoundThink()
end

function MODE:PlayerDeath(_,ply)
	if wn.ROUND_STATE == 1 then
		ply:GiveSkill(-0.1)
	end
end

function MODE:CanSpawn()
end

function MODE:EndRound()
	local playersharm = {}
	for ply, tbl in pairs(wn.HarmDone) do
		for attacker, harm in pairs(tbl) do
			playersharm[attacker] = (playersharm[attacker] or 0) + harm
		end
	end

	local most_violent_player
	local curharm = 0
	for ply, harm in pairs(playersharm) do
		if harm > curharm then
			most_violent_player = ply
			curharm = harm
		end
	end

	timer.Simple(2,function()
		net.Start("wn_dm_end")
		local ent = wn:CheckAlive(true)[1]
		
		if IsValid(ent) then
			ent:GiveExp(math.random(150,200))
			ent:GiveSkill(math.Rand(0.2,0.3))
		end

		if IsValid(most_violent_player) then
			most_violent_player:GiveExp(math.random(150,200))
			most_violent_player:GiveSkill(math.Rand(0.2,0.3))
		end

		net.WriteEntity(IsValid(ent) and ent:Alive() and ent or NULL)
		net.WriteEntity(IsValid(most_violent_player) and most_violent_player or NULL)
		net.Broadcast()
	end)
end
