--local Organism = wn.organism
wn.organism.module = wn.organism.module or {}
local module = wn.organism.module
hook.Add("Org Clear", "Main", function(org)
	org.alive = true
	org.otrub = false
	module.pulse[1](org)
	module.blood[1](org)
	module.pain[1](org)
	module.stamina[1](org)
	module.lungs[1](org)
	module.liver[1](org)
	module.metabolism[1](org)
	module.random_events[1](org)
	org.brain = 0
	org.consciousness = 1
	org.disorientation = 0
	org.jaw = 0
	org.spine1 = 0
	org.spine2 = 0
	org.spine3 = 0
	org.chest = 0
	org.pelvis = 0
	org.skull = 0
	org.stomach = 0
	org.intestines = 0

	org.lleg = 0
	org.rleg = 0
	org.larm = 0
	org.rarm = 0
	org.llegdislocation = false
	org.rlegdislocation = false
	org.rarmdislocation = false
	org.larmdislocation = false
	org.jawdislocation = false

	org.health = 100
	org.canmove = true
	org.recoilmul = 1
	org.meleespeed = 1
	org.temperature = 36.7
	org.superfighter = false
	org.CantCheckPulse = nil
	org.HEV = nil
	org.bleedingmul = 1

	--\\ info for rp addition
	org.last_heartbeat = CurTime()
	org.bulletwounds = 0
	org.stabwounds = 0
	org.slashwounds = 0
	org.bruises = 0
	org.burns = 0
	org.explosionwounds = 0

	org.fear = 0
	org.fearadd = 0
	--//

	if IsValid(org.owner) then
		if org.owner:IsPlayer() and org.owner:Alive() then
			org.owner:SetHealth(100)
			org.owner:SetNetVar("wounds",{})
			org.owner:SetNetVar("arterialwounds",{})
		end
		
		org.owner:SetNetVar("zableval_masku", false)
	end
end)

hook.Add("Should Fake Up", "organism", function(ply)
	local org = ply.organism
	if org.otrub or org.fake or org.spine1 >= wn.organism.fake_spine1 or org.spine2 >= wn.organism.fake_spine2 or org.spine3 >= wn.organism.fake_spine3 or (org.lleg == 1 and org.rleg == 1) or (org.blood < 2900) then return false end
end)

util.AddNetworkString("organism_send")
util.AddNetworkString("organism_sendply")
local CurTime = CurTime
local nullTbl = {}
local hg_developer = ConVarExists("hg_developer") and GetConVar("hg_developer") or CreateConVar("hg_developer",0,FCVAR_SERVER_CAN_EXECUTE,"enable developer mode (enables damage traces)",0,1)
local function send_organism(org, ply)
	if not IsValid(org.owner) then return end
	local sendtable = {}

	sendtable.otrub = org.otrub
	sendtable.owner = org.owner
	sendtable.stamina = org.stamina
	sendtable.immobilization = org.immobilization
	sendtable.adrenaline = org.adrenaline
	sendtable.adrenalineAdd = org.adrenalineAdd
	sendtable.analgesia = org.analgesia
	sendtable.lleg = org.lleg
	sendtable.rleg = org.rleg
	sendtable.rarm = org.rarm
	sendtable.larm = org.larm
	sendtable.pelvis = org.pelvis
	sendtable.disorientation = org.disorientation
	sendtable.brain = org.brain
	sendtable.o2 = org.o2
	sendtable.blood = org.blood
	sendtable.bloodtype = org.bloodtype
	sendtable.bleed = org.bleed
	sendtable.hurt = org.hurt
	sendtable.pain = org.pain
	sendtable.shock = org.shock
	sendtable.pulse = org.pulse
	sendtable.timeValue = org.timeValue
	sendtable.holdingbreath = org.holdingbreath
	sendtable.arteria = org.arteria
	sendtable.recoilmul = org.recoilmul
	sendtable.meleespeed = org.meleespeed
	sendtable.temperature = org.temperature
	sendtable.canmove = org.canmove
	sendtable.fear = org.fear
	sendtable.llegdislocation = org.llegdislocation
	sendtable.rlegdislocation = org.rlegdislocation
	sendtable.rarmdislocation = org.rarmdislocation
	sendtable.larmdislocation = org.larmdislocation
	sendtable.jawdislocation = org.jawdislocation
	sendtable.lungsfunction = org.lungsfunction
	sendtable.consciousness = org.consciousness
	
	sendtable.critical = org.critical
	sendtable.incapacitated = org.incapacitated
	
	sendtable.superfighter = org.superfighter
	
	net.Start("organism_send")
	net.WriteTable(not hg_developer:GetBool() and sendtable or org)
	net.WriteBool(org.owner.fullsend)
	net.WriteBool(false)
	net.WriteBool(true)
	net.WriteBool(false)
	if IsValid(ply) and ply:IsPlayer() then
		net.Send(ply)
	else
		net.Broadcast()
	end
	if org.owner == ply or not IsValid(ply) or not ply:IsPlayer() then
		org.owner.fullsend = nil
	end
end

local function send_bareinfo(org)
	if not IsValid(org.owner) then return end
	local sendtable = {}

	sendtable.otrub = org.otrub
	sendtable.owner = org.owner
	sendtable.bloodtype = org.bloodtype
	sendtable.pulse = org.pulse
	sendtable.o2 = org.o2
	sendtable.timeValue = org.timeValue
	sendtable.superfighter = org.superfighter
	sendtable.lungsfunction = org.lungsfunction

	local rf = RecipientFilter()
	--rf:AddAllPlayers()
	rf:AddPVS(org.owner:GetPos())
	if org.owner:IsPlayer() then rf:RemovePlayer(org.owner) end

	net.Start("organism_send")
	net.WriteTable(not hg_developer:GetBool() and sendtable or org)
	net.WriteBool(org.owner.fullsend)
	net.WriteBool(true)
	net.WriteBool(false)
	net.WriteBool(false)
	net.Send(rf)
end

wn.send_organism = send_organism
wn.send_bareinfo = send_bareinfo

hook.Add("Org Think", "Main", function(owner, org, timeValue)
	if not IsValid(owner) then
		wn.organism.list[owner] = nil
		return
	end

	if owner:IsPlayer() and not owner:Alive() then return end

	local isPly = owner:IsPlayer()

	org.isPly = isPly

	if isPly or org.fakePlayer then
		if not org.fakePlayer then
			org.alive = owner:Alive()
		end
	else
		org.alive = false
	end

	org.needotrub = false
	org.needfake = false
	if isPly then
		org.ownerFake = org.FakeRagdoll and true
	else
		org.ownerFake = false
	end
	
	org.timeValue = timeValue
	org.incapacitated = false
	org.critical = false

	if isPly then
		module.stamina[2](owner, org, timeValue)
	end
	
	if isPly or org.fakePlayer then
		module.lungs[2](owner, org, timeValue)
	end

	if isPly then
		module.liver[2](owner, org, timeValue)
	end

	--module.blood[3](owner,org,timeValue)--arteria
	module.blood[2](owner, org, timeValue)
	if isPly then
		module.pain[2](owner, org, timeValue)
		module.metabolism[2](owner, org, timeValue)
		module.random_events[2](owner, org, timeValue)
	end
	module.pulse[2](owner, org, timeValue)

	if org.otrub then
		org.uncon_timer = org.uncon_timer or 0
		org.uncon_timer = org.uncon_timer + timeValue
	else
		org.uncon_timer = 0
	end

	local just_went_uncon = not org.otrub and org.needotrub
	local just_woke_up = not org.needotrub and org.otrub and (org.uncon_timer or 0) > 10
	if isPly and just_went_uncon then hook.Run("WN_OnOtrub", owner); hook.Run("PlayerDropWeapon", owner) end
	if isPly and just_woke_up then hook.Run("WN_OnWakeOtrub", owner) end
	
	org.canmove = (org.spine2 < wn.organism.fake_spine2 and org.spine3 < wn.organism.fake_spine3) and not org.otrub
	org.canmovehead = (org.spine3 < wn.organism.fake_spine3) and not org.otrub
	
	if not (org.canmove and org.canmovehead and (org.stun - CurTime()) < 0) then org.needfake = true end
	if (org.blood < 2700) then org.needfake = true end

	local just_went_uncon = not org.otrub and org.needotrub
	
	if org.posturing then //-- the decerebrate one
		local ent = wn.GetCurrentCharacter(org.owner)

		local rleg = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Foot")))
		local lleg = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_L_Foot")))
		local rarm = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
		local larm = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_L_Hand")))

		local down = -ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Spine")):GetAngles():Forward()
		if IsValid(rleg) and IsValid(rarm) and IsValid(larm) and IsValid(lleg)then
			rleg:ApplyForceCenter(down * 500)
			lleg:ApplyForceCenter(down * 500)
			rarm:ApplyForceCenter(down * 500)
			larm:ApplyForceCenter(down * 500)
		end
	end

	if org.otrub and isPly and org.owner:Alive() then
		org.owner:ScreenFade(SCREENFADE.PURGE, color_black, 0.5, 0)
		org.owner:ConCommand("soundfade 100 99999")
	end

	if not org.otrub and isPly and org.owner:Alive() then
		org.owner:ConCommand("soundfade 0 1")
	end

	if just_went_uncon then
		org.owner.fullsend = true
	end

	if org.brain > 0.05 then
		if math.random(600) < org.brain * 20 then
			org.needfake = true
		end
	end

	org.otrub = org.needotrub
	org.fake = org.needfake

	if owner:IsPlayer() and (org.healthRegen or 0) < CurTime() then
		org.healthRegen = CurTime() + 30
		owner:SetHealth(math.min(owner:GetMaxHealth(), owner:Health() + math.max(1.5 - org.hurt, 0)))
	end

	org.health = owner:Health()
	local rag = owner:IsPlayer() and owner.FakeRagdoll or owner
	if IsValid(rag) and rag:IsRagdoll() and (not owner.lastFake or owner.lastFake == 0) then rag:SetCollisionGroup((rag:GetVelocity():LengthSqr() > (200*200)) and COLLISION_GROUP_NONE or COLLISION_GROUP_WEAPON) end
	if isPly then
		if org.otrub or org.fake then wn.Fake(owner,nil,true) end
		if not org.alive and owner:Alive() then owner:Kill() end
	end

	if not org.otrub and isPly then
		local mul = wn.likely_to_phrase(owner)
		
		if not org.likely_phrase then org.likely_phrase = 0 end

		org.likely_phrase = math.max(org.likely_phrase + math.Rand(0, mul) / 100, 0)
		//print(org.likely_phrase)
		if org.likely_phrase >= 1 and !wn.GetCurrentCharacter(owner):IsOnFire() then
			org.likely_phrase = 0

			local str = wn.get_status_message(owner)
			//print(str)
			-- (msg, delay, msgKey, showTime, func, clr)
			owner:Notify(str, 1, "phrase", 1, nil, Color(255, math.Clamp(1 / wn.likely_to_phrase(owner) * 255, 0, 255), math.Clamp(1 / wn.likely_to_phrase(owner) * 255, 0, 255), 255))
		end
	end

	if !org.alive then org.otrub = true end

	if !org.alive then
		org.lungsfunction = false
		org.heartstop = true
	end

	time = CurTime()
	if org.pulseStart < time then
		org.pulseStart = time + 60 / org.pulse
		//wn.organism.Pulse(owner, org, timeValue)
	end

	if IsValid(owner) then
		org.sendPlyTime = org.sendPlyTime or CurTime()
		if (org.sendPlyTime > time) and !just_went_uncon then return end
		org.sendPlyTime = CurTime() + 1 + (not isPly and 2 or 0)
		send_bareinfo(org)

		if isPly and owner:Alive() then
			send_organism(org, owner)
		end
	end
end)

concommand.Add("hg_organism_setvalue", function(ply, cmd, args)
	if not ply:IsAdmin() then return end
	
	if not args[3] then
		if isbool(ply.organism[args[1]]) then
			ply.organism[args[1]] = tonumber(args[2]) != 0
		else
			ply.organism[args[1]] = tonumber(args[2])
		end
	end

	if args[3] then
		for i,pl in pairs(player.GetListByName(args[3])) do
			if isbool(pl.organism[args[1]]) then
				pl.organism[args[1]] = tonumber(args[2]) != 0
			else
				pl.organism[args[1]] = tonumber(args[2])
			end
		end
	end
end)

concommand.Add("hg_organism_setvalue2", function(ply, cmd, args)
	if not ply:IsAdmin() then return end
	
	ply.organism[args[1]][tonumber(args[2])] = tonumber(args[3])
end)

concommand.Add("hg_organism_clear", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	if not args[1] then
		wn.organism.Clear(ply.organism)
	end

	if args[1] then
		for i,pl in pairs(player.GetListByName(args[1])) do
			wn.organism.Clear(pl.organism)
		end
	end
end)

hook.Add("SetupMove", "hg-speed", function(ply, mv) end) --mv:SetMaxClientSpeed(100) --mv:SetMaxSpeed(100)

hook.Add("StartCommand","hg_lol",function(ply,cmd)
	if ply.organism.otrub and ply:Alive() then
		cmd:ClearMovement()
	end
end)

hook.Add("PlayerDeath","next-respawn-full",function(ply)
	ply.fullsend = true
end)

hook.Add("WN_OnWakeOtrub", "afterOtrub", function( owner ) 
	owner.organism.after_otrub = true
	local str = wn.get_status_message(owner)
	owner.organism.after_otrub = nil
	//print(str)
	-- (msg, delay, msgKey, showTime, func, clr)
	timer.Simple(0.1,function()
		if not IsValid(owner) then return end
		owner:Notify(str, 1, "wake", 1, nil, Color(255, math.Clamp(1 / wn.likely_to_phrase(owner) * 255, 0, 255), math.Clamp(1 / wn.likely_to_phrase(owner) * 255, 0, 255)) )
	end)

	owner:SendLua("system.FlashWindow()")
end)

hook.Add("WN_OnOtrub", "fearful", function( plya )// ЧЕ
	local ent = wn.GetCurrentCharacter(plya)
	for i,ply in ipairs(ents.FindInSphere(ent:GetPos(),256)) do
		if not ply:IsPlayer() or not ply.organism or plya == ply then continue end
		
		local tr = {}
		tr.start = ply:GetPos()
		tr.endpos = ent:GetPos()
		tr.filter = {ply,ent}
		if not util.TraceLine(tr).Hit then
			ply.organism.adrenalineAdd = ply.organism.adrenalineAdd + 0.3
			ply.organism.fearadd = ply.organism.fearadd + 0.3
		end
	end
end)

local function fixlimb(org, key)
	if math.random(100) > (90 - (org.analgesia * 50 + org.painkiller * 15)) then
		org[key.."dislocation"] = false
		org.painadd = org.painadd + 5
		org.fearadd = org.fearadd + 0.1
	else
		org.painadd = org.painadd + 20
		org.fearadd = org.fearadd + 0.3
	end
end

concommand.Add("hg_fixdislocation", function(ply, cmd, args)
	local org = ply.organism
	if !ply:Alive() or !org or org.otrub then return end
	if (ply.tried_fixing_limb or 0) > CurTime() then return end
	if !org.canmove or !org.canmovehead or org.pain > 45 then return end
	ply.tried_fixing_limb = CurTime() + org.pain / 30

	if math.Round(tonumber(args[1])) == 1 then
		if org.llegdislocation then
			fixlimb(org, "lleg")
		elseif org.rlegdislocation then
			fixlimb(org, "rleg")
		end
	elseif math.Round(tonumber(args[1])) == 2 then
		if org.larmdislocation then
			fixlimb(org, "larm")
		elseif org.rarmdislocation then
			fixlimb(org, "rarm")
		end
	elseif math.Round(tonumber(args[1])) == 3 then
		if org.jawdislocation then
			fixlimb(org, "jaw")
		end
	end
end)