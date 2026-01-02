wn.organism = wn.organism or {}
--local Organism = wn.organism
wn.organism.list = wn.organism.list or {}
local hook_Run = hook.Run
function wn.organism.Add(ent)
	ent.organism = {
		owner = ent
	}

	local org = ent.organism
	org.owner = ent
	wn.organism.list[ent] = org
	return org
end

function wn.organism.Clear(org)
	hook_Run("Org Clear", org)
	if IsValid(org.owner) then org.owner.fullsend = true end
	wn.send_organism(org)
end

function wn.organism.Remove(ent)
	local org = wn.organism.list[ent]
	if org then org.owner = nil end
	wn.organism.list[ent] = nil
end

hook.Add("PlayerInitialSpawn", "whitenoise-organism", function(ply) wn.organism.Add(ply) end)
hook.Add("Player Spawn", "whitenoise-organism", function(ply) wn.organism.Clear(ply.organism) end)
hook.Add("PlayerDisconnected", "whitenoise-organism", function(ply) wn.organism.Remove(ply) end)
hook.Add("PostPlayerDeath", "whitenoise-organism", function(ply)
	local ragdoll = ply:GetNWEntity("RagdollDeath")
	
	if not IsValid(ragdoll) then ragdoll = ply.FakeRagdoll end

	if IsValid(ragdoll) then
		local newOrg = wn.organism.Add(ragdoll)
		table.Merge(newOrg,ply.organism)

		hook.Run("RagdollDeath",ply,ragdoll)

		table.Merge(wn.net.list[ragdoll], wn.net.list[ply])

		newOrg.alive = false
		newOrg.owner = ragdoll
		ragdoll:CallOnRemove("organism", wn.organism.Remove, ragdoll)
	end

	wn.organism.Clear(ply.organism)
end)

local tickrate = 1 / 10
local delay = 0
local time, mulTime, start
local CurTime = CurTime
local SysTime = SysTime
hook.Add("Think", "whitenoise-organism", function()
	time = CurTime()
	local tickrate2 = tickrate// / math.max(game.GetTimeScale(), 0.01)
	//print(delay ,time + tickrate)
	if delay + tickrate2 > time then return end

	delay = time

	if not start then
		start = SysTime()
		return
	end
	
	mulTime = (SysTime() - start) * game.GetTimeScale()

	start = SysTime()
	for owner, org in pairs(wn.organism.list) do
		hook_Run("Org Think", owner, org, mulTime)
	end
end)

hook.Add("Org Think Call", "whitenoise-organism", function(owner, org)
	time = CurTime()

	if not start then
		start = SysTime()
		return
	end

	local mulTime = SysTime() - start
	
	hook_Run("Org Think", owner, org, mulTime)
end)


hook.Add("Fake", "organism", function(ply, ragdoll)
	ragdoll.organism = ply.organism
	--wn.net.list[ragdoll] = wn.net.list[ply]
end)