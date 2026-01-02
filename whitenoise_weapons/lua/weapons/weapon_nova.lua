--ents.Reg(nil,"weapon_m4super")
do return end
SWEP.Base = "weapon_m4super"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Benelli Nova"
SWEP.Author = "Benelli Armi"
SWEP.Instructions = "Pump-action shotgun chambered in 12/70"
SWEP.Category = "Weapons - Shotguns"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/tfa_ins2/w_nova.mdl"

SWEP.WepSelectIcon2 = Material("vgui/hud/tfa_ins2_nova")
SWEP.IconOverride = "vgui/hud/tfa_ins2_nova"

SWEP.CustomShell = "12x70"
--SWEP.EjectPos = Vector(0,-15,0)
SWEP.EjectAng = Angle(0,-2,0)

SWEP.LocalMuzzlePos = Vector(36.045,1.246,2.843)
SWEP.LocalMuzzleAng = Angle(0.3,0,0)
SWEP.WeaponEyeAngles = Angle(-0.7,0,0)
SWEP.ReloadSound = "weapons/tfa_ins2/nova/nova_shell_insert_1.wav"
SWEP.CockSound = "pwb2/weapons/remington870police/m3_pump.wav"
SWEP.weight = 4
SWEP.ScrappersSlot = "Primary"
SWEP.weaponInvCategory = 1
SWEP.ShellEject = "ShotgunShellEject"
SWEP.AutomaticDraw = false
SWEP.UseCustomWorldModel = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Spread = Vector(0.01, 0.01, 0.01)
SWEP.Primary.Sound = {"toz_shotgun/toz_fp.wav", 80, 90, 100}
SWEP.SupressedSound = {"toz_shotgun/toz_suppressed_fp.wav", 65, 90, 100}
SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor5", Vector(0,0,0), {}},
	},
	sight = {
		["mountType"] = "picatinny",
		["mount"] = Vector(-20, 1, 0),
	},
}

--models/weapons/tfa_ins2/upgrades/att_suppressor_12ga.mdl
SWEP.Primary.Wait = 0.25
SWEP.NumBullet = 8
SWEP.AnimShootHandMul = 10
SWEP.DeploySnd = {"homigrad/weapons/draw_hmg.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/hmg_holster.mp3", 55, 100, 110}
SWEP.HoldType = "rpg"
SWEP.ZoomPos = Vector(-3, 1.243, 4.1643)
SWEP.RHandPos = Vector(0, 0, -1)
SWEP.LHandPos = Vector(7, 0, -2)
SWEP.Ergonomics = 0.9
SWEP.Penetration = 7
SWEP.WorldPos = Vector(-1, 0, -0.5)
SWEP.WorldAng = Angle(0.7, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(0, -0.6, 0)
SWEP.lengthSub = 20

SWEP.holsteredBone = "ValveBiped.Bip01_Spine2"
SWEP.holsteredPos = Vector(4, 10, -4)
SWEP.holsteredAng = Angle(210, 0, 180)

--local to head
SWEP.RHPos = Vector(1,-4.5,4)
SWEP.RHAng = Angle(0,-15,90)
--local to rh
SWEP.LHPos = Vector(19,-1,-4)
SWEP.LHAng = Angle(-100,-90,-90)
local fingerhuy1 = Angle(-5, -20, 10)
local fingerhuy2 = Angle(0, 10, 20)
local fingerhuy3 = Angle(0, -10, 0)
local fingerhuy4 = Angle(-20, -8, 0)

function SWEP:AnimHoldPost()
end

function SWEP:AnimationPost()
	self:BoneSet("l_finger0", vector_origin, fingerhuy1)
	self:BoneSet("l_finger02", vector_origin, fingerhuy2)
	--self:BoneSet("r_finger0", vector_origin, fingerhuy4)

	local animpos = math.Clamp(self:GetAnimPos_Draw(CurTime()),0,1)
	local sin = 1 - animpos
	if sin >= 0.5 then
		sin = 1 - sin
	else
		sin = sin * 1
	end
	sin = sin * 2
	sin = math.ease.InOutSine(sin)
	self.LHPos[1] = 19 - sin * 5
	self.RHPos[1] = 0 - sin * 2

	self.RHPos[1] = 1 - sin * 4

	local wep = self:GetWeaponEntity()
	if CLIENT and IsValid(wep) then
		wep:ManipulateBonePosition(2,Vector(0,sin * 5,0),false)
	end
end

-- Inspect Assault

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
	Angle(-5,9,5),
	Angle(-5,9,14),
	Angle(-5,9,16),
	Angle(-6,10,15),
	Angle(-5,9,16),
	Angle(-10,15,-15),
	Angle(-2,22,-15),
	Angle(0,25,-32),
	Angle(0,24,-45),
	Angle(0,22,-55),
	Angle(0,20,-56),
	Angle(0,0,0)
}