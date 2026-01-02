--
util.AddNetworkString("addpredictable")
function SWEP:CreateWorldModel()
	local model = ents.Create("prop_physics")--ents.Create("whitenoise_gun")
	model:SetNoDraw(not wn.show_weapons)
	model:SetModel(self.WorldModel)
	model:SetMaterial("models/wireframe")
	model:Spawn()
	model:PhysicsDestroy()
	model:SetMoveType(MOVETYPE_NONE)
	model:SetNWBool("nophys", true)
	model:SetSolidFlags(FSOLID_NOT_SOLID)
	model:AddEFlags(EFL_NO_DISSOLVE)
	self:DeleteOnRemove(model)
	self.worldModel = model
	self:SetLagCompensated(true)
	model.weapon = self
	return model
end

local math_max = math.max
local vecZero = Vector(0, 0, 0)
local angZero = Angle(0, 0, 0)
local hook_Run = hook.Run
function SWEP:WorldModel_Transform(bNoApply,bNoAdditional)
	local model, owner = self.worldModel, self:GetOwner()
	
	if not IsValid(model) then model = self:CreateWorldModel() end
	
	if owner:IsNPC() then
        return false
    end
	
	if IsValid(owner) and (IsValid(owner:GetActiveWeapon()) and self == owner:GetActiveWeapon()) then
		local ent = IsValid(owner.FakeRagdoll) and owner.FakeRagdoll or owner
		
		local dtime = SysTime() - (self.last_transform or SysTime())
		self.last_transform = SysTime()

		local RHand = ent:LookupBone("ValveBiped.Bip01_R_Hand")
		
		if not RHand then return end

		local inuse = !owner:IsNPC() && (((!owner.InVehicle || !owner:InVehicle()) && self:KeyDown(IN_USE)) || ((owner.InVehicle && owner:InVehicle()) && not self:KeyDown(IN_USE))) || owner.suiciding || (owner == ent or owner:GetNetVar("lastFake", 0) > CurTime())

		local should = true and not (ent ~= owner and not (inuse))

		local matrixR = ent:GetBoneMatrix(RHand)
		
		if not matrixR then return end
		
		local aimvec = ent:IsNPC() and matrixR:GetAngles() or owner:GetAimVector():Angle()

		self:ChangeGunPos()
		
		local matrixRAngRot = matrixR:GetAngles()
		matrixRAngRot:RotateAroundAxis(matrixRAngRot:Forward(),180)
		local lerp = self:KeyDown(IN_ATTACK2) and 1 or 1
		local _,ang = WorldToLocal(vecZero,matrixRAngRot,vecZero,aimvec)
		ang = ang * lerp
		local _,ang = LocalToWorld(vecZero,ang,vecZero,aimvec)
		ang[3] = matrixRAngRot[3]
		local desiredAng = ((ent~=owner)) and ang or aimvec
		desiredAng[3] = desiredAng[3] + (owner:EyeAngles()[3])
		desiredAng:RotateAroundAxis(desiredAng:Forward(), ent:IsNPC() and 0 or 180)
		local desiredPos = matrixR:GetTranslation()
		
		--local oldPos = -(-desiredPos)
		--local oldAng = -(-desiredAng)
		
		self.lerped_positioning = Lerp(wn.lerpFrameTime2(0.1, dtime), self.lerped_positioning or 0, should and (ent != owner and 0.8 or 1) or 0.3)
		self.lerped_angle = Lerp(wn.lerpFrameTime2(0.1, dtime), self.lerped_angle or 0, should and 1 or (wn.KeyDown(owner, IN_ATTACK2) and 1 or 0))

		if !owner:IsNPC() then//should then
			local desiredPos1, desiredAng1 = self:PosAngChanges(owner, desiredPos, desiredAng, bNoAdditional)
			
			desiredPos = LerpVector(self.lerped_positioning, desiredPos, desiredPos1)
			desiredAng = LerpAngle(self.lerped_angle, desiredAng, desiredAng1)
			--self.lastTpikPos = desiredPos
			--self.lastTpikAng = desiredAng
		end

		--self.fuckhands = LerpFT(0.1, self.fuckhands, self.setrhik and 1 or 0)

		--desiredPos = LerpVector(self.fuckhands, oldPos, self.lastTpikPos or desiredPos)
		--desiredAng = LerpAngle(self.fuckhands, oldAng, self.lastTpikAng or desiredAng)

		local newPos,newAng = LocalToWorld(self.WorldPos, self.WorldAng, desiredPos, desiredAng)
		newAng:RotateAroundAxis(newAng:Forward(), 180)

		if self:ShouldUseFakeModel() then
			//newPos, newAng = LocalToWorld(self.FakePos, self.FakeAng, newPos, newAng)
		end

		if bNoApply then
			return newPos, newAng, desiredPos, desiredAng
		end

		self.desiredPos, self.desiredAng = newPos, newAng
		self.handPos, self.handAng = desiredPos, desiredAng
		
		model:SetPos(newPos)
		model:SetAngles(newAng)
		
		return newPos,newAng
	else
		model:SetPos(self:GetPos())
		model:SetAngles(self:GetAngles())
	end
end

local weaponsList = wn.weapons
concommand.Add("hg_show_weapons", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsAdmin() then return end
	wn.show_weapons = tonumber(args[1]) > 0
	for i,wep in ipairs(weaponsList) do
		if not IsValid(wep.worldModel) then continue end
		wep.worldModel:SetNoDraw(not wn.show_weapons)
	end
end)

