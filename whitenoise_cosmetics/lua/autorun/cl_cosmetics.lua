-- White Noise - Cosmetics System (Client)

if CLIENT then
	local cosmeticsMenu = nil
	
	function WN.Cosmetics:OpenMenu()
		if IsValid(cosmeticsMenu) then
			cosmeticsMenu:Remove()
		end
		
		cosmeticsMenu = vgui.Create("DFrame")
		cosmeticsMenu:SetSize(800, 600)
		cosmeticsMenu:Center()
		cosmeticsMenu:SetTitle("White Noise - Cosmetics Shop")
		cosmeticsMenu:SetVisible(true)
		cosmeticsMenu:SetDraggable(true)
		cosmeticsMenu:ShowCloseButton(true)
		cosmeticsMenu:MakePopup()
		
		-- White theme styling
		cosmeticsMenu.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255, 250))
			draw.RoundedBox(8, 0, 0, w, 30, Color(240, 240, 240))
			draw.SimpleText("White Noise - Cosmetics Shop", "DermaDefaultBold", 10, 15, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
		-- Category tabs
		local categoryTabs = vgui.Create("DPropertySheet", cosmeticsMenu)
		categoryTabs:SetPos(10, 40)
		categoryTabs:SetSize(780, 550)
		
		-- Create tabs for each category
		for categoryId, categoryData in pairs(WN.Cosmetics.Categories) do
			local categoryPanel = vgui.Create("DPanel")
			categoryPanel.Paint = function(self, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(250, 250, 250))
			end
			
			local scrollPanel = vgui.Create("DScrollPanel", categoryPanel)
			scrollPanel:Dock(FILL)
			
			-- Add cosmetics from this category
			local yPos = 0
			for cosmeticId, cosmeticData in pairs(WN.Cosmetics.Items) do
				if cosmeticData.category == categoryId then
					local cosmeticPanel = vgui.Create("DPanel", scrollPanel)
					cosmeticPanel:SetPos(10, yPos)
					cosmeticPanel:SetSize(760, 100)
					cosmeticPanel.Paint = function(self, w, h)
						draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255))
						draw.RoundedBox(4, 0, 0, w, 2, Color(200, 200, 200))
						
						-- Check if owned (using IGS)
						local owned = false
						if IGS and LocalPlayer().HasPurchase then
							owned = LocalPlayer():HasPurchase(cosmeticData.igs_item)
						end
						
						local equipped = LocalPlayer():GetNWString("WN_Cosmetic_" .. cosmeticId, "") == "1"
						local statusColor = equipped and Color(0, 200, 0) or (owned and Color(150, 150, 150) or Color(100, 100, 100))
						local statusText = equipped and "EQUIPPED" or (owned and "OWNED" or "NOT OWNED")
						
						draw.SimpleText(cosmeticData.name, "DermaDefaultBold", 10, 10, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw.SimpleText(statusText, "DermaDefault", 10, 30, statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw.SimpleText(cosmeticData.description, "DermaDefault", 10, 50, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					end
					
					-- Equip/Unequip button (if owned)
					local owned = false
					if IGS and LocalPlayer().HasPurchase then
						owned = LocalPlayer():HasPurchase(cosmeticData.igs_item)
					end
					
					if owned then
						local isEquipped = LocalPlayer():GetNWString("WN_Cosmetic_" .. cosmeticId, "") == "1"
						local equipBtn = vgui.Create("DButton", cosmeticPanel)
						equipBtn:SetPos(650, 30)
						equipBtn:SetSize(100, 40)
						equipBtn:SetText(isEquipped and "Unequip" or "Equip")
						equipBtn:SetTextColor(Color(255, 255, 255))
						equipBtn.Paint = function(self, w, h)
							local col = isEquipped and Color(200, 100, 100) or Color(100, 200, 100)
							if self:IsHovered() then
								col = isEquipped and Color(220, 120, 120) or Color(120, 220, 120)
							end
							draw.RoundedBox(4, 0, 0, w, h, col)
						end
						equipBtn.DoClick = function()
							if isEquipped then
								net.Start("WN_Cosmetics_Unequip")
								net.WriteString(cosmeticId)
								net.SendToServer()
							else
								net.Start("WN_Cosmetics_Equip")
								net.WriteString(cosmeticId)
								net.SendToServer()
							end
							cosmeticsMenu:Close()
						end
					else
						-- Purchase button (opens IGS)
						local buyBtn = vgui.Create("DButton", cosmeticPanel)
						buyBtn:SetPos(650, 30)
						buyBtn:SetSize(100, 40)
						buyBtn:SetText("Buy in IGS")
						buyBtn:SetTextColor(Color(255, 255, 255))
						buyBtn.Paint = function(self, w, h)
							local col = Color(100, 150, 255)
							if self:IsHovered() then
								col = Color(120, 170, 255)
							end
							draw.RoundedBox(4, 0, 0, w, h, col)
						end
						buyBtn.DoClick = function()
							if IGS and IGS.OpenMenu then
								IGS.OpenMenu()
							else
								LocalPlayer():ChatPrint("[White Noise] IGS menu not available. Use !donate or F1")
							end
						end
					end
					
					yPos = yPos + 110
				end
			end
			
			categoryTabs:AddSheet(categoryData.name, categoryPanel, categoryData.icon)
		end
	end
	
	-- Network receiver
	net.Receive("WN_Cosmetics_Open", function()
		WN.Cosmetics:OpenMenu()
	end)
	
	-- Command to open shop
	concommand.Add("wn_cosmetics", function()
		WN.Cosmetics:OpenMenu()
	end)
	
	-- Chat command
	hook.Add("OnPlayerChat", "WN_Cosmetics_ChatCommand", function(ply, text, teamChat)
		if ply ~= LocalPlayer() then return end
		
		text = string.lower(text)
		if text == "!cosmetics" or text == "!cosmetic" or text == "/cosmetics" then
			WN.Cosmetics:OpenMenu()
			return true
		end
	end)
end
