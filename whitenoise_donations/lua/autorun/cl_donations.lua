-- White Noise Donation System
-- Client-side donation system

if CLIENT then
	-- Donation menu
	local donationMenu = nil
	
	function WN.Donations:OpenMenu()
		if IsValid(donationMenu) then
			donationMenu:Remove()
		end
		
		donationMenu = vgui.Create("DFrame")
		donationMenu:SetSize(600, 500)
		donationMenu:Center()
		donationMenu:SetTitle("White Noise - Donation System")
		donationMenu:SetVisible(true)
		donationMenu:SetDraggable(true)
		donationMenu:ShowCloseButton(true)
		donationMenu:MakePopup()
		
		-- White theme styling
		donationMenu.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255, 250))
			draw.RoundedBox(8, 0, 0, w, 30, Color(240, 240, 240))
			draw.SimpleText("White Noise - Donation System", "DermaDefault", 10, 15, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
		-- Current rank display
		local currentRank = vgui.Create("DPanel", donationMenu)
		currentRank:SetPos(10, 40)
		currentRank:SetSize(580, 60)
		currentRank.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(240, 240, 240))
			
			local rankData = WN.Donations:GetRankData(LocalPlayer())
			draw.SimpleText("Current Rank: " .. rankData.name, "DermaDefaultBold", 10, 10, rankData.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("SteamID: " .. LocalPlayer():SteamID(), "DermaDefault", 10, 35, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		
		-- Packages list
		local scrollPanel = vgui.Create("DScrollPanel", donationMenu)
		scrollPanel:SetPos(10, 110)
		scrollPanel:SetSize(580, 350)
		
		-- Add packages
		local yPos = 0
		for packageId, package in pairs(WN.Donations.Packages or {}) do
			local packagePanel = vgui.Create("DPanel", scrollPanel)
			packagePanel:SetPos(0, yPos)
			packagePanel:SetSize(560, 100)
			packagePanel.Paint = function(self, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(250, 250, 250))
				draw.RoundedBox(4, 0, 0, w, 2, Color(200, 200, 200))
				
				draw.SimpleText(package.name, "DermaDefaultBold", 10, 10, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText("$" .. string.format("%.2f", package.price), "DermaDefaultBold", 10, 30, Color(0, 150, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(package.description, "DermaDefault", 10, 55, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			
			local buyButton = vgui.Create("DButton", packagePanel)
			buyButton:SetPos(450, 30)
			buyButton:SetSize(100, 40)
			buyButton:SetText("Purchase")
			buyButton:SetTextColor(Color(255, 255, 255))
			buyButton.Paint = function(self, w, h)
				local col = Color(100, 150, 255)
				if self:IsHovered() then
					col = Color(120, 170, 255)
				end
				draw.RoundedBox(4, 0, 0, w, h, col)
			end
			buyButton.DoClick = function()
				net.Start("WN_DonationPurchase")
				net.WriteString(packageId)
				net.SendToServer()
				
				LocalPlayer():ChatPrint("[White Noise] Purchase request sent! Please complete payment through the payment system.")
			end
			
			yPos = yPos + 110
		end
		
		-- Info label
		local infoLabel = vgui.Create("DLabel", donationMenu)
		infoLabel:SetPos(10, 470)
		infoLabel:SetSize(580, 20)
		infoLabel:SetText("Note: This is a placeholder donation system. Integrate with your payment processor.")
		infoLabel:SetTextColor(Color(150, 150, 150))
	end
	
	-- Command to open menu
	concommand.Add("wn_donations", function()
		WN.Donations:OpenMenu()
	end)
	
	-- Chat command
	hook.Add("OnPlayerChat", "WN_Donations_ChatCommand", function(ply, text, teamChat)
		if ply ~= LocalPlayer() then return end
		
		text = string.lower(text)
		if text == "!donate" or text == "!donations" or text == "/donate" then
			WN.Donations:OpenMenu()
			return true
		end
	end)
	
	-- Update donation display when rank changes
	net.Receive("WN_DonationUpdate", function()
		-- Refresh any donation-related UI
		if IsValid(donationMenu) then
			donationMenu:Remove()
			WN.Donations:OpenMenu()
		end
	end)
end
