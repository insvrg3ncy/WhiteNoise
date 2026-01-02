--
local CurTime = CurTime
util.AddNetworkString("hgwep reload")
function SWEP:Reload(time)
	if not self:CanUse() or not self:CanReload() then return end
	self.LastReload = CurTime()
	self:ReloadStart()
	self:ReloadStartPost()
	local org = self:GetOwner().organism
	self.StaminaReloadMul = (org and ((2 - (self:GetOwner().organism.stamina[1] / 180)) + ((org.pain / 40) + (org.larm / 3) + (org.rarm / 5)) - (1 - math.Clamp(org.recoilmul or 1,0.45,1.4))) or 1)
	self.StaminaReloadMul = math.Clamp(self.StaminaReloadMul,0.65,1.5)
	self.StaminaReloadTime = self.ReloadTime * self.StaminaReloadMul
	self.StaminaReloadTime = (self.StaminaReloadTime + (self:Clip1() > 0 and -self.StaminaReloadTime/3 or 0 ))
	self.reload = self.LastReload + self.StaminaReloadTime
	self.dwr_reverbDisable = true
	net.Start("hgwep reload")
		net.WriteEntity(self)
		net.WriteFloat(self.LastReload)
		net.WriteInt(self:Clip1(),10)
		net.WriteFloat(self.StaminaReloadTime)
		net.WriteFloat(self.StaminaReloadMul)
	net.Broadcast()
end

function SWEP:OnCantReload()

end

function SWEP:ReloadStart()
	self:SetHold(self.ReloadHold or self.HoldType)
	hook.Run("HGReloading", self)
	--if self.ReloadSound then self:GetOwner():EmitSound(self.ReloadSound, 60, 100, 0.8, CHAN_AUTO) end
end