local class = "car15"

local function generate()
	local weapon = classItemData.genItem("rifleBase")
	weapon.setClass(class)
	weapon.setName("Car 15")
	weapon.setDescription("Reknown and Durable")
	weapon.setFireSound("weapons/car15/car15-1.wav")	
	weapon.setFireRate( .075 )
	weapon.setAutomatic(true)
	weapon.setDamage(20)
	weapon.setAccuracy(.04)
	weapon.setClipSize(30)
	weapon.setModel("models/weapons/w_rif_car1.mdl")
	weapon.setShouldDraw(false)
	weapon.setPhysicsOverride(true)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(1,-18,0.5)
	    tempData.ang = Angle(180,90,0)
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
	classScarcity.addItemToCategory(4, class)
end