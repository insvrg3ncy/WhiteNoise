wn.armor = {}
wn.armor.torso = {
	["vest1"] = {
		"torso",
		"models/combataegis/body/ballisticvest_d.mdl",
		Vector(19, 3, 0),
		Angle(0, 90, 90),
		protection = 14.5,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/combataegis/body/ballisticvest.mdl",
		femPos = Vector(-4, 0, 1),
		femscale = 0.92,
		effect = "Impact",
		surfaceprop = 67,
		mass = 10,
		ScrappersSlot = "Armor",
		nobonemerge = true
	},
	["vest2"] = {
		"torso",
		"models/eu_homicide/armor_prop.mdl",
		Vector(-1, 2, 0),
		Angle(0, 90, 90),
		protection = 6.7,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/eu_homicide/armor_on.mdl",
		femPos = Vector(-2.4, 0, 1.1),
		femscale = 0.94,
		effect = "Impact",
		surfaceprop = 77,
		mass = 3,
		ScrappersSlot = "Armor",
	},
	["vest3"] = {
		"torso",
		"models/jworld_equipment/kevlar.mdl",
		Vector(-42, 3.2, 0),
		Angle(0, 90, 90),
		protection = 9.8,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/sal/acc/armor01.mdl",
		material = "sal/acc/armor01",
		femPos = Vector(2.5, 0, 1),
		scale = 0.88,
		femscale = 0.8,
		effect = "Impact",
		surfaceprop = 77,
		mass = 5,
		ScrappersSlot = "Armor",
		nobonemerge = true
	},
	["vest4"] = {
		"torso",
		"models/jworld_equipment/kevlar.mdl",
		Vector(-42, 3.2, 0),
		Angle(0, 90, 90),
		protection = 13.5,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/sal/acc/armor01.mdl",
		material = "sal/acc/armor01_2",
		femPos = Vector(2.5, 0, 1),
		scale = 0.88,
		femscale = 0.8,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
		nobonemerge = true
	},
	["vest5"] = {
		"torso",
		"models/eft_props/gear/armor/ar_6b13_flora.mdl",
		Vector(0, 2.7, 0),
		Angle(0, 90, 90),
		protection = 13,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/eft_props/gear/armor/ar_6b13_flora.mdl",
		femPos = Vector(-1, 0, 1.2),
		scale = 0.88,
		femscale = 0.8,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
	},--models/eft_props/gear/armor/ar_paca.mdl
	["vest6"] = {
		"torso",
		"models/eft_props/gear/armor/ar_paca.mdl",
		Vector(-0.4, 2.9, 0),
		Angle(0, 92, 90),
		protection = 9.9,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/eft_props/gear/armor/ar_paca.mdl",
		femPos = Vector(-1.5, 0, 1.5),
		scale = 0.9,
		femscale = 0.82,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
	},
	["vest7"] = {
		"torso",
		"models/eft_props/gear/armor/ar_untar.mdl",
		Vector(-0.4, 2.9, 0),
		Angle(0, 92, 90),
		protection = 10.2,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/eft_props/gear/armor/ar_untar.mdl",
		femPos = Vector(-1.5, 0, 1.5),
		scale = 0.9,
		femscale = 0.82,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
	},
	["vest8"] = {
		"torso",
		"models/monolithservers2/kerry/sswat_armor.mdl",
		Vector(-9, 2.5, 0),
		Angle(0, 92, 90),
		protection = 12.5,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/monolithservers2/kerry/sswat_armor.mdl",
		femPos = Vector(0, 0, 0),
		scale = 1,
		femscale = 1,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor"
	},
	["gordon_armor"] = {
		"torso",
		"",
		Vector(-9, 2.5, 0),
		Angle(0, 92, 90),
		protection = 16.5,
		bone = "ValveBiped.Bip01_Spine2",
		model = "",
		femPos = Vector(0, 0, 0),
		scale = 1,
		femscale = 1,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
		restricted = {"torso"},
		nodrop = true,
	},
	["cmb_armor"] = {
		"torso",
		"",
		Vector(-9, 2.5, 0),
		Angle(0, 92, 90),
		protection = 8,
		bone = "ValveBiped.Bip01_Spine2",
		model = "",
		femPos = Vector(0, 0, 0),
		scale = 1,
		femscale = 1,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
		restricted = {"torso"},
		nodrop = true,
	},
	["ego_equalizer"] = {
		"torso",
		"models/monolithservers2/kerry/sswat_armor.mdl",
		Vector(-9, 2.5, 0),
		Angle(0, 92, 90),
		protection = 0,
		bone = "ValveBiped.Bip01_Spine2",
		model = "models/monolithservers2/kerry/sswat_armor.mdl",
		-- material = "models/shiny",
		material = "models/props_c17/paper01",
		femPos = Vector(0, 0, 0),
		scale = 1,
		femscale = 1,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor"
	},
}

wn.armor.head = {
	["helmet1"] = {
		"head",
		"models/barney_helmet.mdl",
		Vector(1, -2, 0),
		Angle(180, 110, 90),
		protection = 9.5,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/barney_helmet.mdl",
		femPos = Vector(-1, 0, 0),
		material = "sal/hanker",
		norender = true,
		viewmaterial = Material("sprites/mat_jack_hmcd_helmover"),
		femscale = 0.92,
		effect = "Impact",
		surfaceprop = 67,
		mass = 2,
		ScrappersSlot = "Armor",
	},
	["helmet2"] = {
		"head",
		"models/dean/gtaiv/helmet.mdl",
		Vector(2.6, 0, 0),
		Angle(180, 110, 90),
		protection = 4.2,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/dean/gtaiv/helmet.mdl",
		femPos = Vector(-1, 0, 0),
		norender = true,
		viewmaterial = Material("sprites/mothelm_over"),
		effect = "Impact",
		surfaceprop = 67,
		mass = 1,
		ScrappersSlot = "Armor",
	},
	["helmet3"] = {
		"head",
		"models/eu_homicide/helmet.mdl",
		Vector(2, 0.2, 0),
		Angle(180, 110, 90),
		protection = 4,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/eu_homicide/helmet.mdl",
		femPos = Vector(-1.2, 0, 0.5),
		norender = true,
		viewmaterial = Material("sprites/mat_jack_helmoverlay_r"),
		effect = "Impact",
		surfaceprop = 67,
		mass = 1,
		ScrappersSlot = "Armor",
	},
	["helmet4"] = {
		"head",
		"models/props_interiors/pot02a.mdl",
		Vector(7, -3.8, -3.8),
		Angle(-45, -65, 90),
		protection = 3,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/props_interiors/pot02a.mdl",
		femPos = Vector(-1.2, 0, 0.5),
		norender = true,
		viewmaterial = Material("sprites/mat_jack_hmcd_helmover"),
		effect = "Impact",
		surfaceprop = 67,
		mass = 1,
		ScrappersSlot = "Armor",
	},
	["helmet5"] = {
		"head",
		"models/eft_props/gear/helmets/helmet_achhc_b.mdl",
		Vector(2.2,-1, 0),
		Angle(180, 100, 90),
		protection = 11,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/eft_props/gear/helmets/helmet_achhc_b.mdl",
		femPos = Vector(-1, 0, 0.1),
		norender = true,
		effect = "Impact",
		surfaceprop = 67,
		scale = 0.9,
		mass = 1,
		ScrappersSlot = "Armor",
	},
	["helmet6"] = {
		"head",
		"models/monolithservers2/kerry/swat_hat.mdl",
		Vector(0, 0, 0),
		Angle(180, 100, 90),
		protection = 11,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/monolithservers2/kerry/swat_hat.mdl",
		femPos = Vector(0, 0, 0),
		norender = true,
		effect = "Impact",
		surfaceprop = 67,
		scale = 1,
		mass = 1,
		ScrappersSlot = "Armor",
	},
	["helmet7"] = {
		"head",
		"models/eft_props/gear/helmets/helmet_s_sh_68.mdl",
		Vector(2.5, -0.8, 0),
		Angle(180, 95, 90),
		protection = 12,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/eft_props/gear/helmets/helmet_s_sh_68.mdl",
		femPos = Vector(-0.6, 0, 0.3),
		norender = true,
		viewmaterial = Material("sprites/mat_jack_helmoverlay_h"),
		effect = "Impact",
		surfaceprop = 67,
		mass = 1.8,
		ScrappersSlot = "Armor",
	},
	["helmet8"] = {
		"head",
		"models/eft_props/gear/helmets/helmet_un.mdl",
		Vector(2.2,-1, 0),
		Angle(180, 100, 90),
		protection = 8,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/eft_props/gear/helmets/helmet_un.mdl",
		femPos = Vector(-1, 0, 0.1),
		--material = "sal/hanker",
		norender = true,
		viewmaterial = Material("sprites/mat_jack_hmcd_helmover"),
		femscale = 0.92,
		effect = "Impact",
		surfaceprop = 67,
		mass = 1,
		ScrappersSlot = "Armor",
	},
	["gordon_helmet"] = {
		"head",
		"",
		Vector(-9, 2.5, 0),
		Angle(0, 92, 90),
		protection = 16,
		bone = "ValveBiped.Bip01_Spine2",
		model = "",
		femPos = Vector(0, 0, 0),
		scale = 1,
		femscale = 1,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
		restricted = {"head","ears","face"},
		nodrop = true,
	},
	["cmb_helmet"] = {
		"head",
		"",
		Vector(-9, 2.5, 0),
		Angle(0, 92, 90),
		protection = 8,
		bone = "ValveBiped.Bip01_Spine2",
		model = "",
		femPos = Vector(0, 0, 0),
		scale = 1,
		femscale = 1,
		effect = "Impact",
		surfaceprop = 67,
		mass = 8,
		ScrappersSlot = "Armor",
		restricted = {"head","ears","face"},
		nodrop = true,
	},
}

wn.armor.ears = {
	["headphones1"] = {
		"ears",
		"models/eft_props/gear/headsets/headset_msa.mdl",
		Vector(2.2, 0, 0),
		Angle(0, 100, 90),
		protection = 0,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/eft_props/gear/headsets/headset_msa.mdl",
		femPos = Vector(-0.5, 0, 1),
		norender = true,
		viewmaterial = Material("sprites/mat_jack_hmcd_helmover"),
		effect = "Impact",
		surfaceprop = 67,
		mass = 1,
		ScrappersSlot = "Armor",
		scale = 0.9,
		femscale = 0.85,
		SoundlevelAdd = 15,
		VolumeAdd = 0.2,
		NormalizeSnd = {0.75,0.2}
	}
}

local function DrawNoise(amt, alpha)
	local W, H = ScrW(), ScrH()

	for i = 0, amt do
		local Bright = math.random(0, 255)
		surface.SetDrawColor(Bright, Bright, Bright, alpha)
		local X, Y = math.random(0, W), math.random(0, H)
		surface.DrawRect(X, Y, 1, 1)
	end
end

local blurMat2, Dynamic2 = Material("pp/blurscreen"), 0

local function BlurScreen(density,alpha)
	local layers, density, alpha = 1, density or .4, alpha or 255
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blurMat2)
	local FrameRate, Num, Dark = 1 / FrameTime(), 3, 150

	for i = 1, Num do
		blurMat2:SetFloat("$blur", (i / layers) * density * Dynamic2)
		blurMat2:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	Dynamic2 = math.Clamp(Dynamic2 + (1 / FrameRate) * 7, 0, 1)
end

local custommat = Material("overlays/nvg_scene_opticf2.png")

sound.Add( {
	name = "breath_normal",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 55,
	pitch = 100,
	sound = "breath_normal.wav"
} )

local colormodify01 = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.15,
	["$pp_colour_addb"] = 0.17,
	["$pp_colour_brightness"] = 0.01,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local colormodify02 = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.15,
	["$pp_colour_addb"] = 0.17,
	["$pp_colour_brightness"] = -0.1,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

wn.armor.face = {
	["mask1"] = {
		"face", -- "face"
		"models/jmod/ballistic_mask.mdl",
		Vector(4.55, -0.8, 0),
		Angle(180, 90, 90),
		protection = 9.5,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/jmod/ballistic_mask.mdl",
		femPos = Vector(-1.2, 0, 0.15),
		material = "sal/hanker",
		norender = true,
		scale = 1,
		femscale = 0.97,
		viewmaterial = Material("sprites/mat_jack_hmcd_narrow"),
		effect = "MetalSpark",
		surfaceprop = 77,
		mass = 1.5,
		ScrappersSlot = "Armor",
		voice_change = true,
	},
	["mask2"] = {
		"face", -- "face"
		"models/gasmasksfix/m40_drop.mdl",
		Vector(3,-2,-0.5),
		Angle(-90, 90, 0),
		protection = 1.5,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/gasmasksfix/m40_fix.mdl",
		femPos = Vector(-1,0,0),
		norender = true,
		scale = 1,
		femscale = 1,
		viewmaterial = Material("overlays/ba_gasmask"),
		effect = "Impact",
		surfaceprop = 67,
		loopsound = "breath_normal",
		mass = 0.5,
		ScrappersSlot = "Armor",
		voice_change = true,
	},
	["mask3"] = {
		"face", -- "face"
		"models/eft_props/gear/helmets/helmet_rys_t_shield.mdl",
		Vector(0, 0.3, 0),
		Angle(-90, 180, 90),
		protection = 7,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/props_silo/welding_helmet.mdl",
		femPos = Vector(-1, 0, 0.5),
		norender = true,
		scale = 1.03,
		femscale = 1,
		viewmaterial = Material("sprites/mat_jack_hmcd_narrow"),
		effect = "MetalSpark",
		surfaceprop = 77,
		mass = 2,
		ScrappersSlot = "Armor",
		voice_change = true,
	},
	["nightvision1"] = {
		"face", -- "face"
		"models/arctic_nvgs/nvg_gpnvg.mdl",
		Vector(1.6, 0.6, 0),
		Angle(0, -90, -90),
		protection = 0,
		bone = "ValveBiped.Bip01_Head1",
		model = "models/arctic_nvgs/nvg_gpnvg.mdl",
		femPos = Vector(-1, 0, 0.5),
		norender = true,
		scale = 0.95,
		femscale = 0.92,
		effect = "MetalSpark",
		surfaceprop = 77,
		mass = 1.5,
		ScrappersSlot = "Armor",
		custommat = Material("overlays/nvg_scene_opticf2.png"),
		NVGRender = function()
			 
			if not IsValid(lply.EZNVGlamp) then
				lply.EZNVGlamp = ProjectedTexture()
				lply.EZNVGlamp:SetTexture("effects/flashlight001")
				lply.EZNVGlamp:SetBrightness(.02)
				lply.EZNVGlamp:SetEnableShadows(false)
				local FoV = lply:GetFOV()
				lply.EZNVGlamp:SetFOV(FoV+45)
				lply.EZNVGlamp:SetFarZ(500000 / FoV)
				lply.EZNVGlamp:SetConstantAttenuation(.1)
			else
				local Ang = EyeAngles()
				lply.EZNVGlamp:SetPos(lply:EyePos())
				lply.EZNVGlamp:SetAngles(Ang)
				lply.EZNVGlamp:Update()
			end

			BlurScreen(0.2,65)

			DrawColorModify(colormodify01)
			DrawColorModify(colormodify02)

			DrawBloom(0.2, 1, 4, 4, 1, 0.8, 1, 1, 1)
			DrawNoise(500,25)

			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(custommat or mat)
			local viewpunching = GetViewPunchAngles()
			surface.DrawTexturedRect(-ScrW()+(ScrW()*1.5)/2 - viewpunching.r * 5, -20 - viewpunching.x*5, ScrW()*1.5, ScrH()+40)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(-ScrW()+(ScrW()*1.5)/2,(ScrH()+20) - viewpunching.x*5, ScrW()*1.5, ScrH()+40)
			surface.DrawRect(-ScrW()+(ScrW()*1.5)/2,-(ScrH()+40) - viewpunching.x*5, ScrW()*1.5, ScrH()+40)
		end,
		CustomSnd = "snds_jack_gmod/tinycapcharge.wav",
		AfterPickup = function(ply)
			timer.Simple(1,function()
				if IsValid(ply) and ply:IsPlayer() then
					ply:Notify("Enable \\ Disable NVG - С + E",nil,nil,0)
				end
			end)
		end
	}
}
if SERVER then
	local ArmorEffect
	local force
	local function protec(org, bone, dmg, dmgInfo, placement, armor, scale, scaleprot, punch, boneindex, dir, hit, ricochet)
		if not force and org.owner.armors[placement] ~= armor then return 0 end
		force = nil
		
		local prot = placement and wn.armor[placement] and armor and wn.armor[placement][armor] and (wn.armor[placement][armor].protection - (dmgInfo:GetInflictor().bullet and dmgInfo:GetInflictor().bullet.Penetration or 1)) or (10 - ( dmgInfo:GetInflictor().bullet and dmgInfo:GetInflictor().bullet.Penetration or 1))
		
		if punch then
			if org.owner:IsPlayer() and org.alive and dmgInfo:IsDamageType(DMG_BUCKSHOT + DMG_BULLET) then
				org.owner:ViewPunch(AngleRand(-30, 30))
				if not IsValid(org.owner.FakeRagdoll) then
					--org.owner:EmitSound("homigrad/player/headshot_helmet.wav")
				end
				org.disorientation = org.disorientation + dmg * math.Rand(0,3)

				wn.organism.input_list.spine3(org, bone, (dmg/100) * math.Rand(0,0.1), dmgInfo)
				--org.spine3 = org.spine3 + math.Rand(0.05,1) * dmg / 5
			end
		end
		
		scale = scale * (dmgInfo:IsDamageType(DMG_SLASH) and 0.1 or 1)
		
		ArmorEffect(placement, armor, dmgInfo, org, hit, prot)


		if prot < 0 then
			//dmgInfo:ScaleDamage(scale)
			return 0
		end

		dmgInfo:SetDamageType(DMG_CLUB)
		dmgInfo:ScaleDamage(0.2)
		
		return 0.9
	end

	ArmorEffect = function(placement, armor, dmgInfo, org, hit, prot)
		local armdata = placement and wn.armor[placement] and wn.armor[placement][armor] or {}
		local eff = prot < 0 and "Impact" or armdata.effect or "Impact"
		local dir = -dmgInfo:GetDamageForce()
		dir:Normalize()
		local effdata = EffectData()
		
		effdata:SetOrigin((hit and isvector(hit) and hit or dmgInfo:GetDamagePosition()) - dir)
		effdata:SetNormal(dir)
		effdata:SetMagnitude(0.25)
		effdata:SetRadius(4)
		effdata:SetNormal(dir)
		effdata:SetStart((hit and isvector(hit) and hit or dmgInfo:GetDamagePosition()) + dir)
		effdata:SetEntity(org.owner)
		effdata:SetSurfaceProp(prot < 0 and 67 or armdata.surfaceprop or 67)
		effdata:SetDamageType(dmgInfo:GetDamageType())

		EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(4)..".wav",dmgInfo:GetDamagePosition(),0,CHAN_AUTO,1,55,nil,100)
		util.Effect(eff,effdata)
	end

	local ArmorEffectEx = function(ent,dmgInfo,eff,surfaceprop)
		local dir = -dmgInfo:GetDamageForce()
		dir:Normalize()
		local effdata = EffectData()
		
		effdata:SetOrigin( dmgInfo:GetDamagePosition() - dir )
		effdata:SetNormal( dir )
		effdata:SetMagnitude(0.25)
		effdata:SetRadius(4)
		effdata:SetNormal(dir)
		effdata:SetStart(dmgInfo:GetDamagePosition() + dir)
		effdata:SetEntity(ent)
		effdata:SetSurfaceProp(surfaceprop or 67)
		effdata:SetDamageType(dmgInfo:GetDamageType())

		EmitSound("physics/metal/metal_solid_impact_bullet"..math.random(4)..".wav",dmgInfo:GetDamagePosition(),0,CHAN_AUTO,1,55,nil,100)
		util.Effect(eff,effdata)
	end

	wn.ArmorEffect = ArmorEffect
	wn.ArmorEffectEx = ArmorEffectEx

	wn.organism = wn.organism or {}
	wn.organism.input_list = wn.organism.input_list or {}
	wn.organism.input_list.vest1 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest1", 0.6, 0.6, false, ...)
		return protect
	end

	wn.organism.input_list.helmet1 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet1", 1, 0.6, true, ...)
		return protect
	end

	wn.organism.input_list.helmet2 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet2", 1, 0.3, true, ...)
		return protect
	end

	wn.organism.input_list.helmet3 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet3", 1, 0.25, true, ...)
		return protect
	end

	wn.organism.input_list.helmet5 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet5", 1, 0.4, true, ...)
		return protect
	end

	wn.organism.input_list.helmet6 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet6", 1, 0.5, true, ...)
		return protect
	end

	wn.organism.input_list.helmet7 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet7", 1, 0.4, true, ...)
		return protect
	end

	wn.organism.input_list.helmet8 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "head", "helmet8", 1, 0.6, true, ...)
		return protect
	end

	wn.organism.input_list.vest2 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest2", 1, 0.3, false, ...)
		return protect
	end

	wn.organism.input_list.vest3 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest3", 0.8, 0.3, false, ...)
		return protect
	end

	wn.organism.input_list.vest4 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest4", 0.8, 0.3, false, ...)
		return protect
	end

	wn.organism.input_list.mask1 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "face", "mask1", 1, 0.9, true, ...)
		return protect
	end

	wn.organism.input_list.mask3 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "face", "mask3", 1, 1, true, ...)
		return protect
	end

	wn.organism.input_list.vest5 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest5", 0.8, 0.6, false, ...)
		return protect
	end
	wn.organism.input_list.vest6 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest6", 0.8, 0.4, false, ...)
		return protect
	end

	wn.organism.input_list.vest7 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest7", 0.7, 0.4, false, ...)
		return protect
	end

	wn.organism.input_list.vest8 = function(org, bone, dmg, dmgInfo, ...)
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "vest8", 0.7, 0.4, false, ...)
		return protect
	end
	-------------------------------------------------------------------

	-- Gordon's armor
	wn.organism.input_list.gordon_helmet = function(org, bone, dmg, dmgInfo, ...)
		local owner = wn.GetCurrentCharacter(org.owner) or org.owner
		if owner:GetBodygroup(2) ~= 2 then return 0 end
		--owner:SetBodygroup(2,0)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "head", "gordon_helmet", 0.5, 0.3, false, ...)
		return protect
	end
	
	wn.organism.input_list.gordon_armor = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "gordon_armor", 0.5, 0.3, true, ...)
		return protect
	end
	
	wn.organism.input_list.gordon_arm_armor_left = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "arm", "gordon_arm_armor_left", 0.5, 0.3, false, ...)
		return protect
	end
	

	wn.organism.input_list.gordon_arm_armor_right = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "arm", "gordon_arm_armor_right", 0.5, 0.3, false, ...)
		return protect
	end
	

	wn.organism.input_list.gordon_leg_armor_left = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "leg", "gordon_leg_armor_left", 0.5, 0.3, false, ...)
		return protect
	end

	wn.organism.input_list.gordon_leg_armor_right = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "leg", "gordon_leg_armor_right", 0.5, 0.3, false, ...)
		return protect
	end
	

	wn.organism.input_list.gordon_calf_armor_left = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "leg", "gordon_calf_armor_left", 0.5, 0.3, false, ...)
		return protect
	end
	

	wn.organism.input_list.gordon_calf_armor_right = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "leg", "gordon_calf_armor_right", 0.5, 0.3, false, ...)
		return protect
	end

	-------------------------------------------------------------------

	-- Combine armor
	wn.organism.input_list.cmb_helmet = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "head", "cmb_helmet", 0.8, 0.7, true, ...)
		return protect
	end
	
	wn.organism.input_list.cmb_armor = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "torso", "cmb_armor", 0.9, 0.7, false, ...)
		return protect
	end
	
	wn.organism.input_list.cmb_arm_armor_left = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "arm", "cmb_arm_armor_left", 0.9, 0.7, false, ...)
		return protect
	end
	

	wn.organism.input_list.cmb_arm_armor_right = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "arm", "cmb_arm_armor_right", 0.9, 0.7, false, ...)
		return protect
	end
	

	wn.organism.input_list.cmb_leg_armor_left = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "leg", "cmb_leg_armor_left", 0.9, 0.7, false, ...)
		return protect
	end

	wn.organism.input_list.cmb_leg_armor_right = function(org, bone, dmg, dmgInfo, ...)
		force = true
		local protect = protec(org, bone, dmg, dmgInfo, "leg", "cmb_leg_armor_right", 0.9, 0.7, false, ...)
		return protect
	end
end

local armorNames = {
	["vest1"] = "Plate Body Armor IV",
	["helmet1"] = "ACH Helmet III",
	["helmet2"] = "Biker Helmet",
	["helmet3"] = "Riot Helmet",
	["helmet4"] = "Pot",
	["helmet7"] = "SSh-68",
	["helmet8"] = "UNTAR Helmet",
	["vest2"] = "Police Riot Vest",
	["vest3"] = "Kevlar IIIA Vest",
	["vest4"] = "Kevlar III Vest",
	["mask1"] = "Balistic Mask",
	["mask2"] = "M40 Gas Mask",
	["mask3"] = "Welding Mask",
	["vest5"] = "6B13",
	["nightvision1"] = "NVG GPNVG 18",
	["vest6"] = "PACA Soft Armor",
	["vest7"] = "MF-UNTAR Body Armor",
	["headphones1"] = "MSA Sordin Supreme PRO-X/L",
	["helmet5"] = "HighCom Striker ACHHC IIIA helmet",
	["vest8"] = "SWAT Balistic Vest",
	["ego_equalizer"] = "[HE] Equalizer",
	["helmet6"] = "SWAT Balistic Helmet"
}
wn.armorNames = armorNames
local armorIcons = {
	["vest1"] = "scrappers/armor1.png",
	["helmet1"] = "vgui/icons/helmet.png",
	["helmet2"] = "vgui/icons/mothelmet.png",
	["helmet3"] = "vgui/icons/riothelm.png",
	["helmet4"] = "entities/ent_jack_gmod_ezarmor_bomber.png",
	["helmet7"] = "entities/ent_jack_gmod_ezarmor_ssh68.png",
	["helmet8"] = "entities/ent_jack_gmod_ezarmor_untarhelm.png",
	["vest2"] = "vgui/icons/policevest.png",
	["vest3"] = "vgui/icons/armor01.png",
	["vest4"] = "vgui/icons/armor02.png",
	["mask1"] = "vgui/icons/ballisticmask",
	["mask2"] = "vgui/icons/gasmask",
	["mask3"] = "entities/ent_jack_gmod_ezarmor_weldingkill.png",
	["vest5"] = "entities/ent_jack_gmod_ezarmor_6b13flora.png",
	["nightvision1"] = "vgui/icons/nvg",
	["vest6"] = "entities/ent_jack_gmod_ezarmor_paca.png",
	["vest7"] = "entities/ent_jack_gmod_ezarmor_untar.png",
	["headphones1"] = "entities/ent_jack_gmod_ezarmor_sordin.png",
	["helmet5"] = "entities/ent_jack_gmod_ezarmor_achhcblack.png",
	["vest8"] = "vgui/icons/armor01.png",
	["helmet6"] = "vgui/icons/helmet.png",
}
wn.armorIcons = armorIcons

local entityMeta = FindMetaTable("Entity")
function entityMeta:SyncArmor()
	if self.armors then
		self:SetNetVar("Armor", self.armors)
		local rag = wn.GetCurrentCharacter(self)
		if IsValid(rag) and rag:IsRagdoll() then
			rag:SetNetVar("Armor", self.armors)
		end
	end
end

local function initArmor()
	for possibleArmor, armors in pairs(wn.armor) do
		for armorkey, armorData in pairs(armors) do
			if CLIENT then language.Add(armorkey, (wn.armorNames and wn.armorNames[armorkey]) or armorkey) end
			local armor = {}
			armor.Base = "wn_armor_base"
			armor.PrintName = CLIENT and language.GetPhrase(armorkey) or armorkey
			armor.name = armorkey
			armor.Category = "WN Armor"
			armor.Spawnable = true
			armor.Model = armorData[2]
			armor.WorldModel = armorData[2]
			armor.SubMats = armorData[4]
			armor.armor = armorData
			armor.placement = armorData[1]
			armor.IconOverride = wn.armorIcons[armorkey]
			armor.PhysModel = armorData.PhysModel or nil
			armor.PhysPos = armorData.PhysPos or nil
			armor.PhysAng = armorData.PhysAng or nil
			armor.material = armorData.material or nil
			scripted_ents.Register(armor, "ent_wn_armor_" .. armorkey)
		end
	end
end

function wn.GetArmorPlacement(armor)
	if istable(armor) then return end
	armor = string.Replace(armor,"ent_armor_","")
	
	local found
	for i,armplc in pairs(wn.armor) do
		for i2,armor2 in pairs(armplc) do
			if i2 == armor then found = i end
		end
	end
	return found
end

local stringToNum = {
	["torso"] = 1,
	["head"] = 2,
	["face"] = 3,
}

function wn.GetArmorPlacementNum(armor)
	return stringToNum[wn.GetArmorPlacement(armor)]
end

initArmor()
hook.Add("Initialize", "init-atts", initArmor)