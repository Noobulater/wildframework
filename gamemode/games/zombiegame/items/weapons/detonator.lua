local class = "detonator"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("C4 Detonator")
	weapon.setDescription("Detonates C4 You have Placed")
	weapon.setFireSound("buttons/button14.wav")	
	weapon.setFireRate( 2 )
	weapon.setClipSize(-1)
	weapon.setHoldType("pistol")
	weapon.setModel("models/alyx_emptool_prop.mdl")
	weapon.setPrimaryEQSlot(-3)
	weapon.primClip = -1
	
	weapon.primaryFire = function( user, swep )
		if SERVER then
			sound.Play((weapon.getFireSound() or swep.Primary.Sound), user:GetPos() + Vector(0,0,30), 75, 100, 1 )
			timer.Simple(.5, function() 
								for index, bomb in pairs(ents.FindByClass("c4")) do
									if bomb:GetDTEntity(0) == user then
										bomb:explode()
									end
								end
							end)
			swep:setNextPFire(CurTime() + weapon.getFireRate())
		end
		return false
	end	

	function weapon.paperDoll( )
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(-3.2,-1.1,-3.2)
	    tempData.ang = Angle(270, 0, 0)
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

	return weapon
end

classItemData.register( class, generate )
