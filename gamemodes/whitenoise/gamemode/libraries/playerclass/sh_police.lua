local CLASS = player.RegClass("police")

function CLASS.Off(self)
    if CLIENT then return end
end

local models = {
    -- Male
    ["models/player/group01/male_01.mdl"] = "models/monolithservers/mpd/male_01.mdl",
    ["models/player/group01/male_02.mdl"] = "models/monolithservers/mpd/male_02.mdl",
    ["models/player/group01/male_03.mdl"] = "models/monolithservers/mpd/male_03.mdl",
    ["models/player/group01/male_04.mdl"] = "models/monolithservers/mpd/male_04_2.mdl",
    ["models/player/group01/male_05.mdl"] = "models/monolithservers/mpd/male_05.mdl",
    ["models/player/group01/male_06.mdl"] = "models/monolithservers/mpd/male_06_2.mdl",
    ["models/player/group01/male_07.mdl"] = "models/monolithservers/mpd/male_07_2.mdl",
    ["models/player/group01/male_08.mdl"] = "models/monolithservers/mpd/male_08.mdl",
    ["models/player/group01/male_09.mdl"] = "models/monolithservers/mpd/male_09_2.mdl",
    -- FEMKI
    ["models/player/group01/female_01.mdl"] = "models/monolithservers/mpd/female_01_2.mdl",
    ["models/player/group01/female_02.mdl"] = "models/monolithservers/mpd/female_02.mdl",
    ["models/player/group01/female_03.mdl"] = "models/monolithservers/mpd/female_03.mdl",
    ["models/player/group01/female_04.mdl"] = "models/monolithservers/mpd/female_04.mdl",
    ["models/player/group01/female_05.mdl"] = "models/monolithservers/mpd/female_05_2.mdl",
    ["models/player/group01/female_06.mdl"] = "models/monolithservers/mpd/female_06.mdl"
}

local ranks = {
    {name = "Chief", chance = 5},    
    {name = "Cmdr.", chance = 5},    
    {name = "Cpt.", chance = 15},    
    {name = "Lt.", chance = 35},
    {name = "Sgt.", chance = 45},     
    {name = "Officer", chance = 80}  
}

function CLASS.On(self)
    if CLIENT then return end
    GetAppearance(self)
    local Appearance = self.Appearance or GetRandomAppearance(self)

    local randomValue = math.random(100)
    local cumulativeChance = 0
    local rank = "Officer"  

    for _, rankInfo in ipairs(ranks) do
        cumulativeChance = cumulativeChance + rankInfo.chance
        if randomValue <= cumulativeChance then
            rank = rankInfo.name
            break
        end
    end

    self:SetNWString("PlayerName", rank .. " " .. Appearance.Name)
    self:SetPlayerColor(Color(10, 10, 100):ToVector())
    self:SetModel(models[string.lower(Appearance.Model)])
    self:SetSubMaterial()

    Appearance.Attachmets = "none"
    self:SetNetVar("Accessories", Appearance.Attachmets or "none")

    Appearance.ClothesStyle = ""
    self:SetNWString("PlayerName", rank .. " " .. Appearance.Name)
    self.CurAppearance = Appearance
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

