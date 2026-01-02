-- White Noise - Base Weapon
-- Base weapon class for White Noise, uses homigrad_base functionality

SWEP.Base = "homigrad_base"
SWEP.PrintName = "White Noise Base Weapon"
SWEP.Author = "White Noise Team"
SWEP.Instructions = "Left click to fire, Right click to aim"
SWEP.Category = "White Noise"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize = 17
SWEP.Primary.DefaultClip = 17
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true

-- White Noise theme colors
SWEP.WNColor = Color(255, 255, 255)
SWEP.WNColorDark = Color(200, 200, 200)

function SWEP:Initialize()
	self:SetHoldType("pistol")
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:SetNextPrimaryFire(CurTime() + 0.5)
	
	self:ShootBullet(10, 1, 0.01)
	self:EmitSound("Weapon_Pistol.Single")
	
	self:TakePrimaryAmmo(1)
end

function SWEP:SecondaryAttack()
	-- Aim down sights or other secondary function
end

function SWEP:ShootBullet(damage, numbullets, aimcone)
	local bullet = {}
	bullet.Num = numbullets
	bullet.Src = self:GetOwner():GetShootPos()
	bullet.Dir = self:GetOwner():GetAimVector()
	bullet.Spread = Vector(aimcone, aimcone, 0)
	bullet.Tracer = 1
	bullet.TracerName = "Tracer"
	bullet.Force = damage * 0.5
	bullet.Damage = damage
	bullet.AmmoType = self.Primary.Ammo
	
	self:GetOwner():FireBullets(bullet)
	self:ShootEffects()
end

function SWEP:ShootEffects()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:Reload()
	if self:DefaultReload(ACT_VM_RELOAD) then
		self:EmitSound("Weapon_Pistol.Reload")
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	-- Custom weapon selection drawing with white theme
	draw.SimpleText(self.PrintName, "DermaLarge", x + wide/2, y + tall*0.3, self.WNColor, TEXT_ALIGN_CENTER)
end
