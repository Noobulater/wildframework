local class = "mac10"

local function generate()
	local weapon = classItemData.genItem("smgBase")
	weapon.setClass(class)
	weapon.setName("MAC-10")
	weapon.setDescription("Thug life")
	weapon.setFireSound("weapons/mac10/mac10-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(12)
	weapon.setAccuracy(.03)
	weapon.setClipSize(36)
	weapon.setModel("models/weapons/w_smg_mac10.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(2, class)
end