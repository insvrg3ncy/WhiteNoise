AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local vecZero = Vector(0,0,0)
function ENT:Initialize()
	self:SetModel(self.PhysModel or self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self:SetPos(self:GetPos() + Vector(0,0,30))

	if self.material then
		self:SetSubMaterial(0,self.material)
	end
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(10)
		phys:Wake()
		phys:EnableMotion(true)
	end

end

function ENT:OnRemove()

end

function ENT:Use(activator)
	self:TakeByPlayer(activator)
end

function ENT:TakeByPlayer(activator)
	if not activator:IsPlayer() then return end

	local can = wn.AddArmor(activator,self.name)
    if can then
		if self.zablevano then
			activator:SetNetVar("zableval_masku", true)
		end

		self:EmitSound("snd_jack_hmcd_disguise.wav", 75, math.random(90,110), 1, CHAN_ITEM)
        self:Remove()
	end
end