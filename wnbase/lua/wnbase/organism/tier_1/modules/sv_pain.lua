local max, min, Clamp, Approach = math.max, math.min, math.Clamp, math.Approach
--local Organism = wn.organism
wn.organism.module.pain = {}
local module = wn.organism.module.pain
module[1] = function(org)
	org.shock = 0
	org.pain = 0
	org.avgpain = 0
	org.painadd = 0
	org.hurt = 0
	org.hurtadd = 0
	org.painkiller = 0
	org.analgesia = 0
	org.analgesiaAdd = 0
	org.naloxone = 0
	org.naloxoneadd = 0
	org.immobilization = 0
	org.paincritical = 60
	org.painlessen = 0
	org.tranquilizer = 0

	org.stun = 0
	org.lightstun = 0
end

function wn.organism.paincheck(org)
	local analgesiaMul = (org.analgesia * 4 + 1)
	local adrenalineMul = min(max(1 + org.adrenaline, 1), 1.2)

	return (org.shock > org.shock_turn * 4 * analgesiaMul)
end

module[2] = function(owner, org, timeValue)
	local adrenalineMul = min(max(1 + org.adrenaline, 1), 1.2)
	local adrenaline = org.adrenaline
	local analgesiaMul = (org.analgesia * 4 + 1)
	local painkillerMul = (org.painkiller * 0.5 + 1)

	org.shock_turn = 10 * (!org.otrub and 1 or 0.1)

	if org.shock > org.shock_turn * 1.5 * analgesiaMul * painkillerMul then
		org.needfake = true
	end

	org.pain_turn = org.otrub and adrenalineMul * 80 or adrenalineMul * 90

	local owner = org.owner
	
	if !org.lasthit or org.lasthit + 1.5 < CurTime() then org.shock = max(org.shock - timeValue * 4 * (org.otrub and 1 or 0.5), 0) end
	org.immobilization = max(org.immobilization - timeValue * 2 * adrenalineMul, 0)

	local shouldPainAdd = not (org.otrub or org.spine2 >= wn.organism.fake_spine2 or org.spine3 >= wn.organism.fake_spine3)
	
	local add = math.min(timeValue * 20, org.painadd)
	local sub = (add <= 0.2) and (timeValue * 2 * (org.otrub and 2 or 1) + timeValue * (org.painkiller * 2) + timeValue * (org.analgesia * 4)) or (0)

	if adrenaline > 0.5 then
		sub = sub * math.max(2 - adrenaline, 0.1) / 1.5// / (adrenaline >= 2 and 16 or 8)
		add = add * math.max(2 - adrenaline, 0.1) / 1.5// / (adrenaline >= 2 and 16 or 8)
	end

	if org.pain > 60 and not org.otrub then
		add = add / 5
		if org.pain > 70 and add > 0.01 then
			sub = sub / 20
		else
			sub = sub / 5
		end

		org.disorientation = org.disorientation + add
		org.fearadd = 1

		if org.pain > 70 and org.alive then
			wn.StunPlayer(owner)
			org.shock = org.shock + timeValue * 8
		end
	end

	if org.tranquilizer > 0 then
		org.tranquilizer = math.Approach(org.tranquilizer, 0, timeValue / 60)
		org.consciousness = math.Approach(org.consciousness, 0, timeValue / 30)
	else
		org.consciousness = math.Approach(org.consciousness, 1, timeValue / 30)
	end

	if org.consciousness < 0.5 then
		org.needotrub = true
	end

	org.avgpain = min(org.avgpain + add, 150)
	if !org.lasthit or org.lasthit + 1 < CurTime() then org.avgpain = max(org.avgpain - sub, 0) end
	org.painlessen = sub

	org.pain = org.avgpain * math.max(1 - adrenaline / 3, 0.3) * math.max(1 - org.analgesia, 0)

	org.painadd = max(org.painadd - add, 0)

	//org.painkiller = Approach(org.painkiller, 0, timeValue / 240 * (org.naloxone * 25 + 1))

	if wn.organism.paincheck(org) then
		org.needotrub = true
	end
	
	org.analgesia =  Approach(org.analgesia, 0, timeValue / 240 * (org.naloxone * 25 + 1))
	
	if org.analgesiaAdd > 0 then
		org.analgesia =  Approach(org.analgesia, 4, timeValue / 15)
		org.analgesiaAdd = Approach(org.analgesiaAdd, 0, timeValue / 15)
	end

	org.naloxone = Approach(org.naloxone, org.naloxoneadd > 0 and 4 or 0, org.naloxoneadd > 0 and timeValue / 30 or timeValue / 60)
	org.naloxoneadd = Approach(org.naloxoneadd, 0, timeValue / 15)
	
	--if owner.suiciding and org.adrenaline < 1.5 then
	--	org.adrenalineAdd = Approach(org.adrenalineAdd, 4, timeValue / 5)
	--end

	if org.adrenalineAdd > 0 then
		org.adrenaline = Approach(org.adrenaline, 4, timeValue / 5)
	end

	org.adrenalineAdd = Approach(org.adrenalineAdd, 0, org.adrenalineAdd < 0 and timeValue / 30 or timeValue / 5)

	org.adrenaline = Approach(org.adrenaline, 0, timeValue / 30)

	if org.lleg < 1 then
		org.lleg = max(org.lleg - timeValue / 240, 0)
	end

	if org.rleg < 1 then
		org.rleg = max(org.rleg - timeValue / 240, 0)
	end

	if org.rarm < 1 then
		org.rarm = max(org.rarm - timeValue / 240, 0)
	end

	if org.larm < 1 then
		org.larm = max(org.larm - timeValue / 240, 0)
	end

	if org.pain > org.paincritical then		
		org.needfake = true
	end

	org.disorientation = min(max(org.disorientation - timeValue / 5, 0), 10)
end