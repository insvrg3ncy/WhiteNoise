-- White Noise - Cosmetic Attachment Entity (Client)

if CLIENT then
	function ENT:Initialize()
		-- Client-side initialization
	end
	
	function ENT:Draw()
		if not IsValid(self:GetParent()) then return end
		
		-- Draw the cosmetic attachment
		self:DrawModel()
	end
end
