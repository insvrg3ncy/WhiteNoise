bloodparticles1 = bloodparticles1 or {}
bloodparticles_hook = bloodparticles_hook or {}

local tr = {
	//filter = function(ent) return not ent:IsPlayer() and not ent:IsRagdoll() end
}

local col_red_darker = Color(122,0,0)
local col_red = Color(200,0,0)
local vecDown = Vector(0, 0, -40)
local vecZero = Vector(0, 0, 0)
local LerpVector = LerpVector
local math_random = math.random
local table_remove = table.remove
local util_Decal = util.Decal
local util_TraceLine = util.TraceLine
local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local render_DrawBeam = render.DrawBeam

local hg_blood_draw_distance = ConVarExists("hg_blood_draw_distance") and GetConVar("hg_blood_draw_distance") or CreateClientConVar("hg_blood_draw_distance", 1024, true, nil, "distance to draw blood", 0, 4096)
local hg_blood_sprites = ConVarExists("hg_blood_sprites") and GetConVar("hg_blood_sprites") or CreateClientConVar("hg_blood_sprites", 1, true, nil, "blood is sprites or trails", 0, 1)

hook.Add("PostCleanupMap","removeblooddroplets",function()
	bloodparticles1 = {}
	wn.bloodpositions = {}
	wn.bloodcount = 0
end)

local mat_huy = Material("effects/blood_core")
  
bloodparticles_hook[1] = function(anim_pos,mul)
	 
	local int = hg_blood_draw_distance:GetInt()
	local pos = lply:EyePos()
	--render.OverrideBlend( true, BLEND_SRC_ALPHA, BLEND_ONE, BLENDFUNC_ADD )
	local dstsqr = int * int
	local lplypos = LocalPlayer():EyePos()
	local lplyang = LocalPlayer():EyeAngles():Forward()
	for i = 1, #bloodparticles1 do
		local part = bloodparticles1[i]
		if not part then continue end
		if (pos - lplypos):Dot(lplyang) < 0 then continue end
		if (part[2] - pos):LengthSqr() > dstsqr then continue end
		--if !wn.isVisible(part[1],LocalPlayer():GetShootPos(),LocalPlayer(),MASK_VISIBLE) then continue end
		--render_SetMaterial(part[4])
		local pos = LerpVector(anim_pos, part[2], part[1])
		
		if part.kishki then
			render_SetMaterial(part[4])
			render_DrawSprite(pos, part[5], part[6], col_red)
		else
			render_SetMaterial(mat_huy)
			render_DrawBeam(pos - (part[2] - part[1]) * 0.5 / mul / 24,pos + (part[2] - part[1]) * 0.5 / mul / 24, 1, 0, 1, part[9] or (part.artery and col_red or col_red_darker) )
		end
	end
	--render.OverrideBlend( false )
end

local hg_new_blood = ConVarExists("hg_new_blood") and GetConVar("hg_new_blood") or CreateClientConVar("hg_new_blood", 0, true, false, "new decals, or old", 0, 1)
local hg_experimental_blood = ConVarExists("hg_experimental_blood") and GetConVar("hg_experimental_blood") or CreateClientConVar("hg_experimental_blood", 0, true, false, "experimental shit", 0, 1)

wn.bloodpositions = wn.bloodpositions or {}
wn.bloodcount = wn.bloodcount or 0
local function decalBlood(pos, normal, hitTexture, artery, owner)
	local vec = tostring(math.Round(pos[1]))..tostring(math.Round(pos[2]))..tostring(math.Round(pos[3]))

	wn.bloodpositions[vec] = (wn.bloodpositions[vec] or 0) + 1
	wn.bloodcount = wn.bloodcount + 1
	
	if wn.bloodcount > 10000 then
		wn.bloodpositions = {}
		wn.bloodcount = 0
	end

	-- я не знаю насколько большой можно делать такие таблицы... надеюсь, что это не так страшно выйдет

	if artery then
		if hg_new_blood:GetBool() then
			local howmuch = hg_experimental_blood:GetBool() and (math.random(2) == 1 and (util.RemoveDecalsAt(pos, 0.6) + 1) or 1) or 1
			
			//timer.Simple(0.1, function()
				if wn.bloodpositions[vec] and wn.bloodpositions[vec] < 5 then
					util.Decal("Arterial.Blood2"..math.max(math.Clamp(howmuch + ((!hg_experimental_blood:GetBool() and math.random(0, 3) or 1) or 0), 1, 5), wn.bloodpositions[vec]), pos + normal, pos - normal, owner)
				end
			//end)
		else
			util.Decal("Arterial.Blood1", pos + normal, pos - normal, owner)
		end
	else
		if hg_new_blood:GetBool() then
			local howmuch = hg_experimental_blood:GetBool() and (math.random(2) == 1 and (util.RemoveDecalsAt(pos, 0.6) + 1) or 1) or 1

			//timer.Simple(0.1, function()
				if wn.bloodpositions[vec] and wn.bloodpositions[vec] < 5 then
					util.Decal("Normal.Blood2"..math.max(math.Clamp(howmuch + ((!hg_experimental_blood:GetBool() and math.random(1, 4) or 1) or 0), 1, 5), wn.bloodpositions[vec]), pos + normal + VectorRand(-1, 1), pos - normal + VectorRand(-1, 1), owner)
				end
			//end)
		else
			util.Decal("Normal.Blood1", pos + normal, pos - normal, owner)
		end
	end
end
--дурак, просто смотри сколько ентити стоит в одном месте
local tr2 = { collisiongroup = COLLISION_GROUP_WORLD, output = {} }

function util.IsInWorld( pos )
	tr2.start = pos
	tr2.endpos = pos

	return not util.TraceLine( tr2 ).HitWorld
end

local gravity = GetConVar("sv_gravity")

local radius = 20000
local radiusSqr = radius * radius

hook.Add("InitPostEntity", "sizeget", function()
	if hg and isfunction(wn.GetWorldSize) then
		radius = wn.GetWorldSize()
	else
		radius = radius or 20000
	end
    radiusSqr = radius * radius
end)

bloodparticles_hook[2] = function(mul)
	local grav = gravity:GetInt() / 10
    local time = CurTime()

	for i = #bloodparticles1, 1, -1 do
		local part = bloodparticles1[i]
		if not part then table_remove(bloodparticles1, i) continue end
		
		local pos = part[1]
		local posSet = part[2]

		tr.start = posSet
		tr.endpos = tr.start + part[3] * mul
		tr.collisiongroup = COLLISION_GROUP_WORLD

		result = util_TraceLine(tr)
		local hitPos = result.HitPos
		
		if radiusSqr < hitPos:LengthSqr() then table_remove(bloodparticles1, i) continue end
		
        if bit.band(util.PointContents(hitPos), CONTENTS_WATER) == CONTENTS_WATER then
			wn.addBloodPart2(hitPos, part[3] / 20 + VectorRand(-1, 1), nil, nil, nil, nil, true)

			table_remove(bloodparticles1, i)
			continue
		end
		
		if time - part[7] >= 30 then
			table_remove(bloodparticles1, i)

			continue
		end

		if result.Hit then
			table_remove(bloodparticles1, i)
			local dir = result.HitNormal
			decalBlood(result.HitPos, dir, result.HitTexture, part.artery, part.owner)
			sound.Play("whitenoise/blooddrip" .. math_random(1, 4) .. ".wav", hitPos, math.random(10, 60), math.random(80, 120))
			
			continue
		else
			pos:Set(posSet + part.start_velocity * mul)
			posSet:Set(hitPos + part.start_velocity * mul)
		end

		--if bit.band( util.PointContents( pos ), CONTENTS_WATER ) == CONTENTS_WATER then
		--	part[9] = part[9] or Color(115,0,0,250)
		--	part[9].a = Lerp(0.25,part[9].a or 250, 0)
		--	if part[4]~= WetBlood then part[4] = WetBlood end
		--	part[5] = Lerp(0.01,part[5], 25)
		--	part[6] = Lerp(0.01,part[6], 25)
		--	part[3] = LerpVector(0.25 * 3, part[3], vecZero)
		--	part[8] = part[8] or VectorRand() * 0.5
		--	part[3]:Add((VectorRand() * 1) + part[8])
		--	if part[9].a < 5 then table_remove(bloodparticles1,i) continue end
		--else
			part[3] = LerpVector(0.25 * mul, part[3], vecZero)
			part[3]:Add(vecDown * mul * (math.max(0.1, grav)))
		--end
	end
end