local class = "scar"

local function generate()
	local weapon = classItemData.genItem("rifleBase")
	weapon.setClass(class)
	weapon.setName("scar")
	weapon.setDescription("Reknown and Durable")
	weapon.setFireSound("weapons/scarh/scar-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(18)
	weapon.setAccuracy(.04)
	weapon.setClipSize(30)
	weapon.setModel("models/weapons/w_rif_scar.mdl")
	weapon.setShouldDraw(false)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(-2,0,-1)
	    tempData.ang = Angle(10,0,180)
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