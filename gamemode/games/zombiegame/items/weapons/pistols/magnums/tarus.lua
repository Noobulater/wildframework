local class = "taurus"

local function generate()
	local weapon = classItemData.genItem("magnumBase")
	weapon.setClass(class)
	weapon.setName("Taurus .44")
	weapon.setDescription("Packs a punch")
	weapon.setFireSound("weapons/tarus/tarus1.wav")	
	weapon.setFireRate( .3 )
	weapon.setDamage(40)
	weapon.setAccuracy(.02)
	weapon.setClipSize(6)
	weapon.setHoldType("pistol")
	weapon.setModel("models/weapons/w_relv_tarus1.mdl")
	weapon.setShouldDraw(false)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(0,0,-1)
	    tempData.ang = Angle(0,0,180)
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

if SERVER then
	classScarcity.addItemToCategory(4, class)
end

-- EXAMPLE OF A CUSTOM WEAPON