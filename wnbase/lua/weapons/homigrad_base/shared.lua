SWEP.Base = "weapon_base"
SWEP.PrintName = "base_hg"
SWEP.Category = "Other"
SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.ReloadTime = 1
SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav"
SWEP.Primary.SoundEmpty = {"zcitysnd/sound/weapons/m14/handling/m14_empty.wav", 75, 100, 105, CHAN_WEAPON, 2}
SWEP.Primary.Wait = 0.1
SWEP.Primary.Next = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.shouldntDrawHolstered = false
wn.weapons = wn.weapons or {}

SWEP.ishgwep = true
SWEP.iswnwep = true

SWEP.EyeSprayVel = Angle(0,0,0)

SWEP.ScrappersSlot = "Primary"
--[type_] = {1 = name,2 = dmg,3 = pen,4 = numbullet,5 = RubberBullets,6 = ShockMultiplier,7 = Force},
SWEP.AmmoTypes2 = {
	["12/70 gauge"] = {
		[1] = {"12/70 gauge"},
		[2] = {"12/70 beanbag"},
		[3] = {"12/70 Slug"},
		[4] = {"12/70 RIP"},
		[5] = {"12/70 Blank"}
	},
	["9x19 mm Parabellum"] = {
		[1] = {"9x19 mm Parabellum"},
		[2] = {"9x19 mm Green Tracer"},
		[3] = {"9x19 mm QuakeMaker"}
	}, 
	["5.56x45 mm"] = {
		[1] = {"5.56x45 mm"},
		[2] = {"5.56x45 mm M856"},
		[3] = {"5.56x45 mm AP"}
	},
	["7.62x39 mm"] = {
		[1] = {"7.62x39 mm"},
		[2] = {"7.62x39 mm SP"},
		[3] = {"7.62x39 mm BP gzh"}
	},
	["7.62x51 mm"] = {
		[1] = {"7.62x51 mm"},
		[2] = {"7.62x51 mm M993"}
	},
	["14.5x114mm B32"] = {
		[1] = {"14.5x114mm B32"},
		[2] = {"14.5x114mm BZTM"}
	},
	[".45 ACP"] = {
		[1] = {".45 ACP"},
		[2] = {".45 ACP Hydro Shock"},
	},
	[".50 Action Express"] = {
		[1] = {".50 Action Express"},
		[2] = {".50 Action Express Copper Solid"},
		[3] = {".50 Action Express JHP"}
	},
	["9mm PAK Blank"] = {
		[1] = {"9mm PAK Blank"},
		[2] = {"9mm PAK Flash Defense"},
	},
}

function SWEP:OnReloaded()
	if self.newammotype then
		self:ApplyAmmoChanges(self.newammotype)
	end
	hook.Run("OnReloadedWep", self)
end

SWEP.CanSuicide = true

game.AddParticles("particles/tfa_smoke.pcf")
PrecacheParticleSystem("smoke_trail_tfa")
PrecacheParticleSystem("smoke_trail_wild")

local vector_full = Vector(1, 1, 1)

function SWEP:HintShow(lply,fraction,trace)
	wn.BasicHudHint(self,lply,fraction,trace)
end

if CLIENT then
	SWEP.HowToUseInstructions = "<font=ZCity_Tiny>"..string.upper( input.LookupBinding("+use") ).." to pickup</font>"
end
SWEP.StartAtt = {}
function SWEP:Initialize()
	self:SetLastShootTime(0)
	self.LastPrimaryDryFire = 0
	self:Initialize_Spray()
	self:Initialize_Anim()
	self:Initialize_Reload()
	self:SetClip1(self.Primary.DefaultClip)
	self:Draw()

	self.AdditionalPos = Vector(0,0,0)
	self.AdditionalPos2 = Vector(0,0,0)
	self.AdditionalAng = Angle(0,0,0)
	self.AdditionalAng2 = Angle(0,0,0)

	if CLIENT then
		self.HudHintMarkup = markup.Parse("<font=ZCity_Tiny>".. self.PrintName .."</font>\n<font=ZCity_SuperTiny><colour=125,125,125>".. self.HowToUseInstructions .."</colour></font>",450)
	end

	self:MapEvents()

	if self:GetOwner():IsNPC() then
		if self.HoldType == "rpg" then
			self.HoldType = "smg"
		end
		self:SetHoldType( self.HoldType )
	end
	
	self.SlotPos = self:IsPistolHoldType() and 1 or 2

	self.deploy = CurTime() + self.CooldownDeploy / self.Ergonomics

	self:ClearAttachments()

	self.AmmoTypes = self.AmmoTypes2[self.Primary.Ammo]

	self:WorldModel_Transform()

	table.insert(wn.weapons,self)
	self.ishgweapon = true

	if SERVER then
		self:SetNetVar("attachments",self.attachments)
	end

	if CLIENT then
		if not IsValid(self.worldModel) then
			self:CreateWorldModel()
		end

		self:CallOnRemove("asdasd", function()
			if self.flashlight and self.flashlight:IsValid() then
				self.flashlight:Remove()
				self.flashlight = nil
			end
		end)
	end

	self:AddCallback("PhysicsCollide", function(ent, data)
		self:PhysicsCollide(ent, data)
	end)

	self.init = false
	
	timer.Simple(0.1,function()
		if IsValid(self) and self.PlayAnim then self:PlayAnim("idle", 1, not self.NoIdleLoop) end
		if self.AmmoTypes and SERVER then
			self:ApplyAmmoChanges(1)
		end
	end)

	if SERVER then wn.SyncWeapons() end
	self:InitializePost()
end

function SWEP:PhysicsCollide(ent, data)
	if !self.CantFireFromCollision and (!self.lastshotfromhit or (self.lastshotfromhit + 0.5 < CurTime())) and data.Speed > 250 and math.random(45) == 1 then
		self:PrimaryAttack()
		self.lastshotfromhit = CurTime()
	end
end

SWEP.WepSelectIcon2 = Material("null")
SWEP.IconOverride = ""

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( self.WepSelectIcon2 )
	if not self.IconEdited then
		self.WepSelectIcon2:SetInt("$flags", 32)
		self.IconEdited = true
	end
	if self.WepSelectIcon2box then
		surface.DrawTexturedRect( x + wide/2 - (wide/1.95)/2, y,  wide/1.95 , wide/1.95 )
	else
		surface.DrawTexturedRect( x, y,  wide , wide/2)
	end

	render.PopFilterMin()
	render.PopFilterMag()

	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end

if CLIENT then
	hook.Add("OnGlobalVarSet","hg-weapons",function(key,var)
		if key == "weapons" then
			wn.weapons = var
		end
	end)

	hook.Add("OnNetVarSet","weapons-net-var",function(index,key,var)
		if key == "attachments" then
			local ent = Entity(index)

			ent.attachments = nil
			if ent.modelAtt then
				for atta, model in pairs(ent.modelAtt) do
					if not atta then continue end
					if IsValid(model) then model:Remove() end
					ent.modelAtt[atta] = nil
				end
			end

			ent.attachments = var
		end
	end)
else
	function wn.SyncWeapons()
		SetNetVar("weapons",wn.weapons)
	end
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:OwnerChanged()
	self.init = true
	self.reload = nil
	
	if CLIENT and IsValid(self.worldModel) then
		self.worldModel:Remove()
	end

	//self:PlayAnim("idle", 1, not self.NoIdleLoop)

	if not IsValid(self:GetOwner()) then
		self.deploy = nil
		self:SetDeploy(0)
	
		self.holster = nil
		self:SetHolster(0)
		
		return
	else
		self.SlotPos = self:IsPistolHoldType() and 1 or 2
	end

	if SERVER then
		self:SetNetVar("attachments",self.attachments)
	end
end

function SWEP:InitializePost()
end

wn.weaponsDead = wn.weaponsDead or {}
function SWEP:OnRemove()
	if SERVER then
		table.RemoveByValue(wn.weapons,self)

		SetNetVar("weapons",wn.weapons)
	end
end

local owner
local CurTime = CurTime
function SWEP:IsZoom()
	local owner = self:GetOwner()
	return self:CanUse() and (self:GetButtstockAttack() - CurTime() < -1) and (self:GetOwner():IsPlayer() and self:KeyDown(IN_ATTACK2)) and !(self:IsSprinting() and !IsValid(owner.FakeRagdoll)) and ((IsValid(owner.FakeRagdoll) and self:KeyDown(IN_USE)) or (owner:IsOnGround() or owner:InVehicle())) and not owner.suiciding and !(owner.organism and (owner.organism.larm and !self:IsPistolHoldType()) and owner.organism.rarm and (owner.organism.larm > 0.99 or owner.organism.rarm > 0.99))-- and owner.posture ~= 1 and owner.posture ~= 3-- and (not IsValid(owner.FakeRagdoll) or self:KeyDown(IN_JUMP))
end

function SWEP:CanUse()
    local owner = self:GetOwner()
	if not IsValid(owner) then return true end
    if owner:IsNPC() then return true end
    return not (self.reload or self.deploy or (owner:IsPlayer() and (self:IsSprinting() or (owner.organism and owner.organism.otrub))))
end

function SWEP:IsSprinting()
	local ply = self:GetOwner()
	return not ply:IsNPC() and (self:KeyDown(IN_SPEED)) and ply:GetVelocity():LengthSqr() > 170 * 170 and not IsValid(ply.FakeRagdoll)
end

function SWEP:IsLocal()
	return CLIENT and self:GetOwner() == LocalPlayer()
end

function SWEP:IsLocal2()
	return CLIENT and self:GetOwner() == LocalPlayer() and LocalPlayer() == GetViewEntity()
end
local hg_quietshots = GetConVar("hg_quietshots") or CreateClientConVar("hg_quietshots", "0", true, false, "quieter gun sounds", 0, 1)
local hg_gunshotvolume = GetConVar("hg_gunshotvolume") or CreateClientConVar("hg_gunshotvolume", "1", true, false, "volume of gun sounds", 0, 1)

local math_random = math.random
function SWEP:PlaySnd(snd, server, chan, vol, pitch, entity, tripleaffirmative)
	if SERVER and not server then return end
	local owner = self:GetOwner()
	owner = IsValid(owner) and owner or self

	if CLIENT then
		local view = render.GetViewSetup(true)
		local time = owner:GetPos():Distance(view.origin) / 17836

		timer.Simple(time, function()
			if not IsValid(self) then return end
			local ent = wn.GetCurrentCharacter(self:GetOwner())
			owner = IsValid(owner) and owner or self

			if type(snd) == "table" then
				local rand = math.random(-5,5)
				EmitSound( snd[1], owner:GetPos(), (entity or owner:EntIndex()) + owner:EntIndex(), CHAN_WEAPON, vol, snd[2] or (self.Supressor and 75 or 75), nil, (pitch or 100) + rand)
				if tripleaffirmative and !hg_quietshots:GetBool() then
					EmitSound( snd[1], owner:GetPos()-vector_up, (entity or owner:EntIndex()) + 1 + owner:EntIndex(), CHAN_WEAPON, vol, snd[2] or (self.Supressor and 75 or 75), nil, (pitch or 100) + rand)
					EmitSound( snd[1], owner:GetPos(), (entity or owner:EntIndex()) + 2 + owner:EntIndex(), CHAN_WEAPON, vol, (snd[2] or (self.Supressor and 75 or 75)) + 1, nil, (pitch or 100) + rand)
				end
				--self:EmitSound(snd[1], (snd[2] or (self.Supressor and 75 or 75)), (pitch or 100) + rand, vol, CHAN_AUTO)
			else
				local rand = math.random(-5,5)
				EmitSound( snd, owner:GetPos(), (entity or owner:EntIndex()) + owner:EntIndex(), CHAN_WEAPON, vol, (self.Supressor and 75 or 75), nil, (pitch or 100) + rand)
				if tripleaffirmative and !hg_quietshots:GetBool() then
					EmitSound( snd, owner:GetPos()-vector_up, (entity or owner:EntIndex()) + 1 + owner:EntIndex(), CHAN_WEAPON, vol, (self.Supressor and 75 or 75), (pitch or 100) + rand)
					EmitSound( snd, owner:GetPos(), (entity or owner:EntIndex()) + 2 + owner:EntIndex(), CHAN_WEAPON, vol, ((self.Supressor and 75 or 75)) + 1, nil, (pitch or 100) + rand)
				end
				--self:EmitSound(snd[1], ((self.Supressor and 75 or 75)), (pitch or 100) + rand, vol, CHAN_AUTO)
			end
		end)
	else
		if type(snd) == "table" then
			EmitSound(snd[1], owner:GetPos(), owner:EntIndex(), chan or CHAN_ITEM, 1, snd[2] or (self.Supressor and 75 or 75), 0, math_random(snd[3] or 100, snd[4] or 100), 1)
		else
			EmitSound(snd, owner:GetPos(), owner:EntIndex(), chan or CHAN_ITEM, 1, self.Supressor and 75 or 75, 0, 100, 1)
		end
	end
end

wn.PlaySnd = SWEP.PlaySnd

SOUND_LEVEL_GUNFIRE = 150

function SWEP:PlaySndDist(snd)
	if SERVER then return end
	local owner = IsValid(self:GetOwner().FakeRagdoll) and self:GetOwner().FakeRagdoll or self:GetOwner()
	owner = IsValid(owner) and owner or self
	local view = render.GetViewSetup(true)
	local pos = owner:GetPos() + vector_up * 72
	local dist = owner:GetPos():Distance(view.origin)
	local time = dist / 17836
	

	local bRoom = util.IsSkyboxVisibleFromPoint(pos)
	
	timer.Simple(time, function()
		if not IsValid(self) or not IsValid(self:GetOwner()) then return end

		local owner = IsValid(self) and (IsValid(self:GetOwner()) and (IsValid(self:GetOwner().FakeRagdoll) and self:GetOwner().FakeRagdoll or self:GetOwner()) or self)
		owner = IsValid(owner) and owner
		if not owner then return end
		
		local roomMultiplier = bRoom and 1.0 or 0.7
		local suppressorVolume = self.Supressor and (self.DOZVUK and 10 or 60) or 150
		local finalVolume = suppressorVolume * roomMultiplier

		EmitSound(snd, owner:GetPos(), owner:EntIndex(), CHAN_STATIC, 1, finalVolume, 0, 90, SOUND_LEVEL_GUNFIRE)

		local farPitch = math.Clamp(100 - (dist / 1000), 75, 95)
		if dist > 1000 then
			EmitSound(snd, owner:GetPos(), owner:EntIndex() + 1, CHAN_STATIC, 1, finalVolume * 1.2, 0, farPitch, SOUND_LEVEL_GUNFIRE)
		end
	end)
end

local math_Rand = math.Rand
local matrix, matrixSet
local math_random = math.random
local primary
local weapons_Get = weapons.Get
if SERVER then util.AddNetworkString("hgwep shoot") end
function SWEP:CanPrimaryAttack()
	//local owner = self:GetOwner()
	--[[if owner.suiciding then
		if (owner:GetNetVar("suicide_time",CurTime()) + 8) < CurTime() then if SERVER then owner:SetNetVar("suicide_time",nil) end return true end
		if SERVER and owner:KeyPressed(IN_ATTACK) then owner:SetNetVar("suicide_time",owner:GetNetVar("suicide_time",CurTime()) - 0.5) end
		return false
	end--]]
	return true
end

hook.Add("Player Think","huyhuy",function(ply)
	local wep = ply:GetActiveWeapon()
	if !wep.ishgweapon then ply.suiciding = false end
end)

function SWEP:PrimaryShootPre()
end

function SWEP:Shoot(override)
	--self:GetWeaponEntity():ResetSequenceInfo()
	--self:GetWeaponEntity():SetSequence(1)
	self:PrimaryShootPre()
	if self:GetOwner():IsNPC() then self.drawBullet = true end
	if not self:CanPrimaryAttack() then return false end
	if self:KeyDown(IN_USE) and !IsValid(self:GetOwner().FakeRagdoll) then return false end
	if not self:CanUse() then return false end
	if CLIENT and self:GetOwner() != LocalPlayer() and not override then return false end
	local primary = self.Primary
	if override then self.drawBullet = override end
	
	if not self.drawBullet or (self:Clip1() == 0 and not override) then
		self.LastPrimaryDryFire = CurTime()
		self:PrimaryShootEmpty()
		primary.Automatic = false
		return false
	end
	
	if IsValid(self:GetOwner()) and not self:GetOwner():IsNPC() and primary.Next > CurTime() then return false end
	if IsValid(self:GetOwner()) and not self:GetOwner():IsNPC() and (primary.NextFire or 0) > CurTime() then return false end
	
	primary.Next = CurTime() + primary.Wait * 1.1
	primary.RealAutomatic = primary.RealAutomatic or weapons_Get(self:GetClass()).Primary.Automatic
	primary.Automatic = primary.RealAutomatic
	self:PrimaryShoot()
	self:PrimaryShootPost()
end

function SWEP:PrimaryAttack()
	if CLIENT and not IsFirstTimePredicted() then return end
	if CLIENT and not self:IsClient() then return end
	
	local huy = self:Shoot() ~= false
	if SERVER then
		net.Start("hgwep shoot")
		net.WriteEntity(self)
		net.WriteBool(huy)
		net.Broadcast()
	end
end

function SWEP:PrimaryShootPost()
end

function SWEP:Draw(server)
	if self.drawBullet == false then
		if SERVER and server then self:RejectShell(self.ShellEject) end
		if CLIENT and not server then self:RejectShell(self.ShellEject) end
		self.drawBullet = nil
	end

	if self:Clip1() > 0 then self.drawBullet = true end
end

SWEP.AutomaticDraw = true
SWEP.ShootAnimMul = 2
function SWEP:PrimaryShoot()
	local ammotype = wn.ammotypeshuy[self.Primary.Ammo].BulletSettings
	if ammotype.IsBlank then
		self.dwr_reverbDisable = nil
		self.shooanim = self.ShootAnimMul

		if not (CLIENT and self:GetOwner():IsNPC()) then
			self:TakePrimaryAmmo(1)
		end

		self.drawBullet = false
		if self.AutomaticDraw then self:Draw() end
		self:PlaySnd(self.Primary.SoundEmpty, true, CHAN_AUTO)
		return
	end
	self:EmitShoot()
	--if SERVER or self:IsClient() then
		self:FireBullet()
	--end
	self.dwr_reverbDisable = nil
	self.shooanim = self.ShootAnimMul
	self.shot = self.shot or 0
	self.shot = math.min(3, self.shot + (self.NumBullet or 1))

	if not (CLIENT and self:GetOwner():IsNPC()) then
		self:TakePrimaryAmmo(1)
	end

	self.drawBullet = false
	if self.AutomaticDraw then self:Draw() end
	self:PrimarySpread()
end

SWEP.SightSlideOffset = 1

function SWEP:PrimaryShootEmpty()
	if CLIENT then return end
	self:PlaySnd(self.Primary.SoundEmpty, true, CHAN_AUTO)
end

SWEP.DistSound = "m4a1/m4a1_dist.wav"
SWEP.NewSoundClose = nil
SWEP.NewSoundDist = nil
SWEP.NewSoundSupressor = nil

if SERVER then
	util.AddNetworkString("resettinnitus")

	hook.Add("PlayerSpawn","ResetTinnitus",function(ply)
		if OverrideSpawn then return end
		net.Start("resettinnitus")
		net.WritePlayer(ply)
		net.Send(ply)
	end)
else
	net.Receive("resettinnitus", function(len, ply)
		local ply = net.ReadPlayer() or ply
		ply.TinnitusFactor = 0
	end)

	hook.Add("Player Think", "TinnitusPadaet", function(ply, ent)
		if (ply.TinnitusFactor or 0) > 0 then
			ply.TinnitusFactor = math.min(math.max((ply.TinnitusFactor or 0) - 0.5, 0),102)
			
		end
	end)
end

function SWEP:EmitShoot()
	if SERVER then return end
	local snd_new = "sounds_zcity/"..(string.Replace(self:GetClass(),"weapon_","")).."/"
	local snd_close = snd_new.."close.wav"
	local snd_suppressor = snd_new.."supressor.wav"
	local snd_dist = snd_new.."dist.wav"

	local vol = hg_gunshotvolume:GetFloat()
	local ply = self:GetOwner()

	if CLIENT then
		if IsValid(lply) and lply.armors and lply.armors["ears"] == "headphones1" then
			vol = vol / 2
		end
	end

	self.Supressor = (self:HasAttachment("barrel", "supressor") and true) or self.SetSupressor
	
	if not self.Supressor and !self.NoWINCHESTERFIRE then self:PlaySnd("rifle_win1892/win1892_fire_01.wav", nil, nil, vol, math.Clamp(1 / self.Primary.Force / (self.NumBullet or 1) * 100 * 50,90,150), 55555, true) end

	if (self.Primary.SoundFP or self.Supressor and self.SupressedSoundFP) and (GetViewEntity() == ply or GetViewEntity():GetPos():Distance( self:GetPos() ) < 150) then
		self:PlaySnd((self.Supressor and self.SupressedSoundFP) or self.Primary.SoundFP, nil, nil, vol, nil, 55533, not self.Supressor)
	else
		self:PlaySnd(self.Supressor and (self.SupressedSound or (self:IsPistolHoldType() and "whitenoise/weapons/pistols/sil.wav" or "m4a1/m4a1_suppressed_fp.wav")) or self.Primary.Sound, nil, nil, vol, nil, 55533, not self.Supressor)
	end
	self:PlaySndDist(self.DistSound, nil, nil, nil, nil, 55511, not self.Supressor)
end

function SWEP:CanSecondaryAttack()
end

function SWEP:SecondaryAttack()
end

PISTOLS_WAIT = 0.1

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:GetInfo()
	if not IsValid(self) then return {self.Primary.ClipSize,wn.ClearAttachments(self.ClassName)} end -- дурак
	return {self:Clip1(),self:GetNetVar("attachments")}
end

function SWEP:SetInfo(info)
	if not info then return end
	self:SetClip1(info[1] or self:GetMaxClip1())
	self.attachments = info[2] or {}
	self:SetNetVar("attachments", self.attachments)
end

local colBlack = Color(0, 0, 0, 125)
local colWhite = Color(255, 255, 255, 255)
local yellow = Color(255, 255, 0)
local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local lerpAmmoCheck = 0
local function LerpColor(lerp, source, set)
	return Lerp(lerp, source.r, set.r), Lerp(lerp, source.g, set.g), Lerp(lerp, source.b, set.b)
end

local col = Color(0, 0, 0)
local col2 = Color(0, 0, 0)
local dynamicmags
local instructions 
if CLIENT then
	surface.CreateFont("AmmoFont",{
		font = "Bahnschrift",
		size = ScreenScale(16),
		extended = true,
		weight = 500,
		antialias = true
	})

	surface.CreateFont("DescFont",{
		font = "Bahnschrift",
		size = ScreenScale(8),
		extended = true,
		shadow = true,
		weight = 500,
		antialias = true
	})

	dynamicmags = CreateClientConVar("hg_dynamic_mags", "0", true, false, "Enables dynamic ammo show when shooting",0,1)
	instructions = CreateClientConVar("hg_instructions","1", true, false, "Enables gun instructions",0,1)
end

function SWEP:DrawHUDAdd()
end

local blur = Material( "pp/blurscreen" )
local function DrawBlurRect(x, y, w, h, dens, alpha)

	local lightness = alpha and 80*math.Clamp(alpha,0,255)/255 or 50

	draw.RoundedBox(0,x,y,w,h,Color(0,0,0,lightness))
   	surface.SetDrawColor(0,0,0)
end

	--local clipsize = (self:GetMaxClip1() + (self.OpenBolt and 0 or 1))
	--local owner = self:GetOwner()
	--local attpos = self:GetMuzzleAtt(nil, true, true).Pos
	--local posX,posY = dynamicmags:GetBool() and attpos:ToScreen().x + 50 or ScrW() - ScrW() / 4, dynamicmags:GetBool() and attpos:ToScreen().y + 90 or ScrH() - ScrH() / 6
	--local sizeX,sizeY =  (clipsize == 1 and ScrH() / 15 or ScrW() / 40) * scale, (clipsize == 1 and ScrH() / 80 or ScrH() / 10) * scale
--
--
	--lerpAmmoCheck = Lerp(owner:KeyDown(IN_RELOAD) and 0.5 or 0.02, lerpAmmoCheck, self:KeyDown(IN_RELOAD) and 1 or (dynamicmags:GetBool() and 0 or 0.0))
	--colBlack.a = 125 * lerpAmmoCheck
	--colWhite.a = 255 * lerpAmmoCheck
	--local ammoLeft = math.ceil(self:Clip1() / clipsize * sizeY)
	--local ammo = owner:GetAmmoCount(self:GetPrimaryAmmoType())
	--local magCount = math.ceil(ammo / clipsize)
--
	--col:SetUnpacked(LerpColor(ammoLeft / sizeY, yellow, color_white))
	--col.a = 255 * lerpAmmoCheck
	--if col.a > 1 then
	--	DrawBlurRect(posX-sizeX*(clipsize ~= 1 and .2 or .3),posY-sizeY*(clipsize ~= 1 and .1 or .7),(sizeX+sizeX*(clipsize ~= 1 and .12 or .2)) * (math.max(math.min(magCount+1,(clipsize ~= 1 and 5 or 4)),1.3)), sizeY + (clipsize ~= 1 and 20 or 60),7,col.a*5)
	--end
	--
	--local color = col
	--surface.SetDrawColor(color)
	--surface.DrawRect(posX,posY - ammoLeft + sizeY, sizeX, ammoLeft, 1)
	--surface.DrawOutlinedRect(posX - 5, posY - 5, sizeX + 10, sizeY + 10, 1)
--
	--local posX,posY = posX + (clipsize == 1 and ScrW() / 40 or ScrW() / 50), posY + (clipsize == 1 and ScrH()/70 or ScrH() / 20)
	--local sizeX,sizeY = sizeX / 2,sizeY / 2
--
	--for i = 1,magCount do
	--	if i > 3 then continue end
	--	local ammoasd = math.min(clipsize,ammo)
	--	ammo = ammo - ammoasd
	--	
	--	local ammoLeft = math.ceil(ammoasd / clipsize * sizeY)
	--	
	--	col2:SetUnpacked(LerpColor(ammoLeft / sizeY, yellow, color_white))
	--	col2.a = 255 * lerpAmmoCheck
	--	surface.SetDrawColor(col2)
	--	surface.DrawRect(posX + (sizeX + 15) * i,posY - ammoLeft + sizeY, sizeX, ammoLeft, 1)
	--	surface.DrawOutlinedRect(posX - 5 + (sizeX + 15) * i,posY - 5, sizeX + 10, sizeY + 10, 1)
	--end
--
	--if magCount > 3 then
	--	draw.SimpleText("+"..magCount-3,"AmmoFont",posX + (sizeX + 15) * 4 + 1, posY + sizeX/2 + 1,Color(0,0,0,255*lerpAmmoCheck),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	--	draw.SimpleText("+"..magCount-3,"AmmoFont",posX + (sizeX + 15) * 4 , posY + sizeX/2,Color(255,255,255,255*lerpAmmoCheck),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	--end
	

	--self.hudinspect = self.hudinspect or 0
	--if instructions:GetBool() and self.hudinspect - (CurTime()-6) > 0 then
	--	self.InfoAlpha = Lerp(FrameTime() * 10,self.InfoAlpha or 0,math.min(self.hudinspect - (CurTime() - 5),1)*255)
	--	local txt = self.Instructions
	--	if not self.InfoMarkup1 then
	--		self.InfoMarkup1 = markup.Parse( "<font=DescFont>"..txt.."</font>", 450 )
	--	end
	--	DrawBlurRect(posX - 5 - self.InfoMarkup1:GetWidth() - ScrW()*0.05, posY - self.InfoMarkup1:GetHeight()/2 - 5, self.InfoMarkup1:GetWidth()+10, self.InfoMarkup1:GetHeight()+10, 8, self.InfoAlpha)
	--	self.InfoMarkup1:Draw(posX- ScrW()*0.05,posY,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,self.InfoAlpha)
	--end

local scale = 1
local developer = GetConVar("developer")


local function DrawBullet(matIcon, x, y, size, cColor)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
		surface.SetDrawColor(cColor)
		surface.SetMaterial(matIcon or matPistolAmmo)
		surface.DrawTexturedRect(x-size/2,y-size,size,size)
	render.PopFilterMin()
end

if CLIENT then
	local scrW, scrH = ScrW(), ScrH()
	local lastShoot = 0
	local StopShowBullet = false
	local WhiteColor = Color(200,200,200,255)

	local coloruse = Color(255,255,255,255)

	local matPistolAmmo = Material("vgui/hud/bullets/low_caliber.png")
	local matRfileAmmo = Material("vgui/hud/bullets/high_caliber.png")
	local matShotgunAmmo = Material("vgui/hud/bullets/buck_caliber.png")
	local lerpAmmoCheck = 0
	local ammoCheck = 0
	local color_bg = Color(0,0,0,150)
	local ammoLongCheck = 0
	SWEP.DrawAmmoMetods = {
		["Default"] = function(self,texture)
			local clipsize = self:GetMaxClip1() + (self.OpenBolt and 0 or 1)
			local clip = self:Clip1()
			local owner = self:GetOwner()
			local shoot = CurTime() - self:LastShootTime()
			local ammo = owner:GetAmmoCount(self:GetPrimaryAmmoType())
			local magCount = self.AnimInsert and ammo or math.ceil(ammo / clipsize)
			local posX = scrW*0.75
			local posX2 = scrW*0.8
			local HudHPos = 0.8
			
			lastShoot = LerpFT(0.5,lastShoot, shoot > 0 and 1 or 0)
			lastShootFor = lastShoot
			self.hudinspect = self.hudinspect or 0
			if self.hudinspect > CurTime() or (clip < clipsize/3 and lastShoot < 0.9 and dynamicmags:GetBool()) or self:KeyDown(IN_RELOAD) then
				ammoCheck = CurTime() + 1	
			end
			ammoLongCheck = LerpFT(0.025,ammoLongCheck, (self:KeyDown(IN_RELOAD) or self.hudinspect > CurTime()) and 5 or 0)
			
			if ammoLongCheck > 4 then
				local text = (
					(clip > clipsize - (self.OpenBolt and 0 or 1) - 1) and "Full" or 
					(clip <= clipsize and clip > clipsize/1.5 ) and "~ Full" or 
					(clip <= clipsize/1.5 and clip > clipsize/3.5) and "~ Half" or 
					(clip <= clipsize/3.5 and clip != 0 ) and "~ Almost Empty" or 
					(clip == 0 and "Empty")
				)
				coloruse.r = 0
				coloruse.g = 0
				coloruse.b = 0
				coloruse.a = 210*math.max(ammoLongCheck-4,0)
				draw.SimpleText(text,"AmmoFont",scrW*0.8 + 2, scrH*HudHPos + scrH*0.05 + 2,coloruse,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				coloruse.r = 255
				coloruse.g = 255
				coloruse.b = 255
				coloruse.a = 210*math.max(ammoLongCheck-4,0)
				draw.SimpleText(text,"AmmoFont",scrW*0.8, scrH*HudHPos + scrH*0.05,coloruse,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end

			lerpAmmoCheck = LerpFT((ammoCheck > CurTime()) and 0.2 or 0.1, lerpAmmoCheck, ammoCheck > CurTime() and 1 or 0)
			local Yellow = (( clipsize/clip )-1)/(clipsize/5)
			--print(Yellow)
			color_bg.r = 55*Yellow
			--draw.RoundedBox(0,scrW*0.75-(scrH*0.12/2),scrH*0.72,scrH*0.12,scrH*0.18,ColorAlpha(color_black,50))
			color_bg.a = (250*lastShoot) * lerpAmmoCheck
			WhiteColor.a = (150*lastShoot) * lerpAmmoCheck
			local PosLerp = Lerp(math.ease.OutExpo(lerpAmmoCheck),150,0)
			--print(PosLerp)
			if clip > 0 then
				DrawBullet(texture,posX - (scrH*0.16)+(scrH*0.08)*(1+lastShoot) + 2 + PosLerp,scrH*(HudHPos) + 2,scrH*0.08, color_bg)
				DrawBullet(texture,posX - (scrH*0.16)+(scrH*0.08)*(1+lastShoot) + PosLerp,scrH*(HudHPos),scrH*0.08, WhiteColor)
				--if lastShoot < 0.2 then StopShowBullet = true end
			end
			--if StopShowBullet then
			--	lastShootFor = 0 
			--	if lastShoot > 0.6 then
			--		StopShowBullet = false
			--	end
			--else
			--end
			--print(clipsize)
			--print(lastShoot)
			for i = 2, clip do
				if i > 6 and lastShootFor > 0.5 or i > 7 then continue end
				i = i - 1
				local PosAdjust = math.max(PosLerp - i*15,0)
				--print(PosAdjust)
				if i < 2 then
					DrawBullet(texture,posX + 2 + PosAdjust,scrH*((HudHPos) + i*(0.026*lastShoot))+2,scrH*0.08, color_bg)
					DrawBullet(texture,posX + PosAdjust,scrH*((HudHPos) + i*(0.026*lastShoot)),scrH*0.08, WhiteColor)
				else
					color_bg.a = (210 - (20 * i)) * lerpAmmoCheck
					WhiteColor.a = (210 - (20 * i) )* lerpAmmoCheck
					DrawBullet(texture,posX+2 + PosAdjust,scrH*((HudHPos - 0.026) + i*0.026+(0.026*lastShootFor))+2,scrH*0.08, color_bg)
					DrawBullet(texture,posX + PosAdjust,scrH*((HudHPos - 0.026) + i*0.026+(0.026*lastShootFor)),scrH*0.08, WhiteColor)
				end
			end

			if magCount > 0 then
				coloruse.r = 0
				coloruse.g = 0
				coloruse.b = 0
				coloruse.a = 210*lerpAmmoCheck
				draw.SimpleText("+"..magCount,"AmmoFont",posX2 + 2, scrH*HudHPos + 2,coloruse,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				coloruse.r = 255
				coloruse.g = 255
				coloruse.b = 255
				coloruse.a = 210*lerpAmmoCheck
				draw.SimpleText("+"..magCount,"AmmoFont",posX2, scrH*HudHPos,coloruse,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			--draw.SimpleText("lastShoot: "..lastShoot,"Default",0,0)
		end
	}

	SWEP.AmmoDrawMetod = "Default"

	function SWEP:DrawHUD()
		if not IsValid(self:GetOwner()) then return end
		local ammotype = wn.ammotypeshuy[self.Primary.Ammo].BulletSettings and wn.ammotypeshuy[self.Primary.Ammo].BulletSettings.Icon or matPistolAmmo
		self.DrawAmmoMetods[self.AmmoDrawMetod](self,ammotype)
		
		self.isscoping = false
		if self.attachments then
			for plc,att in pairs(self.attachments) do
				if not self:HasAttachment(plc) then continue end
				if wn.attachments[plc][att[1]].sightFunction then
					wn.attachments[plc][att[1]].sightFunction(self)
				end
			end
		end
		self:ChangeFOV()
		self:CheckBipod()
		self:DrawHUDAdd()
		if self.dort then self:DoRT() end

		self.hudinspect = self.hudinspect or 0

		--[[if developer:GetBool() and LocalPlayer():IsAdmin() then
			local _,tr = self:CloseAnim()
			cam.Start3D()
				render.DrawLine(tr.StartPos,tr.HitPos,color_white,true)
			cam.End3D()
		end--]]
	end
end

if CLIENT then
	local hook_Run = hook.Run
	hook.Add("Think", "whitenoise-weapons", function()
		for i,wep in ipairs(wn.weapons) do
			--local wep = ply:GetActiveWeapon()

			if not IsValid(wep) or not wep.Step or (not IsValid(wep:GetOwner()) and wep:GetVelocity():LengthSqr() < 5) then continue end
			--hook_Run("SWEPStep", wep)
			if wep.NotSeen or not wep.shouldTransmit then continue end
			//if (wep.lasttimetick or 0) > CurTime() then continue end
			local owner = wep:GetOwner()
			//wep.lasttimetick = CurTime() + (IsValid(owner) and owner:IsPlayer() and (owner == LocalPlayer() or owner == LocalPlayer():GetNWEntity("spect")) and 0 or 0.1)
			if IsValid(owner) and owner:IsPlayer() then
				wep:Step_HolsterDeploy(CurTime())
				continue
			end
			wep:Step()
		end
	end)

	hook.Add("Player Think", "OwOasss", function(ply)
		local wep = ply:GetActiveWeapon()
		if wep and IsValid(wep) and wep.Step then
			wep:Step()
		end
	end)
end

if SERVER then
	hook.Add("Think", "whitenoise-weapons", function()
		for i,wep in ipairs(wn.weapons) do
			if wep:GetClass() != "weapon_taser" then continue end
			if not IsValid(wep) or not wep.Step or (not IsValid(wep:GetOwner()) and wep:GetVelocity():Length() < 1) then continue end

			if not IsValid(wep:GetOwner()) and wep:GetVelocity():Length() > 1 then
				wep:Step()
			end
		end
	end)
end

function SWEP:Think()
	if SERVER then
		self:Step()
	end
end

function SWEP:Step()
	self:CoreStep()
end

local CurTime = CurTime
if CLIENT then
	SWEP.particleEffect = nil

	local vecSmoke = Vector(255, 255, 255)
	function SWEP:MuzzleEffect(time_)
		//local tr, pos, ang = self:GetTrace()
		local att = self:GetMuzzleAtt(gun, true)
		if not att then return end
		local pos, ang = att.Pos, att.Ang

		local owner = self:GetOwner()

		local lastdmg = self.dmgStack
		local lastdmgMul = lastdmg / 100
		
		if time_ < 0.5 and self.SprayI == 0 then
			if not IsValid(self.particleEffect) then
				self.particleEffect = CreateParticleSystemNoEntity("smoke_trail_tfa", pos, ang)
				self.particleEffectCreateTime = CurTime()
			end
		end
		
		if IsValid(self.particleEffect) then
			self.particleEffect:SetControlPoint(0, pos)
			
			if self.particleEffectCreateTime + 2 < CurTime() then
				self.particleEffect:StopEmission()
			end

			if self.particleEffectCreateTime + 4 < CurTime() then
				self.particleEffect:StopEmissionAndDestroyImmediately()
				self.particleEffect = nil
			end

			if IsValid(owner) and owner:IsPlayer() and IsValid(owner:GetActiveWeapon()) and owner:GetActiveWeapon() ~= self and self.shouldntDrawHolstered then
				if IsValid(self.particleEffect) then
					self.particleEffect:StopEmission()
				end
			end
		end
	end
else
	function SWEP:MuzzleEffect(time)
	end
end

function SWEP:CoreStep()
	local owner = self:GetOwner()
	local actwep = owner.GetActiveWeapon and owner:GetActiveWeapon() or nil

	if self:GetClass() == "weapon_taser" then
		self:WorldModel_Transform()
	end

	if CLIENT and IsValid(self:GetWeaponEntity()) then self:GetWeaponEntity():SetLOD(0); end

	if SERVER and (not IsValid(owner) or (IsValid(actwep) and self != actwep)) then return end

	local dtime = SysTime() - (self.dtimethink or SysTime())
	local time = CurTime()
	
	if IsValid(owner) then
		self:Step_HolsterDeploy(time)
	end

	//if SERVER and self.UseCustomWorldModel then
		self:ChangeGunPos()
		self:GetAdditionalValues()
	//end

	if CLIENT and IsValid(self:GetWM()) and (self:GetWM():GetSequence() == 0) then self:PlayAnim("idle", 1, not self.NoIdleLoop) end
	
	--[[if CLIENT and ((self.cooldown_transform or 0) < CurTime()) then
		self.cooldown_transform = CurTime() + 0.05

		self:CloseAnim(dtime)
	end]]

	--[[if SERVER and ((self.cooldown_transform or 0) < CurTime()) then
		self.cooldown_transform = CurTime() + 0.05

		self:CloseAnim(dtime)

		--self:WorldModel_Transform()
	end]]

	--[[if owner:IsPlayer() then
		local inv = owner:GetNetVar("Inventory")
		
		local noSling = inv and (not inv["Weapons"] or not inv["Weapons"]["hg_sling"])
		
		if not noSling then owner.holdingWeapon = nil end

		if not self.shouldntDrawHolstered and noSling then
			owner.holdingWeapon = owner:GetActiveWeapon() ~= self and self or nil
		end
	end--]]
	
	if not self.reload and self.RevertMag then
		self:RevertMag()
	end

	if CLIENT then
		self.sprayAngles = Lerp(wn.lerpFrameTime2(0.1,dtime),self.sprayAngles or Angle(0,0,0),angle_zero)
	end

	if owner.suiciding and not wn.CanSuicide(owner) then owner.suiciding = false end

	--	if SERVER and self.UseCustomWorldModel then self:WorldModel_Transform() end

	if SERVER and not owner:IsNPC() and self != actwep then
		--local inv = owner:GetNetVar("Inventory",{})

		if not (inv["Weapons"] and inv["Weapons"]["hg_sling"] and not self:IsPistolHoldType()) then
			//wn.drop(owner, self)
			hook.Run("PlayerDropWeapon", owner)
		end
	end

	if SERVER and not owner:IsNPC() and owner.organism and (not owner.organism.canmove or ((owner.organism.stun - CurTime()) > 0) or (owner.organism.larm == 1 and owner.organism.rarm == 1)) and IsValid(actwep) and self == actwep then
		self:RemoveFake()
		
		local inv = owner:GetNetVar("Inventory",{})
		if not (inv["Weapons"] and inv["Weapons"]["hg_sling"] and not self:IsPistolHoldType()) then
			//wn.drop(owner, self)
			hook.Run("PlayerDropWeapon", owner)
		else
			hook.Run("PlayerDropWeapon", owner)
			//owner:SetActiveWeapon(owner:GetWeapon("weapon_hands_sh"))
		end

		return
	end
	
	if CLIENT then
		local time2 = time - self:LastShootTime()

		self:MuzzleEffect(time2)
	end

	if not IsValid(owner) or (IsValid(actwep) and self != actwep) then return end

	self:Step_Inspect(time)
	self:Step_Reload(time)
	self:ClearAnims()
	-- self:Animation(time)

	if CLIENT then
		if self.Primary.Next + 1 < time then 
			//self.dmgStack = 0
			--self.dmgStack2 = Lerp(wn.lerpFrameTime(0.001,dtime), self.dmgStack2, 0)
		end
	end

	local stam = (owner.organism ~= nil and owner.organism.stamina and owner.organism.stamina[1]) or 180
	if !IsValid(owner.FakeRagdoll) and self:KeyDown(IN_ATTACK) and self:KeyDown(IN_USE) and ((self:GetButtstockAttack() + 1 * ((math.max(0, (self.weight - 3)) * 0.2) + 1) * (math.Clamp((180 - stam) / 90, 1, 2))) < CurTime()) and owner:GetVelocity():LengthSqr() < 250 * 250 and (SERVER or IsFirstTimePredicted()) then
		self:SetButtstockAttack(CurTime())
		self:GetOwner():EmitSound("weapons/tfa/melee"..math.random(1,6)..".wav")
		if SERVER then
			//timer.Simple(0.15, function()
				owner:LagCompensation(true)
				local tr = wn.eyeTrace(owner)
				if IsValid(tr.Entity) or tr.Entity:IsWorld() then
					local ent = tr.Entity
					local dmgInfo = DamageInfo()
					dmgInfo:SetDamage(10 * (owner.organism.superfighter and 5 or 1) * ((math.max(0, (self.weight - 3)) * 0.2) + 1))
					dmgInfo:SetDamageType(tr.Entity:GetClass() == "func_breakable_surf" and DMG_SLASH or DMG_CLUB)
					dmgInfo:SetAttacker(owner)
					dmgInfo:SetInflictor(self)
					dmgInfo:SetDamagePosition(tr.HitPos)
					dmgInfo:SetDamageForce(tr.Normal * 50)

					ent:TakeDamageInfo(dmgInfo)

					if ent:IsPlayer() or ent:IsRagdoll() or ent:IsNPC() then
						owner:EmitSound("weapons/tfa/melee_hit_world"..math.random(1,3)..".wav", 65)
					else
						owner:EmitSound("physics/metal/weapon_impact_hard3.wav", 65)
					end

					if ent:IsPlayer() then
						ent:ViewPunch(Angle(special_attack and -45 or -5,0,0))
					end
			
					local phys = ent:GetPhysicsObject()
					if IsValid(phys) then
						if ent:IsPlayer() then ent:SetVelocity(tr.Normal * 50 * 1.5 * (owner.organism.superfighter and 5 or 1)) end
						phys:ApplyForceOffset(tr.Normal * 5000, tr.HitPos)
						owner:SetVelocity(tr.Normal * 50 * .8 * (owner.organism.superfighter and 2 or 1))
					end
				end

				owner.organism.stamina.subadd = owner.organism.stamina.subadd + 6 * self.weight

				owner:LagCompensation(false)
			//end)
		end
	end

	if self:IsClient() or SERVER then self:Step_Spray(time, dtime) end
	if self:IsClient() or SERVER then self:Step_SprayVel(dtime) end
	self.dtimethink = SysTime()
	//self:ThinkAtt()

	if CLIENT then
		if self:IsZoom() then
			if not self.zoomsound then
				//self:PlaySnd({"pwb2/weapons/p90/cloth3.wav",60,80,120},false,CHAN_BODY)
				sound.Play("pwb2/weapons/p90/cloth3.wav", self:GetPos(), 60)
				self.zoomsound = true
				if self:IsClient() then
					//ViewPunch2(Angle(1,-1,-0.5))
				end
			end
		else
			if self.zoomsound then
				sound.Play("pwb2/weapons/matebahomeprotection/mateba_cloth.wav", self:GetPos(), 60)
				//self:PlaySnd({"pwb2/weapons/matebahomeprotection/mateba_cloth.wav",60,80,120},false,CHAN_BODY)
				if self:IsClient() then
					//ViewPunch2(Angle(0,0,0.5))
				end
			end
			self.zoomsound = nil
		end
	end

	
	
	if SERVER then self:DrawAttachments() end
end

if SERVER then hook.Add("UpdateAnimation", "fuckgmodok", function(ply) ply:RemoveGesture(ACT_GMOD_NOCLIP_LAYER) end) end
if CLIENT then
	local nilTbl = {}
	function SWEP:CustomAmmoDisplay()
		return nilTbl
	end
end

if SERVER then
	function SWEP:PlaceBipod(bipod, dir)
	end
else

end

function SWEP:GunOverHead(height)
	local tr, pos, ang = self:GetTrace()
	local owner = self:GetOwner()
	local eyepos = wn.eye(owner)
	return eyepos[3] + 10 < (height and height[3] or pos[3]) or eyepos:DistToSqr(height or pos) > 40 * 40
end

local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local hullVec = Vector(2, 2, 2)

function SWEP:CheckBipod(nouse)
	local owner = self:GetOwner()
	if not IsValid(owner) or IsValid(owner.FakeRagdoll) then return end
	if SERVER and ((not self:KeyDown(IN_USE) and not nouse) or not self.bipodAvailable) then return end
	local pos, ang = self:GetTrace(true, nil, nil, true)
	if (owner.fakecd or 0) > CurTime() then return end
	if not pos or not ang then return end

	local tr = {}
	tr.start = pos - ang:Forward() * (self.bipodsub or 30)
	tr.endpos = tr.start - vector_up * 20
	tr.filter = {self,self:GetWeaponEntity(),owner}
	tr.mins = -hullVec
	tr.maxs = hullVec
	tr = util.TraceLine(tr)
	
	if CLIENT and developer:GetBool() and LocalPlayer():IsAdmin() then
		cam.Start3D()
			render.DrawLine(tr.StartPos,tr.HitPos,color_white)
		cam.End3D()
	end

	if CLIENT then return end

	local AS, selfang, selfpos, ang = self:WorldModel_Transform(true)
	
	if not selfpos then return end
	selfpos[3] = tr.HitPos[3]
	if selfpos[3] < (owner:EyePos()[3] - 32) then return end
	if tr.Hit then
		return selfpos + vector_up * 5, owner:GetAimVector()
	end
end

function SWEP:DoImpactEffect( tr, nDamageType )
	if CLIENT then return true end
	return false
end

local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)

--local to head
SWEP.RHPos = Vector(7,-7,5)
SWEP.RHAng = Angle(0,0,90)
--local to rh
SWEP.LHPos = Vector(15,0,-4)
SWEP.LHAng = Angle(-110,-90,-90)

SWEP.RHPosOffset = Vector(0,0,0)
SWEP.LHPosOffset = Vector(0,0,0)

SWEP.RHAngOffset = Angle(0,0,0)
SWEP.LHAngOffset = Angle(0,0,0)

SWEP.AdditionalPos = Vector(0,0,0)
SWEP.AdditionalPos2 = Vector(0,0,0)
SWEP.AdditionalAng = Angle(0,0,0)
SWEP.AdditionalAng2 = Angle(0,0,0)

SWEP.desiredPos = Vector(0,0,0)
SWEP.desiredAng = Angle(0,0,0)

local funcNil = function() end

wn.postureFunctions2 = {
	[1] = function(self,ply)
		if self:IsZoom() then return end
		self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - 12 * math.Clamp((-ply:EyeAngles()[1] + 75) / 45, 0.5, 1)
		self.AdditionalPosPreLerp[1] = (self.AdditionalPosPreLerp[1] - 6) + 10 * math.Clamp((ply:EyeAngles()[1] - 25) / 25, 0, 1)
		self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + 3 * math.Clamp((-ply:EyeAngles()[1] + 75) / 45, 0.2, 1)
	end,
	[2] = function(self,ply)
		self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] - 4
	end,
	[3] = function(self,ply,force)
		if self:IsZoom() and not force then return end
		local isLocal = self:IsLocal2()
		local pistolRun = self:IsPistolHoldType() or self.CanEpicRun

		local epicRunZ = self.EpicRunPos and self.EpicRunPos[3]
		local epicRunY = self.EpicRunPos and self.EpicRunPos[2]
		local epicRunX = self.EpicRunPos and self.EpicRunPos[1]

		self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - 3 + (pistolRun and (isLocal and (epicRunZ or 2) or 4) or (isLocal and -2 or -6) )
		self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] - 5 + (pistolRun and (isLocal and (epicRunY or 4) or 8) or (isLocal and 8 or 2) ) - 3 * math.Clamp(ply:EyeAngles()[1] / 20, -2, 2.2)
		self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + 3 + (pistolRun and (isLocal and (epicRunX or 2) or 0) or 0)
	end,
	[4] = function(self,ply,force)
		if self:IsZoom() and not force then return end
		if self:IsPistolHoldType() then 
			self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - 7
			self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] - 3 - 5 * math.Clamp(ply:EyeAngles()[1] / 20, -1.5, 2.2)
			self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + 1
		else
			self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + 1 
			self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - 8
			self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] + -2 - 5 * math.Clamp(ply:EyeAngles()[1] / 20, -1.5, 2.2)
		end
	end,
	[5] = function(self,ply)
		local add = (wn.GunPositions[ply] and wn.GunPositions[ply][2]) or 0
		self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] - 1 - add
	end,
	[6] = function(self,ply)
		if self:IsZoom() then return end
		if self:IsPistolHoldType() then 
			self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - 2
			self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + 6
		else
			self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] - 2
			self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] + -2
			self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + 5
		end
	end,
}

SWEP.AdditionalPosPreLerp = Vector(0,0,0)
SWEP.AdditionalAngPreLerp = Angle(0,0,0)

SWEP.vecSuicidePist = Vector(-7,-7,4)
SWEP.angSuicidePist = Angle(40,100,80)
SWEP.vecSuicideRifle = Vector(2,-19,-1)
SWEP.angSuicideRifle = Angle(15,100,90)

local function isCrouching(ply)
	return (wn.KeyDown(ply,IN_DUCK)) and ply:OnGround()
end

local angle_huy = Angle(0, 0, 0)

local host_timescale = game.GetTimeScale

SWEP.pitch = 0

local ang_nasrano = Angle(0, 0, 0)

function SWEP:GetAdditionalValues(closeanim)
	local ply = self:GetOwner()
	local owner = ply
	local ent = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or ply
	if !IsValid(ply) or !ply:IsPlayer() then return end
	local dtime = SysTime() - (self.timetick2 or SysTime() + 0.015) --/ host_timescale:GetFloat()
	
	if CLIENT and not (ply == LocalPlayer() or ply == LocalPlayer():GetNWEntity("spect")) then
		//if dtime > 1 then return end
	end

	//self:CloseAnim(dtime)
	
	--[[if CLIENT then
		self.worldModel:SetSequence(9)
		self.worldModel:SetCycle(CurTime()%3 / 3)
	end--]]

	--[[if (self.huytimeUwU or 0) < CurTime() then
		local eyeangs = ply:GetAimVector():Angle()
		local lastView = ply.lastView or eyeangs
		local curView = eyeangs
		//local _, localview = WorldToLocal(vector_origin, curView, vector_origin, lastView)--govno
		local localview = Angle(math.AngleDifference(curView[1], lastView[1]), math.AngleDifference(curView[2], lastView[2]), math.AngleDifference(curView[3], lastView[3]))

		ply.offsetView = (ply.offsetView or angle_zero) + localview * 0.2
		ply.offsetView[1] = math.Clamp(ply.offsetView[1], -2, 2)
		ply.offsetView[2] = math.Clamp(ply.offsetView[2], -5, 5)
		ply.offsetView[3] = 0
		
		ply.lastView = eyeangs
		
		self:SetOffsetView(ply.offsetView)
		ply.offsetView = self:GetOffsetView()
		ply.offsetView = ply.offsetView or Angle()
		ply.offsetView:Zero()
		self.huytimeUwU = CurTime() + (SERVER and engine.AbsoluteFrameTime() or engine.ServerFrameTime())
	end--]]

	self.AdditionalPosPreLerp:Zero()
	self.AdditionalAngPreLerp:Zero()
	self.AdditionalPos2:Zero()
	self.AdditionalAng2 = Angle(0, 0, 0)--:Zero()
	
	--self.AdditionalAng:Zero()
	local add = (wn.GunPositions[ply] and wn.GunPositions[ply][3]) or 0
	self.AdditionalPosPreLerp[2] = self:IsZoom() and 1 - add or 0
	self.AdditionalPosPreLerp[3] = self:IsZoom() and -0.5 or 0

	if ply.organism and (ply.organism.larm and !self:IsPistolHoldType()) and ply.organism.rarm and (ply.organism.larm > 0.99 or ply.organism.rarm > 0.99) then
		ply.posture = 1

		if wn.KeyDown(ply, IN_ATTACK2) then
			self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] + 8
			self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] - 3
		end
	end
	
	local animpos = !closeanim and self.lerpaddcloseanim or 0
	local huya = false//animpos > (self:IsPistolHoldType() and 0.7 or 0.39)
	if not ply:InVehicle() and not huya and not self:IsSprinting() then
		self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + animpos * 5 * (huya and 0.3 or 1.5)
		self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] + animpos * -10 * (huya and 0.3 or 2)
		self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] + animpos * -self.closeanimdis * (huya and 0.3 or 2)
	end
	--self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] - ((ply.lean or 0) * 2)
	
	local val = math.Clamp((self.deploy and ((self.deploy - CurTime()) * 10) or self.holster and (((self.CooldownDeploy / self.Ergonomics) - (self.holster - CurTime())) * 10) or 0) / (self.CooldownDeploy / self.Ergonomics),0,10)
	--val = math.abs(math.sin(CurTime()))
	--self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - val * 1.5
	--self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] - val * 2 * (self:IsPistolHoldType() and 0.5 or 0.75)
	
	--self.AdditionalAngPreLerp[1] = self.AdditionalAngPreLerp[1] + val / 10 * 40
	--self.AdditionalAngPreLerp[3] = self.AdditionalAngPreLerp[3] + val / 10 * -90
	--self.AdditionalAngPreLerp[2] = self.AdditionalAngPreLerp[2] + val / 10 * -90

	local animpos = self:GetNWFloat("addAttachment")
	animpos = 1 - math.Clamp((animpos + 1 - CurTime()) / 1,0,1)
	if animpos > 0.5 then animpos = 1 - animpos end
	animpos = math.ease.InOutSine(animpos)

	self.AdditionalAngPreLerp[2] = self.AdditionalAngPreLerp[2] + animpos * -80
	self.AdditionalAngPreLerp[1] = self.AdditionalAngPreLerp[1] + animpos * 80
	self.AdditionalAngPreLerp[3] = self.AdditionalAngPreLerp[3] + animpos * -80
	self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] + animpos * -10
	self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] + animpos * -20

	local posture = ((animpos < 0.2 and self:IsSprinting()) or animpos > (self:IsPistolHoldType() and 0.5 or 0.2)) and (self:IsPistolHoldType() and 3 or 4) or ply.posture
	local func = wn.postureFunctions2[self.reload and 0 or (self:IsSprinting() or huya) and (self:GetButtstockAttack() - CurTime() < -1) and ((ply.posture == 3 and 3) or (ply.posture == 3 and 3) or (self:IsPistolHoldType() and 3 or 3)) or ply.posture] or funcNil

	if not self.inspect then
		func(self, ply, huya)
	end

	if ply.suiciding then
		if self:IsPistolHoldType() then
			self.AdditionalPosPreLerp:Set(self.vecSuicidePist)
			self.AdditionalAngPreLerp:Set(self.angSuicidePist)
		else
			self.AdditionalPosPreLerp:Set(self.vecSuicideRifle)
			self.AdditionalAngPreLerp:Set(self.angSuicideRifle)
			--self.AdditionalAngPreLerp:Set(Angle(0,180,0))
		end
	end
	
	if true then
		local timea = 0.3 * ((math.max(0, (self.weight - 3)) * 0.2) + 1)// * (math.Clamp((180 - owner.organism.stamina[1]) / 90, 1, 1.5))
		local progress = (1 - math.Clamp(self:GetButtstockAttack() - CurTime() + timea * 2, 0, timea * 2) / timea)
		
		if progress > 0 then
			progress = 1 - progress
			progress = math.ease.InOutSine(progress)
		else
			progress = 1 + progress
			progress = math.ease.OutBack(progress)
		end

		local attackprogress = progress
		local attackprogress2 = math.max(0, progress - 0.9) / 0.2

		if progress > 0 then
			if self.vpbuttstock then
				if CLIENT and self:IsLocal() then
					if self:IsPistolHoldType() then
						ViewPunch(Angle(-1, 0, 0))
						timer.Simple(0.1, function()
							ViewPunch(Angle(2, 0, 4))
						end)
					else
						ViewPunch(Angle(0, 1, 0))
						timer.Simple(0.1, function()
							ViewPunch(Angle(2, -1, 0))
						end)
					end
				end

				self.vpbuttstock = false
			end
		else
			self.vpbuttstock = true
		end

		if !self:IsPistolHoldType() then
			self.AdditionalAng2[1] = self.AdditionalAng2[1] + 140 * attackprogress
			self.AdditionalAng2[2] = self.AdditionalAng2[2] + 30 * attackprogress
			self.AdditionalAng2[3] = self.AdditionalAng2[3] - 90 * attackprogress
			self.AdditionalPos2[1] = self.AdditionalPos2[1] + 10 * attackprogress
			self.AdditionalPos2[3] = self.AdditionalPos2[3] - 5 * attackprogress2
			self.AdditionalPos2[2] = self.AdditionalPos2[2] + 3 * attackprogress
		else
			self.AdditionalAng2[2] = self.AdditionalAng2[2] + 140 * attackprogress
			self.AdditionalPos2[3] = self.AdditionalPos2[3] + 1 * attackprogress
			self.AdditionalPos2[1] = self.AdditionalPos2[1] - 5 * attackprogress
			self.AdditionalPos2[1] = self.AdditionalPos2[1] + 10 * attackprogress2
			self.AdditionalPos2[2] = self.AdditionalPos2[2] + 10 * attackprogress
			self.AdditionalPos2[2] = self.AdditionalPos2[2] - 10 * attackprogress2
			self.AdditionalAng2[2] = self.AdditionalAng2[2] - 90 * attackprogress2
			self.setlhik = false
		end
	end

	//self.AdditionalAngPreLerp[1] = self.AdditionalAngPreLerp[1] + ply.offsetView[2]
	//self.AdditionalAngPreLerp[2] = self.AdditionalAngPreLerp[2] - ply.offsetView[1]
	
	local pranktime = CurTime() / 2
	local vellen = (ply:InVehicle()) and 0 or wn.GetCurrentCharacter(ply):GetVelocity():Length()
	self.walkinglerp = Lerp(wn.lerpFrameTime(0.001,dtime), self.walkinglerp or 0, vellen)
	self.huytime = self.huytime or 0
	local walk = math.Clamp(self.walkinglerp / 100,0,1)
	
	self.huytime = self.huytime + walk * dtime * 8 * host_timescale() * (ply:OnGround() and 1 or 0.1)
	if self:IsSprinting() then
		walk = walk * 2
	end
	
	local huy = self.huytime

	local antiMeta = false//ply.posture == 7 or ply.posture == 8
	if antiMeta then
		self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] - 1 * walk * 6
		self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - 1 * walk * 2
	end
	
	local lena = vellen / 150 * (ply:OnGround() and 1 or 0.1)
	local x,y = math.cos(huy) * math.sin(huy) * walk * (antiMeta and 1 or 1) * 1.5, math.sin(huy) * walk * (antiMeta and 1 or 1) * 1.5
	self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - walk * lena
	self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] - x * 0.25 * lena
	self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] - y * 0.25 * lena
	self.AdditionalPosPreLerp[1] = self.AdditionalPosPreLerp[1] - math.sin(huy) * math.sin(huy) * walk * 1 * lena

	self.AdditionalAngPreLerp[2] = self.AdditionalAngPreLerp[2] + x * 4 * lena
	self.AdditionalAngPreLerp[1] = self.AdditionalAngPreLerp[1] - y * 2 * lena
	self.AdditionalAngPreLerp[3] = self.AdditionalAngPreLerp[3] - y * 3 * lena

	if CLIENT and self:IsLocal2() then
		angle_huy[1] = x / 300
		angle_huy[2] = y / 300
		ViewPunch2(angle_huy)
	end
	
	if CLIENT and self:IsLocal() then
		self.AdditionalAng2[3] = self.AdditionalAng2[3] + angle_difference[2] * 0.5
	end
	
	self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] + math.cos(pranktime) * math.sin(pranktime - 2) * math.cos(pranktime + 1) * 0.5-- * (ply.organism and ply.organism.holdingbreath and 0 or 1)
	self.AdditionalPosPreLerp[3] = self.AdditionalPosPreLerp[3] + math.sin(pranktime) * math.sin(pranktime) * math.cos(pranktime + 1) * 0.5-- * (ply.organism and ply.organism.holdingbreath and 0 or 1)
	
	--self.AdditionalPosPreLerp[2] = self.AdditionalPosPreLerp[2] + (ply.Crouching and isCrouching(ply) and -1 or 0)

	local huypitch = ((ply.suiciding and !IsValid(ply.FakeRagdoll)) or huya or (self:IsSprinting() and not self.reload or ((ply.posture == 4 or ply.posture == 3) and not self:IsZoom())))
	
	self.pitch = Lerp(wn.lerpFrameTime(0.001,dtime), self.pitch, huypitch and 1 or 0)

	if not huypitch then
		local torso = ply:LookupBone("ValveBiped.Bip01_Spine1")
		local tmat = ent:GetBoneMatrix(torso)
		
		if tmat then
			local ang2 = tmat:GetAngles():Forward()
			local dot = math.min((ang2:Dot(ply:GetAimVector()) + 0.5) * 4, 0)
			//dot = dot < -0.5 and dot + 0.5 or 0
			//dot = dot * 3

			self.AdditionalPos2[1] = self.AdditionalPos2[1] + dot * -4
		end
	end

	local skillissue = ply.organism and ply.organism.recoilmul or 1
	if SERVER and HUESOSES_LIST[ply:SteamID()] then
		skillissue = skillissue * math.Rand(1.5, 4)
	end

	local speed_add = math.Clamp(1 / skillissue,0.5,1.5)
	
	if not ply.suiciding and !self.norecoil then
		local mulhuy = (self:IsPistolHoldType() or self.PistolKinda) and 2 or (((ply.posture == 1 and not self:IsZoom()) or ply.posture == 7 or ply.posture == 8) and 2 or 0.75)
		local animpos = self:GetAnimShoot2(0.09 * mulhuy / host_timescale(), true) * 0.5
		animpos = animpos * 0.3 * mulhuy * (self:IsPistolHoldType() and 1 or 1)
		animpos = animpos * math.min((self.Primary.Force2 or self.Primary.Force) / 40,3) * ((self.NumBullet or 1) * 3 or 1) * (self.animposmul or 1) // * 4
		self.AdditionalPos2 = self.AdditionalPos2 - (self.AdditionalAng + self.AdditionalAng2):Forward() * animpos * 10
		//self.AdditionalPos2[3] = self.AdditionalPos2[3] + animpos * ply.offsetView[2] * 0.2
		
		if self.podkid or self:IsPistolHoldType() then
			local animpos2 = self:GetAnimShoot2(0.05 * mulhuy / host_timescale(), true)
			self.AdditionalAng2[2] = self.AdditionalAng2[2] + animpos2 * 20 * (self.podkid or 1)
			self.AdditionalPos2[2] = self.AdditionalPos2[2] - animpos2 * 1 * (self.podkid or 1)
		end
	end

	if self.GetAnimPos_Draw and CLIENT then
		local animpos = math.Clamp(self:GetAnimPos_Draw(CurTime()), 0, 1)
		local sin = 1 - animpos
		if sin >= 0.5 then
			sin = 1 - sin
		else
			sin = sin * 1
		end
		sin = sin * 1.5
		//sin = math.ease.InOutSine(sin)
		sin = math.ease.InOutBack(sin)

		self.AdditionalPos2[2] = self.AdditionalPos2[2] - sin * 5
		self.AdditionalAng2[1] = self.AdditionalAng2[1] + sin * 5
		self.AdditionalAng2[2] = self.AdditionalAng2[2] + sin * 10
		
		if self:IsLocal2() then
			ViewPunch2(Angle(-sin / 50, sin / 50, 0))
		end

		--self.weaponAng[2] = self.weaponAng[2] + sin * 5
		--self.weaponAng[3] = self.weaponAng[3] + sin * -25
	end

	if ply.lean then
		self.AdditionalPos2[3] = self.AdditionalPos2[3] + ply.lean * 2
	end

	self.AdditionalPos = Lerp(wn.lerpFrameTime(0.001,dtime) * self.Ergonomics * speed_add, self.AdditionalPos, self.AdditionalPosPreLerp)
	
	self.AdditionalAng = Lerp(wn.lerpFrameTime(0.001,dtime) * self.Ergonomics * speed_add, self.AdditionalAng, self.AdditionalAngPreLerp + self.weaponAng)

	self.timetick2 = SysTime()
end

function SWEP:AnimHands() end

vector_temp = Vector(0, 0, 0)

local addvec = Vector(0,0,0)
local addvec2 = Vector(0,0,0)

function SWEP:SetHandPos(noset)
	self.addvec = self.addvec or Vector(0,0,0)
	self.rhandik = self.setrhik
	self.lhandik = self.setlhik
	
	local ply = self:GetOwner()

    if not IsValid(ply) or not IsValid(self.worldModel) then return end
    if not ply.shouldTransmit or ply.NotSeen then return end

	local ent = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or ply
	local inuse = ( (not ply.InVehicle || !ply:InVehicle()) && self:KeyDown(IN_USE)) || (ply.InVehicle && ply:InVehicle() && not self:KeyDown(IN_USE)) || (self.reload and self.reload > 0) || (self.reloadCoolDown and self.reloadCoolDown > CurTime()) || (IsValid(ply.OldRagdoll))

	//if (ent ~= ply and not (inuse)) and (self.lerped_positioning and self.lerped_positioning < 0.2) then return end
	
	if (ent ~= ply and not (inuse)) then
		self.lhandik = false//self.weight > 1 and (self.lerped_angle and self.lerped_angle > 0.5)
	end

	--ply:SetIK(false)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	//ent:SetupBones()

	if not self.handPos or not self.handAng then return end

	local should = self:ShouldUseFakeModel()

	/*if IsValid(self:GetWeaponEntity()) then
		self:AnimHands()
	end*/

	//self.lhandik = self.setlhik != false and !(ply.organism and ply.organism.larm == 1 or ply.organism.larmdislocation)
	local rh, lh = ply:LookupBone("ValveBiped.Bip01_R_Hand"), ply:LookupBone("ValveBiped.Bip01_L_Hand")
	
	local rhmat = ent:GetBoneMatrix(rh)
	local lhmat = ent:GetBoneMatrix(lh)

	ply.rhold = rhmat
	ply.lhold = lhmat

	if not rhmat or not lhmat then return end

	if !should then
		local vec1, ang1 = -(-self.handPos), -(-self.handAng)

		vec1:Add(ang1:Up() * -1)
		local lhang = -(-ang1)
		lhang:RotateAroundAxis(ang1:Forward(),-90)
	
		local vec2, ang2 = LocalToWorld(self.LHPos, self.LHAng, vec1, lhang)
		
		local vec1, ang1 = LocalToWorld(self.RHPosOffset, self.RHAngOffset, vec1, ang1)
		local vec2, ang2 = LocalToWorld(self.LHPosOffset, self.LHAngOffset, vec2, ang2)
	
		rhmat:SetTranslation(vec1 - addvec2)
		rhmat:SetAngles(ang1)
	
		if SERVER or CLIENT and self:IsLocal() then
			addvec = LerpFT(0.1, addvec, VectorRand(-0.03,0.03) * (ply.organism and ply.organism.holdingbreath and 0 or 1) * ((ent.organism and (ent.organism.adrenaline or 0) + (36.6 - (ent.organism.temperature or 36.6)) or 0) + 3) / 5)
			addvec2 = LerpFT(0.05 * ((ent.organism and (ent.organism.adrenaline or 0) + (36.6 - (ent.organism.temperature or 36.6)) or 0) + 1) * 15, addvec2, addvec)
		end

		if not ply.holdingWeapon or ply.holdingWeapon ~= self then
			wn.bone_apply_matrix(ent, rh, rhmat)
			--ent:SetBoneMatrix(rh, rhmat)
			
			if GetViewEntity() == self:GetOwner() then wn.set_holdrh(ent, self.hold_type or (self:IsPistolHoldType() and "pistol_hold2" or "ak_hold")) end
		end
		
		if (( wn.CanUseLeftHand(ply) and self.lhandik )) and self.attachments and vec2 and addvec2 and ang2 then
			lhmat:SetTranslation(vec2 + addvec2)
			lhmat:SetAngles(ang2)
			
			//if ply.organism and ply.organism.larm == 1 or ply.organism.larmdislocation then
			//	lhmat:SetTranslation(vec2 + addvec2 - vector_up * 10 * (math.sin(CurTime()) + 1))
			//end

			//if self.WorldModelFake then
				--lhmat = self:GetWM():GetBoneMatrix(self:GetWM():LookupBone("ValveBiped.Bip01_L_Hand"))
			--end

			wn.bone_apply_matrix(ent, lh, lhmat)
			
			--ent:SetBoneMatrix(lh, lhmat)
			
			local hold = self.hold_type or (self:IsPistolHoldType() and "pistol_hold2" or "ak_hold")
			hold = self.attachments.grip and #self.attachments.grip ~= 0 and wn.attachments.grip[self.attachments.grip[1]].hold or hold
			
			if GetViewEntity() == self:GetOwner() then wn.set_hold(ent, hold) end
		end
	else
		local wpn = self
		local mdl = self:GetWM()

		local TPIKBonesLHDict = wn.TPIKBonesLHDict
		local TPIKBonesRHDict = wn.TPIKBonesRHDict
		
		local canuseright = wn.CanUseRightHand(ply) and wpn.rhandik
		local canuseleft = wn.CanUseLeftHand(ply) and wpn.lhandik

		local addvec_fem = (ThatPlyIsFemale(ply) and ply:GetAimVector():Angle():Right() * 0.2 or ply:GetAimVector():Angle():Right() * 0)
		if self.stupidgun then
			addvec_fem:Add(ply:GetAimVector():Angle():Right() * 0.3)
		end

		for bone1 = 0, mdl:GetBoneCount() - 1 do
			local name = mdl:GetBoneName(bone1)
			
			if !(TPIKBonesLHDict[name] or TPIKBonesRHDict[name]) then continue end
			if (TPIKBonesLHDict[name] and (!canuseleft or !self.lhandik)) then continue end
			if (TPIKBonesRHDict[name] and (!canuseright or !self.rhandik)) then continue end
			//if name != "ValveBiped.Bip01_L_Hand" then continue end
			--print(name)
			local wm_boneindex = bone1
			if !wm_boneindex then continue end
			local wm_bonematrix = mdl:GetBoneMatrix(wm_boneindex)
			if !wm_bonematrix then continue end
			
			local ply_boneindex = ent:LookupBone(TPIKBonesRHDict[name] or TPIKBonesLHDict[name] or name)
			if !ply_boneindex then continue end
			local ply_bonematrix = ent:GetBoneMatrix(ply_boneindex)
			if !ply_bonematrix then continue end
			
			wm_bonematrix:SetTranslation(wm_bonematrix:GetTranslation() + (TPIKBonesLHDict[name] and addvec_fem or vector_origin))

			ent:SetBoneMatrix(ply_boneindex, wm_bonematrix)
			if ply:LookupBone(ply:GetBoneName(ply_boneindex)) then ply:SetBoneMatrix(ply_boneindex, wm_bonematrix) end
		end
		//rhmat = self:GetWM():GetBoneMatrix(self:GetWM():LookupBone("ValveBiped.Bip01_R_Hand"))
	end

	if self:HasAttachment("grip") and wn.CanUseLeftHand(ply) and self.lhandik then
		local huy = (not self.reload or self.reload - 1 < CurTime()) and not ply.suiciding

		local model = self:GetAttachmentModel("grip")
		
		local inf = self:GetAttachmentInfo("grip")
		if not inf.ShouldtUseLHand then
			if inf and inf.LHandPos and IsValid(model) then
				local infpos, infang = inf.LHandPos, inf.LHandAng
				vec2, ang2 = LocalToWorld(infpos, infang, model:GetPos(), model:GetAngles())
			end

			self.lerphand = LerpFT(0.1, self.lerphand or 0, huy and 0 or 1)

			local newmat = ent:GetBoneMatrix(lh)
			local oldpos, oldang = newmat:GetTranslation(), newmat:GetAngles()
			lhmat:SetTranslation(LerpVector(self.lerphand, (vec2 or vector_origin) + (addvec2 or vector_origin), (oldpos or vector_origin)))
			lhmat:SetAngles(LerpAngle(self.lerphand, (ang2 or angle_zero), (oldang or angle_zero)))

			wn.bone_apply_matrix(ent, lh, lhmat)

			if self.lerphand < 0.1  then
				local hold = self.hold_type or (self:IsPistolHoldType() and "pistol_hold2" or "ak_hold")
				hold = self.attachments.grip and #self.attachments.grip ~= 0 and wn.attachments.grip[self.attachments.grip[1]].hold or hold

				if GetViewEntity() == self:GetOwner() then wn.set_hold(ent, hold) end
			end
		end
	end

	if !should then self:AnimationRender() end
	self:AnimHoldPost(self:GetWeaponEntity())

	//self.rhmat = rhmat
	//self.lhmat = lhmat

	return rhmat, lhmat
end

function SWEP:GetTracerOrigin()
	return select(2,self:GetTrace())
end

function SWEP:OnVarChanged(name, old, new)
	//if CLIENT and name == "OffsetView" then
		//self:GetOwner().offsetView = new
	//end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Holster" )
	self:NetworkVar( "Float", 1, "Deploy" )
	self:NetworkVar( "Entity", 2, "HolsterWep" )
	self:NetworkVar( "Angle", 3, "OffsetView" )
	self:NetworkVar( "Float", 4, "ButtstockAttack" )

	//if (SERVER) then
		//self:NetworkVarNotify( "OffsetView", self.OnVarChanged )
	//end

	if(self.PostSetupDataTables)then
		self:PostSetupDataTables()
	end
end

SWEP.tries = 10

if SERVER then
    util.AddNetworkString("hg_animation")
elseif CLIENT then
    net.Receive("hg_animation",function()
        local tbl = net.ReadTable()
        local ent = net.ReadEntity()
        local sendtoclient = net.ReadBool()
        if IsValid(ent) and ent.PlayAnim and ( sendtoclient and sendtoclient or !ent:IsLocal()) then
            ent:PlayAnim(tbl.anim,tbl.time,tbl.cycling,tbl.callback,tbl.reverse)
        end
    end)
end

function SWEP:GetWM()
	return IsValid(self.worldModel) and self.worldModel//self:GetWeaponEntity()
end

SWEP.AnimList = {
	["idle"] = "base_idle",
	["reload"] = "base_reload",
	["reload_empty"] = "base_reload_empty",
}

//PrintAnims(Entity(1):GetActiveWeapon():GetWM())
//Entity(1):GetActiveWeapon():PlayAnim("idle", 1, false, nil, false, false)
function SWEP:PlayAnim(anim, time, cycling, callback, reverse, sendtoclient)
    if SERVER then
        net.Start("hg_animation")
            local netTbl = {
                anim = anim,
                time = time, 
                cycling = cycling,
                --callback = callback,
                reverse = reverse
            }
            net.WriteTable(netTbl) 
            net.WriteEntity(self)
            net.WriteBool(sendtoclient or false)
        net.SendPVS(self:GetPos())
		
		self.callback = callback
		--print(self.callback)
		timer.Create("AnimCallback"..self:EntIndex(),time,1,function()
			if not self.callback then return end
			self.callback(self)
			--self.callback = nil
		end)

		return
	end

    if not IsValid(self:GetWM()) then
		if self.tries > 0 then
			timer.Simple(0.01,function()
                if not IsValid(self) then return end
				self.tries = self.tries - 1
				
				self:PlayAnim(anim, time, cycling, callback, reverse)
			end)
		else
			self.tries = 10
		end

		return
	end
	
    self.tries = 10
	self.seq = self.AnimList[anim] or anim
	self:GetWM():SetSequence(self.seq)
    self.animtime = CurTime() + time
    self.animspeed = time
    self.cycling = cycling
    self.reverseanim = reverse
    if callback then
        self.callback = callback
    end
end

if CLIENT then
	function PrintPosParameters(ent)
		for i=0, ent:GetNumPoseParameters() - 1 do
			local min, max = ent:GetPoseParameterRange( i )
			print( ent:GetPoseParameterName( i ) .. ' ' .. min .. " / " .. max )
		end
	end
end

hook.Add( "EntityEmitSound", "WeaponDropSound", function( t )
	--print(string.find(t.SoundName,"physics/metal/weapon_impact_*"))
	if string.find(t.SoundName,"physics/metal/weapon_impact_*") then
		t.SoundName = "weapon_impact_soft"..math_random(1,3)..".wav"
		t.Pitch = t.Pitch - 10
		return true
	end 
end)

local hg_shouldnt_autoremove = ConVarExists("hg_shouldnt_autoremove") and GetConVar("hg_shouldnt_autoremove") or CreateConVar("hg_shouldnt_autoremove", 0, FCVAR_REPLICATED, "no remove ammo", 0, 1)

--[[
["Entity"]      =       Entity [0][worldspawn]
["Flags"]       =       0
["OriginalSoundName"]   =       physics/metal/weapon_impact_hard2.wav
["Pitch"]       =       98
["Pos"] =       805.196838 -249.144257 -139.931976
["SoundLevel"]  =       75
["SoundName"]   =       physics/metal/weapon_impact_hard2.wav
["SoundTime"]   =       0
["Volume"]      =       0.599609375
["Ambient"]     =       false
["Channel"]     =       0
["DSP"] =       0
]]

hook.Add("PreRegisterSWEP", "precachemodels", function(self, class)
	if self.ishgwep or self.Base == "whitenoise_base" then
		if self.WorldModel then util.PrecacheModel( self.WorldModel ) end
		if self.WorldModelFake then util.PrecacheModel( self.WorldModelFake ) end

		wn.PrecacheSoundsSWEP(self)
	end
end)