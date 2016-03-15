local class = "mp7"

local function generate()
	local weapon = classItemData.genItem("smgBase")
	weapon.setClass(class)
	weapon.setName("H&K MP5")
	weapon.setDescription("Thug life")
	weapon.setFireSound("weapons/mp7/mp7.wav")	
	weapon.setFireRate( .06 )
	weapon.setAutomatic(true)
	weapon.setDamage(15)
	weapon.setAccuracy(.04)
	weapon.setClipSize(20)
	weapon.setModel("models/weapons/w_smg_mp7.mdl")
	weapon.setShouldDraw(false)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(4,2,-1)
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
	classScarcity.addItemToCategory(3, class)
end