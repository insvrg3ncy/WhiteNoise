AddCSLuaFile()
wn.ammotypes = wn.ammotypes or {}

/*
BulletSettings = {
			Damage = 8,
			Force = 5,
			Penetration = 4,
			Shell = "9x18",
			Speed = 259,
			Diameter = 11.19,
			Distance = 10,
			Mass = 10,
			AirResistMul = 0.0001,
			NumBullet = 1,
		}
*/

function SWEP:ApplyAmmoChanges(type_)
	if not self.AmmoTypes or not istable(self.AmmoTypes) then
		print("ЭРРАР: Таблица не валдинайа")
		return
	end

	local ammo = self.AmmoTypes[type_]
	if not ammo then
		print("ЭРРАР: ИНВАЛИД ТИП ПАТРОНААА")
		return
	end

	local ammohuy = wn.ammotypeshuy[ammo[1]]
	if not ammohuy then
		print("ЭРРАР: говно с патриками в wn.ammotypeshuy")
		return
	end

	local ammotype = ammohuy.BulletSettings
	if not ammotype then
		print("ЭРРАР: Нет настройек огузки") -- дека дебил
		return
	end

	self.Primary.Ammo = ammo[1]
	self.newammotype = type_
	self.RealAmmoType = ammo[1]
	self.Primary.Damage = ammotype.Damage
	self.Penetration = ammotype.Penetration
	self.NumBullet = ammotype.NumBullet
	--self.Primary.Force = ammotype.Force

	if SERVER then
		net.Start("syncAmmoChanges")
		net.WriteEntity(self)
		net.WriteInt(type_, 4)
		net.Broadcast()
	end
end


if SERVER then
	util.AddNetworkString("syncAmmoChanges")
else
	net.Receive("syncAmmoChanges", function()
		local self = net.ReadEntity()
		local type_ = net.ReadInt(4)
		if self.ApplyAmmoChanges then
			self:ApplyAmmoChanges(type_)
		end
	end)
end

if CLIENT then
	 
	wn.weapons = wn.weapons or {}
	concommand.Add("hg_unload_ammo", function(ply, cmd, args)
		local wep = ply:GetActiveWeapon()
		if wep and ishgweapon(wep) and wep:Clip1() > 0 and wep:CanUse() then
			net.Start("unload_ammo")
			net.WriteEntity(wep)
			net.SendToServer()
			wep:SetClip1(0)
			wep.drawBullet = nil
		end
	end)

	concommand.Add("hg_change_ammotype", function(ply, cmd, args)
		local wep = ply:GetActiveWeapon()
		local type_ = math.Round(args[1])
		if wep and ishgweapon(wep) and wep:Clip1() == 0 or wep.AllwaysChangeAmmo and wep:CanUse() and wep.AmmoTypes and wep.AmmoTypes[type_] then
			--wep:ApplyAmmoChanges(type_)
			ply:ChatPrint("Changed ammotype to: " .. wep.AmmoTypes[type_][1])
			net.Start("changeAmmoType")
			net.WriteEntity(wep)
			net.WriteInt(type_, 4)
			net.SendToServer()
		end
	end)

	local function unloadAmmo()
		RunConsoleCommand("hg_unload_ammo")
	end

	local function changeAmmoType(chosen)
		RunConsoleCommand("hg_change_ammotype", chosen)
	end

	hook.Add("radialOptions", "2", function()
		local wep = LocalPlayer():GetActiveWeapon()
		local organism = LocalPlayer().organism or {}

		if organism.otrub then return end

		if IsValid(wep) and ishgweapon(wep) then
			if (wep:Clip1() == 0 or wep.AllwaysChangeAmmo) and wep.AmmoTypes and not wep.reload then
				
				local ammotypes = {}
				for k,ammotype in ipairs(wep.AmmoTypes) do
					ammotypes[k] = ammotype[1]
				end 
				local tbl = {
					changeAmmoType,
					"Change Ammo Type",
					true,
					ammotypes
				}

				wn.radialOptions[#wn.radialOptions + 1] = tbl
			elseif wep:Clip1() > 0 then
				local tbl = {unloadAmmo, "Unload Ammo"}
				wn.radialOptions[#wn.radialOptions + 1] = tbl
			end
		end
	end)

	net.Receive("unload_ammo",function()
		local wep = net.ReadEntity()
		if wep.Unload then
			wep:Unload()
		end
	end)
else
	util.AddNetworkString("unload_ammo")
	util.AddNetworkString("changeAmmoType")
	net.Receive("unload_ammo", function(len, ply)
		local wep = net.ReadEntity()
		wep.drawBullet = nil
		if wep and wep:GetOwner() == ply and ishgweapon(wep) and wep:Clip1() > 0 and wep:CanUse() then
			ply:GiveAmmo(wep:Clip1(), wep:GetPrimaryAmmoType(), true)
			wep:SetClip1(0)
			if wep.Unload then
				wep:Unload()
			end
			net.Start("unload_ammo")
			net.WriteEntity(wep)
			net.Broadcast()
			wn.GetCurrentCharacter(ply):EmitSound("snd_jack_hmcd_ammotake.wav")
		end
	end)

	net.Receive("changeAmmoType", function(len, ply)
		local wep = net.ReadEntity()
		local type_ = net.ReadInt(4)
		if wep and ishgweapon(wep) and wep:Clip1() == 0 or wep.AllwaysChangeAmmo and wep:CanUse() and wep.AmmoTypes and wep.AmmoTypes[type_] then wep:ApplyAmmoChanges(type_) end
	end)
	--bruh probably need to broadcast this bullshit after
end