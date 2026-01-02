local CLASS = player.RegClass("terrorist")

function CLASS.Off(self)
    if CLIENT then return end
end

local masks = {
    "arctic_balaclava",
    "phoenix_balaclava",
    "bandana"
}

function CLASS.On(self)
    if CLIENT then return end
    ApplyAppearance(self)
    timer.Simple(.1,function()
        local Appearance = self.CurAppearance or GetRandomAppearance(self)

        Appearance.Attachmets = {
            masks[math.random(#masks)],
            "terrorist_band"
        }
        self:SetNetVar("Accessories", Appearance.Attachmets or "none")
        
        self.CurAppearance = Appearance
    end)
end

function CLASS.Guilt(self, victim)
    if CLIENT then return end

    if victim:GetPlayerClass() == self:GetPlayerClass() then
        return 2
    end
    
    if victim == wn.hostage then
        return 3
    end
end