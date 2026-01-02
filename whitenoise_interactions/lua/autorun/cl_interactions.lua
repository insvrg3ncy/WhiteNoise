-- White Noise - Interaction System (Client)
-- Q-меню для взаимодействий

if CLIENT then
	local interactionMenu = nil
	local qMenuOpen = false
	
	-- Открыть Q-меню
	function wn.Interactions:OpenMenu()
		if IsValid(interactionMenu) then
			interactionMenu:Remove()
		end
		
		if not LocalPlayer():Alive() then return end
		
		interactionMenu = vgui.Create("DFrame")
		interactionMenu:SetSize(600, 500)
		interactionMenu:Center()
		interactionMenu:SetTitle("White Noise - Взаимодействия")
		interactionMenu:SetVisible(true)
		interactionMenu:SetDraggable(true)
		interactionMenu:ShowCloseButton(true)
		interactionMenu:MakePopup()
		interactionMenu:SetKeyboardInputEnabled(false)
		
		-- White theme styling
		interactionMenu.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(255, 255, 255, 250))
			draw.RoundedBox(8, 0, 0, w, 30, Color(240, 240, 240))
			draw.SimpleText("White Noise - Взаимодействия", "DermaDefaultBold", 10, 15, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		
		-- Category tabs
		local categoryTabs = vgui.Create("DPropertySheet", interactionMenu)
		categoryTabs:SetPos(10, 40)
		categoryTabs:SetSize(580, 450)
		
		-- Жесты
		local gesturesPanel = vgui.Create("DPanel")
		gesturesPanel.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(250, 250, 250))
		end
		
		local gesturesScroll = vgui.Create("DScrollPanel", gesturesPanel)
		gesturesScroll:Dock(FILL)
		
		local yPos = 0
		for gestureId, gestureData in pairs(wn.Interactions.Gestures) do
			local gestureBtn = vgui.Create("DButton", gesturesScroll)
			gestureBtn:SetPos(10, yPos)
			gestureBtn:SetSize(560, 50)
			gestureBtn:SetText("")
			gestureBtn.Paint = function(self, w, h)
				local col = self:IsHovered() and Color(240, 240, 240) or Color(255, 255, 255)
				draw.RoundedBox(4, 0, 0, w, h, col)
				draw.RoundedBox(4, 0, 0, w, 2, Color(200, 200, 200))
				
				draw.SimpleText(gestureData.name, "DermaDefaultBold", 10, 10, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(gestureData.description, "DermaDefault", 10, 30, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			gestureBtn.DoClick = function()
				net.Start("WN_UseGesture")
				net.WriteString(gestureId)
				net.SendToServer()
				interactionMenu:Close()
			end
			
			yPos = yPos + 60
		end
		
		categoryTabs:AddSheet("Жесты", gesturesPanel, "icon16/emoticon_smile.png")
		
		-- Фразы
		local phrasesPanel = vgui.Create("DPanel")
		phrasesPanel.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(250, 250, 250))
		end
		
		local phrasesScroll = vgui.Create("DScrollPanel", phrasesPanel)
		phrasesScroll:Dock(FILL)
		
		yPos = 0
		for phraseId, phraseData in pairs(wn.Interactions.Phrases) do
			local phraseBtn = vgui.Create("DButton", phrasesScroll)
			phraseBtn:SetPos(10, yPos)
			phraseBtn:SetSize(560, 50)
			phraseBtn:SetText("")
			phraseBtn.Paint = function(self, w, h)
				local col = self:IsHovered() and Color(240, 240, 240) or Color(255, 255, 255)
				draw.RoundedBox(4, 0, 0, w, h, col)
				draw.RoundedBox(4, 0, 0, w, 2, Color(200, 200, 200))
				
				draw.SimpleText(phraseData.name, "DermaDefaultBold", 10, 10, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(phraseData.description, "DermaDefault", 10, 30, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			phraseBtn.DoClick = function()
				net.Start("WN_UsePhrase")
				net.WriteString(phraseId)
				net.SendToServer()
				interactionMenu:Close()
			end
			
			yPos = yPos + 60
		end
		
		categoryTabs:AddSheet("Фразы", phrasesPanel, "icon16/comment.png")
		
		-- Действия
		local actionsPanel = vgui.Create("DPanel")
		actionsPanel.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(250, 250, 250))
		end
		
		local actionsScroll = vgui.Create("DScrollPanel", actionsPanel)
		actionsScroll:Dock(FILL)
		
		yPos = 0
		for actionId, actionData in pairs(wn.Interactions.Actions) do
			local actionBtn = vgui.Create("DButton", actionsScroll)
			actionBtn:SetPos(10, yPos)
			actionBtn:SetSize(560, 50)
			actionBtn:SetText("")
			actionBtn.Paint = function(self, w, h)
				local col = self:IsHovered() and Color(240, 240, 240) or Color(255, 255, 255)
				draw.RoundedBox(4, 0, 0, w, h, col)
				draw.RoundedBox(4, 0, 0, w, 2, Color(200, 200, 200))
				
				draw.SimpleText(actionData.name, "DermaDefaultBold", 10, 10, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(actionData.description, "DermaDefault", 10, 30, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			actionBtn.DoClick = function()
				net.Start("WN_UseAction")
				net.WriteString(actionId)
				net.SendToServer()
				
				-- Для фейк рагдолла не закрываем меню сразу (можно переключиться обратно)
				if actionId ~= "fake_ragdoll" then
					interactionMenu:Close()
				end
			end
			
			yPos = yPos + 60
		end
		
		categoryTabs:AddSheet("Действия", actionsPanel, "icon16/cog.png")
		
		-- Эмоции
		local emotesPanel = vgui.Create("DPanel")
		emotesPanel.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(250, 250, 250))
		end
		
		local emotesScroll = vgui.Create("DScrollPanel", emotesPanel)
		emotesScroll:Dock(FILL)
		
		yPos = 0
		for emoteId, emoteData in pairs(wn.Interactions.Emotes) do
			local emoteBtn = vgui.Create("DButton", emotesScroll)
			emoteBtn:SetPos(10, yPos)
			emoteBtn:SetSize(560, 50)
			emoteBtn:SetText("")
			emoteBtn.Paint = function(self, w, h)
				local col = self:IsHovered() and Color(240, 240, 240) or Color(255, 255, 255)
				draw.RoundedBox(4, 0, 0, w, h, col)
				draw.RoundedBox(4, 0, 0, w, 2, Color(200, 200, 200))
				
				draw.SimpleText(emoteData.name, "DermaDefaultBold", 10, 10, Color(50, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(emoteData.description, "DermaDefault", 10, 30, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
			emoteBtn.DoClick = function()
				net.Start("WN_UseEmote")
				net.WriteString(emoteId)
				net.SendToServer()
				interactionMenu:Close()
			end
			
			yPos = yPos + 60
		end
		
		categoryTabs:AddSheet("Эмоции", emotesPanel, "icon16/emoticon_happy.png")
		
		qMenuOpen = true
	end
	
	-- Закрыть Q-меню
	function wn.Interactions:CloseMenu()
		if IsValid(interactionMenu) then
			interactionMenu:Close()
			interactionMenu = nil
		end
		qMenuOpen = false
	end
	
	-- Перехватываем Q-меню (вместо спавн меню)
	hook.Add("PlayerBindPress", "WN_QMenu", function(ply, bind, pressed)
		if bind == "+menu_context" and pressed then
			if LocalPlayer():Alive() then
				wn.Interactions:OpenMenu()
				return true
			end
		end
		
		if bind == "-menu_context" and not pressed then
			if qMenuOpen then
				wn.Interactions:CloseMenu()
				return true
			end
		end
	end)
	
	-- Блокируем стандартное Q-меню
	hook.Add("ContextMenuOpen", "WN_BlockQMenu", function()
		if LocalPlayer():Alive() then
			wn.Interactions:OpenMenu()
			return false -- Блокируем стандартное меню
		end
	end)
	
	-- Отображаем жесты других игроков
	net.Receive("WN_UseGesture", function()
		local ply = net.ReadEntity()
		local gestureId = net.ReadString()
		
		if not IsValid(ply) then return end
		
		local gesture = wn.Interactions.Gestures[gestureId]
		if gesture and gesture.animation then
			ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture.animation, true)
		end
	end)
	
	-- Отображаем эмоции других игроков
	net.Receive("WN_UseEmote", function()
		local ply = net.ReadEntity()
		local emoteId = net.ReadString()
		
		if not IsValid(ply) then return end
		
		local emote = wn.Interactions.Emotes[emoteId]
		if emote and emote.animation then
			ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, emote.animation, true)
		end
		
		if emote and emote.sound then
			ply:EmitSound(emote.sound)
		end
	end)
	
	-- Отображаем сдачу
	net.Receive("WN_Surrender", function()
		local ply = net.ReadEntity()
		
		if not IsValid(ply) then return end
		
		ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_BOW, true)
	end)
end
