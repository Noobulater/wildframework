local class = "projectileBase"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Base_Launcher")
	weapon.setDescription("A Launcher")
	weapon.setFireSound("weapons/m4a1/m4a1_unsil-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(19)
	weapon.setAccuracy(.03)
	weapon.setClipSize(30)
	weapon.setHoldType("ar2")
	weapon.setAmmoType("rifleAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_rif_m4a1.mdl")
	weapon.setTracerName("none")

	local projectile = "models/Items/AR2_Grenade.mdl"

	function weapon.projectile(user, swep)

	end

	function weapon.primaryFire( user, swep )

		swep.Owner:LagCompensation( true )

		local entity = weapon.projectile( user, swep )

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
								weapon.callBack( attacker, tr, dmginfo, entity )
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

		swep.nextPFire = CurTime() + weapon.getFireRate()

		return false
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON