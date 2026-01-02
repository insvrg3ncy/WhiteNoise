--
wn = wn or {}

wn.Experience = wn.Experience or {}
wn.Experience.PlayerInstances = wn.Experience.PlayerInstances or {}
wn.Experience.Active = wn.Experience.Active or false

hook.Add("DatabaseConnected", "WN_ExperienceCreateData", function()
	local query

	query = mysql:Create("wn_experience")
		query:Create("steamid", "VARCHAR(20) NOT NULL")
		query:Create("steam_name", "VARCHAR(32) NOT NULL")
		query:Create("skill", "FLOAT NOT NULL")
		query:Create("experience", "INT NOT NULL") -- Надо перевести в большие числа INT НЕ ХВАТАЕТ!!!
        query:Create("deaths", "INT NOT NULL")
        query:Create("kills", "INT NOT NULL")
        query:Create("suicides", "INT NOT NULL")
		query:PrimaryKey("steamid")
	query:Execute()

    wn.Experience.Active = true
end)

--local query = mysql:Drop("wn_experience")
--query:Execute()

hook.Add( "PlayerInitialSpawn","WN_Exp_OnInitSpawn", function( ply )
    local name = ply:Name()
	local steamID64 = ply:SteamID64()

    if not wn.Experience.Active then
        wn.Experience.PlayerInstances[steamID64] = {}
        return
    end 

	local query = mysql:Select("wn_experience")
		query:Select("skill")
		query:Select("experience")
        query:Select("deaths")
        query:Select("kills")
        query:Select("suicides")
		query:Where("steamid", steamID64)
		query:Callback(function(result)
			if (IsValid(ply) and istable(result) and #result > 0 and result[1].experience) then
				local updateQuery = mysql:Update("wn_experience")
					updateQuery:Update("steam_name", name)
					updateQuery:Where("steamid", steamID64)
				updateQuery:Execute()

				wn.Experience.PlayerInstances[steamID64] = {}

                wn.Experience.PlayerInstances[steamID64].skill = tonumber(result[1].skill)
                wn.Experience.PlayerInstances[steamID64].experience = tonumber(result[1].experience)
                wn.Experience.PlayerInstances[steamID64].deaths = tonumber(result[1].deaths)
                wn.Experience.PlayerInstances[steamID64].kills = tonumber(result[1].kills)
                wn.Experience.PlayerInstances[steamID64].suicides = tonumber(result[1].suicides)

			else
				local insertQuery = mysql:Insert("wn_experience")
					insertQuery:Insert("steamid", steamID64)
					insertQuery:Insert("steam_name", name)
					insertQuery:Insert("skill", 0)
		            insertQuery:Insert("experience", 0)
                    insertQuery:Insert("deaths", 0)
		            insertQuery:Insert("kills", 0)
                    insertQuery:Insert("suicides", 0)
				insertQuery:Execute()

				wn.Experience.PlayerInstances[steamID64] = {}

				wn.Experience.PlayerInstances[steamID64].skill = 0
                wn.Experience.PlayerInstances[steamID64].experience = 0
                wn.Experience.PlayerInstances[steamID64].deaths = 0
                wn.Experience.PlayerInstances[steamID64].kills = 0
                wn.Experience.PlayerInstances[steamID64].suicides = 0

			end
		end)
	query:Execute()

end)

local plyMeta = FindMetaTable("Player")

function plyMeta:GetExp()

    return wn.Experience.PlayerInstances[self:SteamID64()].experience or 0

end

function plyMeta:GiveExp( ammout )
    if not wn.Experience or not wn.Experience.PlayerInstances or not wn.Experience.PlayerInstances[self:SteamID64()] then return end

    local steamID64 = self:SteamID64()
    local currentExp = wn.Experience.PlayerInstances[steamID64].experience or 0
    wn.Experience.PlayerInstances[steamID64].experience = math.max(currentExp + ammout, 0)

    if wn.Experience.Active then
        local updateQuery = mysql:Update("wn_experience")
            updateQuery:Update("experience", self:GetExp())
            updateQuery:Where("steamid", steamID64)
        updateQuery:Execute()
    end
end


function plyMeta:GetSkill()
    if not wn.Experience or not wn.Experience.PlayerInstances or not wn.Experience.PlayerInstances[self:SteamID64()] then 
        return 0
    end
    return wn.Experience.PlayerInstances[self:SteamID64()].skill or 0
end

function plyMeta:GiveSkill( ammout )
    if not wn.Experience or not wn.Experience.PlayerInstances or not wn.Experience.PlayerInstances[self:SteamID64()] then return end

    local steamID64 = self:SteamID64()
    local currentSkill = wn.Experience.PlayerInstances[steamID64].skill or 0
    wn.Experience.PlayerInstances[steamID64].skill = math.max(currentSkill + ammout, 0)

    if wn.Experience.Active then
        local updateQuery = mysql:Update("wn_experience")
            updateQuery:Update("skill", self:GetSkill())
            updateQuery:Where("steamid", steamID64)
        updateQuery:Execute()
    end
end

function plyMeta:GetDeaths()

    return 0

end

function plyMeta:GiveDeaths( ammout )

    //if not wn.Experience.Active then
    //    wn.Experience.PlayerInstances[steamID64] = {}
    //    return
    //end 

    //local steamID64 = self:SteamID64()

    //wn.Experience.PlayerInstances[self:SteamID64()].deaths = math.max( wn.Experience.PlayerInstances[self:SteamID64()].deaths + ammout, 0 )

	//local updateQuery = mysql:Update("wn_experience")
	//	updateQuery:Update("deaths", self:GetDeaths())
	//	updateQuery:Where("steamid", steamID64)
	//updateQuery:Execute()
    --self:SetNWInt( "experience", exp + ammout )
end

function plyMeta:GetKills()

    return 1337

end

function plyMeta:GiveKills( ammout )

    //if not wn.Experience.Active then
    //    wn.Experience.PlayerInstances[steamID64] = {}
    //    return
    //end 

    //local steamID64 = self:SteamID64()

    //wn.Experience.PlayerInstances[self:SteamID64()].kills = math.max( wn.Experience.PlayerInstances[self:SteamID64()].kills + ammout, 0 )

	//local updateQuery = mysql:Update("wn_experience")
	//	updateQuery:Update("kills", self:GetKills())
	//	updateQuery:Where("steamid", steamID64)
	//updateQuery:Execute()
    --self:SetNWInt( "experience", exp + ammout )
end


function plyMeta:GetSuicides( ammout )

    return 0

end

function plyMeta:GiveSuicides( ammout )

    //if not wn.Experience.Active then
    //    wn.Experience.PlayerInstances[steamID64] = {}
    //    return
    //end 

    //local steamID64 = self:SteamID64()

    //wn.Experience.PlayerInstances[self:SteamID64()].suicides =  math.max( wn.Experience.PlayerInstances[self:SteamID64()].suicides + ammout, 0 )

	//local updateQuery = mysql:Update("wn_experience")
	//	updateQuery:Update("suicides", self:GetSuicides())
	//	updateQuery:Where("steamid", steamID64)
	//updateQuery:Execute()
    --self:SetNWInt( "experience", exp + ammout )
end


util.AddNetworkString("WN_XP_Get")

net.Receive("WN_XP_Get",function(len,ply)
    if not wn.Experience.Active then
        return
    end 

    local get_ply = net.ReadEntity()

    net.Start("WN_XP_Get")
        net.WriteEntity( get_ply )
        net.WriteFloat( get_ply:GetSkill() )
        net.WriteInt( get_ply:GetExp(), 19 )
    net.Send(ply)
end)


--hook.Add( "WN_EndRound", "WN_Exp_Give", function()
--    local exp = ply.RoundEXP or 0
--    local skill = ply.RoundSkill or 0
--
--    ply:SetPData( "wn_experience", exp )
--    ply:SetPData( "zb_skill", skill )
--
--    ply:SetNWInt( "experience", exp )
--    ply:SetNWFloat( "skill", skill )
--
--    ply.RoundEXP = 0
--    ply.RoundSkill = 0
--end)
