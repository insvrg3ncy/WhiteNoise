
hook.Add("WN_OnPlayerChat", "TextModificationBasedOnStuff", function(ply, text, bTeam, bDead, plyColor, plyName, bWhisper)
	local txt = text[1]
	
	local dist = ply:GetPos():Distance(lply:GetPos())
	if dist > 512 then
		local cutdist = (dist - 512) / 64
		local cutamt = math.Round(cutdist, 0)

		local iter = utf8.codes(txt)
		local len = 0
		local chars = {}
		local minus = utf8.codepoint("-", 1, 1)
		for i, code in iter do
			if math.random(10 - math.max(cutamt, 1)) == 1 then -- max dist 640
				code = minus
			end

			len = len + 1
			chars[len] = utf8.char(code)
		end
		txt = table.concat(chars)
	end

	text[1] = txt
end)

hook.Add("ScalePlayerDamage", "remove-effects", function(ent, hitgroup, dmgInfo)
	if dmgInfo:IsDamageType(DMG_BUCKSHOT + DMG_BULLET + DMG_SLASH) then
		return true
	end
end)

local min = math.min
local pain_mat = Material("sprites/mat_jack_hmcd_narrow")

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

local tabblood = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

local k1, k2, k3

local upDir = Vector(0, 0, 1)
local fwdDir = Vector(0, 2.5, 0)
local rightDir = Vector(2.5, 0, 0)

local function MegaDSP(ply)
		local trDist = 3000
		local view = render.GetViewSetup()
		local viewent = GetViewEntity()
		local filter = {wn.GetCurrentCharacter(ply),ply,viewent}
		local trUp = util.TraceLine({
			start = view.origin,
			endpos = view.origin + upDir * trDist,
			filter = filter
		})
		local trUpFwdL = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir + fwdDir - rightDir) * trDist,
			filter = filter
		})
		local trUpFwd = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir + fwdDir + rightDir / 2) * trDist,
			filter = filter
		})
		local trUpFwdR = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir + fwdDir + rightDir) * trDist,
			filter = filter
		})
		local trUpBackL = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir - fwdDir - rightDir) * trDist,
			filter = filter
		})
		local trUpBack = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir - fwdDir + rightDir / 2) * trDist,
			filter = filter
		})
		local trUpBackR = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir - fwdDir + rightDir) * trDist,
			filter = filter
		})
		local trRight = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir + rightDir) * trDist,
			filter = filter
		})
		local trLeft = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (upDir - rightDir) * trDist,
			filter = filter
		})
	
		local trDown = util.TraceLine({
			start = view.origin,
			endpos = view.origin - upDir * trDist,
			filter = filter
		})
		local trDownFwdL = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir + fwdDir - rightDir) * trDist,
			filter = filter
		})
		local trDownFwd = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir + fwdDir + rightDir / 2) * trDist,
			filter = filter
		})
		local trDownFwdR = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir + fwdDir + rightDir) * trDist,
			filter = filter
		})
		local trDownBackL = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir - fwdDir - rightDir) * trDist,
			filter = filter
		})
		local trDownBack = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir - fwdDir + rightDir / 2) * trDist,
			filter = filter
		})
		local trDownBackR = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir - fwdDir + rightDir) * trDist,
			filter = filter
		})
		local trDownRight = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir + rightDir) * trDist,
			filter = filter
		})
		local trDownLeft = util.TraceLine({
			start = view.origin,
			endpos = view.origin + (-upDir - rightDir) * trDist,
			filter = filter
		})
	
		local avgUpDist = 0
		local avgDownDist = 0
		local avgDist
		local upTraces = {trUp, trUpFwdL, trUpFwd, trUpFwdR, trUpBackL, trUpBack, trUpBackR, trRight, trLeft}
		local downTraces = {trDown, trDownFwdL, trDownFwd, trDownFwdR, trDownBackL, trDownBack, trDownBackR, trDownRight, trDownLeft}
		local shouldCompute = true
	
		for _, tr in ipairs(upTraces) do
			-- debugoverlay.Line(view.origin, tr.HitPos, 0.1)
			if not tr.Hit or tr.HitSky then
				shouldCompute = false
				break
			end
		end
		for _, tr in ipairs(downTraces) do
			-- debugoverlay.Line(view.origin, tr.HitPos, 0.1)
			if not tr.Hit or tr.HitSky then
				shouldCompute = false
				break
			end
		end
	
		if shouldCompute then
			for _, tr in ipairs(upTraces) do
				avgUpDist = avgUpDist + (tr.Hit and (tr.HitPos - view.origin):LengthSqr() or 0)
			end
			avgUpDist = avgUpDist / #upTraces
	
			for _, tr in ipairs(downTraces) do
				avgDownDist = avgDownDist + (tr.Hit and (tr.HitPos - view.origin):LengthSqr() or 0)
			end
			avgDownDist = avgDownDist / #downTraces
			
			avgDist = avgUpDist > avgDownDist and avgUpDist or avgDownDist
		else
			avgDist = 10 ^ 8
		end
	
		-- Do not set to 0 for no effect; it causes DSP allocation error.
		--print(avgDist)
		if avgDist > 50000000 then
			RunConsoleCommand("dsp_player", 0)
			RunConsoleCommand("room_type", 1)
		elseif avgDist > 5000000 then
			RunConsoleCommand("dsp_player", 105)
			RunConsoleCommand("room_type", 1)
		elseif avgDist > 500000 then
			RunConsoleCommand("dsp_player", 3)
			RunConsoleCommand("room_type", 1)
		elseif avgDist > 50000 then
			RunConsoleCommand("dsp_player", 2)
			RunConsoleCommand("room_type", 1)
		elseif avgDist > 5000 then
			RunConsoleCommand("dsp_player", 104)
			RunConsoleCommand("room_type", 1)
		elseif avgDist <= 5000 then
			RunConsoleCommand("dsp_player", 102)
			RunConsoleCommand("room_type", 1)
		end
end

local function plyCommand(ply,cmd)
	local time = CurTime()
	ply.cmdtimer = ply.cmdtimer or time
	
	if cmd == "soundfade 100 99999" then
		if atlaschat and atlaschat.theme and IsValid(atlaschat.theme.GetValue("panel")) then
			atlaschat.theme.GetValue("panel").list:AlphaTo(0, 0, 0)
			atlaschat.theme.GetValue("panel"):AlphaTo(0, 0, 0)

			timer.Create("otrubhuy", 1, 1, function()
				if not lply.organism.otrub then lply:ConCommand("soundfade 0 1") end
				atlaschat.theme.GetValue("panel").list:AlphaTo(255, 1.5, 0)
				atlaschat.theme.GetValue("panel"):AlphaTo(255, 1.5, 0)
			end)
		end
	end

	if ply.cmdtimer < time then
		ply.cmdtimer = time + 0.1

		ply:ConCommand(cmd)
	end
end

local clr_black1 = Color( 0, 0, 0, 255)
local clr_black2 = Color( 0, 0, 0, 255)

local mat1 = Material("vgui/gradient-u")
local mat2 = Material("vgui/gradient-d")

local ang1 = Angle()
local ang2 = Angle()

hook.Add("HUDShouldDraw", "wn.HUDShouldDraw", function(id)
	if (fakeTimer and fakeTimer - 2 > CurTime()) then
		return false
	end
end)

hook.Add("WN_OnOtrub", "adsadsadhuy!!", function(ply)	
	if ply == LocalPlayer() then
		lply:SetDSP(17)
		plyCommand(lply,"soundfade 100 99999")
	end
end)

hook.Add("Player Death", "adsadsadhuy!!", function(ply)	
	if ply == LocalPlayer() then
		lply:SetDSP(17)
		plyCommand(lply,"soundfade 100 99999")
	end
end)

local auto_dsp_convar = ConVarExists("hg_auto_dsp") and GetConVar("hg_auto_dsp") or CreateClientConVar("hg_auto_dsp","1",true,false,"Enable auto D.S.P. (Reverb, echo etc.)",0,1)

local alivestart = CurTime()
wn.screens = wn.screens or {}
local screens = wn.screens
local screened = 0
local curscreen = 1
local switch = false
local file_Delete = file.Delete
wn.alivecntr = wn.alivecntr or 0

local function remove_imgs()
	if file.Exists("dreams", "DATA") then
		local files, _ = file.Find("dreams/*", "DATA")

		for i, file in pairs(files) do
			file_Delete("dreams/"..file)
		end
	end
end

local disorientationLerp = 0

hook.Add("Player Spawn", "screenshot_game", function(ply)
	if OverrideSpawn then return end

	if ply == lply then
		disorientationLerp = 0

		alivestart = CurTime()
		lply.tried_fixing_limb = nil

		wn.alivecntr = wn.alivecntr + 1

		for i, screen in ipairs(wn.screens) do
			wn.screens[i] = nil
		end

		remove_imgs()
	end
end)

hook.Add("InitPostEntity", "removeshits", function()
	remove_imgs()
end)

hook.Add("Player Disconnected", "removeshits", function()
	remove_imgs()
end)

hook.Add("radialOptions", "DislocatedJoint", function()
    if !lply:Alive() or !lply.organism or lply.organism.otrub then return end
	if (lply.tried_fixing_limb or 0) > CurTime() then return end
	local org = lply.organism
	if org.pain > 60 then return end
    
    if org.llegdislocation or org.rlegdislocation then
        local tbl = {
            function()
				lply.tried_fixing_limb = CurTime() + 0.5
				RunConsoleCommand("hg_fixdislocation", 1, 0)
            end,
            "Fix dislocation (leg)"
        }
        wn.radialOptions[#wn.radialOptions + 1] = tbl
	else
		local ent = wn.eyeTrace(lply).Entity

		if ent.organism and (ent.organism.llegdislocation or ent.organism.rlegdislocation) then
			local tbl = {
				function()
					lply.tried_fixing_limb = CurTime() + 0.5
					RunConsoleCommand("hg_fixdislocation", 1, 1)
				end,
				"Fix "..ent:GetPlayerName().."'s dislocation (arm)"
			}
			wn.radialOptions[#wn.radialOptions + 1] = tbl
		end
    end
end)

hook.Add("radialOptions", "DislocatedJoint2", function()
    if !lply:Alive() or !lply.organism or lply.organism.otrub then return end
	if (lply.tried_fixing_limb or 0) > CurTime() then return end
	local org = lply.organism
	if org.pain > 60 then return end
	
    if org.larmdislocation or org.rarmdislocation then
        local tbl = {
            function()
				lply.tried_fixing_limb = CurTime() + 0.5
				RunConsoleCommand("hg_fixdislocation", 2, 0)
            end,
            "Fix dislocation (arm)"
        }
        wn.radialOptions[#wn.radialOptions + 1] = tbl
	else
		local ent = wn.eyeTrace(lply).Entity

		if ent.organism and (ent.organism.larmdislocation or ent.organism.rarmdislocation) then
			local tbl = {
				function()
					lply.tried_fixing_limb = CurTime() + 0.5
					RunConsoleCommand("hg_fixdislocation", 2, 1)
				end,
				"Fix "..ent:GetPlayerName().."'s dislocation (arm)"
			}
			wn.radialOptions[#wn.radialOptions + 1] = tbl
		end
    end
end)

hook.Add("radialOptions", "DislocatedJaw", function()
    if !lply:Alive() or !lply.organism or lply.organism.otrub then return end
	if (lply.tried_fixing_limb or 0) > CurTime() then return end
	local org = lply.organism
	if org.pain > 60 then return end
	
    if org.jawdislocation then
        local tbl = {
            function()
				lply.tried_fixing_limb = CurTime() + 0.5
				RunConsoleCommand("hg_fixdislocation", 3, 0)
            end,
            "Fix dislocation (jaw)"
        }
        wn.radialOptions[#wn.radialOptions + 1] = tbl
	else
		local ent = wn.eyeTrace(lply).Entity

		if ent.organism and ent.organism.jawdislocation then
			local tbl = {
				function()
					lply.tried_fixing_limb = CurTime() + 0.5
					RunConsoleCommand("hg_fixdislocation", 3, 1)
				end,
				"Fix "..ent:GetPlayerName().."'s dislocation (jaw)"
			}
			wn.radialOptions[#wn.radialOptions + 1] = tbl
		end
    end
end)

hook.Add("PostRender", "screenshot_think", function()
	do return end
	local org = lply.organism
	
	if not org or not org.brain or org.otrub or !lply:Alive() then return end
	
	local part = CurTime() - alivestart
	//print(part)
	if part % 60 > 59 and (screened != math.Round(part / 60, 0)) then
		screened = math.Round(part / 60, 0)
		//gui.HideGameUI()

		if gui.IsGameUIVisible() or gui.IsConsoleVisible() or IsValid(vgui.GetHoveredPanel()) then return end

		local data = render.Capture( {
			format = "jpeg",
			x = 0,
			y = 0,
			w = ScrW(),
			h = ScrH(),
			quality = 1,
			//alpha = false
		} )

		if not data then return end

		local name = "dreams/dream"..wn.alivecntr.."_"..(#screens + 1)..".jpeg"
		
		if not file.Exists("dreams", "DATA") then file.CreateDir("dreams") end
		file.Write(name, data)
		
		timer.Simple(1, function()
			screens[#screens + 1] = Material("data/"..name)
		end)
	end
end)

local braindeathstart = CurTime() + 20
local lerpedpart = 0
local lerpedbrain = 0

hook.Add("Post Pre Post Processing", "ShowScreens", function()
	local org = lply.organism
	
	if !lply:Alive() then return end
	if not org or not org.brain then return end

	local part = CurTime() - braindeathstart

	local show_multiki = org.brain > 0.1 and org.otrub

	if show_multiki then
		lerpedbrain = LerpFT(0.05, lerpedbrain, org.brain)
		local time = 40 - (lerpedbrain - 0.1) * 20
		if part % time > time / 3 and curscreen <= #screens and screens[curscreen] and !screens[curscreen]:IsError() then
			switch = true
			local part2 = math.ease.InOutSine(math.sin(((part % time) - time / 3) / (time / 3 * 2) * math.pi))
			lerpedpart = LerpFT(0.1, lerpedpart, part2)
			
			surface.SetDrawColor(255, 255, 255, math.Clamp(lerpedpart * 50, 0, 255))
			surface.SetMaterial(screens[curscreen])
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

			DrawToyTown(4, ScrH())
		else
			if switch then
				curscreen = curscreen == #screens and 1 or curscreen + 1
				switch = false
			end
		end
	else
		braindeathstart = CurTime()
	end
end)

local hurtoverlay = Material("zcity/neurotrauma/damageOverlay.png")
local blindoverlay = Material("zcity/neurotrauma/blindoverlay.png")
local addtime = CurTime()

local hg_potatopc
local old = false
local tinnitusSoundFactor

hook.Add("RenderScreenspaceEffects", "organism-effects", function()
	local spect = IsValid(lply:GetNWEntity("spect")) and lply:GetNWEntity("spect")
	local organism = lply:Alive() and lply.organism or (viewmode == 1 and IsValid(spect) and spect.organism) or {}
	local new_organism = lply:Alive() and lply.new_organism or (viewmode == 1 and IsValid(spect) and spect.new_organism) or {}

	//wn.DrawAffliction(0, 0, 100, 100, 1, "pale")

	if organism.owner == LocalPlayer() then
		if new_organism.otrub and !old then
			hook.Run("WN_OnOtrub", new_organism.owner)
		end
		
		old = new_organism.otrub
	end

	--LerpVariables(FrameTime(),organism,new_organism)

	if not organism then return end
	local alive = lply:Alive() or (spect and spect:Alive())

	local health = (lply:Alive() and lply:Health()) or 100

	if not alive or follow then end

	local org = organism
	
	if not org.brain then return end
	
	local adrenaline = org.adrenaline or 0
	local pulse = org.pulse or 70
	local pain = org.pain or 0
	local hurt = org.hurt or 0
	local blood = org.blood or 5000
	local bleed = org.bleed or 0
	local o2 = org.o2 and org.o2[1] or 30
	local brain = org.brain or 0
	local otrub = lply:Alive() and org.otrub or false
	local analgesia = organism.analgesia or 0
	local health = health
	local disorientation = org.disorientation or 0
	local immobilization = org.immobilization or 0
	local incapacitated = org.incapacitated or false
	local critical = org.critical or false
	tinnitusSoundFactor = Lerp(FrameTime()*2.5,tinnitusSoundFactor or 0, math.min(math.max( lply.tinnitus and (lply.tinnitus - CurTime()) or 0, 0)*7.5,120))
	--print(lply.tinnitus)
	local adrenK = math.min(math.max(1 + adrenaline, 1), 1.2)
	
	if lply.suiciding and lply:Alive() then
		lply:SetDSP(130)
		olddspchange = true
	else
		if olddspchange then
			lply:SetDSP(0)
			olddspchange = false
		end
	end

	if org.otrub then
		//DrawMotionBlur(0.1, 1., 0.1)
		//lply:ScreenFade( SCREENFADE.IN, clr_black2, 2, 0.5 )
	end

	if otrub or (fakeTimer and fakeTimer - 2 > CurTime()) then
		--if otrub or (fakeTimer and fakeTimer - 2 > CurTime()) then
		clr_black1.a = math.Clamp(pain / 50 * 255, 250, 255)
		//lply:ScreenFade( SCREENFADE.IN, clr_black2, 2, 0.5 )
		--lply:ScreenFade( SCREENFADE.IN, Color(0,0,0,255), 2, 0.5 )

		if isnumber(wn.ROUND_STATE) and (wn.ROUND_STATE ~= 1) then
			lply:SetDSP(0)
			plyCommand(lply,"soundfade "..tinnitusSoundFactor.." 25")
		elseif lply:Alive() then
			lply:SetDSP(17)
			plyCommand(lply,"soundfade 100 25")
		end
	else
		--print(tinnitusSoundFactor)
		plyCommand(lply,"soundfade "..tinnitusSoundFactor.." 25")

		if ((disorientation and disorientation > 3) or (brain and brain > 0.2)) and lply:Alive() then
			lply:SetDSP(130)
		end
		if auto_dsp_convar:GetBool() then
			MegaDSP(lply)
		else
			lply:SetDSP(0)
		end
	end

	if not alive then
		return false
	end
	
	k1 = Lerp(FrameTime() * 15, k1 or 0, math.min(math.min(adrenaline / 1, 1.2),1.5))
	k2 = (30 - (o2 or 30)) / 30 + (1 - org.consciousness) * 1-- + brain * 2
	k3 = ((5000 / math.max(blood, 1000)) - 1) * 1.5

	DrawSharpen(k1 * 1.5, k1 * 1)
	local lowpulse = math.max((70 - pulse) / 70, 0) + math.max(3000 * ((math.cos(CurTime()/2) + 1) / 2 * 0.1 + 1) - (blood * adrenK - 300),0) / 400

	local amount = 1 - math.Clamp(lowpulse + disorientation / 4 + k2 * 2,0,1)

	disorientationLerp = LerpFT(disorientation > disorientationLerp and 1 or 0.01, disorientationLerp, disorientation)

	if (disorientationLerp > 1) and lply:Alive() or brain > 0 then
		local add2 = disorientationLerp - 1
		if not brain_motionblur then DrawMotionBlur(0.15 - math.Clamp(add2 / 1, 0, 0.1), add2 * 2, 0.001) end
		if disorientationLerp > 2 then
			local add = (disorientationLerp - 2) * 2
			local time = CurTime() * 3
			local mul = math.Clamp(add / 16, 0, 0.2)

			ang1[1] = math.cos(time) + math.sin(time * 0.5) + math.sin((time - 5) * 1.1)
			ang1[2] = math.sin(time) + math.cos(time * 0.5) + math.sin((time + 1) * 1.1)
			ViewPunch(ang1 * mul * 0.25)
			//ViewPunch2(ang1 * mul * 1 * 0.25)

			//local ang = lply:EyeAngles()
			//lply:SetEyeAngles(ang - ang1 * 0.01)

			ang2[3] = math.Rand(-15,15) * mul
			//SetViewPunchAngles(ang2)
			//ViewPunch(ang1 * mul * 1)
		end
	end

	if (blood < 3600) then
		lerpblood = LerpFT(0.01, lerpblood or 0, pain / 250 * 255)
		local lowblood = (3600 - blood) / 600

		addtime = addtime + FrameTime() / 6
		local amt = (math.cos(addtime) + math.sin(addtime * 3) + math.sin(addtime * 2)) / 90
		local amt2 = (math.sin(addtime) + math.cos(addtime * 5) + math.sin(addtime * 6)) / 90
		surface.SetDrawColor(255, 255, 255, (lowblood * 2) * 200)
		local mat = Matrix({
			{1 - amt, amt, 0, -amt2 / 2},
			{amt2, 1 - amt2, 0, -amt / 2},
			{0, 0, 1, 0},
			{0, 0, 0, 1},
		})
		hurtoverlay:SetMatrix("$basetexturetransform", mat)
		surface.SetMaterial(hurtoverlay)
		surface.SetDrawColor(255,255,255,lerpblood)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		//ViewPunch(Angle(-amt * 1, amt2 * 1,0))
		//ViewPunch2(Angle(-amt * 1, amt2 * 1,0))
	end
	//pain = math.abs(math.cos(CurTime())) * 40
	if (pain > 0) or (hurt > 0) or (immobilization > 0) or (brain > 0) then
		local k = ((hurt + immobilization / 15) / 2)
		--DrawToyTown(1, k * ScrH())
		local newpain = pain - 10
		if newpain > 0 then
			//surface.SetDrawColor(0, 0, 0, (newpain / 20) * 255 - math.ease.InOutCirc(math.abs(math.cos(CurTime()))) * 50)
			//surface.SetMaterial(pain_mat)
			//surface.DrawTexturedRect(-1, -1, ScrW()+1, ScrH()+1)
			local blur = math.max((newpain / 30 + brain * 10),0) / 30
			if blur > 0 then
				DrawMaterialOverlay( "sprites/mat_jack_hmcd_scope_aberration", blur )
			end
		end
	end
	hg_potatopc = hg_potatopc or wn.ConVars.potatopc
	local potato = hg_potatopc:GetBool()
	if (k1 > 0) or (k2 > 0) or (k3 > 0) or brain > 0 then
		if !potato then
			DrawToyTown(2, (k3 * 3 + k2 * 5 + brain * 10) * ScrH() / 2)
		else

		end
	end

	--DrawMaterialOverlay( "whitenoise/vgui/bloodblur.png", 0)
	local view = render.GetViewSetup()
	--RenderSuperDoF(view.origin,view.angles,0)
	if analgesia > 1 then
		DrawMaterialOverlay( "particle/warp4_warp_noz", -(analgesia - 0.5) * math.sin(CurTime()) * 5 / 150 )
	end

	/*

	local amt = (math.cos(addtime) + math.sin(addtime * 3) + math.sin(addtime * 2)) / 90
	local amt2 = (math.sin(addtime) + math.cos(addtime * 5) + math.sin(addtime * 6)) / 90
	surface.SetDrawColor(255,255,255,math.abs(amt * 255 * 30))
	surface.SetMaterial(blindoverlay)

	local mat = Matrix({
		{1 - amt, amt, 0, -amt2 / 2},
		{amt2, 1 - amt2, 0, -amt / 2},
		{0, 0, 1, 0},
		{0, 0, 0, 1},
	})
	blindoverlay:SetMatrix("$basetexturetransform", mat)
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

	*/

	tabblood["$pp_colour_colour"] = Lerp(FrameTime() * 30, tabblood["$pp_colour_colour"], (blood / 5000) * (potato and (blood / 5000) or 1) + (math.max(org.analgesia - 1, 0) * math.sin(CurTime()) * 5))
	//tabblood["$pp_colour_contrast"] = Lerp(FrameTime() * 30, tabblood["$pp_colour_contrast"], health < 80 and math.max(1.5 * ( 1 - math.min(health / 50, 1) ), 1 ) or 1)
	tabblood["$pp_colour_brightness"] = Lerp(FrameTime() * 30, tabblood["$pp_colour_brightness"], (potato and (blood / 5000 - 1) / 2 or 0) )
	tabblood["$pp_colour_addb"] = !org.otrub and ((potato and k2 / 5 or 0)) or 0
	//tabblood["$pp_colour_addg"] = k2 / 15
	//tabblood["$pp_colour_addr"] = k2 / 15
	--tab["$pp_colour_brightness"] = k1 > 1 and -(k1 - 1) / 20 or 0
	--tab["$pp_colour_contrast"] = k1 > 1 and -(k1 - 1) / 10 + 1 or 1
	--DrawBloom( 0.80, 2, 9, 9, 1, 1, 1, 1, 1 )
	//DrawColorModify(tab)
	
	DrawColorModify(tabblood)

	local ent = IsValid(lply.FakeRagdoll) and lply.FakeRagdoll or lply

	if otrub then
		--[[render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )

		local textOtrub = "You are unconscious. "
		local textOtrub2 =  
			( critical and "You can't be saved." ) or 
			( incapacitated and "You will not get up without someone's help." ) or 
			( 
				"You will probably wake up in "
				..( 	
					( pain < 50 and "about a minute." ) or 
					( pain < 100 and "about two minutes." ) or 
					"a few minutes."
				) 
			)

		local parsed = markup.Parse( 
			"<font=WhiteNoiseFontMedium>"..
			( critical and "You're criticaly injured." or textOtrub )..
			"\n<colour=255,"..( critical and 25 or 255 )..","..( critical and 25 or 255 ) ..",255>"..
			( textOtrub2 ).."</colour></font>" 
		)
		--((critical and "You can not be saved.") or 
		--(incapacitated and "You will not get up without someone's help.") or 
		--( "You will probably wake up in " .. (pain < 50 and "about a minute.") ) or 
		--((pain < 100 and "about two minutes.") or "a few minutes.")) -- WTF???
		
		--surface.SetTextColor(255,255,255,255)
		--surface.SetFont("WhiteNoiseFontMedium")
		--local txtSizeX, txtSizeY = surface.GetTextSize(textOtrub)
		--surface.SetTextPos(ScrW()/2 - (txtSizeX/2),ScrH()/1.1 - (txtSizeY/2))
		--surface.DrawText(textOtrub)

		parsed:Draw( ScrW()/2, ScrH()/1.1, TEXT_ALIGN_CENTER, nil, nil, TEXT_ALIGN_CENTER )
		
		render.PopFilterMag()
		render.PopFilterMin()--]]
	end
	
	if IsValid(ent) and ent.Blinking and lply:Alive() then
		surface.SetDrawColor(0,0,0,255)
		if amtflashed and amtflashed > 0.1 then
			surface.DrawRect(-1,-1,ScrW()+1,ent.Blinking * ScrH())
			surface.DrawRect(-1,ScrH() + 1,ScrW()+1,-ent.Blinking * ScrH())
		end
	end
end)

hook.Add("OnNetVarSet","wounds_netvar",function(index, key, var)
	if key == "wounds" then
		local ent = Entity(index)
		--local ent = wn.RagdollOwner(ent) or ent
		
		if IsValid(ent) then
			if ent.wounds then
				for i = 1, #ent.wounds do
					if !var or !var[i] then continue end
					var[i][5] = ent.wounds[i][5]
				end
			end

			ent.wounds = var

			local rag = IsValid(ent:GetNWEntity("FakeRagdoll")) and ent:GetNWEntity("FakeRagdoll")-- or IsValid(ent:GetNWEntity("RagdollDeath")) and ent:GetNWEntity("RagdollDeath")
			if IsValid(rag) then
				rag.wounds = rag:GetNetVar("wounds") or var
			end
		end
	end
end)

hook.Add("OnNetVarSet","wounds_netvar2",function(index, key, var)
	if key == "arterialwounds" then
		local ent = Entity(index)
		--local ent = wn.RagdollOwner(ent) or ent
		
		if IsValid(ent) then
			if ent.arterialwounds then
				for i = 1, #ent.arterialwounds do
					if not var[i] then continue end
					var[i][5] = ent.arterialwounds[i][5]
				end
			end

			ent.arterialwounds = var
			local rag = IsValid(ent:GetNWEntity("FakeRagdoll")) and ent:GetNWEntity("FakeRagdoll")-- or IsValid(ent:GetNWEntity("RagdollDeath")) and ent:GetNWEntity("RagdollDeath")
			
			if IsValid(rag) then
				rag.arterialwounds = rag:GetNetVar("arterialwounds") or var
			end
		end
	end
end)

hook.Add("Player Spawn", "removewounds", function(ply)
	if OverrideSpawn then return end

	ply.wounds = {}
	ply.arterialwounds = {}
end)

hook.Add("Fake", "huyhuyhuy235", function(ply,ragdoll)
	if not IsValid(ragdoll) then return end

	ragdoll.wounds = ply.wounds
	ragdoll.arterialwounds = ply.arterialwounds
end)

function wn.applyFountain(pos, ang, mul, mul2, forward, ent)
	if bit.band(util.PointContents(pos), CONTENTS_WATER) == CONTENTS_WATER then
		if math.random(2) == 1 then return end
		wn.addBloodPart2(pos, ang:Forward() * forward * 0.5 + VectorRand(-25,25) * mul2, nil, nil, nil, nil, true, nil, ent)
		wn.addBloodPart2(pos + VectorRand(-1,1), ang:Forward() * forward * 0.25 + VectorRand(-10,10) * mul2, nil, nil, nil, nil, true, nil, ent)
		//wn.addBloodPart2(pos + VectorRand(-1,1), ang:Forward() * forward * 0.25 + VectorRand(-10,10) * mul2, nil, nil, nil, nil, true, nil, ent)
	else
		wn.addBloodPart(pos, ang:Forward() * forward * 2 * math.abs(math.sin(CurTime() * 3) + math.cos(CurTime() * 5) + math.sin(CurTime() * 2) + 4) * 0.1 + ang:Right() * 15 * (math.sin(CurTime()) * 1) + ang:Right() * math.sin(CurTime() * 2) * 15 + VectorRand(-3, 3),nil,nil,nil,true)
		wn.addBloodPart(pos + VectorRand(-1,1), ang:Forward() * 55 + VectorRand(-25,25) * mul2,nil,nil,nil,nil, nil, ent)
		//wn.addBloodPart(pos + VectorRand(-1,1), ang:Forward() * 55 + VectorRand(-25,25) * mul2,nil,nil,nil,nil, nil, ent)
	end
end

local hg_new_blood = ConVarExists("hg_new_blood") and GetConVar("hg_new_blood") or CreateClientConVar("hg_new_blood", 0, true, false, "new decals, or old", 0, 1)

hook.Add("Player-Ragdoll think", "organism-think-client-blood", function(ply, ent, time)
	--local ent = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or ply
	--print(ply,ent,ply.organism.owner,ply.new_organism.owner)
	local organism = ply.organism
	local new_organism = ply.new_organism
	
	local seen = ent.shouldTransmit and not ent.NotSeen
	local wounds = ply.wounds
	local arterialwounds = ply.arterialwounds

	ply.pulse_breathe = ply.pulse_breathe or {}
	ent.pulse_breathe = ply.pulse_breathe
	
	wn.LerpVariables(FrameTime() * 10, organism, new_organism)
	
	local org = ent.organism or {}
	local owner = ent
	
	local beatsPerSecond = math.max(min(30 / math.max(org.pulse or 70,2), 4), 0.1) * (hg_new_blood:GetBool() and 0.3 or 1)
		
	if org.pulse and (ent.pulse_breathe.lastpulse or 0) < CurTime() then
		ent.pulse_breathe.lastpulse = CurTime() + (1 / math.Clamp(org.pulse,1,200)) * 60
		local pulse = org.pulse or 0
		local pain = org.pain or 0

		if (pulse > 75) or (pain > 60) then
			ply:EmitSound("heartbeat/heartbeat_single.wav", ((pain > 60 and ply == lply) and 60 or min(pulse/2, 25)), 100, ((pain > 60 and ply == lply) and 1 or (pulse > 75 and (pulse - 75) / 37.5 + 0.3 or 0.3)))
		end
	end

	--why?

	if org.pulse and (ent.pulse_breathe.lastbreathe or 0) < CurTime() and org.o2 and org.o2[1] and (org.pulse > 80 or (org.o2[1] < 15 and ent:WaterLevel() == 3)) and org.lungsfunction and not org.holdingbreath and org.timeValue then
		local pulse = org.pulse or 0
		ent.pulse_breathe.lastbreathe = CurTime() + (1 / math.Clamp(org.pulse + (org.o2[1] - 30) * 1,1,120)) * 100 + ( org.o2[1] < 20 and 5 or 0)
		
		if (ent:WaterLevel() < 3) then
			local muffed

			if ent.armors then
				muffed = ent.armors["face"] == "mask2" or ent.PlayerClassName == "Combine"
			end
			
			if org.o2.curregen <= org.timeValue * 0.5 and org.o2[1] < 20 then
				//soundName: string, soundLevel: number, pitchPercent: number, volume: number, channel: number, soundFlags: number, dsp: number, filter: CRecipientFilter
				ply:EmitSound("zcitysnd/real_sonar/"..(ThatPlyIsFemale(ent) and "fe" or "").."male_wheeze"..math.random(5)..".mp3", 40, nil, nil, nil, nil, 1)
			else
				-- if ent.PlayerClassName == "furry" then
				-- 	ply:EmitSound("zbattle/furry/dog_pant" .. math.random(1, 4) .. ".ogg", min(pulse * 1.35 / ( muffed and 2.5 or 4), 55), math.random(95, 105), pulse > 80 and (pulse - 80) / 10 or 0.5, CHAN_AUTO, 0, muffed and 16 or 0)
				-- else
					ply:EmitSound("snds_jack_hmcd_breathing/" .. (ThatPlyIsFemale(ent) and "f" or "m") .. math.random(4) .. ".wav", min(pulse * 1.35 / ( muffed and 2.5 or 4), 55), math.random(95, 105) + (ply.PlayerClassName == "furry" and 20 or 0), pulse > 80 and (pulse - 80) / 10 or 0.5, CHAN_AUTO, 0, muffed and 16 or 0)
				-- end
			end
		else
			if org.o2[1] < 15 then
				ply:EmitSound("zcitysnd/real_sonar/"..(ThatPlyIsFemale(ent) and "fe" or "").."male_drown"..math.random(5)..".mp3", 60)
			end
		end
	end

	local fountains = GetNetVar("fountains")
	if fountains and fountains[ent] then
		local tbl = fountains[ent]
		if (tbl.time or 0) < CurTime() and org.pulse then
			local mul = 1 / math.max(org.pulse / 40 * 25, 2) * 0.75
			local mul2 = math.max(org.pulse, 1) / 15
			local forward = mul2 * 150
			tbl.time = CurTime() + mul * 0.5
			
			if seen then
				local mat = ent:GetBoneMatrix(tbl.bone)

				if mat then
					local pos, ang = LocalToWorld(tbl.lpos, tbl.lang, mat:GetTranslation(), mat:GetAngles())
					
					wn.applyFountain(pos, ang, mul, mul2, forward, ent)
				end
			else
				local pos, ang = ent:GetPos(), angle_zero
				wn.applyFountain(pos, ang, mul, mul2, forward, ent)
			end
		end
	end
	
	if wounds and #wounds > 0 then
		for i, wound in pairs(wounds) do
			local size = math.random(0, 1) * math.max(math.min(wound[1], 1), 0.5)

			if wound[5] + beatsPerSecond < time then
				wound[5] = time + math.Rand(0, 1) * (hg_new_blood:GetBool() and 0.5 or 1) / wound[1] * 15

				if (owner:IsPlayer() and owner:Alive()) or not owner:IsPlayer() then
					if seen then
						local bone = wound[4]
						local mat = ent:GetBoneMatrix(bone)
						if not mat then return end
						local bonePos, boneAng = mat:GetTranslation(), mat:GetAngles()
						if not wound[2] or not wound[3] or not bonePos or not boneAng then return end
						local pos = LocalToWorld(vector_origin--[[wound[2]], wound[3], bonePos, boneAng)

						if bit.band(util.PointContents(pos), CONTENTS_WATER) == CONTENTS_WATER then
							wn.addBloodPart2(pos, VectorRand(-5, 5), nil, nil, nil, nil, true, nil, ent)
						else
							wn.addBloodPart(pos, VectorRand(-15, 15), nil, size, size, false, nil, ent)
						end
					else
						local pos = ent:GetPos()

						if bit.band(util.PointContents(pos), CONTENTS_WATER) == CONTENTS_WATER then
							wn.addBloodPart2(pos, VectorRand(-5, 5), nil, nil, nil, nil, true, nil, ent)
						else
							wn.addBloodPart(pos, VectorRand(-15, 15), nil, size, size, false, nil, ent)
						end
					end
				end
			end
		end
	end

	if arterialwounds and #arterialwounds > 0 then
		for i, wound in pairs(arterialwounds) do
			local addtime = seen and 1 / math.Clamp(org.pulse or 70, 1,15) * 0.15 or 0.06
			if wound[5] + addtime < time then
				local pos, ang = ent:GetBonePosition(wound[4])
				wound[5] = time
				if (owner:IsPlayer() and owner:Alive()) or not owner:IsPlayer() then
					local size = math.random(1, 2) * math.max(math.min(wound[1], 1), 0.5)
					if seen then
						local bone = wound[4]
						local mat = ent:GetBoneMatrix(bone)
						if not mat then return end
						local bonePos, boneAng = mat:GetTranslation(), mat:GetAngles()
						if not wound[2] or not wound[3] or not bonePos or not boneAng then return end
						local pos = LocalToWorld(vector_origin--[[wound[2]], wound[3], bonePos, boneAng)

						local dir = wound[6]
						local len = dir:Length() * (org.pulse or 70) / 70
						local _, dir = LocalToWorld(vector_origin, dir:Angle(), vector_origin, ang)
						dir = -dir:Forward() * len
						if bit.band(util.PointContents(pos), CONTENTS_WATER) == CONTENTS_WATER then
							wn.addBloodPart2(pos, VectorRand(-5, 5), nil, nil, nil, nil, true, nil, ent)
						else
							wn.addBloodPart(pos, VectorRand(-1, 1) * (org.pulse or 70) / 70 + dir * 5 * (math.abs(math.sin(CurTime() * 2) + math.cos(CurTime() * (5 + i * 2)) + math.sin(CurTime() * (1 + i))) * 0.6 + math.sin(CurTime() * 2) + 4) * 0.1 + dir:Angle():Right() * 25 * math.sin(CurTime() * 2) * math.cos(CurTime() * 4) + ang:Up() * 25 * math.sin(CurTime() * 3) * math.cos(CurTime() * 1) + VectorRand(-1, 1) * (org.pulse or 70) / 70, nil, size, size, true, nil, ent)
						end
					else
						local pos = ent:GetPos()
						
						if bit.band(util.PointContents(pos), CONTENTS_WATER) == CONTENTS_WATER then
							wn.addBloodPart2(pos, VectorRand(-5, 5), nil, nil, nil, nil, true, nil, ent)
						else
							wn.addBloodPart(pos, VectorRand(-15, 15), nil, size, size, true, nil, ent)
						end
					end
				end
			end
		end
	end
end)

local red = Color(255, 0, 0)

local AdminAbuse = CreateClientConVar("hg_adminabuse", "0", false)


hook.Add("SetupOutlines", "WN_AdminAbuse_Outlines", function(Add)
	local ply = LocalPlayer()
	if not ply:IsAdmin() then return end
	if not AdminAbuse:GetBool() then return end

	local targets = {}
	for _, target in player.Iterator() do
		if IsValid(target) and target:Alive() and target:Team() ~= TEAM_SPECTATOR then
			table.insert(targets, target)
		end
	end

	outline.Add(targets, red, OUTLINE_MODE_BOTH)
end)

local UpVector = Vector(0, 0, 80)


hook.Add("PreDrawHUD", "WN_AdminAbuse_ESP", function()
	local ply = LocalPlayer()
	if not ply:IsAdmin() then return end
	if not AdminAbuse:GetBool() then return end

	for _, target in player.Iterator() do
		if not IsValid(target) or not target:Alive() or target:Team() == TEAM_SPECTATOR then
			continue
		end

		if target == ply then continue end

		local eyePos = target:EyePos()
		local eyeDir = target:EyeAngles():Forward()
		local endPos = eyePos + eyeDir * 10000

		cam.Start3D()
			render.DrawLine(eyePos, endPos, red, true)
		cam.End3D()

		local ScreenPos = (target:GetPos() + UpVector):ToScreen()

		cam.Start2D()
			draw.SimpleText(target:Nick(), "TargetIDSmall", ScreenPos.x, ScreenPos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End2D()
	end
end)

local prank = {}
local time_troll = 100

local DontCallMe = false
hook.Add("HG.InputMouseApply","zzzzzzzzzzzzbrain_death",function(tbl)
	 

	if lply:Alive() and lply.organism and (lply.organism.brain or 0) > 0.1 then
		if #prank < time_troll then table.insert(prank,1,{tbl.x,tbl.y}) end
		if #prank >= time_troll then table.remove(prank,#prank) end
		
		local amt = lply.organism.brain / 0.3

		local xa = Lerp(1 * amt,tbl.x,prank[#prank][1])// + math.sin(CurTime() / 5) * amt * 10
		local ya = Lerp(1 * amt,tbl.y,prank[#prank][2])// + math.cos(CurTime() / 5) * math.sin(CurTime() / 2) * amt * 10

		tbl.angle.pitch = math.Clamp(tbl.angle.pitch + tbl.y / 100 + ya / 100, -89, 89)
		tbl.angle.yaw = tbl.angle.yaw - tbl.x / 100 - xa / 100
		tbl.override_angle = true
	end

	--[[local actwep = LocalPlayer():GetActiveWeapon()
	if not actwep or not actwep.GetTrace then return end
	local hitpos,pos,ang = actwep:GetTrace()

	local ply = wn.GetCurrentCharacter(Entity(2))
	local dist = ply:EyePos():Distance(LocalPlayer():EyePos())
	ply:SetupBones()
	scr = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Head1")):GetTranslation():ToScreen()

	angle.pitch = math.Clamp(angle.pitch + (scr.y - (pos+ang:Forward() * dist):ToScreen().y) / 50, -89, 89)
	angle.yaw = angle.yaw - (scr.x - (pos+ang:Forward() * dist):ToScreen().x) / 50
	cmd:SetViewAngles(angle)

	return true--]]
end)