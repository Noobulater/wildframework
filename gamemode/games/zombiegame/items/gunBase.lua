local class = "gunBase"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Base_Gun")
	weapon.setDescription("A GUN")
	weapon.setFireSound("weapons/mac10/mac10-1.wav")	
	weapon.setHoldType("smg")
	weapon.setAmmoType("automaticAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_smg_mac10.mdl")

	if CLIENT then
		local lastFov = 75
		function weapon.calcView( swep, ply, pos, ang, fov )
			if !GAMEMODE.useTopDown then
				-- if LocalPlayer():GetVelocity():Length() == 0 then
				-- 	local aimTime = swep:GetDTFloat(1)
				-- 	if aimTime != nil && aimTime != -1 then 
				-- 		fov = fov - math.Clamp(30 * (1-swep:GetAimFactor()),0,30)
				-- 	end
				-- end

				local desiredFov = fov
				if swep:GetDTBool(0) then
					if swep:GetOwner():GetVelocity():Length() < 10 then
						desiredFov = 45
					else
						desiredFov = 60
					end
				end

				local view = {} -- we only really care about FOV
				view.origin = pos
				view.angles = ang
				view.fov = Lerp(0.1, lastFov, desiredFov)

				lastFov = view.fov

				return view
			end
		end
	end

	function weapon.think( user, swep )
		if !GAMEMODE.useTopDown then
			if swep:GetDTBool(0) then
				if swep:GetOwner():GetVelocity():Length() > 10 then
					swep:SetDTFloat(1, CurTime())
				else
					if swep:GetDTFloat(1) == -1 then
						swep:SetDTFloat(1, CurTime())
					end
				end
			else
				if swep:GetDTFloat(1) != -1 then
					swep:SetDTFloat(1, -1)	
				end
			end
		end
		return true
	end

	function weapon.reload( user , swep )
		if SERVER then
			if GAMEMODE.UnlimitedAmmo then swep:SetClip1(weapon.getClipSize()) return end
			local pool = {}
			local inventoryID = user:getInventory().getUniqueID()
			for slot, item in pairs(user:getInventory().getItems()) do
				if item != 0 && item.getClass() == weapon.getAmmoType() then
					pool[slot] = item
				end
			end
			
			local removePool = weapon.getClipSize() - swep:Clip1()

			for slot, item in pairs(pool) do
				if removePool > 0 then
					local ammo = tonumber(item.getExtras()) or 0
					if removePool >= ammo then
						swep:SetClip1(swep:Clip1() + ammo)
						removePool = removePool - ammo
						if SERVER then
							user:getInventory().removeItem(slot)
						end
					else
						local ammoLeft = ammo - removePool
						swep:SetClip1(swep:Clip1() + removePool)					
						item.setExtras(tostring(ammoLeft)) 
						removePool = 0
						networkSlotExtras(inventoryID, slot, item, user)
						break
					end
				end
			end
		end
	end

	function weapon.getAimFactor( user, swep )
		local aimTime = swep:GetDTFloat(1)
		if aimTime == -1 then
			return 1
		end

		local stillBonus = (CurTime() - aimTime)/5

		local lastFire = swep:getNextPFire() - weapon.getFireRate()
		local silentBonus = 0--(CurTime() - lastFire)
		local bonus = math.Clamp(stillBonus - silentBonus, 0.2, 0.8)

		local aimFactor = 1 - bonus 
		return aimFactor
	end

	function weapon.primaryFire( user, swep )
		swep.Owner:LagCompensation( true )

		-- local muzzle = swep:LookupAttachment("muzzle")
		-- local pos = swep:GetAttachment( muzzle )["Pos"]
		-- local ang = swep:GetAttachment( muzzle )["Ang"]`

		local bData = {}
		bData.Num = 1
		bData.Src = swep.Owner:GetShootPos()
		bData.Dir = swep.Owner:GetAimVector()

		local aimFactor = weapon.getAimFactor( user, swep )

		bData.Spread = Vector( weapon.getAccuracy() * aimFactor, weapon.getAccuracy() * aimFactor , weapon.getAccuracy() * aimFactor)
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
								weapon.callBack(attacker, tr, dmginfo)
							end		
						end
		swep.Owner:FireBullets(bData)

		swep.Owner:LagCompensation( false )

		swep.Owner:SetAnimation( PLAYER_ATTACK1 )
		swep.Owner:MuzzleFlash() 

		if SERVER then
			sound.Play( weapon.getFireSound(), swep:GetOwner():GetPos() + Vector(0,0,30), 75, 100, 1 )
		end

		swep:SetClip1(math.Clamp(swep:Clip1() - 1, 0, weapon.getClipSize() or 10))

		swep.Owner:FireBullets(bullet)

		local aimTime = swep:GetDTFloat(1)
		if aimTime != -1 then
			swep:SetDTFloat(1, CurTime() - math.Clamp(CurTime()-aimTime, 0, 6) + 0.5)
		end		

		swep:setNextPFire(CurTime() + weapon.getFireRate())
	end

	local ironSights
	function weapon.secondaryFire( user, swep )
		if SERVER then
			ironSights = swep:GetDTBool(0)		
			if ironSights then
				swep:SetDTFloat(1, -1)
				user:addSpeedModifier(0, 90)
			else
				user:addSpeedModifier(0, -90)
			end
			swep:SetDTBool(0, !ironSights)	
		end
	end

	function weapon.holster( user )
		if ironSights == false then
			user:addSpeedModifier(0, 90)
		end
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON