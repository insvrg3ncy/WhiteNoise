local min, max, Round = math.min, math.max, math.Round
--local Organism = wn.organism
wn.organism.module.stamina = {}
local module = wn.organism.module.stamina
module[1] = function(org)
	org.adrenaline = 0
	org.adrenalineAdd = 0

	org.stamina = {
		range = 60 * 3,
		regen = 1,
		sub = 0,
		subadd = 0,
		weight = 0,
		max = 60 * 3,
	}

	org.energy = 0

	org.hemotransfusionshock = 0

	org.stamina[1] = org.stamina.range
	local owner = org.owner
	org.moveMaxSpeed = IsValid(owner) and owner:IsPlayer() and owner:GetMaxSpeed() or 250
end

module[2] = function(owner, org, timeValue)
	local stamina = org.stamina
	stamina.sub = 0
	local velLen = 0
	if owner:IsPlayer() then
		local walk = owner:KeyDown(IN_FORWARD) or owner:KeyDown(IN_BACK) or owner:KeyDown(IN_MOVELEFT) or owner:KeyDown(IN_MOVERIGHT)
		velLen = min(owner:GetVelocity():Length(), org.moveMaxSpeed) / owner:GetRunSpeed()
		if (owner:OnGround() or owner:WaterLevel() >= 2) and walk and not owner:InVehicle() and owner:IsSprinting() and org.stamina[1] > 20 then
			stamina.sub = (owner:WaterLevel() >= 2 and 2 or 1) * (velLen ^ 0.5)
		end
	end

	if org.superfighter then
		org.stamina.subadd = org.stamina.subadd / 4
	end

	if org.chest > 0.3 then
		org.lungsL[2] = math.min(org.lungsL[2] + stamina.sub / 200 * org.chest, 1)
		org.lungsR[2] = math.min(org.lungsR[2] + stamina.sub / 200 * org.chest, 1)
	end

	stamina.sub = stamina.sub + stamina.subadd + (org.painkiller > 1.6 and (stamina[1] > 10 and 0.8 or 0) or 0) + (org.analgesia > 1.7 and (stamina[1] > 10 and 2 or 0) or 0)
	stamina.sub = stamina.sub * (owner.StaminaExhaustMul or 1)

	stamina.subadd = 0
	stamina.weight = owner:IsPlayer() and math.Clamp((1 / wn.CalculateWeight(owner,250)) - 1,0,1) or 0
	local muffed = owner.armors and owner.armors["face"] == "mask2"
	stamina.sub = stamina.sub + stamina.sub * stamina.weight * (muffed and 2 or 1)
	org.hungry = org.hungry or 0
	stamina.max = (org.superfighter and 2 or 1) * ((stamina.range * (1 - (org.pneumothorax) / 2) + org.adrenaline * 20 ) * math.max(1 - org.hemotransfusionshock,0.2)) * math.max(1 - (org.hungry/100),0.65)
	stamina[1] = max(stamina[1] - stamina.sub * timeValue * 20, 0)
	//org.o2[1] = org.o2[1] - min(stamina.sub * timeValue, org.o2.regen * timeValue)
	stamina[1] = min(stamina[1] + stamina.regen * timeValue * 9 * 1.5 * math.max(org.stamina[1] / org.stamina.max, 0.2) ^ 0.5 * (org.adrenaline / 16 + 1) * (org.satiety/75 + 1) * ((owner:IsPlayer() and owner:Crouching() and velLen < 0.1) and 1.1 or 1) * (org.holdingbreath and 0 or 1) * (org.lungsfunction and 1 or 0), stamina.max)
end

local vecZero = Vector(0, 0, 0)
hook.Add("FinishMove", "!whitenoise-organism", function(ply, move)
	local vel = move:GetFinalJumpVelocity()

	if !ply.organism then return end

	if vel ~= vecZero then ply.organism.stamina[1] = max(ply.organism.stamina[1] - ply:GetJumpPower() / 10,0) end
	ply.organism.moveMaxSpeed = move:GetMaxSpeed()
end)