local CLASS = player.RegClass("swat")

function CLASS.Off(self)
    if CLIENT then return end
end

local models = {
    "models/css_seb_swat/css_swat.mdl",
}

function CLASS.On(self)
    if CLIENT then return end
    self:SetPlayerColor(Color(10,10,100):ToVector())
    self:SetModel(models[math.random(#models)])
    self:SetSubMaterial()
    self:SetBodyGroups("00000000000")
    GetAppearance(self)
    local Appearance = self.Appearance or GetRandomAppearance(self, 1)
    Appearance.ClothesStyle = ""
    self:SetNetVar("Accessories", "")
    self.CurAppearance = Appearance
    local inv = self:GetNetVar("Inventory", {})
    inv["Weapons"] = inv["Weapons"] or {}
    inv["Weapons"]["hg_sling"] = true
    self:SetNetVar("Inventory", inv)

    self:SetNWString("PlayerName","SWAT "..Appearance.Name)
end

function CLASS.Guilt(self, Victim)
    if CLIENT then return end

    if Victim:GetPlayerClass() == self:GetPlayerClass() then
        return 2
    end

    if CurrentRound().name == "hmcd" then
        return wn.ForcesAttackedInnocent(self, Victim)
    end

    if Victim == wn.hostage then
        return 3
    end

    return 1
end