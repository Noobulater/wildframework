local class = "minigun"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Minigun")
	weapon.setDescription("'nuff said")
	weapon.setFireSound("weapons/minigun/mini-1.wav")	
	weapon.setFireRate( 0.03 )
	weapon.setDamage(10)
	weapon.setAccuracy(.1)
	weapon.setClipSize(200)
	weapon.setReloadTime(1)
	weapon.setAutomatic(true)
	weapon.setHoldType("crossbow")
	weapon.setAmmoType("minigunAmmo")
	weapon.setModel("models/weapons/w_minigun.mdl")
	weapon.primClip = weapon.getClipSize()
	weapon.setShouldDraw(false)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(1,-24,-8.2)
	    tempData.ang = Angle(0,275,162)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end

	function weapon.deploy( user )
		if IsValid(user) then 
			getPaperdollManager().register(user, class, weapon.paperDoll()) 
		end
	end

	function weapon.holster( user )
		if IsValid(user) then 
			getPaperdollManager().clearTag(user, class)
		end
	end

	local revPercent = 0.0

	function weapon.think( user, swep )
		if user:KeyDown(IN_ATTACK) or user:KeyDown(IN_ATTACK2) then
			revPercent = math.Clamp(revPercent + 0.005, 0, 1)
		else
			revPercent = math.Clamp(revPercent - 0.005, 0, 1)
		end
	end	

	function weapon.primaryFire( user, swep )
		if revPercent > 0.2 then
			swep.Owner:LagCompensation( true )

			local bData = {}
			bData.Num = 1
			bData.Src = swep.Owner:GetShootPos()
			bData.Dir = swep.Owner:GetAimVector()

			bData.Spread = Vector( weapon.getAccuracy(), weapon.getAccuracy(), weapon.getAccuracy())
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

			--swep.Owner:SetAnimation( PLAYER_ATTACK1 )
			swep.Owner:MuzzleFlash() 

			if SERVER then
				sound.Play( weapon.getFireSound(), swep:GetOwner():GetPos() + Vector(0,0,30), 75, 100, 1 )
			end

			swep:SetClip1(math.Clamp(swep:Clip1() - 1, 0, weapon.getClipSize() or 10))

			swep.Owner:FireBullets(bullet)

			swep:setNextPFire(CurTime() + (0.3 - (0.3 - weapon.getFireRate()) * revPercent) )
		end
		return false
	end

	function weapon.secondaryFire( user, swep )
		return false
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(5, class)
end