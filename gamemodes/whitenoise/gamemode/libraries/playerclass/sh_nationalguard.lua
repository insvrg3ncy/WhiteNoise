local CLASS = player.RegClass("nationalguard")

function CLASS.Off(self)
    if CLIENT then return end
end

local models = {}
for i = 1, 9 do
    table.insert(models,"models/dejtriyev/enhancednatguard/male_0"..i..".mdl")
end


function CLASS.On(self)
    if CLIENT then return end
    GetAppearance(self)
    local Appearance = self.Appearance or GetRandomAppearance(self, 1)
    self:SetNWString("PlayerName","National Guard "..self:GetNWString("PlayerName"))
    self:SetPlayerColor(Color(5,65,0):ToVector())
    self:SetModel(models[math.random(#models)])
    self:SetBodygroup(0,14)
    self:SetSubMaterial()
    Appearance.ClothesStyle = ""
    self.CurAppearance = Appearance
end

local function IsLookingAt(ply, targetVec)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    local diff = targetVec - ply:GetShootPos()
    return ply:GetAimVector():Dot(diff) / diff:Length() >= 0.8 
end

function CLASS.Guilt(self, Victim)
    if CLIENT then return end

    if Victim:GetPlayerClass() == self:GetPlayerClass() then
        --self:ChatPrint("You killed your teammate!")
        return 2
    end

    if CurrentRound().name == "hmcd" then
        return wn.ForcesAttackedInnocent(self, Victim)
    end

    return 1
end