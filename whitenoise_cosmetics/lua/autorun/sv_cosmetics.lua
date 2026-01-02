-- White Noise - Cosmetics System (Server)

if SERVER then
	util.AddNetworkString("WN_Cosmetics_Open")
	util.AddNetworkString("WN_Cosmetics_Equip")
	util.AddNetworkString("WN_Cosmetics_Unequip")
	
	local IGS_Installed = IGS and IGS.GetInventory
	
	-- Equip cosmetic
	function WN.Cosmetics:EquipCosmetic(ply, cosmeticId)
		if not IsValid(ply) then return false end
		
		local item = self.Items[cosmeticId]
		if not item then return false end
		
		-- Check if player owns the cosmetic
		if IGS_Installed then
			local inventory = IGS.GetInventory(ply:SteamID64())
			if not inventory[item.igs_item] or inventory[item.igs_item] <= 0 then
				ply:ChatPrint("[White Noise] You don't own this cosmetic!")
				return false
			end
		end
		
		-- Unequip other cosmetics from same category
		for otherId, otherItem in pairs(self.Items) do
			if otherItem.category == item.category and otherId ~= cosmeticId then
				ply:SetNWString("WN_Cosmetic_" .. otherId, "0")
			end
		end
		
		-- Equip cosmetic
		ply:SetNWString("WN_Cosmetic_" .. cosmeticId, "1")
		ply:ChatPrint("[White Noise] Equipped: " .. item.name)
		
		return true
	end
	
	-- Unequip cosmetic
	function WN.Cosmetics:UnequipCosmetic(ply, cosmeticId)
		if not IsValid(ply) then return false end
		
		ply:SetNWString("WN_Cosmetic_" .. cosmeticId, "0")
		ply:ChatPrint("[White Noise] Unequipped cosmetic")
		
		return true
	end
	
	-- Network receivers
	net.Receive("WN_Cosmetics_Equip", function(len, ply)
		if not IsValid(ply) then return end
		
		local cosmeticId = net.ReadString()
		WN.Cosmetics:EquipCosmetic(ply, cosmeticId)
	end)
	
	net.Receive("WN_Cosmetics_Unequip", function(len, ply)
		if not IsValid(ply) then return end
		
		local cosmeticId = net.ReadString()
		WN.Cosmetics:UnequipCosmetic(ply, cosmeticId)
	end)
	
	-- Spawn cosmetic attachments on player spawn
	hook.Add("PlayerSpawn", "WN_Cosmetics_Spawn", function(ply)
		if not IsValid(ply) then return end
		
		timer.Simple(0.5, function()
			if not IsValid(ply) then return end
			
			-- Spawn cosmetic attachments
			for cosmeticId, item in pairs(WN.Cosmetics.Items) do
				if ply:GetNWString("WN_Cosmetic_" .. cosmeticId, "") == "1" then
					if item.model then
						-- Spawn attachment entity
						local attachment = ents.Create("wn_cosmetic_attachment")
						if IsValid(attachment) then
							attachment:SetParent(ply)
							attachment:SetModel(item.model)
							attachment:SetPos(ply:GetPos())
							attachment:Spawn()
							attachment:Activate()
							
							-- Attach to bone
							if item.bone then
								local boneId = ply:LookupBone(item.bone)
								if boneId then
									attachment:FollowBone(ply, boneId)
									attachment:SetLocalPos(item.pos or Vector(0, 0, 0))
									attachment:SetLocalAngles(item.ang or Angle(0, 0, 0))
								end
							end
							
							attachment.WN_CosmeticId = cosmeticId
							ply.WN_Cosmetics = ply.WN_Cosmetics or {}
							ply.WN_Cosmetics[cosmeticId] = attachment
						end
					end
				end
			end
		end)
	end)
	
	-- Clean up cosmetics on player death
	hook.Add("PlayerDeath", "WN_Cosmetics_Death", function(victim)
		if IsValid(victim) and victim.WN_Cosmetics then
			for cosmeticId, attachment in pairs(victim.WN_Cosmetics) do
				if IsValid(attachment) then
					attachment:Remove()
				end
			end
			victim.WN_Cosmetics = {}
		end
	end)
	
	-- Command to open cosmetics shop
	concommand.Add("wn_cosmetics", function(ply)
		if not IsValid(ply) then return end
		
		net.Start("WN_Cosmetics_Open")
		net.Send(ply)
	end)
end
