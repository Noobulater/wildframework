local class = "galil"

local function generate()
	local weapon = classItemData.genItem("rifleBase")
	weapon.setClass(class)
	weapon.setName("IMI Galil")
	weapon.setDescription("Shoots things?")
	weapon.setFireSound("weapons/galil/galil-1.wav")	
	weapon.setFireRate( .07 )
	weapon.setAutomatic(true)
	weapon.setDamage(20)
	weapon.setAccuracy(.035)
	weapon.setClipSize(35)
	weapon.setModel("models/weapons/w_rif_galil.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(4, class)
end