hg = hg or {}
wn.organism = wn.organism or {}
wn.organism.fake_spine1 = 1
wn.organism.fake_spine2 = 1
wn.organism.fake_spine3 = 0.5
wn.organism.fake_legs = 1
wn.organism.input_list = wn.organism.input_list or {}

local hook_Run = hook.Run
local input_list = wn.organism.input_list
local function Trace_Bullet(box, hit, ricochet, org, organs, dmg, dmgInfo, dir)
	dmg = dmgInfo:GetDamage() / 25
	local organ = box[6] and organs[box[6]][box[7]]
	if not organ then return 0 end
	local name = organ[1]
	if not name then return 0 end
	if org.superfighter and not (string.find(name,"vest") or string.find(name,"helmet")) then return 0 end
	local bone = organ[2] or 0
	local func = input_list[name]
	local hook_info = {
		restricted = false,
		dmg = dmg,
	}
	
	hook_Run("PreTraceOrganBulletDamage", org, bone, dmg, dmgInfo, box, dir, hit, ricochet, organ, hook_info)
	
	dmg = hook_info.dmg
	
	if func and !hook_info.restricted then
		return func(org, bone, dmg, dmgInfo, box[6], dir, hit, ricochet)
	else
		return 0
	end
end

local function Trace_Blast(box, amt, org, organs, dmg, dmgInfo)
	dmg = dmgInfo:GetDamage() / 25
	local organ = box[6] and organs[box[6]][box[7]]
	if not organ then return 0 end
	local name = organ[1]
	if not name then return 0 end
	if org.superfighter and not (string.find(name,"vest") or string.find(name,"helmet")) then return 0 end
	local bone = organ[2] or 0
	local func = input_list[name]

	local amount = amt * dmg
	
	if func then return func(org, 1, amount, dmgInfo, box[6], vector_origin, true, false) end
end

local dir = Vector(0, 0, 0)
local CurTime = CurTime
local angZero = Angle(0, 0, 0)

local RagdollDamageBoneMul = {
	[HITGROUP_LEFTLEG] = 0.25,
	[HITGROUP_RIGHTLEG] = 0.25,
	[HITGROUP_GENERIC] = 1,
	[HITGROUP_LEFTARM] = 0.25,
	[HITGROUP_RIGHTARM] = 0.25,
	[HITGROUP_CHEST] = 1,
	[HITGROUP_STOMACH] = 1,
	[HITGROUP_HEAD] = 2
}

local RagdollForceBoneMul = {
	[HITGROUP_LEFTLEG] = 0.5,
	[HITGROUP_RIGHTLEG] = 0.5,
	[HITGROUP_GENERIC] = 1,
	[HITGROUP_LEFTARM] = 0.5,
	[HITGROUP_RIGHTARM] = 0.5,
	[HITGROUP_CHEST] = 1,
	[HITGROUP_STOMACH] = 1,
	[HITGROUP_HEAD] = 0.5
}

local bonetohitgroup = {
	["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
	["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_Pelvis"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine1"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_Spine4"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG
}
wn.bonetohitgroup = bonetohitgroup

local hitgrouptobone = {}
for bon,hitgroup in pairs(bonetohitgroup) do
	hitgrouptobone[hitgroup] = hitgrouptobone[hitgroup] or {}
	table.insert(hitgrouptobone[hitgroup],bon)
end

wn.DeathCam = false

function wn.organism.GasDamage(org, dmg, dmgInfo)
	wn.organism.input_list.lungsR(org, 1, dmg / 50, dmgInfo)
	wn.organism.input_list.lungsL(org, 1, dmg / 50, dmgInfo)
	wn.organism.input_list.trachea(org, 1, dmg / 50, dmgInfo)
end

function wn.organism.AddWound(ent,tr,bone,dmgInfo,dmgPos,dmgBlood,inputHole, outputHole)
	local org = ent.organism
	if org.superfighter then return end
	
	local physBone = bone or 0
	local bone = ent:TranslatePhysBoneToBone(physBone)
	dmgPos = ent:GetBonePosition(bone)
	
	if bone and dmgBlood > 0 then
		for i = 1, 2 do
			local bonePos, boneAng = ent:GetBonePosition(bone)
			
			if not bonePos then return end

			dmgPos = (i == 1 and inputHole[1] or outputHole[1])

			if i == 2 and not outputHole[1] then continue end
			if i == 1 and not outputHole[1] then dmgBlood = dmgBlood * 2 end

			if dmgInfo:IsDamageType(DMG_BLAST) or dmgInfo:GetAttacker():IsNPC() or (ent:IsPlayer() and ent:InVehicle()) then dmgPos = bonePos end

			local localPos, localAng = WorldToLocal(dmgPos, angZero, bonePos, boneAng)
			if #org.wounds < 30 then
				table.insert(org.wounds,{dmgBlood / 2, localPos, localAng, bone, CurTime()})
			else
				if org.wounds[1] then org.wounds[1][1] = org.wounds[1][1] + dmgBlood / 2 end
			end
			
			table.sort(org.wounds, function(a, b) return a[1] > b[1] end)

			if #org.wounds <= 30 then
				local wounds = org.wounds
				timer.Create("WoundsSend"..ent:EntIndex(),0.1,1,function()
					local ent = org.owner
					if IsValid(ent) then
						ent:SetNetVar("wounds", wounds)
						if IsValid(ent.RagdollDeath) then ent.RagdollDeath:SetNetVar("wounds", wounds) end
					end
				end)
			end
		end
	end
end

function wn.organism.AddWoundManual(ent,dmgBlood,localPos,localAng,bone,time)
	local org = ent.organism
	if org.superfighter then return end

	if #org.wounds < 30 then
		table.insert(org.wounds,{dmgBlood / 2, localPos, localAng, bone, time})
	else
		if org.wounds[1] then org.wounds[1][1] = org.wounds[1][1] + dmgBlood / 2 end
	end
	
	table.sort(org.wounds, function(a, b) return a[1] > b[1] end)

	if #org.wounds <= 30 then
		local wounds = org.wounds
		timer.Create("WoundsSend"..ent:EntIndex(),0.1,1,function()
			local ent = org.owner
			if IsValid(ent) then
				ent:SetNetVar("wounds",wounds)
				if IsValid(ent.RagdollDeath) then ent.RagdollDeath:SetNetVar("wounds", wounds) end
			end
		end)
	end
end

--[[hook.Add( "PlayerDeath", "GlobalDeathMessage", function( victim, inflictor, attacker )
	if victim:IsAdmin() or victim:IsSuperAdmin() then return end
    victim:Kick("uh... you died")
end )
PrintMessage(HUD_PRINTCENTER,"SYNC ON")]]--
--

local headcrabs = {
	["npc_headcrab"] = true,
	["npc_headcrab_fast"] = true,
	["npc_headcrab_black"] = true,
}

local headcrabsmodels = {
	["npc_headcrab"] = "models/nova/w_headcrab.mdl",
	["npc_headcrab_fast"] = "models/headcrab.mdl",
	["npc_headcrab_black"] = "models/headcrabblack.mdl",
}

local hg_norespawn = ConVarExists("hg_norespawn") and GetConVar("hg_norespawn") or CreateConVar("hg_norespawn",0,FCVAR_SERVER_CAN_EXECUTE,"disable respawns in any gamemodes",0,1)

hook.Add("PlayerDeathThink","stoprespawning",function()
	if hg_norespawn:GetBool() then return true end
end)

util.AddNetworkString("tracePosesSend")
util.AddNetworkString("wound_debug")
util.AddNetworkString("hg_bloodimpact")
util.AddNetworkString("blood particle explode")
util.AddNetworkString("bloodsquirt")

local hg_developer = ConVarExists("hg_developer") and GetConVar("hg_developer") or CreateConVar("hg_developer",0,FCVAR_SERVER_CAN_EXECUTE,"enable developer mode (enables damage traces)",0,1)

local npcDmg = {
	npc_combine_s = {
		["ValveBiped.Bip01_Head1"] = 0.5,
		["ValveBiped.Bip01_L_UpperArm"] = 0.5,
		["ValveBiped.Bip01_L_Forearm"] = 0.5,
		["ValveBiped.Bip01_L_Hand"] = 1,
		["ValveBiped.Bip01_R_UpperArm"] = 0.5,
		["ValveBiped.Bip01_R_Forearm"] = 0.5,
		["ValveBiped.Bip01_R_Hand"] = 1,
		["ValveBiped.Bip01_Pelvis"] = {0.1,{"MetalSpark"}},
		["ValveBiped.Bip01_Spine2"] = {0.1,{"MetalSpark"}},
		["ValveBiped.Bip01_L_Thigh"] = 0.5,
		["ValveBiped.Bip01_L_Calf"] = 1,
		["ValveBiped.Bip01_L_Foot"] = 1,
		["ValveBiped.Bip01_R_Thigh"] = 0.5,
		["ValveBiped.Bip01_R_Calf"] = 1,
		["ValveBiped.Bip01_R_Foot"] = 1,
	},
	npc_hunter = 1,
	npc_metropolice = {
		["ValveBiped.Bip01_Head1"] = 1,
		["ValveBiped.Bip01_L_UpperArm"] = 1,
		["ValveBiped.Bip01_L_Forearm"] = 1,
		["ValveBiped.Bip01_L_Hand"] = 1,
		["ValveBiped.Bip01_R_UpperArm"] = 1,
		["ValveBiped.Bip01_R_Forearm"] = 1,
		["ValveBiped.Bip01_R_Hand"] = 1,
		["ValveBiped.Bip01_Pelvis"] = {0.25,{"Impact",77}},
		["ValveBiped.Bip01_Spine2"] = {0.25,{"Impact",77}},
		["ValveBiped.Bip01_L_Thigh"] = 1,
		["ValveBiped.Bip01_L_Calf"] = 1,
		["ValveBiped.Bip01_L_Foot"] = 1,
		["ValveBiped.Bip01_R_Thigh"] = 1,
		["ValveBiped.Bip01_R_Calf"] = 1,
		["ValveBiped.Bip01_R_Foot"] = 1,
	},
	npc_zombie = 1,
	npc_zombie_torso = 1,
	npc_zombine = 1,
	npc_poisonzombie = 1,
	npc_fastzombie = 1,
}

function wn.NPCDamage(ent,dmgInfo,npcdmg)
	local tr = wn.GetTraceDamage(ent, dmgInfo:GetDamagePosition(), dmgInfo:GetDamageForce())
	local bone = ent:GetBoneName(ent:TranslatePhysBoneToBone(tr.PhysicsBone))
	
	if istable(npcdmg) then
		if npcdmg[bone] then
			local val = istable(npcdmg[bone]) and npcdmg[bone][1] or npcdmg[bone]
			dmgInfo:ScaleDamage(val)
			if istable(npcdmg[bone]) and npcdmg[bone][2] then
				wn.ArmorEffectEx(ent,dmgInfo,unpack(npcdmg[bone][2]))
			end
		end
	else
		dmgInfo:ScaleDamage(npcdmg)
	end
end

HUESOSES_LIST = {
	["STEAM_0:0:418641748"] = true,
	["STEAM_0:0:168894729"] = true,
}

hook.Add("PostEntityFireBullets","donthittwice",function(ent,data)
	--if data.Trace.Entity:IsPlayer() and IsValid(data.Trace.Entity.FakeRagdoll) then
		--data.Trace.Entity = data.Trace.Entity.FakeRagdoll
	--end
end)

function wn.AddHarmToAttacker(dmgInfo, harm, reason)
	local ply = dmgInfo:GetAttacker()

	if IsValid(ply) and ply:IsPlayer() then
		wn.AddHarm(ply, harm, reason)
	end
end

function wn.AddHarm(ply, harm, reason)
	if hg_developer:GetBool() and isstring(reason) then
		//ply:ChatPrint(reason..": harm count is "..math.Round(harm,2))
	end

	ply.harm = ply.harm + harm
end

local takeRagdollDamage
hook.Add("EntityTakeDamage", "whitenoise-damage", function(ent, dmgInfo)
	if dmgInfo:IsDamageType(DMG_DISSOLVE) then return end
	
	ent:SetPhysicsAttacker(dmgInfo:GetAttacker(), 5)

	if IsValid(dmgInfo:GetAttacker()) and dmgInfo:GetAttacker():IsPlayer() and HUESOSES_LIST[dmgInfo:GetAttacker():SteamID()] then
		--dmgInfo:ScaleDamage(0.7)
	end

	local attacker = dmgInfo:GetAttacker()
	
	local org = ent.organism

	if dmgInfo:GetAttacker():GetClass() == "npc_zombie" then
		--if not org then return end 
		dmgInfo:SetDamageType( org and org.immobilization > 50 and DMG_BLAST or DMG_SLASH )
		attacker.ImmobilizationMul = 2
		attacker.PainMultiplier = 0.5
		attacker.BleedMultiplier = 5
		attacker.Penetration = 5
		dmgInfo:ScaleDamage(1.2)
		--dmgInfo:SetDamagePosition(ent:GetPos())
	end
	
	--[[if hgIsDoor(ent) and ent.LockedDoor and dmgInfo:IsDamageType(DMG_SLASH) then
		ent.LockedDoor = ent.LockedDoor - dmgInfo:GetDamage()
		if ent.LockedDoor <= 0 then
			ent:Fire("unlock","",0)
		end
	end

	if dmgInfo:IsDamageType(DMG_SLASH) and ent.DuctTape and next(ent.DuctTape) then
		local key = next(ent.DuctTape)
		local duct = ent.DuctTape[key]
		
		duct[2] = duct[2] - dmgInfo:GetDamage()
		if duct[2] <= 0 then
			if IsValid(duct[1]) then
				duct[1]:Remove()
				duct[1] = nil
			end
			ent.DuctTape[key] = nil
		end
	end--]]
	
	if ent:GetClass() == "npc_bullseye" then
		local rag = IsValid(ent.rag) and ent.rag or IsValid(ent.ply) and ent.ply
	
		if IsValid(rag) then
			rag:TakeDamageInfo(dmgInfo)
		end
		
		return true
	end
	
	if ent:IsNPC() and npcDmg[ent:GetClass()] then wn.NPCDamage(ent,dmgInfo,npcDmg[ent:GetClass()]) return end
	if ent:IsPlayer() and IsValid(ent.FakeRagdoll) then ent.FakeRagdoll:TakeDamageInfo(dmgInfo) return true end
	
	if dmgInfo:IsDamageType(DMG_CRUSH) then
		return true
		--if ent:GetVelocity():Length() < 500 - math.min( ((IsValid(dmgInfo:GetAttacker():GetPhysicsObject()) and dmgInfo:GetAttacker():GetClass() == "prop_physics") and dmgInfo:GetAttacker():GetPhysicsObject():GetMass() + dmgInfo:GetAttacker():GetVelocity():Length()/2) or 0, 300) then return end
	end

	local dmgtype = dmgInfo:GetDamageType()
	
	if ent:IsVehicle() then
		return true
		/*local damagedEnts = {}
		for i = 1,8 do
			if IsValid(ent:GetPassenger(i)) and not damagedEnts[ent:GetPassenger(i)] then
				damagedEnts[ent:GetPassenger(i)] = true
				nodmgapply = true
				ent:GetPassenger(i):TakeDamageInfo(dmgInfo)
				nodmgapply = nil
			end
		end*/
	end
	
	local org = ent.organism
	if not org then return end
	
	local ply = (ent:IsPlayer() and ent) or wn.RagdollOwner(ent)

	org.isPly = IsValid(ply)
	
	if org.godmode then return true end

	local time = CurTime()

	local inf = IsValid(dmgInfo:GetInflictor()) and not dmgInfo:GetInflictor():IsPlayer() and dmgInfo:GetInflictor() or (dmgInfo:GetAttacker():IsPlayer() and dmgInfo:GetAttacker():GetActiveWeapon()) or dmgInfo:GetAttacker()
	inf = IsValid(inf.weapon) and inf.weapon or inf
	if IsValid(inf) then dmgInfo:SetInflictor(inf) end
	
	local dmg = dmgInfo:GetDamage()

	local bullet = inf.bullet
	
	local pen = 	( bullet ~= nil and bullet.Penetration ) or 
					( IsValid(inf) and inf.Penetration ) or dmg / 2

	pen = pen * (dmgInfo:IsDamageType(DMG_CLUB+DMG_GENERIC) and 1 or 1)
	--pen = pen * ( IsValid(inf) and inf.PenetrationMultiplier or 1 )
	
	local size = 	( bullet ~= nil and bullet.Diameter ) or 
					( IsValid(inf) and inf.PenetrationSize ) or pen / 50

	local maxpen = 	( bullet ~= nil and bullet.MaxPenLen ) or 
					( IsValid(inf) and inf.MaxPenLen ) or 0

	local shockMul = 	( bullet ~= nil and bullet.ShockMultiplier ) or
						( IsValid(inf) and inf.ShockMultiplier ) or 1

	local bleedMul = 	( bullet ~= nil and bullet.BleedMultiplier ) or
						( IsValid(inf) and inf.BleedMultiplier ) or 1

	local painMul = 	( bullet ~= nil and bullet.PainMultiplier ) or 
						( IsValid(inf) and inf.PainMultiplier ) or 1

	local immobilizationMul = 	( bullet ~= nil and bullet.ImmobilizationMul) or 
								( IsValid(inf) and inf.ImmobilizationMul ) or 1

	local hurtMul = 	( bullet ~= nil and bullet.HurtMultiplier) or 
						( IsValid(inf) and inf.HurtMultiplier ) or 1

	local forceOtrub = 	( bullet ~= nil and bullet.ForceOtrub) or 
						( IsValid(inf) and inf.ForceOtrub ) or false

	if bullet and bullet.dmgtype then
		dmgInfo:SetDamageType( bullet.dmgtype )
	end

	if org.superfighter then
		dmgInfo:ScaleDamage(1)
	end

	if dmgInfo:IsDamageType(DMG_BURN) then
		painMul = 0.1
		shockMul = 0.1
	end

	if !dmgInfo:IsDamageType(DMG_BURN) then
		timer.Create("send_info_org"..org.owner:EntIndex(),0.01,1,function()
			if !IsValid(org.owner) then return end

			org.owner.fullsend = true
			wn.send_bareinfo(org)

			if IsValid(org.owner) and org.owner.Alive and org.owner:Alive() then
				wn.send_organism(org, org.owner)
			end
		end)
	end

	dir:Set(dmgInfo:GetDamageForce())
	dir:Normalize()
	dir:Mul(pen)
	--print(bullet.Penetration, pen, bullet ~= nil)
	--print(dmgInfo:GetDamageType() == DMG_BULLET)

	ent.armors = ent.armors or {}
	
	if dmgInfo:GetInflictor().poisoned2 and dmgInfo:IsDamageType(DMG_SLASH) then
		org.poison4 = CurTime()

		dmgInfo:GetInflictor().poisoned2 = nil
	end

	local organs = wn.organism.GetHitBoxOrgans(ent:GetModel(), ent)
	local boxs, pos, sphere = wn.organism.ShootMatrix(ent, organs)
	local dmgPos = dmgInfo:GetDamagePosition()
	local tr = util.QuickTrace(dmgPos, dir:GetNormalized() * 100)
	if tr.Hit and tr.Entity == ent then
		dmgPos = tr.HitPos
	else
		tr = util.QuickTrace(dmgPos, -(dmgPos - (ent:GetPos() + ent:OBBCenter())))
		dir = tr.Normal * pen
		if tr.Hit and tr.Entity == ent then
			dmgPos = tr.HitPos
		end
	end

	attacker.harm = dmgInfo:GetDamage() / 100
	
	if ply or org.fakePlayer then
		hook_Run("PreHomigradDamage", org.fakePlayer and ent or ply, dmgInfo, hitgroup, ent, attacker.harm, hitBoxs, inputHole)
	end
	
	local dmg_before = dmgInfo:GetDamage()

	local lastPos, hitBoxs, inputHole, outputHole, outputDir, distance, tracePoses = nil,{},{},{},{},nil,nil
	if dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_SLASH+DMG_CLUB+DMG_GENERIC) then
		lastPos, hitBoxs, inputHole, outputHole, outputDir, distance, tracePoses = wn.organism.Trace(dmgPos, dir, size, maxpen, boxs, pos, sphere, organs, dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT), Trace_Bullet, ent.organism, organs, dmg / 25, dmgInfo, dir)
	elseif dmgInfo:IsDamageType(DMG_BLAST) then
		local organs = wn.organism.GetHitBoxOrgans(ent:GetModel(), ent)
		local boxs, pos, sphere = wn.organism.ShootMatrix(ent, organs)
		
		wn.organism.BlastTrace(dmgInfo:GetDamagePosition(),(ent:GetPos() - dmgInfo:GetDamagePosition()):Length(), dmg / 300, boxs, organs, Trace_Blast, ent.organism, organs, dmg / 300, dmgInfo)
		wn.organism.AddWoundManual(ent,dmg,vector_origin,angle_zero,math.random(0,ent:GetBoneCount()),CurTime())
	end
	
	--\\ rp dopolneniye
	if dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT) then
		org.bulletwounds = org.bulletwounds + 1
	end

	if dmgInfo:IsDamageType(DMG_SLASH) then
		if dmgInfo:GetInflictor().slash then
			org.slashwounds = org.slashwounds + 1
		else
			org.stabwounds = org.stabwounds + 1
		end
	end

	if dmgInfo:IsDamageType(DMG_CLUB+DMG_GENERIC) then
		org.bruises = org.bruises + 1
	end

	if dmgInfo:IsDamageType(DMG_BURN) then
		org.burns = org.burns + 1
	end

	if dmgInfo:IsDamageType(DMG_BLAST) then
		org.explosionwounds = org.explosionwounds + 1
	end
	--//

	if inputHole and #inputHole > 0 and dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT) then
		ent.bloodamt2 = ent.bloodamt2 or 0
		ent.bloodamt2 = ent.bloodamt2 + 1

		timer.Simple(0,function()
			timer.Create("Blood_burst_input"..ent:EntIndex(),0.02,1,function()
				--[[net.Start("hg_bloodimpact")
				net.WriteVector(inputHole[1])
				net.WriteVector(dir / 2)
				net.WriteFloat(dmg)
				net.WriteInt(ent.bloodamt2,8)
				net.Broadcast()--]]
				ent.bloodamt2 = 0
			end)
		end)
	end

	local att = dmgInfo:GetAttacker()
	if false and outputHole and #outputHole > 0 and dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT) then
		local bullet = inf.bullet
		ent.bloodamt = ent.bloodamt or 0
		ent.bloodamt = ent.bloodamt + 1
		
		timer.Simple(0,function()
			if IsValid(ent) then
				timer.Create("Blood_burst"..ent:EntIndex(),0.02,1,function()
					if IsValid(ent) and ent.bloodamt then
						net.Start("hg_bloodimpact")
						net.WriteVector(outputHole[#outputHole])
						net.WriteVector(-outputDir)
						net.WriteFloat(dmg)
						net.WriteInt(ent.bloodamt,8)
						net.Broadcast()
						ent.bloodamt = 0
					end
				end)
			end
			if bullet then
				local mul = distance / pen
				bullet.Src = outputHole[#outputHole]
				bullet.Dir = dir:GetNormalized()//outputDir:GetNormalized()
				bullet.Force = bullet.Force * mul
				bullet.Damage = bullet.Damage * mul
				bullet.Num = 1
				bullet.Attacker = att
				bullet.Tracer = 0
				bullet.TracerName = "nil"
				bullet.IgnoreEntity = ent
				bullet.Filter = {ent}
				bullet.penetrated = bullet.penetrated or 0
				bullet.limit_ricochet = bullet.limit_ricochet or 0
				bullet.penetrated = bullet.penetrated + 1
				bullet.limit_ricochet = bullet.limit_ricochet + 1
				bullet.Penetration = distance
				inf:FireLuaBullets(bullet,true)

				local tr = util.QuickTrace(outputHole[#outputHole], -outputDir:GetNormalized() * 10, ent)
				local effectdata1 = EffectData()
				effectdata1:SetOrigin(outputHole[#outputHole])
				effectdata1:SetStart(tr.HitPos)
				effectdata1:SetEntity(inf)
				effectdata1:SetMagnitude(2)
				util.Effect("eff_tracer", effectdata1)
			end

			--[[local ent = ents.Create("prop_physics")
			ent:SetModel("models/props_c17/lampShade001a.mdl")
			ent:SetPos(outputHole[#outputHole])
			ent:Spawn()
			ent:SetSolidFlags(FSOLID_NOT_SOLID)
			ent:GetPhysicsObject():EnableMotion(false)--]]
		end)

	end
	
	local bone = tr.Entity == ent and tr.PhysicsBone
	if not bone then
		local dir = -(dmgPos - (ent:GetPos() + ent:OBBCenter())):GetNormalized()
		local tr = util.QuickTrace(dmgPos, dir * 100)
		bone = tr.PhysicsBone
	end
	
	if tracePoses then
		local mat = ent:GetBoneMatrix(ent:TranslatePhysBoneToBone(bone))

		table.insert(tracePoses,1,dmgPos - dir * 100)
		table.insert(tracePoses,1,dmgPos - dir * 200)

		local rf = RecipientFilter()
		if org.owner:IsPlayer() then rf:AddPlayer(org.owner) end
		if dmgInfo:GetAttacker():IsPlayer() then rf:AddPlayer(dmgInfo:GetAttacker()) end
		
		local name = dmgInfo:GetAttacker():IsPlayer() and dmgInfo:GetAttacker():Name() or dmgInfo:GetAttacker():GetClass()
		net.Start("tracePosesSend")
		net.WriteTable(tracePoses)
		net.WriteEntity(ent)
		net.WriteTable(hitBoxs)
		net.WriteFloat(pen)
		net.WriteFloat(size)
		net.WriteInt(ent:TranslatePhysBoneToBone(bone) or 0,32)
		net.WriteVector(mat:GetTranslation())
		net.WriteAngle(mat:GetAngles())
		net.WriteString(ent:GetModel())
		net.WriteMatrix(ent:GetBoneMatrix(0))
		net.WriteString(tostring(inf.PrintName or "Unknown"))
		net.WriteString(tostring(name))
		net.Send(rf)
	end
	
	local dmgPos = dmgInfo:GetDamagePosition()
	local dirCool = dmgInfo:GetDamageForce():GetNormalized()
	local tr = util.QuickTrace(dmgPos, dirCool * 100)
	local len = math.abs(dmgInfo:GetDamageForce():Length())

	local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(bone))
	local hitgroup = ( ent:IsPlayer() and ent:LastHitGroup() or bonetohitgroup[bonename])

	if ent:IsRagdoll() then
		if RagdollForceBoneMul[hitgroup] then len = len * RagdollForceBoneMul[hitgroup] end
		if RagdollDamageBoneMul[hitgroup] then dmgInfo:ScaleDamage(RagdollDamageBoneMul[hitgroup]) end
	end
	
	local dmgBlood, dmgHurt, instaPain, immobilization = wn.organism.DamageTypeAffliction(dmg_before / 12, dmgInfo, ent, org)

	local hitbody = #inputHole > 0 or not dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT)
	
	--if hitbody then
	if not org.superfighter then
		dmgBlood = dmgBlood * 1.5
		local bleed_add = dmgBlood * bleedMul// / (RagdollDamageBoneMul[hitgroup] or 1)
		--org.bleed = org.bleed + bleed_add
		attacker.harm = attacker.harm + bleed_add / 50
		local hurt_add = dmgHurt * 0.5 * hurtMul
		org.hurtadd = org.hurtadd + hurt_add
		local painadd = dmgHurt * painMul * 1.5
		local instantPainMul = 0.2
		local instant_pain = (instantPainMul or 0) * painadd
		local slow_pain = (1 - (instantPainMul or 0)) * painadd
		
		local instant_pain = instantPainMul * painadd
		local slow_pain = (1 - instantPainMul) * painadd
		org.painadd = org.painadd + slow_pain
		//org.avgpain = org.avgpain + instant_pain
		org.shock = math.min(org.shock + instaPain * shockMul * 4.5 * math.Clamp(pen / 5,1,2), 70)
		org.immobilization = math.min(org.immobilization + immobilization * immobilizationMul, 30)
		org.lasthit = CurTime()
		
		if bullet and wn.ammotypeshuy[bullet.AmmoType] and wn.ammotypeshuy[bullet.AmmoType].BulletSettings.tranquilizer then
			org.tranquilizer = 1
		end

		if dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_SLASH+DMG_BURN) then
			org.fearadd = org.fearadd + 0.3
			if IsValid(att) and att.organism and att.organism.fearadd then
				//att.organism.fearadd = att.organism.fearadd + 0.05
			end
		end

		if dmgInfo:IsDamageType(DMG_BURN) then
			local bigRand = math.Rand(0.0005,0.0008)
			local smallRand = math.Rand(0.0001,0.0002)
			//org.lungsL[2] = math.min(org.lungsL[2] + bigRand,1)
			//org.lungsR[2] = math.min(org.lungsR[2] + bigRand,1)
			org.lungsL[1] = math.min(org.lungsL[1] + bigRand,1)
			org.lungsR[1] = math.min(org.lungsR[1] + bigRand,1)
			wn.organism.input_list.liver(org,nil,smallRand,dmgInfo)
			wn.organism.input_list.stomach(org,nil,smallRand,dmgInfo)
			wn.organism.input_list.intestines(org,nil,smallRand,dmgInfo)
			wn.AddHarmToAttacker(dmgInfo, bigRand, "Burns harm")
			--org.liver = math.min(org.liver + math.Rand(0.0005,0.0008),1) 
			--org.stomach = math.min(org.stomach + math.Rand(0.0005,0.0008),1) 
			org.trachea = math.min(org.trachea + smallRand,1)
		end
	end
	--end
	
	if not org.otrub and org.adrenalineAdd >= 0 then// and dmgInfo:IsDamageType(DMG_BULLET + DMG_BLAST + DMG_BUCKSHOT + DMG_SLASH + DMG_CLUB + DMG_BURN) then
		org.adrenaline = math.min(org.adrenaline + instaPain * 1, 4)
		//org.adrenalineAdd = math.min(org.adrenalineAdd + instaPain * 0.15, 4)
		//org.adrenaline = math.min(org.adrenaline + instaPain * 0.7, 4)
		//org.adrenalineAdd = math.min(org.adrenalineAdd + instaPain * 0.3, 4)
	end
	
	if dmgInfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT + DMG_BLAST + DMG_SLASH) or (dmgInfo:IsDamageType(DMG_GENERIC + DMG_VEHICLE + DMG_FALL + DMG_CLUB)) then
		local hook_info = {
			bleed = dmgBlood,
			input_hole = inputHole,
			output_hole = outputHole,
			bone = bone,
			restricted = false,
		}
		
		hook_Run("PreHomigradDamageBulletBleedAdd", org.fakePlayer and ent or ply, org, dmgInfo, hitgroup, attacker.harm, hitBoxs, inputHole, hook_info)
		
		if(!hook_info.restricted)then
			wn.organism.AddWound(ent, tr, bone, dmgInfo, dmgPos, hook_info.bleed, inputHole, outputHole)
		end
	end
	
	if ply or org.fakePlayer then
		hook_Run("WhiteNoiseDamage", org.fakePlayer and ent or ply, dmgInfo, hitgroup, ent, attacker.harm, hitBoxs, inputHole)
	end
	
	attacker.harm = 0

	if dmgInfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT + DMG_BLAST + DMG_SLASH + DMG_CLUB + DMG_GENERIC) then
		local force = dirCool * len
		--print("HIT")
		if ply then
			--if ply.lastFake then ply.lastFake = ply.lastFake - len end
			ply.HitBones = ply.HitBones or {}

			if hitgrouptobone[hitgroup] then
				for i,bon in ipairs(hitgrouptobone[hitgroup]) do
					if hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_CHEST then dmg = dmg / 2 end
					ply.HitBones[bon] = CurTime() + dmg
				end
			end
			
			wn.AddForceRag(ply, bone, force * 0.5, 0.5)

			if forceOtrub then -- не работает говно
				ply.organism.otrub = true
				ply.organism.shock = math.max(ply.organism.shock, 40)
			end

			if ply.AddForceRag[bone][2] and ply.AddForceRag[bone][2]:Length() > 4500 then //по-моему какие-то большие значения, не?
				if ply.AddForceRag[bone][2]:Length() > 7000 then
					wn.StunPlayer(ply, 0.5)
					wn.LightStunPlayer(ply, 2)
				else
					wn.LightStunPlayer(ply, 2)
				end
			end
		end
		

		if ent:IsRagdoll() then
			ent:GetPhysicsObjectNum(bone or 0):ApplyForceCenter(force * 0.5)
		end
	end

	ent.dmgstack = (ent.dmgstack or 0) + dmgInfo:GetDamage() + math.Rand(-10,10)

	local mat = ent:GetBoneMatrix(ent:TranslatePhysBoneToBone(bone))
	timer.Create("dmgstack"..ent:EntIndex(),0.1 * math.Rand(0.1, 1),1,function()
		if !IsValid(ent) then return end
		ent.dmgstackfinal = ent.dmgstackfinal or ent.dmgstack
		timer.Simple(0.1,function()
			if not ent.dmgstackfinal then return end
			local rag = IsValid(ply) and (IsValid(ply:GetNWEntity("RagdollDeath", ply.FakeRagdoll)) and ply:GetNWEntity("RagdollDeath", ply.FakeRagdoll)) or ent:IsRagdoll() and ent
			if not IsValid(rag) then return end
			if IsValid(ply) and ply:Alive() then return end
			local distMul = IsValid(inf) and inf:GetPos():Distance(ent:GetPos()) or 100

			//if (math.random(2) == 1) and not ent.bloodsquirted then

			--print(distMul)
			if IsValid(rag) and (ent.dmgstackfinal / (math.Clamp(distMul, 30, 60) / 40)) < (150 + math.Rand(-10,20)) then
				if not rag.bloodsquirted and (hitgroup == HITGROUP_HEAD) and (bit.band(dmgtype, DMG_BULLET + DMG_BUCKSHOT) > 0) and math.random(4) == 1 and org.pulse > 30 then
			//if IsValid(rag) then
				//if true then
					rag.bloodsquirted = true
	
					net.Start("bloodsquirt")
					net.WriteEntity(rag)
					net.WriteString(bonename)
					net.WriteMatrix(mat)
					net.WriteVector(dmgPos + dirCool * 2)
					net.WriteVector(-dirCool * 2)
					net.Broadcast()
	
					if outputHole and #outputHole > 0 then
						net.Start("bloodsquirt")
						net.WriteEntity(rag)
						net.WriteString(bonename)
						net.WriteMatrix(mat)
						net.WriteVector(outputHole[1] - dirCool * 2)
						net.WriteVector(dirCool * 2)
						net.Broadcast()
					end
				end

				ent.dmgstack = 0 ent.dmgstackfinal = nil

				return
			end

			Gib_Input(rag, rag:TranslatePhysBoneToBone(bone), dirCool * len)
			
			ent.dmgstackfinal = nil
			ent.dmgstack = 0
		end)
	end)

	dmgInfo:ScaleDamage(dmgInfo:IsDamageType(DMG_BURN) and 0.015 or 0.15)
	
	takeRagdollDamage(ent, dmgInfo)

	if org.isPly then
		//hook.Run("Org Think Call", ply, org)
		
		if not ply:Alive() or not org.alive or org.otrub or wn.organism.paincheck(org) or (ply:Health() <= 0) then
			if org.skull == 1 then
				//ent:SetNWString("PlayerName", "Unidentifiable person")
			end

			ply:ScreenFade(SCREENFADE.PURGE, color_black, 1, 1)
			ply:ConCommand("soundfade 100 99999")
		end
	end

	-- EFFECT
	if dmgInfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT + DMG_SLASH) then
		if dmgBlood > 1 and #inputHole > 0 then
			--[[net.Start("hg_bloodimpact")
			net.WriteVector(dmgPos)
			net.WriteVector(dirCool/15)
			net.WriteFloat(dmg/10)
			net.WriteInt(1,8)
			net.Broadcast()--]]

			if (hitgroup ~= HITGROUP_HEAD) then
				if dmgInfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then
					--local effdata = EffectData()
					--effdata:SetOrigin( dmgPos )
					--effdata:SetRadius(0)
					--effdata:SetMagnitude(0)
					--effdata:SetScale(0)
					--util.Effect("BloodImpact",effdata)
				else
					--ParticleEffect( "headshot", dmgPos, dirCool:Angle() )
				end
			end	
		end
	end
	
	if ply and (not ply:GetNetVar("headcrab")) then
		local class = dmgInfo:GetAttacker():GetClass()
		
		if dmgInfo:GetAttacker():IsNPC() and headcrabs[class] then
			ply:AddHeadcrab(headcrabsmodels[class])
			
			dmgInfo:GetAttacker():Remove()
		end
	end
	
	return true
end)

local paintable = {
	[HITGROUP_STOMACH] = function(ply,ent)
		local snd = (ply.painCD and CurTime() < ply.painCD + 10 ) and "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/pain0"..math.random(1,9)..".wav" or "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/mygut02.wav"
		ent:EmitSound(snd,75,ply.VoicePitch)
		ply.painCD = CurTime() + SoundDuration(snd)
		ply.lastPhr = snd
	end,
	[HITGROUP_CHEST] = function(ply,ent)
		local snd = "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/pain0"..math.random(1,9)..".wav"
		ent:EmitSound(snd,75,ply.VoicePitch)
		ply.painCD = CurTime() + SoundDuration(snd)
		ply.lastPhr = snd
	end,
	[HITGROUP_LEFTARM] = function(ply,ent)
		local snd = (ply.painCD and CurTime() < ply.painCD + 10 ) and "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/pain0"..math.random(1,9)..".wav" or "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/myarm0"..math.random(1,2)..".wav"
		ent:EmitSound(snd,75,ply.VoicePitch)
		ply.painCD = CurTime() + SoundDuration(snd)
		ply.lastPhr = snd
	end,
	[HITGROUP_RIGHTARM] = function(ply,ent)
		local snd = (ply.painCD and CurTime() < ply.painCD + 10 ) and "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/pain0"..math.random(1,9)..".wav" or "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/myarm0"..math.random(1,2)..".wav"
		ent:EmitSound(snd,75,ply.VoicePitch)
		ply.painCD = CurTime() + SoundDuration(snd)
		ply.lastPhr = snd
	end,
	[HITGROUP_RIGHTLEG] = function(ply,ent)
		local snd = (ply.painCD and CurTime() < ply.painCD + 10 ) and "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/pain0"..math.random(1,9)..".wav" or "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/myleg0"..math.random(1,2)..".wav"
		ent:EmitSound(snd,75,ply.VoicePitch)
		ply.painCD = CurTime() + SoundDuration(snd)
		ply.lastPhr = snd
	end,
	[HITGROUP_LEFTLEG] = function(ply,ent)
		local snd = (ply.painCD and CurTime() < ply.painCD + 10 ) and "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/pain0"..math.random(1,9)..".wav" or "vo/npc/"..(ThatPlyIsFemale(ply) and "female" or "male").."01/myleg0"..math.random(1,2)..".wav"
		ent:EmitSound(snd,75,ply.VoicePitch)
		ply.painCD = CurTime() + SoundDuration(snd)
		ply.lastPhr = snd
	end,
}

hook.Add("Player Think","thinkhuy",function(ply, time)
	/*if (ply.think_physbone or 0) < time then
		ply.think_physbone = time + 0.5

		for i,tbl in pairs(ply.AddForceRag) do
			tbl[2] = wn.approach_vector(tbl[2],vector_origin,500)
			if tbl[2]:IsEqualTol(vector_origin, 10) then
				ply.AddForceRag[i] = nil
				continue
			end
		end
	end*/
end)

--[[hook.Add("WhiteNoiseDamage", "painsounds",function(ply, dmgInfo, hitgroup, ent) -- Пример использования WhiteNoiseDamage
	--ply.painCD = ply.painCD or 0
	--if paintable[hitgroup] and ply.painCD and ply.painCD < CurTime() and ply.organism and !ply.organism.otrub and ply:Alive() and !ply.organism.holdingbreath then 
	--	paintable[hitgroup](ply,ent)
	--end
end)--	]]

function wn.organism.DamageTypeAffliction(dmg, dmgInfo, ply, org)
	local dmgBlood, dmgHurt, instaPain, immobilization = dmg, dmg, dmg, 0

	if dmgInfo:IsDamageType(DMG_VEHICLE + DMG_SHOCK) then
		dmgBlood = (math.random(15) == 1) and dmg / 4 or 0
		dmgHurt = dmg * 1
		instaPain = dmg * 1
	end

	if dmgInfo:IsDamageType(DMG_CRUSH + DMG_FALL) then
		dmgBlood = 0
		dmgHurt = 0
		instaPain = 0
	end

	if dmgInfo:IsDamageType(DMG_GENERIC+DMG_CLUB) then
		dmgBlood = (math.random(15) == 1) and dmg / 4 or 0
		dmgHurt = dmg * 6
		instaPain = dmg * 6
		immobilization = dmg * 5
	end

	if dmgInfo:IsDamageType(DMG_BURN) then
		dmgBlood = 0
		dmgHurt = dmg * 3
		instaPain = dmg * 3
	end

	if dmgInfo:IsDamageType(DMG_BULLET) then
		dmgBlood = dmg * 4
		dmgHurt = dmg * 5
		instaPain = dmg * 5
		immobilization = dmg * 5
	end
	
	if dmgInfo:IsDamageType(DMG_SLASH) then
		dmgBlood = dmg * 7
		dmgHurt = dmg * 8
		instaPain = dmg * 9
		immobilization = dmg * 6
	end
	
	if dmgInfo:IsDamageType(DMG_BUCKSHOT) then
		dmgBlood = dmg * 4
		dmgHurt = dmg * 5
		instaPain = dmg * 5
		immobilization = dmg * 5
	end

	if dmgInfo:IsDamageType(DMG_BLAST) then
		dmgBlood = dmg * 1
		dmgHurt = dmg * 4
		instaPain = dmg * 2
	end
	
	if dmgInfo:IsDamageType(DMG_NERVEGAS) then--вроде если ты в фейке то не бьет
		if ply.armors.face == "mask2" or ply.PlayerClassName == "Combine" then
			dmgInfo:ScaleDamage(0)
			dmgBlood = 0
			dmgHurt = 0
			instaPain = 0
		else
			wn.organism.GasDamage(org, dmg, dmgInfo)
			dmgBlood = 0
			dmgHurt = dmg * 5
			instaPain = 0
		end
	end

	return dmgBlood * 2, dmgHurt, instaPain / 20, immobilization
end

local util_TraceLine = util.TraceLine
local endpos = Vector(0, 0, 0)
local dir, start
local filterEnt
local tr = {
	ignoreworld = true,
	mins = Vector(-3,-3,-3),
	maxs = Vector(3,3,3),
}
local util_TraceHull = util.TraceHull

local function GetTraceDamage(ent, start, dir)
	dir = -(-dir)
	dir:Normalize()
	dir:Mul(512)
	start = -(-start)
	tr.start = start
	endpos:Set(start)
	endpos:Add(dir) --вероятнее всего х3
	tr.endpos = endpos
	--tr.filter = ent --gunius
	local traceResult = util_TraceLine(tr)
	if not traceResult.Hit then
		endpos:Set(start)
		endpos:Sub(dir)
		traceResult = util_TraceHull(tr)
	end
	return traceResult
end

wn.GetTraceDamage = GetTraceDamage

--local Organism = wn.organism
local abs = math.abs
takeRagdollDamage = function(ent, dmgInfo)
	if not ent:IsRagdoll() then return end
	local ply = wn.RagdollOwner(ent)
	if not IsValid(ply) then return end
	if ply.organism and ply.organism.godmode then return end
	local traceResult = GetTraceDamage(ent, dmgInfo:GetDamagePosition(), dmgInfo:GetDamageForce())
	--я не ебу как

	if not IsValid(ply) or not ply:Alive() then return end

	if traceResult.Hit then
		local bone = traceResult.PhysicsBone
		local hitgroup
		local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(bone))
		if bonetohitgroup[bonename] ~= nil then hitgroup = bonetohitgroup[bonename] end
		--if RagdollDamageBoneMul[hitgroup] then dmgInfo:ScaleDamage(RagdollDamageBoneMul[hitgroup]) end
		if RagdollForceBoneMul[hitgroup] then dmgInfo:SetDamageForce(dmgInfo:GetDamageForce() * RagdollForceBoneMul[hitgroup]) end
		
		local org = ply.organism
		if dmgInfo:GetInflictor():IsWeapon() and not dmgInfo:IsDamageType(DMG_CRUSH) then
			if hitgroup == HITGROUP_LEFTARM then
				if IsValid(ent.ConsLH) then
					ent.ConsLH:Remove()
					ent.ConsLH = nil
				end
			end

			if hitgroup == HITGROUP_RIGHTARM then
				if IsValid(ent.ConsRH) then
					ent.ConsRH:Remove()
					ent.ConsRH = nil
				end
			end
		end
	end
	
	//if not dmgInfo:IsDamageType(DMG_CRUSH) then
	//	ply:SetHealth(ply:Health() - dmgInfo:GetDamage())
	//	if ply:Health() <= 0 and ply:Alive() then timer.Simple(0,function() if ply:Alive() then ply:Kill() end end) end
	//end
end

wn.takeRagdollDamage = takeRagdollDamage

local bleedSurfaces = { -- https://developer.valvesoftware.com/wiki/Material_surface_properties
	["boulder"] = true,
	["gravel"] = true,
	["rock"] = true,
	["concrete"] = true,
	["chain"] = true,
	["chainlink"] = true,
	["metalgrate"] = true,
	["glass"] = true,
	["glassbottle"] = true,
	["pottery"] = true,
	["combine_Metal"] = true,
	["cavern_rock"] = true,
	["glassfloor"] = true,
	["asphalt"] = true,
	["clay"] = true,
	["brokenglass"] = true,
	["boncretegrit"] = true,
	["glass_breakable"] = true
}

local function velocityDamage(ent,data)
	local speed = (data.OurOldVelocity - data.TheirOldVelocity):Length()
	if speed < 350 then return end
	--print(data.HitObject:GetEntity():IsWorld())
	local dmg = speed / 5350 * data.DeltaTime * ((IsValid(data.HitObject) && !data.HitObject:GetEntity():IsWorld()) && math.min(data.HitObject:GetMass() / 20, 1) || 1)
	dmg = dmg * math.abs(data.OurOldVelocity:GetNormalized():Dot(data.HitNormal))
	if !data.HitObject:GetEntity():IsWorld() && !data.HitObject:GetEntity():IsRagdoll() then
		//dmg = dmg * math.max(data.HitObject:GetMass()*(speed/50000),5)
	end
	if dmg * 20 * 2 < 0.2 then return end
	local bone
	for i = 0,ent:GetPhysicsObjectCount() do
		local phys = ent:GetPhysicsObjectNum(i)
		if phys == data.PhysObject then
			bone = i
		end
	end

	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage(dmg * 20)
	local surfaceType = util.GetSurfacePropName(data["TheirSurfaceProps"])
	--[[if surfaceType and surfaceType ~= nil and bleedSurfaces[surfaceType] then
		--print(surfaceType)
		--print(bleedSurfaces[surfaceType])
		dmgInfo:SetDamageType(DMG_SLASH)
	else]]
		dmgInfo:SetDamageType(DMG_CRUSH)
	--end
	local att = data.HitObject:GetEntity():GetPhysicsAttacker(5)
	att = IsValid(att) and att or ent:GetPhysicsAttacker(5)
	dmgInfo:SetAttacker(IsValid(att) and att or IsValid(dmgInfo:GetAttacker()) and dmgInfo:GetAttacker() or game.GetWorld())
	att.harm = dmgInfo:GetDamage() / 15
	-- 100 is kil
	
	local ply = wn.RagdollOwner(ent)
	local traceResult = GetTraceDamage(ent, data.HitPos, -(data.OurOldVelocity - data.TheirOldVelocity))
	
	if not bone then
		bone = tr.PhysicsBone
	end

	if IsValid(att) and att:IsPlayer() and att.organism and att.organism.fear and att.organism.fear < 0 then
		att.organism.fear = 0
	end

	local hitgroup
	local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(bone))
	
	if bonetohitgroup[bonename] ~= nil then hitgroup = bonetohitgroup[bonename] end
	if RagdollDamageBoneMul[hitgroup] then dmgInfo:ScaleDamage(RagdollDamageBoneMul[hitgroup]) end
	if not IsValid(ply) or not ply:Alive() then return end
	local org = ply.organism
	if org.godmode then return end

	if not org.superfighter then
		if hitgroup == HITGROUP_LEFTLEG and (dmg * 3 > 0.25) then wn.organism.input_list.llegdown(org, bone, dmg * 3 * math.Rand(0, 2), dmgInfo) end--org.lleg = math.min(org.lleg + dmg, 1) end
		if hitgroup == HITGROUP_RIGHTLEG and (dmg * 3 > 0.25) then wn.organism.input_list.rlegdown(org, bone, dmg * 3 * math.Rand(0, 2), dmgInfo) end
		if hitgroup == HITGROUP_LEFTARM and (dmg * 2 > 0.2) then wn.organism.input_list.larmup(org, bone, dmg * 3 * math.Rand(0, 2), dmgInfo) end
		if hitgroup == HITGROUP_RIGHTARM and (dmg * 2 > 0.2) then wn.organism.input_list.rarmup(org, bone, dmg * 3 * math.Rand(0, 2), dmgInfo) end
		if hitgroup == HITGROUP_CHEST and (dmg * 3 > 0.25) then wn.organism.input_list.chest(org, bone, dmg * 3, dmgInfo) end
		if hitgroup == HITGROUP_STOMACH and (dmg * 3 > 0.25) then wn.organism.input_list.pelvis(org, bone, dmg * 3, dmgInfo) end
		local physAng = data.PhysObject:GetAngles()
		
		if hitgroup == HITGROUP_STOMACH and physAng:Forward():Dot(data.HitNormal) > 0.6 then  wn.organism.input_list.spine1(org, bone, dmg * (math.random(3) > 1 and 1 or 0) * 3, dmgInfo) end -- | И В ПРАВДУ ПОЧЕМУ У НАС СПИНА ЛОМАЕТСЯ ОТ ПАДЕНИЯ НА ГРУДЬ ИЛИ ЖИВОТ...
		if hitgroup == HITGROUP_CHEST and physAng:Forward():Dot(data.HitNormal) > 0.6 then  wn.organism.input_list.spine2(org, bone, dmg * (math.random(3) > 1 and 1 or 0) * 3, dmgInfo) end


		--print(dmg * 3, dmg * 80)
		if surfaceType and surfaceType ~= nil and bleedSurfaces[surfaceType] and (dmg * 3 > 0.17) and math.random(2) == 2 then
			wn.organism.AddWoundManual(ent,dmg*5,vector_origin,angle_zero,bone,CurTime() + (dmg * 250))
			--PrintTable(org.wounds)
		end
		--print(dmg)
		if dmg > 0.2 then
			org.internalBleed = org.internalBleed + (dmg * 2.5) 
		end

		org.adrenaline = math.min(org.adrenaline + (dmg * 1.5), 4)

		if hitgroup == HITGROUP_HEAD then
			wn.organism.input_list.skull(org, bone, dmg * 3, dmgInfo)
			
			//if dmg > 0.5 then
				wn.organism.input_list.spine3(org, bone, dmg * (math.random(4) == 1 and 1 or 0) * 3, dmgInfo)
			//end

			if dmg * 10 > 0.5 then
				org.otrub = true
				org.shock = org.shock + 10
			end

			if org.spine3 >= 0.8 then
				ent:EmitSound("neck_snap_01.wav", 75, 100, 1, CHAN_AUTO)
				if ply:Alive() then
					ply:Kill()
				end
			end
		end
	end

	hook_Run("WhiteNoiseDamage", ply, dmgInfo, hitgroup, ent, att.harm, {}, {})

	att.harm = 0

	local dmghuy = dmg * 20

	if not org.superfighter then
		org.painadd = org.painadd + dmghuy
		org.shock = org.shock + dmghuy
	else
		dmghuy = dmghuy * 0.5
	end

	//if dmghuy >= 1 then
	//	ply:SetHealth(ply:Health() - dmghuy)
	//	if ply:Health() <= 0 and ply:Alive() then ply:Kill() end
	//end
end

wn.velocityDamage = velocityDamage

hook.Add("Player Spawn", "huyhuyhuy22", function(ply)
	if OverrideSpawn then return end

	--local wnds = table.Copy(ply.wounds)
	--local artwnds = table.Copy(ply.arterialwounds)
	ply.HitBones = {}
	ply.AddForceRag = {}

	ply.wounds = nil
	ply.arterialwounds = nil

	ply.wounds = {}
	ply.arterialwounds = {}
end)

hook.Add("Player Getup", "huyhhgss", function(ply)
	if ply.callback_physics then ply:RemoveCallback("PhysicsCollide",ply.callback_physics) ply.callback_physics = nil end
	
	ply.callback_physics = ply:AddCallback("PhysicsCollide",function(ply,data)
		if data.HitEntity:IsPlayerHolding() then return end
		if ply:GetGroundEntity() == data.HitEntity then return end
		if data.TheirOldVelocity:Length() < 50 then return end
		--if data.DeltaTime < 0.25 then return end
		local vel = data.TheirOldVelocity
		
		local needed = (data.HitEntity:IsRagdoll() and 200 or 4000)
		local force = vel:Length() * (data.HitObject:GetEntity():GetPhysicsObject():GetMass() / 24)
		if (force) > needed then wn.LightStunPlayer(ply,math.min(force / needed,4)) end
	end)
end)

--local PLAYER = FindMetaTable("PLAYER")
--function PLAYER:ApplyPain(number)
	--self.organism.painadd = self.organism.painadd + number
--end
