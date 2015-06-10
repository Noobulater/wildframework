if SERVER then AddCSLuaFile("shared.lua") end

SWEP.Weight             = 5
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.Author			= "Noobulater"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.PrintName			= "Weapon"	

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0

SWEP.HoldType = "normal"

SWEP.weapon = nil

function SWEP:Initialize()
	self:DrawShadow(false)
	self:SetWeaponHoldType(self.HoldType)
	self:LoadWeapon()
end

function SWEP:setModel(newModel)
	self.WorldModel = newModel
end

function SWEP:LoadWeapon()
	local weapon = self.weapon
	if weapon == nil then return false end
	if SERVER then
		self:SetDTFloat(0, -1)
		self:GetOwner():SetNWString("weaponClass", self.weapon.getClass() )
		self:SetClip1(weapon.primClip or 0)
		if self:GetDTFloat(1) != -1 then
			self:SetDTFloat(1, -1)	
		end		
	end
	self.WorldModel	= weapon.getModel()
	self:SetWeaponHoldType(weapon.getHoldType())
	self.Primary.Ammo = weapon.getAmmoType()
	self.Primary.Automatic = weapon.getAutomatic() or false

end

function SWEP:GetWeapon( weaponData )
	return self.weapon
end

function SWEP:SetWeapon( weaponData )
	if SERVER then
		if self.weapon != nil then
			self.weapon.primClip = self:Clip1()
		end
	end
	self.weapon = weaponData
	self:LoadWeapon()
end

function SWEP:Precache()
end

SWEP.nextPFire = 0
function SWEP:CanPrimaryAttack()
	if self:GetWeapon() == nil then return false end
	if self.nextPFire >= CurTime() then return false end
	if self:GetWeapon().getClipSize() <= 0 then return true end
	if self:Clip1() <= 0 then if SERVER then networkForceReload(self:GetOwner()) end return false end
	return true
end

function SWEP:PrimaryAttack()
	local weapon = self.weapon
	if !self:CanPrimaryAttack() then return false end
	if self:GetDTFloat(0) != -1 && self.nextPFire then if SERVER then self:SetDTFloat(0, -1) end end	

	self.nextPFire = CurTime() + weapon.getFireRate()

	if weapon.primaryFire( self:GetOwner(), self ) then
		self.Owner:LagCompensation( true )

		-- local muzzle = self:LookupAttachment("muzzle")
		-- local pos = self:GetAttachment( muzzle )["Pos"]
		-- local ang = self:GetAttachment( muzzle )["Ang"]

		local bData = {}
		bData.Num = 1
		bData.Src = self.Owner:GetShootPos()
		bData.Dir = self.Owner:GetAimVector()
		bData.Spread = Vector( weapon.getAccuracy() * self:GetAimFactor(), weapon.getAccuracy() * self:GetAimFactor() , weapon.getAccuracy() * self:GetAimFactor())
		bData.Tracer = 1
		bData.TracerName = weapon.getTracerName() or nil
		bData.Force = weapon.getDamage() * 3
		bData.Damage = weapon.getDamage()
		bData.Num = weapon.getNumBullets() or 1

		bData.Callback = function( attacker, tr, dmginfo )
							if IsValid(tr.Entity) && tr.Entity:IsNPC() && tr.Entity.hitBody then
								tr.Entity:hitBody( tr.HitGroup, dmginfo )
							end

							if weapon.callBack then
								weapon.callBack()
							end		
						end
		self.Owner:FireBullets(bData)

		self.Owner:LagCompensation( false )

		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash() 

		if SERVER then
			sound.Play( weapon.getFireSound(), self:GetOwner():GetPos() + Vector(0,0,30), 75, 100, 1 )
		end

		self:SetClip1(math.Clamp(self:Clip1() - 1, 0, weapon.getClipSize() or 10))

		self.Owner:FireBullets(bullet)

	end

	return true
end

function SWEP:TakePrimaryAmmo(num)

end

SWEP.nextSFire = 0
function SWEP:CanSecondaryAttack()
	return ( (self:Clip2() > 0) && (self.nextPFire < CurTime()) )
end

function SWEP:SecondaryAttack()
	if !self:CheckReload() then return false end	

	return true
end

function SWEP:TakeSecondaryAmmo(num)

end

function SWEP:CheckReload()
	local weapon = self.weapon
	if self:GetDTFloat(0) != -1 && (self:GetDTFloat(0) < CurTime()) then
		if weapon == nil then return false end	
		self:SetDTFloat(0, -1)
		weapon.reload( self.Owner , self )		
		return true
	end
	return false
end

function SWEP:Reload()
	local weapon = self.weapon
	if weapon == nil then return false end
	if self:GetDTFloat(0) != -1 then return false end
	if self:Clip1() == self:GetWeapon().getClipSize() then return false end	
	self:SetDTFloat( 0, CurTime() + (weapon.getReloadTime() or 2) )
	self.Owner:SetAnimation( PLAYER_RELOAD )
end

function SWEP:OnRestore()	
end

function SWEP:GetAimFactor()
	local weapon = self.weapon	
	if weapon == nil then return 1 end

	local aimTime = self:GetDTFloat(1)
	if aimTime == -1 then
		return 1
	end

	local aimFactor = 1 - math.Clamp((CurTime() - aimTime)/3, 0, 0.8)
	return aimFactor
end

function SWEP:Think()
	if !GAMEMODE.useTopDown && SERVER then
		if self:GetOwner():GetVelocity():Length() == 0 then
			if self:GetOwner():KeyDown(IN_SPEED) then
				if self:GetDTFloat(1) == -1 then
					self:SetDTFloat(1, CurTime())
				end
			else
				if self:GetDTFloat(1) != -1 then
					self:SetDTFloat(1, -1)	
				end				
			end
		else
			if self:GetDTFloat(1) != -1 then
				self:SetDTFloat(1, -1)	
			end
		end	
	end
	self:CheckReload()
end

function SWEP:Holster(wep)
	return true
end

function SWEP:Deploy()
	return true
end

function SWEP:OnRemove()
	self:GetOwner():SetNWString("weaponClass", "" )
end

function SWEP:OwnerChanged()
end

function SWEP:Ammo1()
end

function SWEP:Ammo2()
end

function SWEP:SetupDataTables()
	self:SetDTFloat(0, 0) -- reloading?
end
if CLIENT then

-- function SWEP:DrawWorldModel()
-- 	return true
-- end

local aimTime = nil

local lastFov = 0

function SWEP:CalcView( ply, pos, ang, fov )
	if LocalPlayer():GetVelocity():Length() == 0 then
		local aimTime = self:GetDTFloat(1)
		if aimTime != nil && aimTime != -1 then 
			fov = fov - math.Clamp(50 * (1-self:GetAimFactor()),0,50)

		end
	end

	local view = {} -- we only really care about FOV
	view.origin = pos
	view.angles = ang
	view.fov = fov

	lastFov = fov

	return view
end

local function paperDoll()
	for _,ply in pairs(player.GetAll()) do
		if ply:Alive() && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "weapon_loader" then
			local weaponClass = ply:GetNWString("weaponClass")
			if ply:GetNWString("weaponClass") != nil && ply:GetNWString("weaponClass") != "" then
				if !IsValid(ply.weaponModel) then
					ply.weaponModel = ents.CreateClientProp()
					ply.weaponModel:Spawn()
				end
				local prop = ply.weaponModel
				if ply.weapon == nil or ply.weapon.getClass() != weaponClass then
					ply.weapon = classItemData.genItem(weaponClass)
				end			
				if ply.weapon != nil then
					if ply:GetActiveWeapon().SetWeaponHoldType != nil then
						ply:GetActiveWeapon():SetWeaponHoldType(ply.weapon.getHoldType())
					end
					ply:GetActiveWeapon().WorldModel = ply.weapon.getModel()
			   		//ply.weapon.paperDoll(ply, prop)
				end
			else
				if IsValid(ply.weaponModel) then
					ply.weaponModel:Remove()
				end
			end
		else
			if IsValid(ply.weaponModel) then
				ply.weaponModel:Remove()
			end			
		end
	end
end

hook.Add("CalcView", "weaponPaperDoll", paperDoll)

end