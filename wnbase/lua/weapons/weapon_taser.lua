SWEP.Base = "whitenoise_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Taser X26"
SWEP.Author = "Taser"
SWEP.Instructions = "A TASER is a conducted energy device (CED) primarily used to incapacitate people, allowing them to be approached and handled in an unresisting and thus less-lethal manner."
SWEP.Category = "Weapons - Other"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/defcon/taser/w_taser.mdl"

SWEP.WepSelectIcon2 = Material("vgui/wep_jack_hmcd_taser")
SWEP.IconOverride = "vgui/wep_jack_hmcd_taser"

SWEP.CustomShell = "9x18"
--SWEP.EjectPos = Vector(0,-20,5)
--SWEP.EjectAng = Angle(0,90,0)

SWEP.weight = 1

SWEP.ScrappersSlot = "Secondary"
SWEP.NoWINCHESTERFIRE = true

SWEP.weaponInvCategory = 4
SWEP.ShellEject = "EjectBrass_9mm"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Taser Cartridge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 8
SWEP.Primary.Sound = {"realtasesound.wav", 75, 90, 100}
SWEP.Primary.Force = 5
SWEP.ReloadTime = 2.5
SWEP.ReloadSoundes = {
	"none",
	"none",
	"weapons/kryceks_swep/mp5/magout.wav",
	"none",
	"weapons/kryceks_swep/mp5/magin2.wav",
	"none",
	"none"
}
SWEP.OpenBolt = true
SWEP.Primary.Wait = PISTOLS_WAIT
SWEP.DeploySnd = {"whitenoise/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"whitenoise/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(-3, 0.0217, 1.201)
SWEP.RHandPos = Vector(-5, -1.5, 2)
SWEP.LHandPos = false
SWEP.SprayRand = {Angle(-0, -0.01, 0), Angle(-0.01, 0.01, 0)}
SWEP.Ergonomics = 1
SWEP.AnimShootMul = 0.5
SWEP.AnimShootHandMul = 0.5
SWEP.addSprayMul = 0.5
SWEP.Penetration = 4
SWEP.ShockMultiplier = 1
SWEP.WorldPos = Vector(5, -1.2, -3)
SWEP.WorldAng = Angle(83, -0.5, 90)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0,0,0)
SWEP.attAng = Angle(-90,0,90)
SWEP.rotatehuy = 90
SWEP.lengthSub = 25
SWEP.DistSound = ""
SWEP.holsteredBone = "ValveBiped.Bip01_R_Thigh"
SWEP.holsteredPos = Vector(0, 0, 0)
SWEP.holsteredAng = Angle(-5, -5, 90)
SWEP.shouldntDrawHolstered = true
SWEP.ImmobilizationMul = 20

SWEP.availableAttachments = {}

function SWEP:InitializePost()
	self.attachments.underbarrel = {[1] = "lasertaser0"}
end

--local to head
SWEP.RHPos = Vector(12,-5,4.5)
SWEP.RHAng = Angle(-2,-2,90)
--local to rh
SWEP.LHPos = Vector(-1.2,-1.4,-2.8)
SWEP.LHAng = Angle(5,9,-100)

local finger1 = Angle(0,0,0)
local finger2 = Angle(-15,45,-5)

function SWEP:AnimHoldPost(model)
	--self:BoneSet("l_finger0", vector_zero, finger1)
    --self:BoneSet("l_finger02", vector_zero, finger2)
end

function SWEP:Shoot(override)
	if not self:CanPrimaryAttack() then return false end
	if not self:CanUse() then return false end
	if self:Clip1() == 0 then return end
	local primary = self.Primary
	if not self.drawBullet then
		self.LastPrimaryDryFire = CurTime()
		self:PrimaryShootEmpty()
		primary.Automatic = false
		return false
	end
	local owner = self:GetOwner()
	local gun = self:GetWeaponEntity()
	
	local tr,pos,ang = self:GetTrace(true)

	if primary.Next > CurTime() then return false end
	if (primary.NextFire or 0) > CurTime() then return false end
	primary.Next = CurTime() + primary.Wait
	self:SetLastShootTime(CurTime())
	primary.Automatic = weapons.Get(self:GetClass()).Primary.Automatic
	
    local gun = self:GetWeaponEntity()
	local att = self:GetMuzzleAtt(gun, true)
	--self:GetOwner():Kick("lol")
	self:TakePrimaryAmmo(1)
    
    self:EmitShoot()
	self:PrimarySpread()

	if SERVER then
		local dir = ang:Forward()
		
		self:GetOwner():LagCompensation(true)
        local tr = util.TraceLine( {
            start = pos,
            endpos = pos + dir * 220,
            filter = {self},
            mask = MASK_SHOT
        } )
		self:GetOwner():LagCompensation(false)

		if tr.Entity then
            local ent = tr.Entity
			
			if not ent:IsPlayer() and not ent:IsRagdoll() then return end
            if IsValid(ent.FakeRagdoll) then return end
            
			//if ent == wn.GetCurrentCharacter( self:GetOwner() ) then return end
			local d = DamageInfo()
			d:SetDamage( 5 )
			d:SetAttacker( self:GetOwner() )
			d:SetDamageType( DMG_SHOCK ) 
			d:SetDamagePosition( tr.HitPos ) 

			ent:TakeDamageInfo( d )
            local ply = ent

            if ent:IsRagdoll() then
                ply = wn.RagdollOwner(ent) or ent
            end

			local drugged = ply.organism and ply.organism.analgesia > 0.5

            local time = math.random(5,7) * (drugged and 0.2 or 1)
			
			wn.StunPlayer(ply, time + 3 * (drugged and 0.2 or 1))

			if IsValid(ply) and ply:Alive() then
                local org = ply.organism
                org.tasered = CurTime() + time
            end

            ent:EmitSound("tazer.wav")
            local ragdoll = (IsValid(ply) and ply:Alive()) and ply.FakeRagdoll or ent
            local tasered =  CurTime() + time
			
			timer.Simple(0.1,function()
				for i = 0, 1 do
					if not IsValid(ent) then return end
					local ent = wn.GetCurrentCharacter(ent)
					local phys = ent:GetPhysicsObjectNum(tr.PhysicsBone or 0)
					local localpos,_ = WorldToLocal(tr.HitPos,angle_zero,IsValid(phys) and phys:GetPos() or ent:GetPos(),IsValid(phys) and phys:GetAngles() or angle_zero)
					
					local cons = constraint.CreateKeyframeRope(tr.HitPos,0.1,"cable/cable2",nil,ent,localpos+VectorRand(-0.5,0.5),tr.PhysicsBone,self:GetWM(),Vector(0,-5,-0.3+0.5*i),0,
					{
						["Slack"] = 200 - ent:GetPos():Distance(self:GetPos()),
						["Collide"] = 1,
					})
					//PrintTable(cons:GetKeyValues())
					timer.Simple(7,function()
						if IsValid(cons) then
							cons:SetKeyValue("Dangling", 1)
							cons:SetSaveValue("m_hEndPoint", game.GetWorld())
							//cons:Remove()
							//cons = nil
						end
					end)
				end
			end)
			--чзх добавить возможность тазерить мощнее при нажатии лкм
			timer.Create("Tasering"..ent:EntIndex(),0.1,time*10,function()
				//self:WorldModel_Transform()
                local tasered = tasered

                if IsValid(ragdoll) then
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                    ragdoll:GetPhysicsObjectNum(math.random(0, ragdoll:GetPhysicsObjectCount() - 1)):ApplyForceCenter(VectorRand()*555)
                end

                if ent:IsPlayer() then
                    ent.organism.pain = ent.organism.pain + 0.2
                end

                if tasered - .5 < CurTime() then 
                    if IsValid(ragdoll) then
                        ragdoll:StopSound("tazer.wav")
                    end

                    ent:StopSound("tazer.wav")
                end
            end)
            return
		end
	end
end
if SERVER then
    hook.Add("Should Fake Up","Tasered",function(ply)
        if ply and IsValid(ply.FakeRagdoll) then
            local org = ply.organism
            if org and org.tasered and org.tasered > CurTime() then
                return true
            end
        end
    end)

    hook.Add("CanControlFake","Tasered", function(ply,rag) 
        local org = ply.organism
        if org and org.tasered and org.tasered > CurTime() then
            return true
        end
    end)

    hook.Add("Org Clear","RemoveTasered",function(org)
		org.tasered = false 
	end)
end

SWEP.LocalMuzzlePos = Vector(0,0,0)
SWEP.LocalMuzzleAng = Angle(-0.7,-82,-90)
SWEP.WeaponEyeAngles = Angle(0,0,0)

--RELOAD ANIMS PISTOL

SWEP.ReloadAnimLH = {
	Vector(0,0,0),
    Vector(8,2,3),
    Vector(7,2,3),
    Vector(7,4,3),
    Vector(8,4,3),
    Vector(-10,2,-9),
    Vector(5,3,-2),
    Vector(11,4,3),
    Vector(8,2,3),
	Vector(8,2,3),
    Vector(5,4,1),
    Vector(0,0,0),
}
SWEP.ReloadAnimLHAng = {
	Angle(0,0,0)
}
SWEP.ReloadAnimRH = {
	Vector(0,0,0)
}
SWEP.ReloadAnimRHAng = {
	Angle(0,0,0)
}
SWEP.ReloadAnimWepAng = {
	Angle(0,0,0),
    Angle(15,25,4),
    Angle(15,30,45),
    Angle(15,10,35),
    Angle(0,0,0),
}

-- Inspect Pistol

SWEP.InspectAnimLH = {
	Vector(0,0,0),
	Vector(0,2,-5),
	Vector(2,2,-8),
	Vector(2,3,-7),
	Vector(1,2,-9),
	Vector(2,1,0),
	Vector(0,0,0),
}
SWEP.InspectAnimLHAng = {
	Angle(0,0,0)
}
SWEP.InspectAnimRH = {
	Vector(0,0,0)
}
SWEP.InspectAnimRHAng = {
	Angle(0,0,0)
}
SWEP.InspectAnimWepAng = {
	Angle(0,0,0),
	Angle(-5,25,5),
	Angle(-9,25,14),
	Angle(-11,44,16),
	Angle(-12,46,15),
	Angle(-13,44,16),
	Angle(0,-25,-15),
	Angle(0,-25,-15),
	Angle(0,-22,-12),
	Angle(0,-22,-22),
	Angle(0,-34,-22),
	Angle(0,-22,-22),
	Angle(0,0,0)
}