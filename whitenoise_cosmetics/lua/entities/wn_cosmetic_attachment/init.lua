-- White Noise - Cosmetic Attachment Entity (Server)

if SERVER then
	AddCSLuaFile("shared.lua")
	include("shared.lua")
	
	function ENT:Initialize()
		self:SetModel(self:GetModel() or "models/player/items/all_class/beret_demo.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self:DrawShadow(false)
		
		-- Make it invisible to physics
		self:SetNoDraw(false)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
	end
	
	function ENT:Think()
		if not IsValid(self:GetParent()) then
			self:Remove()
			return
		end
		
		-- Update position if parent moved
		self:SetPos(self:GetParent():GetPos())
		self:SetAngles(self:GetParent():GetAngles())
	end
end
