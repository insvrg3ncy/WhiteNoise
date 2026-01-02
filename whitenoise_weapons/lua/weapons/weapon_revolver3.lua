if true then return end -- нахер небуду больше оружия никакие делать которые меня просят
SWEP.Base = "weapon_m4super"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Colt Navy"
SWEP.Author = "Manurhin"
SWEP.Instructions = "Revolver chambered in .36\n"
SWEP.Category = "Weapons - Pistols"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/tfre/w_walker.mdl"

SWEP.WepSelectIcon2 = Material("vgui/entities/tfa_tfre_colt_walker")
SWEP.WepSelectIcon2box = true
SWEP.IconOverride = "vgui/entities/tfa_tfre_colt_walker"

SWEP.weight = 1.5

SWEP.punchmul = 5
SWEP.punchspeed = 1
SWEP.podkid = 2
SWEP.RecoilMul = 0.1

SWEP.LocalMuzzlePos = Vector(-12,0.8,1)
SWEP.LocalMuzzleAng = Angle(0, 180, 0)
SWEP.WeaponEyeAngles = Angle(0,0,0)

--
SWEP.weaponInvCategory = 2
SWEP.ShellEject = "EjectBrass_57"
SWEP.ShellEject2 = false
SWEP.AutomaticDraw = false
SWEP.OpenBolt = true
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ".38 Special"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 30
SWEP.Primary.Sound = {"zcitysnd/sound/weapons/revolver/revolver_fp.wav", 75, 90, 100}
SWEP.SupressedSound = {"weapons/tfa_ins2/usp_tactical/fp_suppressed1.wav", 55, 90, 100}
SWEP.Primary.SoundEmpty = {"zcitysnd/sound/weapons/revolver/handling/revolver_empty.wav", 75, 100, 105, CHAN_WEAPON, 2}
SWEP.Primary.Spread = Vector(0, 0, 0)
SWEP.NumBullet = 1
SWEP.Primary.Wait = 0.2
SWEP.ReloadTime = 3
SWEP.ReloadSoundes = {
	"none",
	"none",
	"weapons/tfa_ins2/swmodel10/revolver_dump_rounds_02.wav",
}

function SWEP:PostFireBullet(bullet)
	SlipWeapon(self, bullet)
end

SWEP.PPSMuzzleEffect = "muzzleflash_pistol_rbull" -- shared in sh_effects.lua
SWEP.CockSound = "weapons/tfa_ins2/swmodel10/revolver_close_chamber.wav"
SWEP.ReloadSound = "weapons/tfa_ins2/swmodel10/revolver_round_insert_single_01.wav"

SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.AimHold = "revolver"
SWEP.ZoomPos = Vector(-26, -1, 1)
SWEP.RHandPos = Vector(0, 0, 1)
SWEP.LHandPos = false
SWEP.SprayRand = {Angle(-0.1, -0.2, 0), Angle(-0.2, 0.2, 0)}
SWEP.AnimShootMul = 4
SWEP.AnimShootHandMul = 2
SWEP.Ergonomics = 0.9
SWEP.OpenBolt = true
SWEP.Penetration = 10
function SWEP:ReloadStartPost()
	if not self or not IsValid(self:GetOwner()) then return end
	hook.Run("HGReloading", self)
	self.reloadMiddle = CurTime() + self.ReloadTime / 4
end

SWEP.ShockMultiplier = 3

SWEP.ScrappersSlot = "Secondary"

SWEP.CustomShell = ""

function SWEP:ShiftDrum(val)
	val = math.Round(val % 6)
	
	if val == 0 then val = 1 end

	local drumCopy = table.Copy(self.Drum)

	for i = 1,#self.Drum do
		local nextval = i + val
		
		local setval = nextval < 1 and #self.Drum - nextval or nextval > 6 and nextval - 6 or nextval
		
		self.Drum[i] = drumCopy[setval]
	end

	local stringythingy = ""
	for i = 1,#self.Drum do
		stringythingy = stringythingy..tostring(self.Drum[i]).." "
	end
	
	--[[if SERVER then
		net.Start("hg_senddrum")
		net.WriteInt(self:EntIndex(),32)
		net.WriteString(stringythingy)
		net.Broadcast()
	end--]]
	self:SetNWInt("drumroll",self:GetNWInt("drumroll",0) + val)
	self:SetNWString("drum",stringythingy)
end

SWEP.WorldPos = Vector(5, -2.3, -4.8)
SWEP.WorldAng = Angle(0, 180, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0,0,0)
SWEP.attAng = Angle(0,-0.2,0)
SWEP.lengthSub = 25
SWEP.DistSound = "m9/m9_dist.wav"
SWEP.holsteredBone = "ValveBiped.Bip01_R_Thigh"
SWEP.holsteredPos = Vector(4, -8, 2)
SWEP.holsteredAng = Angle(0, 20, 70)
SWEP.shouldntDrawHolstered = false

SWEP.availableAttachments = {}

--local to head
SWEP.RHPos = Vector(10,-5,3)
SWEP.RHAng = Angle(0,-5,90)
--local to rh
SWEP.LHPos = Vector(-1.2,-1.4,-2.8)
SWEP.LHAng = Angle(5,9,-100)

SWEP.ReloadDrawTime = 0.08
SWEP.ReloadDrawCooldown = 0.05
SWEP.ReloadInsertTime = 0.05
SWEP.ReloadInsertCooldown = 0.05
SWEP.ReloadInsertCooldownFire = 0.08


local anims = {
	Vector(0,0,0),
	Vector(0,0,-1),
}
function SWEP:AnimHoldPost(model)
	local animpos = math.Clamp(self:GetAnimPos_Draw(CurTime()),0,1)
	local sin = 1 - animpos
	if sin >= 0.5 then
		sin = 1 - sin
	else
		sin = sin * 1
	end
	if sin > 0 then
		sin = sin * 2
		sin = math.ease.InOutSine(sin)

		local lohsin = math.floor(sin * (#anims))
		local lerp = sin * (#anims) - lohsin

		self.inanim = true
		self.RHPosOffset = Lerp(lerp,anims[math.Clamp(lohsin,1,#anims)],anims[math.Clamp(lohsin+1,1,#anims)])
	else
		self.inanim = nil
		self.RHPosOffset[1] = 0
		self.RHPosOffset[2] = 0
		self.RHPosOffset[3] = 0
	end
	self:BoneSet("r_finger0", vector_zero, Angle(40, -40 * math.Clamp(sin * 3, 1, 2), 0))
end

if CLIENT then
	function SWEP:RejectShell(shell)
	end
end

--RELOAD ANIMS PISTOL

SWEP.ReloadAnimRH = {
	Vector(0,0,0)
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

SWEP.ReloadAnimLH = {
	Vector(0,0,0),
	Vector(4,1,2),
	Vector(3,0,1),
	Vector(-5,3,-4),
	Vector(-7,1,3),
	Vector(5,2,-2),
	Vector(0,0,0),
	"reloadend",
}
SWEP.ReloadAnimLHAng = {
	Angle(0,0,0),
	Angle(0,0,-40),
	Angle(0,0,-50),
	Angle(0,0,-30),
	Angle(0,0,-20),
	Angle(0,0,-10),
	Angle(0,0,0),
	Angle(0,0,0),
}

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
	Angle(6,0,5),
	Angle(15,0,14),
	Angle(16,0,16),
	Angle(4,0,12),
	Angle(-6,0,-2),
	Angle(-15,7,-15),
	Angle(-16,18,-35),
	Angle(-17,17,-42),
	Angle(-18,16,-44),
	Angle(-14,10,-46),
	Angle(-2,2,-4),
	Angle(0,0,0)
}