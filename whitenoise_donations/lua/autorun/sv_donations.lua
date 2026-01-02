-- White Noise Donation System
-- Server-side donation system with IGS integration

if SERVER then
	util.AddNetworkString("WN_DonationMenu")
	util.AddNetworkString("WN_DonationUpdate")
	
	-- Check if IGS is installed
	local IGS_Installed = IGS and IGS.GetInventory
	
	-- Donation packages mapping (IGS items are defined in igs-modification)
	WN.Donations.Packages = {
		["donator"] = {
			name = "Donator",
			igs_item = "wn_donator"
		},
		["vip"] = {
			name = "VIP",
			igs_item = "wn_vip"
		},
		["premium"] = {
			name = "Premium",
			igs_item = "wn_premium"
		},
		["sponsor"] = {
			name = "Sponsor",
			igs_item = "wn_sponsor"
		}
	}
	
	-- Load player donation data from IGS
	function WN.Donations:LoadPlayerData(ply)
		if not IsValid(ply) then return end
		
		if not IGS_Installed then
			ply:SetNWString("WN_DonationRank", "default")
			ply:SetNWString("WN_DonationTitle", "")
			return
		end
		
		-- Check for donation ranks in IGS inventory
		local highestRank = "default"
		local rankPriority = {
			["wn_sponsor"] = 4,
			["wn_premium"] = 3,
			["wn_vip"] = 2,
			["wn_donator"] = 1
		}
		
		local currentPriority = 0
		
		-- Check each rank item
		for rankName, rankData in pairs(self.Packages) do
			if ply:HasPurchase(rankData.igs_item) then
				local priority = rankPriority[rankData.igs_item]
				if priority and priority > currentPriority then
					currentPriority = priority
					highestRank = rankName
				end
			end
		end
		
		ply:SetNWString("WN_DonationRank", highestRank)
		ply:SetNWString("WN_DonationTitle", "")
	end
	
	-- Save player donation data (IGS handles this automatically)
	function WN.Donations:SavePlayerData(ply)
		-- IGS handles saving automatically
		-- This function is kept for compatibility
	end
	
	-- Set player donation rank (for admin commands)
	function WN.Donations:SetPlayerRank(ply, rank)
		if not IsValid(ply) then return false end
		if not self.Ranks[rank] then return false end
		
		ply:SetNWString("WN_DonationRank", rank)
		
		-- Notify player
		ply:ChatPrint("[White Noise] Your donation rank has been updated to: " .. self.Ranks[rank].name)
		
		return true
	end
	
	-- Check if player has IGS item
	function WN.Donations:HasIGSItem(ply, itemId)
		if not IsValid(ply) or not IGS_Installed then return false end
		return ply:HasPurchase(itemId)
	end
	
	-- Hooks
	hook.Add("PlayerInitialSpawn", "WN_Donations_LoadData", function(ply)
		timer.Simple(2, function()
			if IsValid(ply) then
				WN.Donations:LoadPlayerData(ply)
			end
		end)
	end)
	
	hook.Add("PlayerDisconnected", "WN_Donations_SaveData", function(ply)
		WN.Donations:SavePlayerData(ply)
	end)
	
	-- IGS hook to update rank when item is purchased
	if IGS_Installed then
		hook.Add("IGS.PlayerPurchasedItem", "WN_Donations_IGSPurchase", function(ply, item_id)
			-- Check if it's a rank item
			for rankName, rankData in pairs(WN.Donations.Packages) do
				if item_id == rankData.igs_item then
					timer.Simple(0.5, function()
						if IsValid(ply) then
							WN.Donations:LoadPlayerData(ply)
						end
					end)
					break
				end
			end
		end)
	end
	
	-- Admin commands
	concommand.Add("wn_setrank", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsAdmin() then return end
		
		if #args < 2 then
			ply:ChatPrint("Usage: wn_setrank <steamid/name> <rank>")
			return
		end
		
		local target = player.GetBySteamID(args[1]) or player.GetBySteamID64(args[1])
		if not target then
			target = player.GetByName(args[1])
		end
		
		if not IsValid(target) then
			ply:ChatPrint("Player not found!")
			return
		end
		
		local rank = args[2]
		if WN.Donations:SetPlayerRank(target, rank) then
			ply:ChatPrint("Set " .. target:Nick() .. "'s rank to " .. rank)
		else
			ply:ChatPrint("Invalid rank!")
		end
	end)
	
	-- Print IGS status
	if IGS_Installed then
		print("[White Noise] IGS integration enabled!")
	else
		print("[White Noise] WARNING: IGS not found! Donation system will use fallback mode.")
	end
end
