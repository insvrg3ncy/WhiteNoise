if true then return end
SWEP.Base = "whitenoise_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "RPG-26"
SWEP.Author = "Degtyarev plant"
SWEP.Instructions = "The RPG-26 is a portable unguided shoulder-launched anti-tank rocket launcher."
SWEP.Category = "Weapons - Grenade Launchers"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/fas2/world/explosives/rpg26.mdl"

SWEP.WepSelectIcon2 = Material("vgui/inventory/weapon_rpg7")
SWEP.IconOverride = "entities/weapon_sw_rpg26.png"

SWEP.weight = 6
SWEP.ScrappersSlot = "Primary"

SWEP.weaponInvCategory = 1
SWEP.ShellEject = ""
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG-7 Projectile"--rpg rounds
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 1
SWEP.Primary.Sound = {"fas2/rpg26/rpg26_fire1.wav", 75, 90, 100}
SWEP.Primary.Force = 75
SWEP.Primary.Wait = 2
SWEP.ReloadTime = 2.6
SWEP.DeploySnd = {"fas2/rpg26/rpg26_draw.wav", 75, 100, 110}
SWEP.HolsterSnd = {"weapons/ins2rpg7/handling/rpg7_endgrab.wav", 75, 100, 110}
SWEP.HoldType = "rpg"
SWEP.ZoomPos = Vector(-7 + 7.05, 0.9 - 6.3, 20)
SWEP.RHandPos = Vector(0,0,0)
SWEP.LHandPos = false--Vector(13,0,0)
SWEP.Ergonomics = 0.3
SWEP.WorldPos = Vector(2,-2.5,7)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0,-3,13)
SWEP.attAng = Angle(0,0,0)
SWEP.lengthSub = 22
SWEP.DistSound = "weapons/ins2rpg7/rpg7_dist.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_Spine2"
SWEP.holsteredPos = Vector(0,-4,0)
SWEP.holsteredAng = Angle(0, 0, 0)
SWEP.OpenBolt = true
SWEP.SprayRand = {Angle(-0.05, -0.01, 0), Angle(-0.1, 0.01, 0)}
SWEP.SprayRandOnly = true
SWEP.Penetration = 20
SWEP.ReloadSound = "weapons/tfa_hl2r/rpg/rpg_reload1.wav"
SWEP.ReloadHold = "pistol"
SWEP.AnimShootMul = 5
SWEP.AnimShootHandMul = 5
SWEP.addSprayMul = 1
SWEP.ShootAnimMul = 12
SWEP.punchmul = 12
SWEP.punchspeed = 8
SWEP.podkid = 1
SWEP.ReloadTime = 6
--local to head
SWEP.RHPos = Vector(9.5,-1,8)
SWEP.RHAng = Angle(5,10,80)
--local to rh
SWEP.LHPos = Vector(6,-3.1,-5)
SWEP.LHAng = Angle(-10,0,-140)

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

	if primary.Next > CurTime() then return false end
	if (primary.NextFire or 0) > CurTime() then return false end
	primary.Next = CurTime() + primary.Wait
	self:SetLastShootTime(CurTime())
	primary.Automatic = weapons.Get(self:GetClass()).Primary.Automatic
	
    local gun = self:GetWeaponEntity()
	local att = self:GetMuzzleAtt(gun, true)
	self:TakePrimaryAmmo(1)
	if SERVER then
		local projectile = ents.Create("rpg26_projectile")
		projectile.owner = self:GetOwner()
		projectile:SetPos(att.Pos + att.Ang:Up() * -5 + att.Ang:Right() * 5)
		projectile:SetAngles(att.Ang)
		projectile:SetOwner(self:GetOwner())
		projectile:Spawn()
		projectile.Penetration = -(-self.Penetration)

		local phys = projectile:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:GetOwner():GetVelocity() + att.Ang:Forward() * 5000)
		end
		for i, ent in pairs(ents.FindInCone(att.Pos, -att.Ang:Forward(), 128, 0.8)) do
			if not ent:IsPlayer() then continue end
			if ent == wn.GetCurrentCharacter( self:GetOwner() ) then return end
			local d = DamageInfo()
			d:SetDamage( 400 )
			d:SetAttacker( self:GetOwner() )
			d:SetDamageType( DMG_BURN ) 

			ent:TakeDamageInfo( d )
		end
	end

	self:EmitShoot()
	self:PrimarySpread()
	timer.Simple(0.6, function()
		if SERVER and IsValid(self and self:GetOwner()) then
			wn.drop(self:GetOwner())
		end
	end)
end
SWEP.NoWINCHESTERFIRE = true

if SERVER then
	function SWEP:ReloadStart()
		if not IsValid(self and self:GetOwner()) then return end
		wn.drop(self:GetOwner())
	end

	function SWEP:ReloadEnd()
		if not IsValid(self and self:GetOwner()) then return end
		wn.drop(self:GetOwner())
	end

	function SWEP:Unload()
		if not IsValid(self and self:GetOwner()) then return end
		wn.drop(self:GetOwner())
	end
end

SWEP.CanSuicide = false

-- RELOAD ANIM AKM
SWEP.ReloadAnimLH = {
	Vector(0,0,0),
	Vector(12,2,2),
	Vector(9,0,2),
	Vector(6,1,2),
	Vector(4,-1,2),
	Vector(2,-1,2),
	Vector(-1,-1,1),
	"reloadend",
	Vector(0,0,0),
}

SWEP.ReloadAnimRH = {
	Vector(0,0,0)
}

SWEP.ReloadAnimLHAng = {
	Angle(0,0,0),
	Angle(0,0,0),
	Angle(0,0,0),
	Angle(0,0,0),
	Angle(0,0,0),
	Angle(0,0,0)
}

SWEP.ReloadAnimRHAng = {
	Angle(0,0,0),
}

SWEP.ReloadAnimWepAng = {
	Angle(0,0,0),
	Angle(0,5,25),
	Angle(0,5,25),
	Angle(5,5,25),
	Angle(3,5,25),
	Angle(0,0,0)
}

-- Inspect Assault
SWEP.LocalMuzzlePos = Vector(17,-0.2,7)
SWEP.LocalMuzzleAng = Angle(-0.3,0,0)
SWEP.WeaponEyeAngles = Angle(0,0,0)
SWEP.InspectAnimLH = {
	Vector(0,0,0)
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
	Angle(-15,35,5),
	Angle(-15,35,14),
	Angle(-15,34,16),
	Angle(-16,36,15),
	Angle(-15,34,16),
	Angle(-10,25,-15),
	Angle(-2,22,-15),
	Angle(0,25,-22),
	Angle(0,24,-45),
	Angle(0,22,-45),
	Angle(0,20,-35),
	Angle(0,0,0)
}