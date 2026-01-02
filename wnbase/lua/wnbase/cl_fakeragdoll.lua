-- White Noise - Fake Ragdoll System (Client)

if CLIENT then
	wn = wn or {}
	
	local follow = nil
	local fakeTimer = nil
	
	-- Получение рагдолла игрока
	net.Receive("WN_PlayerRagdoll", function()
		local ply = net.ReadEntity()
		local ragdoll = net.ReadEntity()
		
		if not IsValid(ply) then return end
		
		if IsValid(ragdoll) then
			ply.FakeRagdoll = ragdoll
			if ply == LocalPlayer() then
				follow = ragdoll
			end
		else
			ply.FakeRagdoll = nil
			if ply == LocalPlayer() then
				follow = nil
				fakeTimer = nil
			end
		end
	end)
	
	-- Камера для фейк рагдолла
	hook.Add("CalcView", "WN_FakeRagdollView", function(ply, origin, angles, fov)
		if not IsValid(ply) or ply ~= LocalPlayer() then return end
		if not IsValid(ply.FakeRagdoll) then return end
		
		local ragdoll = ply.FakeRagdoll
		local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
		
		if not att then return end
		
		local view = {}
		view.origin = att.Pos
		view.angles = att.Ang
		view.fov = fov
		
		return view
	end)
	
	-- Управление камерой
	hook.Add("InputMouseApply", "WN_FakeRagdollMouse", function(cmd, x, y, angle)
		local ply = LocalPlayer()
		if not IsValid(ply) or not IsValid(ply.FakeRagdoll) then return end
		
		local ragdoll = ply.FakeRagdoll
		local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
		
		if not att then return end
		
		angle.pitch = math.Clamp(angle.pitch + y / 50, -89, 89)
		angle.yaw = angle.yaw - x / 50
		
		cmd:SetViewAngles(angle)
		
		return true
	end)
	
	-- Управление рагдоллом (улучшенное)
	hook.Add("StartCommand", "WN_FakeRagdollControl", function(ply, cmd)
		if not IsValid(ply) or ply ~= LocalPlayer() then return end
		if not IsValid(ply.FakeRagdoll) then return end
		
		local ragdoll = ply.FakeRagdoll
		if not IsValid(ragdoll) then return end
		
		-- Отправляем команды на сервер для управления рагдоллом
		net.Start("WN_FakeRagdollControl")
		net.WriteVector(cmd:GetViewAngles():Forward())
		net.WriteVector(cmd:GetViewAngles():Right())
		net.WriteBool(cmd:KeyDown(IN_FORWARD))
		net.WriteBool(cmd:KeyDown(IN_BACK))
		net.WriteBool(cmd:KeyDown(IN_MOVELEFT))
		net.WriteBool(cmd:KeyDown(IN_MOVERIGHT))
		net.WriteBool(cmd:KeyDown(IN_JUMP))
		net.WriteBool(cmd:KeyDown(IN_DUCK))
		net.SendToServer()
	end)
	
	-- Очистка при спавне
	hook.Add("PlayerSpawn", "WN_RemoveFakeRagdollClient", function(ply)
		if ply == LocalPlayer() then
			follow = nil
			fakeTimer = nil
		end
	end)
end
