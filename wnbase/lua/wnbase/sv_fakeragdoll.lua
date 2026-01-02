-- White Noise - Fake Ragdoll System (Server)
-- Адаптировано из Homigrad

if SERVER then
	wn = wn or {}
	wn.ragdollFake = wn.ragdollFake or {}
	
	util.AddNetworkString("WN_PlayerRagdoll")
	util.AddNetworkString("WN_FakeRagdoll")
	util.AddNetworkString("WN_FakeRagdollControl")
	
	-- Массы костей (из Homigrad)
	local IdealMassPlayer = {
		["ValveBiped.Bip01_Pelvis"] = 12.775918006897,
		["ValveBiped.Bip01_Spine1"] = 24.36336517334,
		["ValveBiped.Bip01_Spine2"] = 24.36336517334,
		["ValveBiped.Bip01_R_Clavicle"] = 3.4941370487213,
		["ValveBiped.Bip01_L_Clavicle"] = 3.4941370487213,
		["ValveBiped.Bip01_R_UpperArm"] = 3.4941370487213,
		["ValveBiped.Bip01_L_UpperArm"] = 3.441034078598,
		["ValveBiped.Bip01_L_Forearm"] = 1.7655730247498,
		["ValveBiped.Bip01_L_Hand"] = 1.0779889822006,
		["ValveBiped.Bip01_R_Forearm"] = 1.7567429542542,
		["ValveBiped.Bip01_R_Hand"] = 1.0214320421219,
		["ValveBiped.Bip01_R_Thigh"] = 10.212161064148,
		["ValveBiped.Bip01_R_Calf"] = 4.9580898284912,
		["ValveBiped.Bip01_Head1"] = 5.169750213623,
		["ValveBiped.Bip01_L_Thigh"] = 10.213202476501,
		["ValveBiped.Bip01_L_Calf"] = 4.9809679985046,
		["ValveBiped.Bip01_L_Foot"] = 2.3848159313202,
		["ValveBiped.Bip01_R_Foot"] = 2.3848159313202
	}
	
	-- Создание рагдолла
	function wn.Ragdoll_Create(ply, fake)
		if not IsValid(ply) or not ply:Alive() then return end
		
		local ragdoll = ents.Create("prop_ragdoll")
		ragdoll:SetModel(ply:GetModel())
		ragdoll:SetPos(ply:GetPos())
		ragdoll:SetAngles(ply:GetAngles())
		ragdoll:SetSkin(ply:GetSkin())
		ragdoll:SetColor(ply:GetColor())
		ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		ragdoll:Spawn()
		ragdoll:Activate()
		ragdoll:AddEFlags(EFL_NO_DAMAGE_FORCES)
		ragdoll:AddFlags(FL_NOTARGET)
		
		-- Копируем bodygroups
		for i = 0, ply:GetNumBodyGroups() - 1 do
			ragdoll:SetBodygroup(i, ply:GetBodygroup(i))
		end
		
		-- Устанавливаем массы костей
		local velocity = ply:GetVelocity()
		local offset = ply:GetPos() - ply:GetBoneMatrix(0):GetTranslation() + Vector(0, 0, 36)
		
		for physNum = 0, ragdoll:GetPhysicsObjectCount() - 1 do
			local phys = ragdoll:GetPhysicsObjectNum(physNum)
			if not IsValid(phys) then continue end
			
			local bone = ragdoll:TranslatePhysBoneToBone(physNum)
			if bone < 0 then continue end
			
			local matrix = ply:GetBoneMatrix(bone)
			if not matrix then continue end
			
			local boneName = ragdoll:GetBoneName(bone)
			phys:SetMass(IdealMassPlayer[boneName] or 4)
			phys:SetVelocity(velocity)
			phys:SetPos(matrix:GetTranslation() + offset)
			phys:SetAngles(matrix:GetAngles())
			
			-- Поворачиваем голову
			if boneName == "ValveBiped.Bip01_Head1" then
				local _, ang = LocalToWorld(Vector(0, 0, 0), Angle(-80, 0, 90), Vector(0, 0, 0), ply:EyeAngles())
				phys:SetAngles(ang)
			end
			
			phys:EnableDrag(1)
			phys:SetDragCoefficient(-1000)
			phys:SetDamping(0, 2)
			phys:Wake()
		end
		
		-- Устанавливаем сетевые переменные
		ragdoll:SetNWString("PlayerName", ply:Name())
		ragdoll:SetNWVector("PlayerColor", ply:GetPlayerColor())
		ragdoll:SetNWEntity("ply", ply)
		
		-- Callback при удалении
		ragdoll:CallOnRemove("FakeRemove", function()
			if IsValid(ply) then
				ply.FakeRagdoll = nil
				wn.ragdollFake[ply] = nil
			end
		end)
		
		-- Коллизии рагдолла
		ragdoll:AddCallback("PhysicsCollide", function(ragdoll, data)
			hook.Run("WN_RagdollCollide", ragdoll, data)
		end)
		
		return ragdoll
	end
	
	-- Создание фейк рагдолла
	function wn.Fake(ply, ragdoll, no_freemove, force)
		if ply:InVehicle() and not force then return end
		if not IsValid(ragdoll) and (not IsValid(ply) or IsValid(ply.FakeRagdoll) or not (ply:IsPlayer() and ply:Alive())) then return end
		
		local rag = IsValid(ragdoll) and ragdoll or wn.Ragdoll_Create(ply, true)
		if not IsValid(rag) then return end
		
		rag:CallOnRemove("Fake", function()
			if IsValid(ply) and ply.FakeRagdoll == rag then
				ply.FakeRagdoll = nil
				if ply:Alive() then ply:Kill() end
			end
		end)
		
		ply.fakecd = CurTime() + 1
		NET_Fake(rag, ply)
		
		ply.FakeRagdoll = rag
		
		if IsValid(ply.FakeRagdollOld) then
			ply.FakeRagdollOld:Remove()
		end
		ply.FakeRagdollOld = nil
		
		if rag:GetVelocity():LengthSqr() < (200 * 200) or ply:InVehicle() then
			wn.SetFreemove(ply, not no_freemove)
		end
		
		wn.ragdollFake[ply] = rag
		ply.ActiveWeapon = ply:GetActiveWeapon()
		
		hook.Run("WN_Fake", ply, rag)
		
		timer.Simple(0, function()
			if not IsValid(ply) then return end
			ply:DrawWorldModel(false)
			ply:DrawShadow(false)
			local pos = ply:GetPos()
			ply:SetSolidFlags(bit.bor(ply:GetSolidFlags(), FSOLID_NOT_SOLID))
			ply:SetPos(pos)
			ply:SetNoDraw(false)
			ply:SetRenderMode(RENDERMODE_NONE)
		end)
		
		if ply:FlashlightIsOn() then ply:Flashlight(false) end
		ply.oldCanUseFlashlight = ply:CanUseFlashlight()
		ply:AllowFlashlight(false)
		
		if ply:IsOnFire() then
			timer.Simple(0.1, function()
				if IsValid(ply) then ply:Extinguish() end
			end)
		end
	end
	
	-- Вставание из фейк рагдолла
	function wn.FakeUp(ply, forced, respawn_like)
		if ply:InVehicle() then forced = true end
		if ply:InVehicle() and ply:GetVehicle():WaterLevel() >= 3 then return end
		if not forced and (not IsValid(ply.FakeRagdoll) or not ply:Alive() or hook.Run("WN_ShouldFakeUp", ply) ~= nil) then return false end
		
		ply.fakecd = CurTime() + 2
		local ragdoll = ply.FakeRagdoll
		
		if not IsValid(ragdoll) then return false end
		
		local ent = ragdoll
		local posit = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Pelvis"))
		if not posit then posit = ent:GetPos() else posit = posit:GetTranslation() end
		
		local pos = posit + Vector(0, 0, 50)
		
		if not pos and not forced then return false end
		
		hook.Run("WN_FakeUp", ply, ragdoll)
		
		ply.FakeRagdollOld = ragdoll
		ply:SetNWEntity("FakeRagdollOld", ragdoll)
		ply.FakeRagdoll = nil
		
		ply:ConCommand("+duck")
		timer.Simple(0.5, function()
			if IsValid(ply) then
				ply:ConCommand("-duck")
			end
		end)
		
		if IsValid(ragdoll) and ragdoll:IsOnFire() then
			timer.Simple(0.1, function()
				if IsValid(ply) and IsValid(ragdoll) and ragdoll.fires then
					for fire, firePos in pairs(ragdoll.fires) do
						-- Переносим огонь на игрока (если нужно)
					end
				end
			end)
		end
		
		-- Восстанавливаем игрока
		local hp, armor = ply:Health(), ply:Armor()
		local ang, wep = ply:EyeAngles(), ply:GetActiveWeapon()
		
		ply:SetPos(pos)
		ply:SetRenderMode(RENDERMODE_NORMAL)
		ply.LastFakeUp = CurTime()
		ply:DrawWorldModel(true)
		ply:SetHealth(hp)
		ply:SetArmor(armor)
		ply:SetEyeAngles(ang)
		
		ply:SetSolidFlags(bit.band(ply:GetSolidFlags(), bit.bnot(FSOLID_NOT_SOLID)))
		ply:SetNoDraw(false)
		ply:SetRenderMode(RENDERMODE_NORMAL)
		
		if ply.oldCanUseFlashlight then
			ply:AllowFlashlight(ply.oldCanUseFlashlight)
			ply.oldCanUseFlashlight = nil
		end
		
		NET_Up(ply)
		
		return true
	end
	
	-- Получить текущий character (ragdoll или игрок)
	function wn.GetCurrentCharacter(ply)
		if not IsValid(ply) then return nil end
		local rag = IsValid(ply.FakeRagdoll) and ply.FakeRagdoll or IsValid(ply:GetNWEntity("FakeRagdoll", NULL)) and ply:GetNWEntity("FakeRagdoll", NULL)
		return (IsValid(rag) and rag) or ply
	end
	
	-- Установка свободного движения
	function wn.SetFreemove(ply, set)
		if set then
			ply.lastFake = CurTime() + 1.15
			ply:SetNWFloat("WN_lastFake", ply.lastFake)
			ply:SetMoveType(MOVETYPE_WALK)
		else
			ply.lastFake = 0
			ply:SetNWFloat("WN_lastFake", 0)
			ply:SetMoveType(ply:InVehicle() and MOVETYPE_NOCLIP or MOVETYPE_NONE)
			local hull = Vector(5, 5, 5)
			ply:SetHull(-hull, hull)
			ply:SetHullDuck(-hull, hull)
			ply:SetViewOffset(Vector(0, 0, 0))
			ply:SetViewOffsetDucked(Vector(0, 0, 0))
		end
	end
	
	-- Сетевая синхронизация
	local function NET_Fake(ragdoll, ply, send)
		ply:SetNWEntity("FakeRagdoll", ragdoll)
		net.Start("WN_PlayerRagdoll")
		net.WriteEntity(ply)
		net.WriteEntity(ragdoll)
		if IsValid(send) and send:IsPlayer() then
			net.Send(send)
		else
			net.Broadcast()
		end
	end
	
	local function NET_Up(ply, send)
		ply:SetNWEntity("FakeRagdoll", NULL)
		net.Start("WN_PlayerRagdoll")
		net.WriteEntity(ply)
		net.WriteEntity(NULL)
		if IsValid(send) and send:IsPlayer() then
			net.Send(send)
		else
			net.Broadcast()
		end
	end
	
	-- Команда для создания/удаления фейк рагдолла
	net.Receive("WN_FakeRagdoll", function(len, ply)
		if not IsValid(ply) or not ply:Alive() then return end
		if ply.fakecd and ply.fakecd > CurTime() then return end
		if ply:IsFlagSet(FL_FROZEN) then return end
		
		if not IsValid(ply.FakeRagdoll) then
			wn.Fake(ply)
		else
			wn.FakeUp(ply)
		end
	end)
	
	-- Консольная команда
	concommand.Add("wn_fake", function(ply, cmd, args)
		if not IsValid(ply) then return end
		if not ply:Alive() then return end
		if ply.fakecd and ply.fakecd > CurTime() then return end
		if ply:IsFlagSet(FL_FROZEN) then return end
		
		if not IsValid(ply.FakeRagdoll) then
			wn.Fake(ply)
		else
			wn.FakeUp(ply)
		end
	end)
	
	-- Очистка при спавне
	hook.Add("PlayerSpawn", "WN_RemoveFakeRagdoll", function(ply)
		if IsValid(ply.FakeRagdoll) then
			ply.FakeRagdoll:Remove()
			ply.FakeRagdoll = nil
		end
		ply:SetNWEntity("FakeRagdoll", NULL)
		ply:SetNWEntity("FakeRagdollOld", NULL)
		wn.ragdollFake[ply] = nil
		ply:RemoveFlags(FL_NOTARGET)
	end)
	
	-- Очистка при смерти
	hook.Add("PlayerDeath", "WN_RemoveFakeOnDeath", function(ply)
		if IsValid(ply.FakeRagdoll) then
			ply.FakeRagdoll:Remove()
			ply.FakeRagdoll = nil
		end
	end)
	
	-- Блокируем шаги при фейк рагдолле
	hook.Add("PlayerFootstep", "WN_FakeFootstep", function(ply)
		if IsValid(ply.FakeRagdoll) then
			return true
		end
	end)
	
	-- Управление рагдоллом
	net.Receive("WN_FakeRagdollControl", function(len, ply)
		if not IsValid(ply) or not IsValid(ply.FakeRagdoll) then return end
		
		local ragdoll = ply.FakeRagdoll
		if not IsValid(ragdoll) then return end
		
		local forward = net.ReadVector()
		local right = net.ReadVector()
		local keyForward = net.ReadBool()
		local keyBack = net.ReadBool()
		local keyLeft = net.ReadBool()
		local keyRight = net.ReadBool()
		local keyJump = net.ReadBool()
		local keyDuck = net.ReadBool()
		
		-- Получаем физический объект таза
		local phys = ragdoll:GetPhysicsObjectNum(0) -- Pelvis
		if not IsValid(phys) then return end
		
		local vel = Vector(0, 0, 0)
		local speed = 200
		
		if keyForward then
			vel = vel + forward * speed
		end
		if keyBack then
			vel = vel - forward * speed
		end
		if keyLeft then
			vel = vel - right * speed
		end
		if keyRight then
			vel = vel + right * speed
		end
		if keyJump then
			vel = vel + Vector(0, 0, 300)
		end
		
		-- Применяем скорость к тазу
		phys:SetVelocity(vel)
		
		-- Также применяем к другим важным костям для лучшего управления
		local spinePhys = ragdoll:GetPhysicsObjectNum(1) -- Spine
		if IsValid(spinePhys) then
			spinePhys:SetVelocity(vel * 0.5)
		end
	end)
	
	-- Обновление позиции игрока при фейк рагдолле
	hook.Add("PlayerThink", "WN_FakeRagdollUpdate", function(ply)
		if not IsValid(ply.FakeRagdoll) then return end
		
		local ragdoll = ply.FakeRagdoll
		if not IsValid(ragdoll) then return end
		
		-- Обновляем позицию игрока (невидимого) к позиции рагдолла
		local pelvis = ragdoll:GetPhysicsObjectNum(0)
		if IsValid(pelvis) then
			ply:SetPos(pelvis:GetPos())
		end
	end)
end
