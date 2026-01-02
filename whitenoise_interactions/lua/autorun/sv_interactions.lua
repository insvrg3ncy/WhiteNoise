-- White Noise - Interaction System (Server)

if SERVER then
	util.AddNetworkString("WN_InteractionMenu")
	util.AddNetworkString("WN_UseGesture")
	util.AddNetworkString("WN_UsePhrase")
	util.AddNetworkString("WN_UseAction")
	util.AddNetworkString("WN_UseEmote")
	util.AddNetworkString("WN_DropWeapon")
	util.AddNetworkString("WN_DropAllWeapons")
	util.AddNetworkString("WN_Surrender")
	
	-- Открыть меню взаимодействий
	net.Receive("WN_InteractionMenu", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		-- Отправляем данные на клиент
		net.Start("WN_InteractionMenu")
		net.Send(ply)
	end)
	
	-- Использовать жест
	net.Receive("WN_UseGesture", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		local gestureId = net.ReadString()
		local gesture = wn.Interactions.Gestures[gestureId]
		
		if not gesture then return end
		
		-- Воспроизводим анимацию
		if gesture.animation then
			ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture.animation, true)
		end
		
		-- Отправляем другим игрокам
		net.Start("WN_UseGesture")
		net.WriteEntity(ply)
		net.WriteString(gestureId)
		net.SendOmit(ply)
	end)
	
	-- Использовать фразу
	net.Receive("WN_UsePhrase", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		local phraseId = net.ReadString()
		local phrase = wn.Interactions.Phrases[phraseId]
		
		if not phrase then return end
		
		-- Отправляем текст в чат
		ply:Say(phrase.text)
		
		-- Воспроизводим звук
		if phrase.sound then
			ply:EmitSound(phrase.sound)
		end
		
		-- Отправляем другим игрокам
		net.Start("WN_UsePhrase")
		net.WriteEntity(ply)
		net.WriteString(phraseId)
		net.SendOmit(ply)
	end)
	
	-- Использовать действие
	net.Receive("WN_UseAction", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		local actionId = net.ReadString()
		local action = wn.Interactions.Actions[actionId]
		
		if not action then return end
		
		if actionId == "drop_weapon" then
			net.Start("WN_DropWeapon")
			net.Send(ply)
		elseif actionId == "drop_all" then
			net.Start("WN_DropAllWeapons")
			net.Send(ply)
		elseif actionId == "surrender" then
			net.Start("WN_Surrender")
			net.Send(ply)
		elseif actionId == "fake_ragdoll" then
			-- Создать/удалить фейк рагдолл
			if wn and wn.Fake then
				if not IsValid(ply.FakeRagdoll) then
					wn.Fake(ply)
				else
					wn.FakeUp(ply)
				end
			end
		end
	end)
	
	-- Использовать эмоцию
	net.Receive("WN_UseEmote", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		local emoteId = net.ReadString()
		local emote = wn.Interactions.Emotes[emoteId]
		
		if not emote then return end
		
		-- Воспроизводим анимацию
		if emote.animation then
			ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, emote.animation, true)
		end
		
		-- Воспроизводим звук
		if emote.sound then
			ply:EmitSound(emote.sound)
		end
		
		-- Отправляем другим игрокам
		net.Start("WN_UseEmote")
		net.WriteEntity(ply)
		net.WriteString(emoteId)
		net.SendOmit(ply)
	end)
	
	-- Выбросить оружие
	net.Receive("WN_DropWeapon", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) then return end
		
		-- Проверяем, можно ли выбросить
		if wep:GetClass() == "weapon_hands" or wep:GetClass() == "weapon_physcannon" then return end
		
		-- Выбрасываем оружие
		ply:DropWeapon(wep)
	end)
	
	-- Выбросить всё оружие
	net.Receive("WN_DropAllWeapons", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		for _, wep in pairs(ply:GetWeapons()) do
			if IsValid(wep) and wep:GetClass() != "weapon_hands" and wep:GetClass() != "weapon_physcannon" then
				ply:DropWeapon(wep)
			end
		end
	end)
	
	-- Сдаться
	net.Receive("WN_Surrender", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		
		-- Поднимаем руки вверх
		ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_BOW, true)
		ply:SetNWBool("WN_Surrendered", true)
		
		-- Отправляем другим игрокам
		net.Start("WN_Surrender")
		net.WriteEntity(ply)
		net.SendOmit(ply)
	end)
end
