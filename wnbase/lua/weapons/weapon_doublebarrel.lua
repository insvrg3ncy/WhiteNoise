SWEP.Base = "weapon_doublebarrel_short"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "IZh-43" -- сам ты дабл баррел
SWEP.Author = "Izhevsk Mechanical Plant"
SWEP.Instructions = "IZh-43 is a side by side smoothbore shotgun chambered in 12/70"
SWEP.Category = "Weapons - Shotguns"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/tfa_ins2/w_doublebarrel.mdl"

SWEP.WepSelectIcon2 = Material("entities/tfa_ins2_doublebarrel.png")
SWEP.WepSelectIcon2box = true
SWEP.IconOverride = "entities/tfa_ins2_doublebarrel.png"

SWEP.SprayRand = {Angle(-0.2, -0.4, 0), Angle(-0.4, 0.4, 0)}

SWEP.cameraShakeMul = 1
SWEP.FakeBodyGroups = "0000"
SWEP.addSprayMul = 1
SWEP.ScrappersSlot = "Primary"
SWEP.CustomShell = "12x70"
SWEP.weight = 4
SWEP.addweight = 2
SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "12/70 gauge"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 16
SWEP.Primary.Spread = Vector(0.01, 0.01, 0.01)
SWEP.Primary.Force = 12
SWEP.Primary.Sound = {"weapons/tfa_ins2/doublebarrel/doublebarrel_fire.wav", 80, 100, 75}
SWEP.Primary.Wait = 0
SWEP.OpenBolt = true

SWEP.CanEpicRun = false

SWEP.LocalMuzzlePos = Vector(37.893,0.388,1.648)
SWEP.LocalMuzzleAng = Angle(0,0,0)
SWEP.WeaponEyeAngles = Angle(0,0,0)

SWEP.RHandPos = Vector(-15, -2, 4)
SWEP.LHandPos = Vector(-15, -2, 4)

SWEP.IsPistol = false
SWEP.podkid = 0.5
SWEP.punchmul = 4
SWEP.punchspeed = 1
SWEP.animposmul = 2

SWEP.AnimShootMul = 0.5
SWEP.AnimShootHandMul = 0.2

SWEP.attPos = Vector(0, 0.2, 0)
SWEP.attAng = Angle(0, 0, 0)

SWEP.Ergonomics = 0.8

SWEP.ZoomPos = Vector(-26, 0.3414, 2.4255)
--SWEP.IsPistol = false
--local to head
SWEP.RHPos = Vector(3,-4.5,3.5)
SWEP.RHAng = Angle(0,0,90)
--local to rh
SWEP.LHPos = Vector(15,-0.9,-3.3)
SWEP.LHAng = Angle(-110,-90,-90)

-- RELOAD ANIM AKM
SWEP.ReloadAnimLH = {
	Vector(0,0,0),
	Vector(-2,-5,-15),
	Vector(-2,-5,-15),
	Vector(-2,-5,-12),
	Vector(-2,-4,-8),
	Vector(-2,1,-7),
	Vector(-2,1,-7),
	Vector(-2,1,-5),
	Vector(0,0,0),
}

SWEP.ReloadAnimRH = {
	Vector(0,0,0)
}

SWEP.ReloadAnimLHAng = {
	Angle(0,0,0),
	Angle(0,0,180),
	Angle(0,0,180),
	Angle(0,0,180),
	Angle(0,0,180),
	Angle(0,0,180),
	Angle(0,0,0),
}

SWEP.ReloadAnimRHAng = {
	Angle(0,0,0),
}

SWEP.ReloadAnimWepAng = {
	Angle(0,0,0),
	Angle(2,5,0),
	Angle(2,5,0),
	Angle(5,10,0),
	Angle(5,10,0),
	--Angle(0,0,0)
}

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
	Angle(-5,15,5),
	Angle(-5,15,15),
	Angle(-5,14,16),
	Angle(-7,16,18),
	Angle(-7,14,20),
	Angle(-6,15,-15),
	Angle(-2,12,-15),
	Angle(0,15,-22),
	Angle(0,14,-45),
	Angle(0,12,-45),
	Angle(0,10,-35),
	Angle(0,0,0)
}