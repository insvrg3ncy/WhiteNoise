
local PLAYER = FindMetaTable("Player")
util.AddNetworkString("hg_headcrab")
function PLAYER:AddHeadcrab(headcrab)
    --self.organism.headcrabon = headcrab
    self:SetNetVar("headcrab",headcrab)
   
    self.organism.headcrabon = headcrab and CurTime()

    --[[net.Start("hg_headcrab")
    net.WriteEntity(self)
    net.WriteString(headcrab)
    net.Broadcast()--]]
end

hook.Add("RagdollDeath","headcrab",function(ply,rag)
    rag:SetNetVar("headcrab",ply:GetNetVar("headcrab"))
    ply:SetNetVar("headcrab",false)
end)

hook.Add("Org Clear","removeheadcrab",function(org)
    org.headcrabon = nil
end)

hook.Add("Org Think", "Headcrab",function(owner, org, timeValue)
    if not owner then return end
    if not owner:IsPlayer() or not owner:Alive() then return end

    if org.headcrabon and (org.headcrabon + 10) < CurTime() and org.brain != 1 then
		local ent = wn.GetCurrentCharacter(owner) or owner
		local mul = ((org.headcrabon + 60) - CurTime()) / 60
		if mul > 0 then
			ent:GetPhysicsObjectNum(math.random(ent:GetPhysicsObjectCount()) - 1):ApplyForceCenter(VectorRand(-750 * mul,750 * mul))
		end
	end

    if org.owner:IsPlayer() then
        if org.alive and org.headcrabon and (org.headcrabon + 10) < CurTime() then org.needotrub = true end
        if org.alive and org.headcrabon and (org.headcrabon + 60) < CurTime() then org.alive = false end
    end
end)