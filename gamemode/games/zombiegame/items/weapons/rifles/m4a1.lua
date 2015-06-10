local class = "m4a1"

local function generate()
	local weapon = classItemData.genItem("rifleBase")
	weapon.setClass(class)
	weapon.setName("m4a1 Carbine")
	weapon.setDescription("Strong and accurate")
	weapon.setFireSound("weapons/m4a1/m4a1_unsil-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(19)
	weapon.setAccuracy(.03)
	weapon.setClipSize(30)
	weapon.setModel("models/weapons/w_rif_m4a1.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON