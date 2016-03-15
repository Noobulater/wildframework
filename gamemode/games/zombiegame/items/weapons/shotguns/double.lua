local class = "double"

local function generate()
	local weapon = classItemData.genItem("shotgunBase")
	weapon.setClass(class)
	weapon.setName("Double Barrel Shotgun")
	weapon.setDescription("I double-tapped, on accident")
	weapon.setFireSound("weapons/double/double1.wav")	
	weapon.setFireRate( .5 )
	weapon.setDamage(14)
	weapon.setAccuracy(.1)
	weapon.setClipSize(2)
	weapon.setNumBullets(10)
	weapon.setReloadTime(0.5)
	weapon.setAutomatic(false)
	weapon.setHoldType("ar2")
	weapon.setModel("models/weapons/w_shot_double.mdl")
	weapon.setShouldDraw(false)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(0,-1.1,-2.5)
	    tempData.ang = Angle(10.9,354,180)
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

-- EXAMPLE OF A CUSTOM WEAPON
if SERVER then
	classScarcity.addItemToCategory(2, class)
end