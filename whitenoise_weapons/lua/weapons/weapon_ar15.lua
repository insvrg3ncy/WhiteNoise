SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "AR-15"
SWEP.Author = "ArmaLite"
SWEP.Instructions = "An AR-15–style rifle is a lightweight semi-automatic rifle based on or similar to the Colt AR-15 design. The Colt model removed the selective fire feature of its predecessor, the original ArmaLite AR-15, itself a scaled-down derivative of the AR-10 design by Eugene Stoner. It is closely related to the military M16 rifle. The AR-15 is a good rifle for defending your possessions. Chambered in 5.56x45 mm"
SWEP.Category = "Weapons - Assault Rifles"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/zcity/colt_m4.mdl"
SWEP.WorldModelFake = "models/weapons/zcity/v_m4a1.mdl" -- Контент инсурги https://steamcommunity.com/sharedfiles/filedetails/?id=3437590840 models/weapons/zcity/v_416c.mdl
--uncomment for funny
SWEP.FakePos = Vector(-2.53, -6, 7)
SWEP.FakeAng = Angle(0, 90, 0)
SWEP.AttachmentPos = Vector(-25.18,2.5,-0.1)
SWEP.AttachmentAng = Angle(0,90,-91)
//SWEP.MagIndex = 53
//MagazineSwap
--Entity(1):GetActiveWeapon():GetWM():SetSubMaterial(0,"NULL")

SWEP.stupidgun = true

SWEP.lmagpos = Vector(0,0,0)
SWEP.lmagang = Angle(0,0,0)
SWEP.lmagpos2 = Vector(0,-0.65,2.8)
SWEP.lmagang2 = Angle(0,0,-2.5)
SWEP.lmagpos3 = Vector(-3,-5.5,0)
SWEP.lmagang3 = Angle(180,180,-90)
SWEP.FakeMagDropBone = 75

SWEP.FakeReloadSounds = {
	[0.25] = "weapons/m4a1/m4a1_magrelease.wav",
	[0.27] = "weapons/m4a1/m4a1_magout.wav",
	[0.69] = "weapons/m4a1/m4a1_magain.wav",
	[0.83] = "weapons/m4a1/m4a1_hit.wav"
}

SWEP.FakeEmptyReloadSounds = {
	[0.22] = "weapons/m4a1/m4a1_magrelease.wav",
	[0.25] = "weapons/m4a1/m4a1_magout.wav",
	[0.37] = "weapons/m4a1/m4a1_magrelease.wav",
	[0.65] = "weapons/m4a1/m4a1_magain.wav",
	[0.77] = "weapons/m4a1/m4a1_hit.wav",
	[0.95] = "weapons/m4a1/m4a1_boltarelease.wav",
}

SWEP.MagModel = "models/weapons/arc9/darsu_eft/mods/mag_stanag_fn_mk16_std_556x45_30.mdl"

local vector_full = Vector(1,1,1)
local vecPochtiZero = Vector(0.01,0.01,0.01)
if CLIENT then
	SWEP.FakeReloadEvents = {
		[0.25] = function( self, timeMul )
			if self:Clip1() < 1 then
				self:GetOwner():PullLHTowards("ValveBiped.Bip01_Spine2", 1.1 * timeMul)//, self.MagModel, {self.lmagpos3, self.lmagang3, isnumber(self.FakeMagDropBone) and self.FakeMagDropBone or self:GetWM():LookupBone(self.FakeMagDropBone or "Magazine") or self:GetWM():LookupBone("ValveBiped.Bip01_L_Hand"), self.lmagpos2, self.lmagang2}, function(self)
				//	if IsValid(self) then
				//		self:GetWM():ManipulateBoneScale(75, vector_full)
				//		self:GetWM():ManipulateBoneScale(76, vector_full)
				//		self:GetWM():ManipulateBoneScale(77, vector_full)
				//	end
				//end)
			else
				//self:GetOwner():PullLHTowards("ValveBiped.Bip01_Spine2", 1.5 * timeMul, self.MagModel, {Vector(-2,-3,0), Angle(180,-0,90), 75, self.lmagpos, self.lmagang}, true)
			end
		end,
		[0.3] = function( self, timeMul )
			if self:Clip1() < 1 then
				wn.CreateMag( self, Vector(0,0,-50) )
				self:GetWM():ManipulateBoneScale(75, vecPochtiZero)
				self:GetWM():ManipulateBoneScale(76, vecPochtiZero)
				self:GetWM():ManipulateBoneScale(77, vecPochtiZero)
			else
				//self:GetWM():ManipulateBoneScale(75, vecPochtiZero)
				//self:GetWM():ManipulateBoneScale(76, vecPochtiZero)
				//self:GetWM():ManipulateBoneScale(77, vecPochtiZero)
			end 
		end,
		[0.4] = function( self, timeMul )
			if self:Clip1() < 1 then
				//self:GetOwner():PullLHTowards()
				self:GetWM():ManipulateBoneScale(75, vector_full)
				self:GetWM():ManipulateBoneScale(76, vector_full)
				self:GetWM():ManipulateBoneScale(77, vector_full)
			else
				//self:GetWM():ManipulateBoneScale(75, vector_full)
				//self:GetWM():ManipulateBoneScale(76, vector_full)
				//self:GetWM():ManipulateBoneScale(77, vector_full)
			end 
		end,
	}
end

SWEP.AnimList = {
	["idle"] = "base_idle",
	["reload"] = "base_reload",
	["reload_empty"] = "base_reloadempty",
}

SWEP.GunCamPos = Vector(5,-10,-5)
SWEP.GunCamAng = Angle(180,-95,-75)

SWEP.weaponInvCategory = 1
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 44
SWEP.Primary.Spread = 0
SWEP.Primary.Force = 44
SWEP.ShockMultiplier = 3
SWEP.Primary.Sound = {"zcitysnd/sound/weapons/firearms/mil_m16a4/m16_fire_01.wav", 75, 90, 100, 1}
SWEP.DistSound = "zcitysnd/sound/weapons/mk18/mk18_dist.wav"
SWEP.Primary.Wait = 0.11

SWEP.CustomShell = "556x45"
SWEP.EjectPos = Vector(-12,0,-4)
SWEP.EjectAng = Angle(0,0,-65)
SWEP.ScrappersSlot = "Primary"
SWEP.WepSelectIcon2 = Material("vgui/wep_jack_hmcd_assaultrifle")
SWEP.IconOverride = "entities/weapon_insurgencym4a1.png"

SWEP.LocalMuzzlePos = Vector(0.106,23.254,3.5)
SWEP.LocalMuzzleAng = Angle(-0.5,90,0)
SWEP.WeaponEyeAngles = Angle(0,-90,0.5)

SWEP.weight = 3

SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor2", Vector(0,0,0), {}},
		[2] = {"supressor6", Vector(0,0,-0.1), {}},
		["mount"] = Vector(-4.5,0.35,0),
	},
	sight = {
		["empty"] = {
			"empty",
			{
				[2] = "models/drgordon/weapons/colt/m4/m4_sights",
			},
		},
		["ironsight2"] = {
			"ironsight2",
			{
				[2] = "models/drgordon/weapons/colt/m4/m4_sights",
			},
		},
		["mountType"] = {"picatinny","ironsight"},
		["mount"] = {ironsight = Vector(-13 - 4.5, 1.8 - 0.4, -0.1), picatinny = Vector(-13 - 6, 1.8 - 0.45, -0.11)},
		["mountAngle"] = Angle(0,0,1),
		["removehuy"] = {
			[2] = "null"
		},
	},
	grip = {
		["mount"] = Vector(2 + 8.6 - 6, -0.7 + 1, -0.1),
		["mountType"] = "picatinny"
	},
	underbarrel = {
		["mount"] = {["picatinny_small"] = Vector(3, -0.03, -2.2),["picatinny"] = Vector(5,0,0)},
		["mountAngle"] = {["picatinny_small"] = Angle(-1, -0.3, -180),["picatinny"] = Angle(0, 0, 0)},
		["mountType"] = {"picatinny_small","picatinny"},
		["removehuy"] = {
		["picatinny"] = {
			},
			["picatinny_small"] = {
			}
		}
	}
}

SWEP.StartAtt = {"grip2"}

SWEP.ReloadTime = 5.5
SWEP.ReloadSoundes = {
	"none",
	"none",
	"none",
	"pwb2/weapons/m4a1/ru-556 clip out 1.wav",
	"none",
	"none",
	"pwb2/weapons/m4a1/ru-556 clip in 2.wav",
	"none",
	"none",
	"pwb2/weapons/m4a1/ru-556 bolt back.wav",
	"pwb2/weapons/m4a1/ru-556 bolt forward.wav",
	"none",
	"none",
	"none",
	"none"
}

SWEP.PPSMuzzleEffect = "pcf_jack_mf_mrifle2" -- shared in sh_effects.lua

SWEP.HoldType = "rpg"
SWEP.ZoomPos = Vector(0, 0.0381, 6.2614)

SWEP.attPos = Vector(-1.5, 0, -25)
SWEP.attAng = Angle(90, -179, -90)

SWEP.cameraShakeMul = 1

SWEP.rotatehuy = 0

SWEP.Ergonomics = 1
SWEP.Penetration = 13
SWEP.WorldPos = Vector(3, -1, -1)
SWEP.WorldAng = Angle(0, 90, 0.5)
SWEP.UseCustomWorldModel = true

--local to head
SWEP.RHPos = Vector(2,-6.2,3.2)
SWEP.RHAng = Angle(0,-15,90)
--local to rh
SWEP.LHPos = Vector(13,1.5,-4)
SWEP.LHAng = Angle(-80,90,90)

local finger1 = Angle(15, -15, 0)
local finger2 = Angle(-40, 20, 40)

SWEP.holsteredBone = "ValveBiped.Bip01_Spine2"
SWEP.holsteredPos = Vector(-3, 10, -2)
SWEP.holsteredAng = Angle(150, 180, 180)

function SWEP:DrawPost()
	local wep = self:GetWeaponEntity()
	self.vec = self.vec or Vector(0,0,0)
	local vec = self.vec
	if CLIENT and IsValid(wep) then
		self.shooanim = LerpFT(0.4,self.shooanim or 0,self:Clip1() > 0 and 0 or 0)
		vec[1] = 0
		vec[2] = 2*self.shooanim
		vec[3] = 0
		wep:ManipulateBonePosition(79,vec,false)
		--vec[1] = -1*self.ReloadSlideOffset
		--vec[2] = 0.09*self.ReloadSlideOffset
		--vec[3] = -0.06*self.ReloadSlideOffset
		--wep:ManipulateBonePosition(2,vec,false)
	end
end

local ang1 = Angle(10, -10, 20)
local ang2 = Angle(0, 40, 0)
local ang3 = Angle(0, 10, 0)

function SWEP:AnimHoldPost()
	self:BoneSet("l_finger0", vector_origin, ang1)
	self:BoneSet("l_finger02", vector_origin, ang2)
	self:BoneSet("l_finger2", vector_origin, ang3)
end

function SWEP:DrawHUDAdd()
	--[[local att = self:GetWeaponEntity():GetAttachment(1)
	local pos,ang = LocalToWorld(self.attPos,self.attAng,att.Pos,att.Ang)
	cam.Start3D()
	render.DrawLine(pos,pos+ang:Forward()*30,color_white,true)
	cam.End3D()--]]
end

-- RELOAD ANIM SR25/AR15
SWEP.ReloadAnimLH = {
	Vector(0,0,0),
	Vector(-2,1,-8),
	Vector(-2,2,-9),
	Vector(-2,2,-9),
	Vector(-2,7,-10),
	Vector(-15,5,-25),
	Vector(-15,15,-25),
	Vector(-5,15,-25),
	Vector(-2,4,-10),
	Vector(-2,2,-10),
	Vector(-2,2,-10),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
}

SWEP.ReloadAnimRH = {
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	Vector(0,0,0),
	"fastreload",
	Vector(-3,1,-3),
	Vector(-3,2,-3),
	Vector(-3,3,-3),
	Vector(-9,3,-3),
	Vector(-9,3,-3),
	Vector(0,3,-3),
	"reloadend",
	Vector(0,0,0),
	Vector(0,0,0),
}

SWEP.ReloadAnimLHAng = {
	Angle(0,0,0),
	Angle(-60,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(-90,0,110),
	Angle(0,0,95),
	Angle(0,0,60),
	Angle(0,0,30),
	Angle(0,0,2),
	Angle(0,0,0),
}

SWEP.ReloadAnimRHAng = {
	Angle(0,0,0),
}

SWEP.ReloadAnimWepAng = {
	Angle(0,0,0),
	Angle(-15,25,-15),
	Angle(-15,25,-25),
	Angle(5,28,-25),
	Angle(5,25,-25),
	Angle(1,24,-22),
	Angle(2,25,-21),
	Angle(-5,24,-22),
	Angle(1,25,-21),
	Angle(0,24,-22),
	Angle(1,25,-32),
	Angle(-5,24,-25),
	Angle(0,25,-26),
	Angle(0,0,2),
	Angle(0,0,0),
}

SWEP.ReloadSlideAnim = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	4,
	4,
	4,
	0,
	0,
	0,
	0
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
	Angle(15,15,15),
	Angle(15,15,24),
	Angle(15,15,24),
	Angle(15,15,24),
	Angle(15,7,24),
	Angle(10,3,-5),
	Angle(2,3,-15),
	Angle(0,4,-22),
	Angle(0,3,-45),
	Angle(0,3,-45),
	Angle(0,-2,-2),
	Angle(0,0,0)
}