util.AddNetworkString("WN_add_equipment")
util.AddNetworkString("WN_drop_equipment")

net.Receive("WN_drop_equipment", function(len, ply)
    local equipment = net.ReadString()

    if not (ply.organism and ply.organism.canmove) then return end

    wn.DropArmor(ply, equipment)
end)

function wn.AddArmor(ply, equipment)
    if not IsValid(ply) then return end
	
	-- Инициализируем armors если нужно
	if not ply.armors then
		ply.armors = {}
	end
	
	local can = hook.Run("CanEquipArmor", ply, equipment)
	
	if(can == false)then
		return nil
	end
	
    if equipment and istable(equipment) then
        for i,equipment1 in pairs(equipment) do
            wn.AddArmor(ply, equipment1)
        end
        return
    end
    equipment = string.Replace(equipment,"ent_wn_armor_","")
    equipment = string.Replace(equipment,"ent_armor_","") -- Для обратной совместимости
    local placement
    for plc, tbl in pairs(wn.armor) do
        placement = tbl[equipment] and tbl[equipment][1] or placement
    end
    
    if not placement then
        print("sh_equipment.lua: no such equipment as: " .. equipment)
        return false
    end
    
    for plc, arm in pairs(ply.armors) do
        if not wn.armor[plc] or not wn.armor[plc][arm] or not wn.armor[plc][arm].restricted then continue end
        if table.HasValue(wn.armor[plc][arm].restricted, placement) then
            return false
        end
    end

    if ply.armors[placement] and ply:IsPlayer() then
        if not wn.DropArmor(ply, ply.armors[placement]) then return false end
    end
    
    if wn.armor[placement][equipment].AfterPickup then
        wn.armor[placement][equipment].AfterPickup(ply)
    end

    ply.armors[placement] = equipment
    
    ply:SyncArmor()
    return true
end

function wn.DropArmorForce(ent, equipment)
    if not table.HasValue(ent.armors, equipment) then return false end
    local placement
    for plc, tbl in pairs(wn.armor) do
        placement = tbl[equipment] and tbl[equipment][1] or placement
    end

    if not placement then
        print("sh_equipment.lua: no such equipment as: " .. equipment)
        return false
    end
    
    if wn.armor[placement][equipment] then
        local equipmentEnt = ents.Create("ent_wn_armor_" .. equipment)
        equipmentEnt:Spawn()
        equipmentEnt:SetPos(ent:GetPos())
        equipmentEnt:SetAngles(ent:GetAngles())

        if ent:GetNetVar("zableval_masku", false) then
            equipmentEnt.zablevano = true
            ent:SetNetVar("zableval_masku", false)
        end

        local phys = equipmentEnt:GetPhysicsObject()

        if IsValid(equipmentEnt) then table.RemoveByValue(ent.armors, equipment) end
        
        ent:SyncArmor()
        
        return equipmentEnt
    end
end

function wn.DropArmor(ply, equipment)
    if not table.HasValue(ply.armors, equipment) then return false end
    
    local placement
    for plc, tbl in pairs(wn.armor) do
        placement = tbl[equipment] and tbl[equipment][1] or placement
    end
    
    if wn.armor[placement][equipment].nodrop then return false end

    if not placement then
        print("sh_equipment.lua: no such equipment as: " .. equipment)
        return false
    end

    if IsValid(ply) and ply.DropCD and ply.DropCD > CurTime() then return false end

    if wn.armor[placement][equipment] then
        ply:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)
	    ply:ViewPunch(Angle(1,-2,1))
        ply.DropCD = CurTime() + 0.35
        --timer.Simple(0.3,function()
        if not IsValid(ply) then return end
        local equipmentEnt = ents.Create("ent_wn_armor_" .. equipment)
        equipmentEnt:Spawn()
        equipmentEnt:SetPos(ply:EyePos())
        equipmentEnt:SetAngles(ply:EyeAngles())
        
        if placement == "face" and ply:GetNetVar("zableval_masku", false) then
            equipmentEnt.zablevano = true
            ply:SetNetVar("zableval_masku", false)
        end
        
        local phys = equipmentEnt:GetPhysicsObject()
        if IsValid(phys) then phys:SetVelocity(ply:EyeAngles():Forward() * 150) end
        if IsValid(equipmentEnt) then table.RemoveByValue(ply.armors, equipment) end
        ply:SyncArmor()
        --end)
        return true
    end
end

-- Инициализация armors при спавне игрока
hook.Add("PlayerSpawn", "WN_InitArmors", function(ply)
	if not ply.armors then
		ply.armors = {}
	end
end)
