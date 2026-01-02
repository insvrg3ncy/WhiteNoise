local MODE = MODE
MODE.start_time = 1
MODE.end_time = 7
 
MODE.ROUND_TIME = 600
 
MODE.randomSpawns = true

MODE.shouldfreeze = true

MODE.PoliceAllowed = false
MODE.OverrideSpawn = true

MODE.LootSpawn = true
MODE.LootOnTime = true

MODE.Chance = 0.28
MODE.LootDivTime = 200

MODE.LootTable = {
	{30, {
		{15,"weapon_smallconsumable"},
		{12,"weapon_bigconsumable"},
		{8,"weapon_tourniquet"},
		{8,"weapon_bandage_sh"},
		{7,"weapon_ducttape"},
		{6,"weapon_painkillers"},
		{5,"weapon_bloodbag"},
		{5,"weapon_hammer"},
		{4,"weapon_walkie_talkie"},
		{3,"hg_flashlight"},
		{2,"weapon_pocketknife"},
		{2,"weapon_medkit_sh"},
		{1,"weapon_bat"},
		{1,"weapon_leadpipe"},
		{0.65,"weapon_hg_extinguisher"},
		{0.65,"ent_armor_mask2"},

		{1,"weapon_matches"},--for dumbasses

		{0.5,"weapon_hg_crowbar"},
		{0.4,"weapon_tomahawk"},
		{0.4,"weapon_hatchet"},
		{0.25,"weapon_hg_axe"},
		{0.25,"weapon_hg_sledgehammer"},
		{0.27, "ent_armor_helmet2"},
	}},
	{8, {
		{8,"hg_sling"},
		{8,"*ammo*"},
		{8,"*sight*"},
		{8,"*barrel*"},
		{15,"weapon_mp-80"},
		{10,"weapon_makarov"},
		{9,"weapon_hk_usp"},
		{9,"weapon_glock17"},
		{9,"weapon_cz75"},
		{9,"weapon_px4beretta"},
		{9,"weapon_m9beretta"},
		{7,"weapon_browninghp"},
		{7,"weapon_fn45"},
		--{7,"weapon_ab10"},
		{7,"weapon_pm9"},
		{7,"weapon_tec9"},
		{7,"weapon_revolver2"},
		--{6,"weapon_revolver357"},
		{6,"weapon_deagle"},
		{6,"weapon_colt9mm"},
		{5,"weapon_doublebarrel_short"},
		--{7,"ent_armor_vest6"},
		{5,"ent_armor_vest7"},
		{8, "ent_armor_helmet2"},
		-- Добавил это так как банально через время верхний тир падает РЕЖЕ в раз сто чем этот.
		{0.3,"weapon_smallconsumable"},
		{0.25,"weapon_bigconsumable"},
		{0.24,"weapon_walkie_talkie"},
		{0.23,"weapon_painkillers"},
		{0.2,"weapon_medkit_sh"},
		-- Как никак полезные инструменты для выбивание барикад и дверей
		{0.15,"weapon_hg_crowbar"},
		{0.15,"weapon_hatchet"},
		{0.1,"weapon_hg_axe"},
		{0.1,"weapon_hg_sledgehammer"},
	}},
	{1, {
		{5,"weapon_doublebarrel"},
		{4,"weapon_remington870"},

		{4,"weapon_glock18c"},
		{4,"weapon_skorpion"},
		{4,"weapon_mac11"},
		{4,"weapon_uzi"},
		{4,"weapon_tmp"},
		
		{4,"weapon_hg_molotov_tpik"},
		{4,"weapon_hg_grenade_pipebomb"},

		{3,"weapon_kar98"},
		{3,"weapon_ar_pistol"},
		{3,"weapon_draco"},
		{3,"weapon_mp5"},
		--{3,"weapon_xm1014"},

		{3,"ent_armor_vest3"},
		{3,"ent_armor_helmet1"},

		{2,"weapon_mp7"},
		{2,"weapon_sks"},
		{2,"weapon_ar15"},

		{2,"ent_armor_vest4"},
		
		--{1,"weapon_akm"},
		{1,"weapon_vpo136"},
		{1,"weapon_sr25"},
	}},
}

MODE.LootTableStandard = {
	{100, {
		{15,"weapon_smallconsumable"},
		{12,"weapon_bigconsumable"},
		{8,"weapon_tourniquet"},
		{8,"weapon_bandage_sh"},
		{7,"weapon_ducttape"},
		{6,"weapon_painkillers"},
		{5,"weapon_bloodbag"},
		{5,"weapon_hammer"},
		{4,"hg_flashlight"},
		{2,"weapon_pocketknife"},
		{1,"weapon_bat"},
		{1,"weapon_leadpipe"},

		{1,"weapon_matches"},--for dumbasses

		{0.4,"weapon_hg_extinguisher"},
		{0.4,"weapon_hg_crowbar"},
		{0.35,"weapon_tomahawk"},
		{0.35,"weapon_hatchet"},
		{0.25,"weapon_hg_axe"},
		{0.25,"weapon_hg_sledgehammer"},
	}},
}

-- MODE.TraitorWords = {
	-- "пистолет",
	-- "трейтор",
	-- "ганмен",
	-- "калаш (винтовка)",
	-- "бомба",
	-- "цианид",
	-- "нож",
	-- "труба",
	-- "топор",
	-- "юсп (пистолет)",
	-- "арка (винтовка)",
	-- "каряк (винтовка)",
	-- "граната",
	-- "улица",
	-- "здание",
	-- "патроны",
	-- "бинт",
	-- "аптечка",
	-- "обезболивающее",
	-- "дробовик",
-- }

MODE.TraitorWordsAdjectives = {
	"pretty",
	"sad",
	"bad",
	"cool",
	"happy",
	"ugly",
	"funny",
	"red",
	"green",
	"blue",
	"yellow",
	"orange",
	"cyan",
	"pink",
	"mesmerizing",
	"",	--; да да
}

MODE.TraitorWords = {
	"crate",
	"death",
	"man",
	"revolver",
	"door",
	"pistol",
	"traitor",
	"gunman",
	"ak rifle",
	"bomb",
	"cyanide",
	"knife",
	"pipe",
	"axe",
	"usp pistol",
	"ar15 rifle",
	"kar98k rifle",
	"grenade",
	"outside",
	"building",
	"ammo",
	"bandage",
	"medkit",
	"painkillers",
	"shotgun",
	"melancholic",
	"poison",
	"murder",
}

MODE.TraitorActions = {
	"punch air or walls",
	"jump",
	"crouch",
	"ragdoll randomly",
	"spin around",
}

SetGlobalBool("WN_RolesPlus_Enable", true)

util.AddNetworkString("WN_Homicide_PoliceRole")
util.AddNetworkString("WN_Homicide(StartPlayersRoleSelection)")
util.AddNetworkString("WN_Homicide(EndPlayersRoleSelection)")
util.AddNetworkString("WN_Homicide(SetSubRole)")
util.AddNetworkString("WN_Homicide_AnnounceTraitorLose")

MODE.Type = MODE.Type or "standard"
MODE.Types = MODE.Types or {}
MODE.Types.standard = {
	ChanceFunction = function() return (wn.GetWorldSize() < WHITENOISE_BIGMAP) and 0.4 or 0 end,
	LootTable = MODE.LootTableStandard,
	Messages = {
		[3] = "Everyone died.",
		[1] = "The murderer has killed everyone.",
		[0] = "The murderer was",
	},
	Message = "The murderer was ",
	TraitorLoot = function(ply)
		ply:Give("weapon_buck200knife")
		ply:Give("weapon_hg_type59_tpik")
		ply:Give("weapon_adrenaline")
		ply:Give("weapon_hg_shuriken")
		ply:Give("weapon_hg_smokenade")
		ply:Give("weapon_traitor_ied")
		ply:Give("weapon_traitor_poison1")
		ply:Give("weapon_traitor_poison2")
		ply:Give("weapon_traitor_poison3")
		ply:Give("weapon_traitor_poison_consumable")
		ply:Give("weapon_traitor_suit")
		local wep = ply:Give("weapon_zoraki")
		timer.Simple(1,function() wep:ApplyAmmoChanges(2) end)

		ply.organism.stamina.range = 220

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_flashlight"] = true
		ply:SetNetVar("Inventory",inv)
	end,
	GunManLoot = function(ply)
		ply:Give("weapon_px4beretta")
		ply.organism.recoilmul = 1
	end,
	PoliceTime = 220,
	SkillIssue = 4,
	PoliceAllowed = true,
	PoliceEquipment = function(ply)
		ply:SetPlayerClass("police")
		local glock = ply:Give("weapon_glock17")
		ply:GiveAmmo(glock:GetMaxClip1() * 3,glock:GetPrimaryAmmoType(),true)
		if math.random(0,1) then
			wn.AddAttachmentForce(ply,gun,"holo16")
		end

		if math.random(0,1) then
			wn.AddAttachmentForce(ply,gun,"laser3")
		end

		ply:Give("weapon_medkit_sh")
		ply:Give("weapon_walkie_talkie")
		ply:Give("weapon_naloxone")
		ply:Give("weapon_painkillers")
		ply:Give("weapon_handcuffs")
		ply:Give("weapon_handcuffs_key")
		ply:Give("weapon_hg_tonfa")
		
		local gun = ply:Give("weapon_taser")
		ply:GiveAmmo(gun:GetMaxClip1() * 3,gun:GetPrimaryAmmoType(),true)

		wn.AddArmor(ply, {"vest2"})

		local hands = ply:Give("weapon_hands_sh")
		ply:SetActiveWeapon( hands )

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_flashlight"] = true
		ply:SetNetVar("Inventory",inv)
		ply.organism.recoilmul = 0.8

		ply:SetNetVar("CurPluv", "pluvberet")

		wn.GiveRole(ply, "Police Officer", Color(15,15,255))
	end
}
MODE.Types.wildwest = {
	ChanceFunction = function() return (wn.GetWorldSize() < WHITENOISE_BIGMAP) and 0.1 or 0 end,
	LootTable = MODE.LootTableStandard,
	Messages = {
		[3] = "The dead silence fills the empty city...",
		[1] = "The town has fallen into the hands of crime.",
		[0] = "The law was settled once again. The bastard is",
	},
	Message = "The criminal was ",
	TraitorLoot = function(ply)
		ply:Give("weapon_sogknife")
		ply:Give("weapon_hg_type59_tpik")
		ply:Give("weapon_adrenaline")
		local revolver = ply:Give(math.random(2) == 2 and "weapon_winchester" or "weapon_revolver2")
		ply:GiveAmmo(revolver:GetMaxClip1() * 1,revolver:GetPrimaryAmmoType(),true)
		ply:Give("weapon_traitor_ied")
		ply:Give("weapon_hg_molotov_tpik")
		ply:Give("weapon_hg_smokenade")

		ply.organism.recoilmul = 1.0
		ply.organism.stamina.range = 220

		ply:SetNetVar("CurPluv", "pluvfancy")

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_sling"] = true
		ply:SetNetVar("Inventory",inv)
	end,
	GunManLoot = function(ply)
		for k,v in player.Iterator() do
			timer.Simple(1,function()
				local Appearance = v:GetNetVar("Accessories",{"none"})
				if istable(Appearance) then
					Appearance[1] = "stetson"
				else
					Appearance = "stetson"
				end
				local appearance = v.CurAppearance
				v:SetSubMaterial(wn.Apperance.SubMaterials[v:GetModel()],wn.Apperance.ClothesStyles["formal"][(not wn.ThatPlyIsFemale(v)) and 1 or 2])
				v:SetNetVar("Accessories", Appearance)
				--v:SetPlayerColor(Vector(1,0.690196,0.537255))
			end)
			if v.isTraitor then continue end
			if v.isGunner then
				v:Give("weapon_winchester")
				v:Give("weapon_revolver357")
				v:Give("weapon_handcuffs")
				v:Give("weapon_handcuffs_key")
			else
				v:Give(math.random(2) == 2 and "weapon_winchester" or "weapon_revolver2")
			end

			v:SetNetVar("CurPluv", "pluvfancy")

			local inv = v:GetNetVar("Inventory")
			inv["Weapons"] = inv["Weapons"] or {}
			inv["Weapons"]["hg_sling"] = true
			v:SetNetVar("Inventory",inv)
		end
	end,
	PoliceTime = 220,
	PoliceAllowed = false,
	SkillIssue = 3,
	PoliceEquipment = function(ply)
		ply:SetPlayerClass("police")
		local glock = ply:Give("weapon_glock17")
		ply:GiveAmmo(glock:GetMaxClip1() * 3,glock:GetPrimaryAmmoType(),true)
		if math.random(0,1) then
			wn.AddAttachmentForce(ply,gun,"holo16")
		end

		if math.random(0,1) then
			wn.AddAttachmentForce(ply,gun,"laser3")
		end

		ply:Give("weapon_medkit_sh")
		ply:Give("weapon_walkie_talkie")
		ply:Give("weapon_naloxone")
		ply:Give("weapon_painkillers")
		ply:Give("weapon_handcuffs")
		ply:Give("weapon_handcuffs_key")
		ply:Give("weapon_hg_tonfa")

		local gun = ply:Give("weapon_taser")
		ply:GiveAmmo(gun:GetMaxClip1() * 3,gun:GetPrimaryAmmoType(),true)

		wn.AddArmor(ply, {"vest2"})

		local hands = ply:Give("weapon_hands_sh")
		ply:SetActiveWeapon( hands )

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_flashlight"] = true
		ply:SetNetVar("Inventory",inv)

		ply:SetNetVar("CurPluv", "pluvberet")

		wn.GiveRole(ply, "Police Officer", Color(15,15,255))
	end
}

MODE.Types.gunfreezone = {
	ChanceFunction = function() return (wn.GetWorldSize() < WHITENOISE_BIGMAP) and 0.1 or 0 end,
	LootTable = MODE.LootTableStandard,
	Messages = {
		[3] = "Everyone died.",
		[1] = "The murderer has killed everyone.",
		[0] = "The murderer was",
	},
	Message = "The murderer was ",
	TraitorLoot = function(ply)
		ply:Give("weapon_buck200knife")
		ply:Give("weapon_hg_type59_tpik")
		ply:Give("weapon_adrenaline")
		ply:Give("weapon_hg_shuriken")
		ply:Give("weapon_hg_smokenade")
		ply:Give("weapon_traitor_ied")
		ply:Give("weapon_traitor_poison1")
		ply:Give("weapon_traitor_poison2")
		ply:Give("weapon_traitor_poison3")
		ply:Give("weapon_traitor_poison_consumable")
		ply:Give("weapon_traitor_suit")

		local wep = ply:Give("weapon_zoraki")
		timer.Simple(1,function() wep:ApplyAmmoChanges(2) end)

		ply.organism.stamina.range = 220

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_flashlight"] = true
		ply:SetNetVar("Inventory",inv)
	end,
	GunManLoot = function(ply)
	end,
	PoliceTime = 120,
	PoliceAllowed = true,
	SkillIssue = 4,
	PoliceEquipment = function(ply)
		ply:SetPlayerClass("police")
		local glock = ply:Give("weapon_glock17")
		ply:GiveAmmo(glock:GetMaxClip1() * 3,glock:GetPrimaryAmmoType(),true)
		if math.random(0,1) then
			wn.AddAttachmentForce(ply,glock,"holo16")
		end

		if math.random(0,1) then
			wn.AddAttachmentForce(ply,glock,"laser3")
		end

		ply:Give("weapon_medkit_sh")
		ply:Give("weapon_walkie_talkie")
		ply:Give("weapon_naloxone")
		ply:Give("weapon_painkillers")
		ply:Give("weapon_handcuffs")
		ply:Give("weapon_handcuffs_key")
		ply:Give("weapon_hg_tonfa")

		local gun = ply:Give("weapon_taser")
		ply:GiveAmmo(gun:GetMaxClip1() * 3,gun:GetPrimaryAmmoType(),true)

		wn.AddArmor(ply, {"vest2"})

		local hands = ply:Give("weapon_hands_sh")
		ply:SetActiveWeapon( hands )

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_flashlight"] = true
		ply:SetNetVar("Inventory",inv)
		ply.organism.recoilmul = 0.8

		wn.GiveRole(ply, "Police Officer", Color(15,15,255))

		ply:SetNetVar("CurPluv", "pluvberet")
	end
}

MODE.Types.soe = {
	ChanceFunction = function() return (wn.GetWorldSize() >= WHITENOISE_BIGMAP) and 0.4 or 0 end,
	LootTable = MODE.LootTable,
	Messages = {
		[3] = "Everyone died.",
		[1] = "The traitor has killed everyone.",
		[0] = "The traitor was",
	},
	Message = "The traitor was ",
	TraitorLoot = function(ply)
		local p22 = ply:Give("weapon_p22")
		wn.AddAttachmentForce(ply,p22,"supressor4")
		ply:Give("weapon_sogknife")
		ply:Give("weapon_hg_type59_tpik")
		ply:Give("weapon_walkie_talkie")
		ply:Give("weapon_adrenaline")
		ply:Give("weapon_hg_smokenade")
		ply:Give("weapon_traitor_ied")
		ply:Give("weapon_traitor_poison2")
		ply:Give("weapon_traitor_poison3")
		ply:Give("weapon_traitor_poison_consumable")
		ply.organism.recoilmul = 1
		ply.organism.stamina.range = 220

		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_flashlight"] = true
		ply:SetNetVar("Inventory",inv)
	end,
	GunManLoot = function(ply)
		local gun = ply:Give( ( math.random(1,2) > 1 and "weapon_remington870" ) or "weapon_kar98" )
		ply.organism.recoilmul = 1.0
		if gun:GetClass() == "weapon_kar98" then
			wn.AddAttachmentForce(ply,gun,"optic12")
		end
		local inv = ply:GetNetVar("Inventory")
		inv["Weapons"]["hg_sling"] = true
		ply:SetNetVar("Inventory",inv)

		ply:SetNetVar("CurPluv", "pluvboss")
	end,
	PoliceTime = 250,
	PoliceAllowed = true,
	SkillIssue = 3,
	PoliceEquipment = function(ply)
		local inv = ply:GetNetVar("Inventory") or {}
		inv["Weapons"] = inv["Weapons"] or {}
		inv["Weapons"]["hg_flashlight"] = true
		inv["Weapons"]["hg_sling"] = true
		ply:SetNetVar("Inventory", inv)
	
		ply:SetPlayerClass("nationalguard")
		local gun = ply:Give("weapon_fn45")
		ply:GiveAmmo(gun:GetMaxClip1() * 3, gun:GetPrimaryAmmoType(), true)
	
		gun = ply:Give("weapon_hk416")
		ply:GiveAmmo(gun:GetMaxClip1() * 3, gun:GetPrimaryAmmoType(), true)
		wn.AddAttachmentForce(ply, gun, {"holo14", "laser3", "grip3"})
	
		ply:Give("weapon_hg_grenade_tpik")
		ply:Give("weapon_melee")
	
		ply:Give("weapon_medkit_sh")
		ply:Give("weapon_bandage_sh")
		ply:Give("weapon_walkie_talkie")
		ply:Give("weapon_painkillers")
		ply:Give("weapon_morphine")
	
		ply.organism.recoilmul = 0.5
	
		ply:Give("weapon_handcuffs")
		ply:Give("weapon_handcuffs_key")
	
		gun = ply:Give("weapon_taser")
		ply:GiveAmmo(gun:GetMaxClip1() * 3, gun:GetPrimaryAmmoType(), true)
	
		wn.AddArmor(ply, {"vest4", "helmet1"})
	
		local hands = ply:Give("weapon_hands_sh")
		ply:SetActiveWeapon(hands)
	
		wn.GiveRole(ply, "National guardian", Color(55, 85, 0))
		ply:SetNetVar("CurPluv", "pluvberet")
	end,
	PoliceText = "National guards have arrived.",
	PoliceSound = "snd_jack_hmcd_heli2.mp3"
}

local modes = {
	"soe",
	"standard",
	"wildwest",
	"gunfreezone",
}

local setmode = ConVarExists("homicide_setmode") and GetConVar("homicide_setmode") or CreateConVar( "homicide_setmode", "random", FCVAR_NONE, "sets homicide mode" )

util.AddNetworkString("WN_Homicide_Start")

function MODE:GetPlySpawn(ply)
end

function MODE:SubModes()
	return modes
end

function MODE:Intermission()
	game.CleanUpMap()

	local _,CROUND = CurrentRound()

	if not CROUND or CROUND == "homicide" then
		CROUND = table.Random(self:SubModes())
	end

	self.Type = CROUND
	local player_count = 0

	for k, ply in ipairs(player.GetAll()) do
		if ply:Team() == TEAM_SPECTATOR then continue end
		ply:KillSilent()

		ply.isPolice = false
		ply.isTraitor = false
		ply.isGunner = false
		ply.MainTraitor = false
		ply.SubRole = nil
		ply.Profession = nil

		ply:SetupTeam(0)

		ply.organism.recoilmul = wn.DefaultSkillIssue
		player_count = player_count + 1
	end

	MODE.TraitorFrequency = nil
	MODE.TraitorWord = MODE.TraitorWords[math.random(1, #MODE.TraitorWords)]
	MODE.TraitorWordSecond = MODE.TraitorWords[math.random(1, #MODE.TraitorWords)]
	local traitors_needed = 1

	if(MODE.ShouldStartRoleRound())then
		traitors_needed = math.ceil(player_count / 9)
		
		if(player_count > 8 and math.random(1, 8) == 1)then
			traitors_needed = traitors_needed + 1
		end
	end

	MODE.TraitorExpectedAmt = traitors_needed
	local main_traitor = nil
	local traitors = {}


	MODE.NextRoundMainTraitors = MODE.NextRoundMainTraitors or {}
	for i, ply in RandomPairs(player.GetAll()) do
		if ply.isTraitor or ply:Team() == TEAM_SPECTATOR then continue end
		if not MODE.NextRoundMainTraitors[ply:SteamID()] then continue end

		if traitors_needed > 0 then
			ply.isTraitor = true
			traitors_needed = traitors_needed - 1
			traitors[#traitors + 1] = ply

			main_traitor = ply
			ply.MainTraitor = true
			MODE.NextRoundMainTraitors[ply:SteamID()] = nil
		end
	end


	for i, ply in RandomPairs(player.GetAll()) do
		if ply.isTraitor or ply:Team() == TEAM_SPECTATOR then continue end
		if math.random(100) > (ply.Karma or 100) then continue end

		if traitors_needed > 0 then
			ply.isTraitor = true
			traitors_needed = traitors_needed - 1
			traitors[#traitors + 1] = ply

			if not main_traitor then
				main_traitor = ply
				ply.MainTraitor = true
			end
		end
	end

	if traitors_needed > 0 then
		for i, ply in RandomPairs(player.GetAll()) do
			if ply.isTraitor or ply:Team() == TEAM_SPECTATOR then continue end

			if traitors_needed > 0 then
				ply.isTraitor = true
				traitors_needed = traitors_needed - 1
				traitors[#traitors + 1] = ply

				if not main_traitor then
					main_traitor = ply
					ply.MainTraitor = true
				end
			end
		end
	end

	self.saved.PoliceTime = CurTime() + math.min(self.Types[self.Type].PoliceTime * (#player.GetAll() / 4),self.Types[self.Type].PoliceTime * 2.2)
	self.PoliceSpawned = false
	self.PoliceAllowed = self.Types[self.Type].PoliceAllowed

	for k, ply in ipairs(player.GetAll()) do
		if(MODE.ShouldStartRoleRound())then
			net.Start("WN_Homicide_Start")	--; TODO Structure description
				net.WriteBool(ply.isTraitor)	--; Is Traitor
				net.WriteBool(ply.isGunner)	--; Is Gunner
				net.WriteString(self.Type)	--; Round Type
				net.WriteBool(false)	--; Round Started
				net.WriteString("")	--; SubRole
				net.WriteBool(ply.MainTraitor == true)	--; MainTraitor

				if(ply.isTraitor)then
					net.WriteString(MODE.TraitorWord)
					net.WriteString(MODE.TraitorWordSecond)
					net.WriteUInt(MODE.TraitorExpectedAmt, MODE.TraitorExpectedAmtBits)
				else
					net.WriteString("")
					net.WriteString("")
					net.WriteUInt(0, MODE.TraitorExpectedAmtBits)
				end
				
				net.WriteString("")	--; Profession
			net.Send(ply)

			local role = self.Roles[self.Type][(ply.isTraitor and "traitor") or (ply.isGunner and "gunner") or "innocent"]

			wn.GiveRole(ply, role.name, role.color)
		end
	end
end

--[[concommand.Add("wn_homicide_call_police", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsAdmin() then
        ply:ChatPrint("loh.")
        return
    end

    if not MODE or not MODE.saved then
        print("fake")
        return
    end

    MODE.saved.PoliceTime = CurTime() - 1
    print("true")
end)--]]

function MODE:CheckAlivePlayers()
	local AlivePlyTbl = {
		[0] = {},
		[1] = {}
	}
	
	for _, ply in ipairs(player.GetAll()) do
		if(not ply:Alive())then
			continue
		end
		
		if((not ply.isTraitor)and ply.organism and ply.organism.incapacitated)then
			continue
		end
		
		if ply.isTraitor and not ply:GetNetVar("handcuffed",false) then
			--print(ply)
			AlivePlyTbl[1][#AlivePlyTbl[1] + 1] = ply
		elseif(not ply.isPolice)then
			AlivePlyTbl[0][#AlivePlyTbl[0] + 1] = ply
		end
	end
	
	return AlivePlyTbl
end
	
local deadPoliceCount = 0
local swatDeployed = false

function MODE:GetActivePlayers()
	local valid = {}

	for _, ply in ipairs(player.GetAll()) do
		if ply:Alive() then continue end                        
		if ply:Team() == TEAM_SPECTATOR then continue end       
		if ply.afkTime2 and ply.afkTime2 > 60 then continue end 

		valid[#valid + 1] = ply
	end

	return valid
end


MODE.deadPoliceCount = MODE.deadPoliceCount or 0
MODE.swatDeployed = MODE.swatDeployed or false
MODE.spawnedPoliceCount = MODE.spawnedPoliceCount or 0
MODE.roundStartType = MODE.roundStartType or nil

function MODE:RoundThink()
	if not self.PoliceAllowed then return end

	if self.Type ~= "soe" and not self.PoliceSpawned and self.saved.PoliceTime < CurTime() then
		if not self.Types[self.Type] or not self.Types[self.Type].PoliceAllowed then return end
		
		local available = self:GetActivePlayers()
		local max = math.min(#available, 4)
	
		if max > 0 then
			local spawned = self:SpawnForce("police", max)
			self.spawnedPoliceCount = spawned
	
			if spawned > 0 then
				self.PoliceSpawned = true
				PrintMessage(HUD_PRINTTALK, "Police have arrived.")
				EmitSound("snd_jack_hmcd_policesiren.wav", vector_origin, 0, CHAN_AUTO, 1, 125, 0, 100)
			end
		end
	end
	

	if self.Type ~= "soe" and not self.swatDeployed and self.deadPoliceCount >= (self.spawnedPoliceCount or 4) and self.spawnedPoliceCount > 0 then
		if not self.Types[self.Type] or not self.Types[self.Type].PoliceAllowed then return end
		
		self.swatDeployed = true
		local currentType = self.Type 
		
		timer.Create("HMCDSpawnSWAT", 60, 1, function()
			if wn.ROUND_STATE ~= 1 or not MODE or MODE.Type ~= currentType then return end 
			
			if not MODE.Types[MODE.Type] or not MODE.Types[MODE.Type].PoliceAllowed then return end
			
			local available = MODE:GetActivePlayers()
			local count = math.min(#available, 5)
	
			if count > 0 then
				PrintMessage(HUD_PRINTTALK, "SWAT team incoming!")
				EmitSound("snd_jack_hmcd_heli2.mp3", vector_origin, 0, CHAN_AUTO, 1, 125, 0, 100)
				MODE:SpawnForce("swat", count)
			end
		end)
	end
	
	if self.Type == "soe" and not self.PoliceSpawned and self.saved.PoliceTime < CurTime() then
		local available = self:GetActivePlayers()
		local count = math.min(#available, 6)
	
		if count > 0 then
			local spawned = self:SpawnForce("nationalguard", count)
			if spawned > 0 then
				self.PoliceSpawned = true
				PrintMessage(HUD_PRINTTALK, self.Types[self.Type].PoliceText or "National Guard have arrived.")
				EmitSound(self.Types[self.Type].PoliceSound or "snd_jack_hmcd_heli2.mp3", vector_origin, 0, CHAN_AUTO, 1, 125, 0, 100)
			end
		end
	end
end

function MODE:SpawnForce(teamtype, count)
    local spawned = 0
    local basepos = nil

    for i, ply in RandomPairs(player.GetAll()) do
        if ply:Alive() or ply.isTraitor or ply:Team() == TEAM_SPECTATOR or ply.afkTime2 > 60 then continue end
        if spawned >= count then break end

        ply.isPolice = true
        ply.isTraitor = false
        ply.isGunner = false
        ply:Spawn()

        if not basepos then
            basepos = wn:GetRandomSpawn()            
			ply:SetPos(basepos)
		else
			wn.tpPlayer(basepos, ply, i)
		end

        if teamtype == "police" then
            self.Types[self.Type].PoliceEquipment(ply)
        elseif teamtype == "swat" then
            self:EquipSWAT(ply, spawned + 1)
        elseif teamtype == "nationalguard" then
            self:EquipNationalGuard(ply, spawned + 1)
        end

        spawned = spawned + 1
    end

    return spawned
end

function MODE:EquipSWAT(ply, index)
    ply:SetPlayerClass("swat")
    
    local classes = {
        [1] = function() return table.Random({"weapon_m4a1", "weapon_hk416"}) end, --;; Team Leader
        [2] = function() ply:Give("weapon_ram") return table.Random({"weapon_remington870", "weapon_m590a1"}) end, --;; Breacher
        [3] = function() return "weapon_mp5" end, --;; Pointman
        [4] = function() return "weapon_sr25" end, --;; Marksman
        [5] = function()
            ply:Give("weapon_medkit_sh")
            ply:Give("weapon_painkillers")
            ply:Give("weapon_adrenaline")
            ply:Give("weapon_needle")
            ply:Give("weapon_bigbandage_sh")
            ply:Give("weapon_bandage_sh")
            ply:Give("weapon_mannitol")
            return "weapon_m4a1"
        end
    }

    local mainWep = classes[index] and classes[index]() or "weapon_m4a1"
    local pistol = ply:Give("weapon_glock17")
	ply:GiveAmmo(pistol:GetMaxClip1() * 3, pistol:GetPrimaryAmmoType(), true)
    local gun = ply:Give(mainWep)
    ply:GiveAmmo(gun:GetMaxClip1() * 3, gun:GetPrimaryAmmoType(), true)

    ply:Give("weapon_melee")
    ply:Give("weapon_handcuffs")
    ply:Give("weapon_handcuffs_key")
    ply:Give("weapon_hg_flashbang_tpik")

	local gun = ply:Give("weapon_taser")
	ply:GiveAmmo(gun:GetMaxClip1() * 3, gun:GetPrimaryAmmoType(),true)

	wn.AddArmor(ply, {"helmet6", "vest8", table.Random({"mask1", "mask2", "nightvision1"})})

    local inv = ply:GetNetVar("Inventory") or {}
    inv["Weapons"] = inv["Weapons"] or {}
	inv["Weapons"]["hg_sling"] = true
    inv["Weapons"]["hg_flashlight"] = true
    ply:SetNetVar("Inventory", inv)
	ply:SetNetVar("flashlight", false)

    ply.organism.recoilmul = 0.6

    ply:SetNetVar("CurPluv", "pluvberet")
    local hands = ply:Give("weapon_hands_sh")
    ply:SetActiveWeapon(hands)

    wn.GiveRole(ply, "SWAT Operative", Color(30, 30, 100))
end

function MODE:EquipNationalGuard(ply, index)
    ply:SetPlayerClass("nationalguard")
    local gun

    if index == 1 then
        gun = ply:Give("weapon_m249")
    else
        gun = ply:Give("weapon_m4a1")
    end

    ply:GiveAmmo(gun:GetMaxClip1() * 3, gun:GetPrimaryAmmoType(), true)
	local pistol = ply:Give("weapon_m9beretta")
	ply:GiveAmmo(pistol:GetMaxClip1() * 3, pistol:GetPrimaryAmmoType(), true)
    ply:Give("weapon_melee")
    ply:Give("weapon_handcuffs")
    ply:Give("weapon_handcuffs_key")
    ply:Give("weapon_walkie_talkie")
    ply:Give("weapon_bandage_sh")
    ply:Give("weapon_medkit_sh")

	local gun = ply:Give("weapon_taser")
	ply:GiveAmmo(gun:GetMaxClip1() * 3,gun:GetPrimaryAmmoType(),true)

    wn.AddArmor(ply, {"vest4", "helmet1"})

	local inv = ply:GetNetVar("Inventory") or {}
	inv["Weapons"] = inv["Weapons"] or {}
	inv["Weapons"]["hg_flashlight"] = true
	inv["Weapons"]["hg_sling"] = true
	ply:SetNetVar("Inventory", inv)

	ply:SetNetVar("CurPluv", "pluvberet")
    local hands = ply:Give("weapon_hands_sh")
    ply:SetActiveWeapon(hands)
    wn.GiveRole(ply, "National Guardian", Color(60, 90, 0))
end

--\\
MODE.ChoosingPlayersList = MODE.ChoosingPlayersList or {}

local gaymaps = {
	["zs_shelter"] = true,
	["gm_sirenmine_v2"] = true,
}

function MODE.StartPlayersRoleSelection()
	MODE.RoleChooseRound = true
	MODE.StartRoundTime = MODE.StartRoundTime + MODE.RoleChooseRoundStartTime

	for _, ply in player.Iterator() do
		if(ply.isTraitor and ply.MainTraitor)then	--; REDO
			net.Start("WN_Homicide(StartPlayersRoleSelection)")
				net.WriteString("Traitor")
			net.Send(ply)

			MODE.ChoosingPlayersList[ply] = true
		end
	end
end

net.Receive("WN_Homicide(StartPlayersRoleSelection)", function(len, ply)
	if(MODE.ChoosingPlayersList[ply])then
		MODE.ChoosingPlayersList[ply] = nil

		if(table.IsEmpty(MODE.ChoosingPlayersList))then
			MODE.StartRoundTime = 0
		end
	end
end)
// ...


util.AddNetworkString("WN_Homicide_TraitorDeathState")
util.AddNetworkString("WN_Homicide_RequestTraitorStatuses")


function MODE:SendTraitorDeathState(traitor, is_alive)
    if not traitor.CurAppearance then return end
    local name = traitor.CurAppearance.Name
    

    local recipients = {}
    for _, ply in ipairs(player.GetAll()) do
        if ply.isTraitor and ply.MainTraitor then
            table.insert(recipients, ply)
        end
    end
    
    net.Start("WN_Homicide_TraitorDeathState")
    net.WriteString(name)
    net.WriteBool(is_alive)
    net.Send(recipients)
end


hook.Add("PlayerDeath", "HMCD_TraitorDeathTracking", function(ply, _)
    if ply.isTraitor then
        MODE:SendTraitorDeathState(ply, false)
    end
end)


hook.Add("PlayerSpawn", "HMCD_TraitorSpawnTracking", function(ply)
    if ply.isTraitor then
        MODE:SendTraitorDeathState(ply, true)
    end
end)

hook.Add("PlayerCanPickupWeapon", "HMCD_TraitorRadioPickup", function( ply, weapon )
    if ply.isTraitor and weapon == "weapon_walkie_talkie" then
        if ply:HasWeapon("weapon_walkie_talkie") then
            weapon:Remove()
			ply:SetActiveWeapon("weapon_walkie_talkie")
			ply:ChatPrint("You hide the additional walkie talkie.")
        end
    end
end)

net.Receive("WN_Homicide_RequestTraitorStatuses", function(len, ply)
    if not ply.isTraitor or not ply.MainTraitor then return end
    

    for _, other_ply in ipairs(player.GetAll()) do
        if other_ply.isTraitor and other_ply.CurAppearance then
            local is_alive = other_ply:Alive() and (not other_ply.organism or not other_ply.organism.incapacitated)
            
            net.Start("WN_Homicide_TraitorDeathState")
            net.WriteString(other_ply.CurAppearance.Name)
            net.WriteBool(is_alive)
            net.Send(ply)
        end
    end
end)
// ...

function MODE.ShouldStartRoleRound()
	return MODE.RoleChooseRoundTypes[MODE.Type] and GetGlobalBool("WN_RolesPlus_Enable", false)
end
--//

function MODE:ShouldRoundEnd()
	if(MODE.StartRoundTime and MODE.RoleChooseRound)then
		if(MODE.StartRoundTime > CurTime())then
			return false
		else
			MODE.StartRoundTime = nil

			net.Start("WN_Homicide(EndPlayersRoleSelection)")
			net.Broadcast()
			MODE.SpawnPlayers(true)
		end
	else
		local endround, winner = wn:CheckWinner(self:CheckAlivePlayers())

		if(endround)then
			MODE.ChoosingPlayersList = {}
		end

		return endround
	end
end

function MODE:RoundStart()
	local roles_choose = MODE.ShouldStartRoleRound()
	MODE.StartRoundTime = CurTime()
	MODE.RoleChooseRound = false
	

	self.roundStartType = self.Type
	

	self.deadPoliceCount = 0
	self.swatDeployed = false
	self.spawnedPoliceCount = 0
	

	timer.Remove("HMCDSpawnSWAT")

	if(roles_choose)then
		MODE.StartPlayersRoleSelection()
		PrintMessage(HUD_PRINTTALK, "Traitor is choosing roles for " .. MODE.RoleChooseRoundStartTime ..  " seconds")
	else
		MODE.ChoosingPlayersList = {}

		MODE.SpawnPlayers(false)
	end
end

function MODE:GiveEquipment()
end

function MODE:CanSpawn()
end

util.AddNetworkString("WN_Homicide_RoundEnd")

function MODE:EndRound()
	timer.Remove("HMCDSpawnSWAT")
	timer.Remove("SpawnAdditionalPolice")
    timer.Remove("SpawnAdditionalNationalGuard")
	

	self.deadPoliceCount = 0
	self.swatDeployed = false
	self.spawnedPoliceCount = 0
	self.roundStartType = nil

	local traitors, gunners = {}, {}
	local players_alive = 0
	local endround, winner = wn:CheckWinner(self:CheckAlivePlayers())

	-- for _, ply in player.Iterator() do	--; Extreme optimization
		-- ply.SubRole = nil
	-- end

	for i, ply in ipairs(player.GetAll()) do
		if ply.isTraitor and ply:Team() ~= TEAM_SPECTATOR then
			traitors[#traitors + 1] = ply
		end
		
		if ply.isGunner and ply:Team() ~= TEAM_SPECTATOR then
			gunners[#gunners + 1] = ply
		end
		
		if(ply:Alive() and ply.organism and !ply.organism.incapacitated)then
			players_alive = players_alive + 1
		end

		ply.isPolice = false
		ply.isTraitor = false
		ply.isGunner = false
		ply.MainTraitor = false
		ply.SubRole = nil
		ply.Profession = nil
	end
	
	if(not winner)then
		net.Start("WN_Homicide_RoundEnd")
			net.WriteUInt(#traitors, MODE.TraitorExpectedAmtBits)
			
			for _, traitor in ipairs(traitors) do
				net.WriteEntity(traitor)
			end
			
			net.WriteUInt(#gunners, MODE.TraitorExpectedAmtBits)
			
			for _, gunner in ipairs(gunners) do
				net.WriteEntity(gunner)
			end
		net.Broadcast()
		
		return
	end

	if self.Type then
		if(MODE.RoleChooseRound)then
			if(winner ~= 1)then
				PrintMessage(HUD_PRINTTALK, "All traitors were stopped.")
				
				for _, traitor in ipairs(traitors) do
					net.Start("WN_Homicide_AnnounceTraitorLose")
						net.WriteEntity(traitor)
						net.WriteBool(traitor:Alive())
					net.Broadcast()
					
					hook.Run("WN_TraitorWinOrNot", traitor, winner)
				end

				for _, traitor in ipairs(traitors) do
					traitor:GiveSkill( -math.Rand(0.05,0.15) )
				end
			else
				for _, traitor in ipairs(traitors) do
					traitor:GiveExp( math.random(25,40) )
					traitor:GiveSkill( math.Rand(0.1,0.3) )
					traitor:SetPData("zb_hmcd_t_wins",traitor:GetPData("zb_hmcd_t_wins",0) + 1)
				end
				PrintMessage(HUD_PRINTTALK, "Every innocent was murdered.")
			end
			
			timer.Simple(2, function()
				if(players_alive == 0)then
					PrintMessage(HUD_PRINTTALK, "No one survived.")
				else
					if(players_alive == 1)then
						PrintMessage(HUD_PRINTTALK, "Only 1 survivor left in the city.")
					else
						PrintMessage(HUD_PRINTTALK, players_alive .. " survivors left in the city.")
					end
				end
			end)
		else
			if traitor and IsValid(traitor) then
				--local CheckAlive = #self:CheckAlivePlayers()[1]
				PrintMessage(HUD_PRINTTALK, self.Types[self.Type].Messages[winner]..(winner == 0 and (traitor:Alive() and " neutralized." or " killed.") or ""))
				
				timer.Simple(2, function()
					PrintMessage(HUD_PRINTTALK, self.Types[self.Type].Message..traitor:Name())
				end)

				if winner == 1 then
					traitor:GiveExp( math.Rand(30,50) )
					traitor:GiveSkill( math.Rand(0.15,0.3) )
					traitor:SetPData("zb_hmcd_t_wins",traitor:GetPData("zb_hmcd_t_wins",0) + 1)
				else
					traitor:GiveSkill( -math.Rand(0.05,0.1) )
				end
				
				hook.Run("WN_TraitorWinOrNot", traitor, winner)
			else
				PrintMessage(HUD_PRINTTALK, self.Types[self.Type].Messages[winner]..(winner == 0 and (" killed.") or ""))
			end
		end
	end

	timer.Simple(2,function()
		net.Start("WN_Homicide_RoundEnd")
			net.WriteUInt(#traitors, MODE.TraitorExpectedAmtBits)
			
			for _, traitor in ipairs(traitors) do
				net.WriteEntity(traitor)
			end
			
			net.WriteUInt(#gunners, MODE.TraitorExpectedAmtBits)
			
			for _, gunner in ipairs(gunners) do
				net.WriteEntity(gunner)
			end
		net.Broadcast()
	end)
end

-- hook.Add("Player Death", "HMCD_PlayerDeath", function(_, ply)
hook.Add("Player Death", "HMCD_PlayerDeath", function(ply, _)
	local most_harm,biggest_attacker = 0,nil
	local last_attacker = nil

	if ply.isPolice then
		MODE.deadPoliceCount = (MODE.deadPoliceCount or 0) + 1
	end

	timer.Simple(.1,function()
		for attacker,attacker_harm in pairs(wn.HarmDone[ply] or {}) do
			if not IsValid(attacker) then continue end
			if most_harm < attacker_harm then
				most_harm = attacker_harm
				biggest_attacker = attacker:Name()
				last_attacker = attacker
			end
		end
		

		if ply.isTraitor then
			--local appearance = ply.CurAppearance
			--
			--if(!appearance)then
			--	-- appearance = wn.GetRandomAppearance(ply)
			--	PrintMessage(HUD_PRINTTALK, "Some traitor died.")
			--else
			--	local character_name = appearance.Name or "error"
			--	
			--	PrintMessage(HUD_PRINTTALK, "Traitor " .. character_name .. " died.")
			--end
		
			if biggest_attacker then
				if biggest_attacker == ply:Name() then
					--timer.Simple(1,function()
					--	if not IsValid(ply) then return end
					--	local msg = (wn.ThatPlyIsFemale(ply) and "Sh" or "H").."e suicided."
					--	PrintMessage(3,msg)
					--end)
				else
					last_attacker:GiveExp( math.random(10,15) )
					last_attacker:GiveSkill( math.Rand(0.025,0.075) )
					last_attacker:SetPData("zb_hmcd_ino_t_kills", last_attacker:GetPData("zb_hmcd_ino_t_kills",0) + 1)
					--timer.Simple(1,function()
					--	if not IsValid(ply) then return end
					--	local msg = (wn.ThatPlyIsFemale(ply) and "Sh" or "H").."e was killed by "..biggest_attacker.."."
					--	PrintMessage(3,msg)
					--end)
				end
			else
				--timer.Simple(1,function()
				--	if not IsValid(ply) then return end
				--	local msg = (wn.ThatPlyIsFemale(ply) and "Sh" or "H").."e died in mysterious circumstances."
				--	PrintMessage(3,msg)
				--end)
			end
		else
			if not biggest_attacker or not IsValid(ply) then return end
			
			if biggest_attacker == ply:Name() then
				ply:ChatPrint("You suicided.")
				
				if not biggest_attacker then
					ply:ChatPrint("You have died.")
				else
					ply:ChatPrint("You were killed by "..biggest_attacker..".")
					
					-- if biggest_attacker == ply:Name() then
						-- ply:ChatPrint("You suicided.")
					-- else
						-- ply:ChatPrint("You were killed by "..biggest_attacker..".")
					-- end
				end
			end
		end
	end)
end)

function MODE:CanLaunch()
	return true
end

util.AddNetworkString("WN_Homicide_RoundEnd")

MODE.NextRoundMainTraitors = MODE.NextRoundMainTraitors or {}

concommand.Add("wn_homicide_request_main_traitor", function(ply, cmd, args)
    if not IsValid(ply) then return end
    

    if wn.ROUND_STATE == 1 then
        ply:ChatPrint("when round end")
        return
    end
    

    MODE.NextRoundMainTraitors[ply:SteamID()] = true
    ply:ChatPrint("true")
end)

hook.Add("RoundStateChange", "ResetNextRoundMainTraitors", function(old, new)
    if new == 2 then 
        MODE.NextRoundMainTraitors = {}
    end
end)

util.AddNetworkString("WN_Homicide_UpdateTraitorAssistants")

function MODE.SpawnPlayers(spawn_with_subroles)
    local gunner_found = false

    for i, ply in RandomPairs(player.GetAll()) do
        if ply.isTraitor or ply.isGunner or ply:Team() == TEAM_SPECTATOR then continue end
        if math.random(100) > (ply.Karma or 100) then continue end

        ply.isGunner = true
        gunner_found = true
        break
    end

    if(not gunner_found)then
        for i,ply in RandomPairs(player.GetAll()) do
            if ply.isTraitor or ply.isGunner or ply:Team() == TEAM_SPECTATOR then continue end

            ply.isGunner = true
            break
        end
    end

    local player_count = 0
    for i, ply in ipairs(player.GetAll()) do
        if(ply:Team() != TEAM_SPECTATOR)then
            player_count = player_count + 1
        end
    end

    --= Профессии
    local professions = {}
    if(spawn_with_subroles and MODE.RoleChooseRoundTypes[MODE.Type])then
        local professions_possible_pre = MODE.RoleChooseRoundTypes[MODE.Type].Professions

        if(professions_possible_pre)then
            local professions_possible = {}
            local professions_count_to_satisfy = math.ceil(player_count / 2)

            for profession, profession_info in pairs(professions_possible_pre) do
                professions_possible[#professions_possible + 1] = {profession_info.Chance, profession}
            end

            for _, ply in RandomPairs(player.GetAll()) do
                if(ply:Team() != TEAM_SPECTATOR)then
                    if((math.random(100) < (ply.Karma or 100)) and (math.random(1, 3) == 1 or (!ply.isTraitor and !ply.isGunner)))then
                        local profession_key, profession = wn.WeightedRandomSelect(professions_possible)
                        professions_possible[profession_key][1] = professions_possible[profession_key][1] / 2
                        ply.Profession = profession
                        professions_count_to_satisfy = professions_count_to_satisfy - 1
                        
                        if(professions_count_to_satisfy == 0)then
                            break
                        end
                    end
                end
            end
            

            if(professions_count_to_satisfy > 0)then
                for _, ply in RandomPairs(player.GetAll()) do
                    if(ply:Team() != TEAM_SPECTATOR and !ply.Profession)then
                        local profession_key, profession = wn.WeightedRandomSelect(professions_possible)
                        professions_possible[profession_key][1] = professions_possible[profession_key][1] / 2
                        ply.Profession = profession
                        professions_count_to_satisfy = professions_count_to_satisfy - 1
                        
                        if(professions_count_to_satisfy == 0)then
                            break
                        end
                    end
                end
            end
        end
    end


    local all_players = player.GetAll()
    for idx, current_ply in pairs(all_players) do
        if(current_ply:Team() != TEAM_SPECTATOR)then
            current_ply.SubRole = nil

            ApplyAppearance(current_ply)
            current_ply:Spawn()
            current_ply:GetRandomSpawn()

            if(!current_ply:Alive())then
                continue
            end

            current_ply:SetSuppressPickupNotices(true)
            current_ply.noSound = true

            if(MODE.Type == "supermario")then
                MODE.Types.supermario.CustomJump(current_ply)
            end

            local sub_role = nil
            if(spawn_with_subroles and MODE.RoleChooseRoundTypes[MODE.Type])then
                if(current_ply.isTraitor)then
                    local sub_role_id = current_ply:GetInfo(MODE.ConVarName_SubRole_Traitor) or "traitor_default"
                    sub_role = sub_role_id
                end

                if(current_ply.isGunner)then
                    MODE.Types[MODE.Type].GunManLoot(current_ply)
                end

                if(sub_role)then
                    if(current_ply.isGunner)then

                    elseif(current_ply.isTraitor)then
                        local role_info = MODE.SubRoles[sub_role]
                        if(!role_info or !MODE.RoleChooseRoundTypes[MODE.Type].Traitor[sub_role])then
                            sub_role = MODE.RoleChooseRoundTypes[MODE.Type].TraitorDefaultRole or "traitor_default"
                            role_info = MODE.SubRoles[sub_role]
                        end

                        if(current_ply.MainTraitor)then
                            local spawn_func = role_info.SpawnFunction
                            current_ply.SubRole = sub_role
                            spawn_func(current_ply)
                        end
                    end
                end
            else
                if(current_ply.isTraitor)then
                    MODE.Types[MODE.Type].TraitorLoot(current_ply)
                end

                if(current_ply.isGunner)then
                    MODE.Types[MODE.Type].GunManLoot(current_ply)
                end
            end
            
            if(MODE.Type == "soe")then
                if(current_ply.isTraitor)then
                    local walkie_talkie = current_ply:Give("weapon_walkie_talkie")
                    MODE.TraitorFrequency = MODE.TraitorFrequency or math.random(1, #walkie_talkie.Frequencies)
                    walkie_talkie.Frequency = MODE.TraitorFrequency
                    current_ply:ChatPrint("Walkie-Talkie Frequency = " .. walkie_talkie.Frequencies[MODE.TraitorFrequency])
                end
            end

            if(gaymaps[game.GetMap()])then
                local inv = current_ply:GetNetVar("Inventory") or {}
                inv["Weapons"] = inv["Weapons"] or {}
                inv["Weapons"]["hg_flashlight"] = true
                current_ply:SetNetVar("Inventory", inv)
            end

            local hands = current_ply:Give("weapon_hands_sh")
            current_ply:SetActiveWeapon(hands)
            current_ply:SetNetVar("flashlight", false)

            local this_player = current_ply
            
            timer.Simple(0.1, function() 
                if IsValid(this_player) then
                    this_player.noSound = false
                    this_player:SetSuppressPickupNotices(false)
                end
            end)

            timer.Simple(0.2 * idx, function()
                if not IsValid(this_player) then return end

                local traitor_amt = 0
                local traitor_assistants = {}
                
                if (this_player.isTraitor) then
                    for _, other_ply in ipairs(player.GetAll()) do
                        if (other_ply.isTraitor) then
                            traitor_amt = traitor_amt + 1
                            

                            if this_player.MainTraitor and other_ply.CurAppearance then
                                local appearance = other_ply.CurAppearance
                                local color = appearance.Color or color_white
                                local name = appearance.Name or "error"
                                local steamID = other_ply:SteamID() or ""
                                
                                if not IsColor(color) then
                                    color = Color(color.r, color.g, color.b)
                                end
                                
                                table.insert(traitor_assistants, {color, name, steamID})
                            end
                        end
                    end
                end
                

                net.Start("WN_Homicide_Start")
                    net.WriteBool(this_player.isTraitor)
                    net.WriteBool(this_player.isGunner)
                    net.WriteString(MODE.Type)
                    net.WriteBool(true)
                    net.WriteString(this_player.SubRole or "")
                    net.WriteBool(this_player.MainTraitor == true)
                    
                    if (this_player.isTraitor) then
                        net.WriteString(MODE.TraitorWord)
                        net.WriteString(MODE.TraitorWordSecond)
                        net.WriteUInt(traitor_amt, MODE.TraitorExpectedAmtBits)
                    else
                        net.WriteString("")
                        net.WriteString("")
                        net.WriteUInt(0, MODE.TraitorExpectedAmtBits)
                    end
                    
                    if (this_player.MainTraitor) then

                        for _, traitor_info in ipairs(traitor_assistants) do
                            net.WriteColor(traitor_info[1], false)
                            net.WriteString(traitor_info[2])
                        end

                        timer.Simple(0.5, function()
                            if IsValid(this_player) and this_player.isTraitor and this_player.MainTraitor then
                                net.Start("WN_Homicide_UpdateTraitorAssistants")
                                    net.WriteUInt(#traitor_assistants, 8)
                                    
                                    for _, info in ipairs(traitor_assistants) do
                                        net.WriteColor(info[1])
                                        net.WriteString(info[2])
                                        net.WriteString(info[3])
                                    end
                                net.Send(this_player)
                            end
                        end)
                    end
                    
                    net.WriteString(this_player.Profession or "")
                net.Send(this_player)
                
                local role = MODE.Roles[MODE.Type][(this_player.isTraitor and "traitor") or (this_player.isGunner and "gunner") or "innocent"]
                if role then
                    wn.GiveRole(this_player, role.name, role.color)
                end
            end)
        end
    end
end

hook.Add("PlayerSpawn", "HMCD_UpdateTraitorsList", function(ply)
	if not ply.isTraitor then return end
	
	timer.Simple(0.5, function()
		for _, main_traitor in ipairs(player.GetAll()) do
			if IsValid(main_traitor) and main_traitor.isTraitor and main_traitor.MainTraitor then
				local traitor_assistants = {}
				
				for _, other_ply in ipairs(player.GetAll()) do
					if other_ply.isTraitor then
						local appearance = other_ply.CurAppearance
						if appearance then
							local color = appearance.Color or color_white
							local name = appearance.Name or "error"
							local steamID = other_ply:SteamID() or ""
							
							if not IsColor(color) then
								color = Color(color.r, color.g, color.b)
							end
							
							table.insert(traitor_assistants, {color, name, steamID})
						end
					end
				end
				
				net.Start("WN_Homicide_UpdateTraitorAssistants")
				net.WriteUInt(#traitor_assistants, 8)
				
				for _, info in ipairs(traitor_assistants) do
					net.WriteColor(info[1])
					net.WriteString(info[2])
					net.WriteString(info[3])
				end
				
				net.Send(main_traitor)
			end
		end
	end)
end)

hook.Add("PlayerDeath", "HMCD_UpdateTraitorsList", function(ply)
	if not ply.isTraitor then return end
	
	timer.Simple(0.1, function()
		if IsValid(ply) and ply.CurAppearance then
			MODE:SendTraitorDeathState(ply, false)
		end
		
		timer.Simple(0.4, function()
			for _, main_traitor in ipairs(player.GetAll()) do
				if IsValid(main_traitor) and main_traitor.isTraitor and main_traitor.MainTraitor then
					local traitor_assistants = {}
					
					for _, other_ply in ipairs(player.GetAll()) do
						if other_ply.isTraitor then
							local appearance = other_ply.CurAppearance
							if appearance then
								local color = appearance.Color or color_white
								local name = appearance.Name or "error"
								local steamID = other_ply:SteamID() or ""
								
								if not IsColor(color) then
									color = Color(color.r, color.g, color.b)
								end
								
								table.insert(traitor_assistants, {color, name, steamID})
							end
						end
					end
					
					net.Start("WN_Homicide_UpdateTraitorAssistants")
					net.WriteUInt(#traitor_assistants, 8)
					
					for _, info in ipairs(traitor_assistants) do
						net.WriteColor(info[1])
						net.WriteString(info[2])
						net.WriteString(info[3])
					end
					
					net.Send(main_traitor)
				end
			end
		end)
	end)
end)
