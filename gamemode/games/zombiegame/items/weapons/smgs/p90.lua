local class = "p90"

local function generate()
	local weapon = classItemData.genItem("smgBase")
	weapon.setClass(class)
	weapon.setName("FN P90")
	weapon.setDescription("A Belguian PERSONAL defense weapon")
	weapon.setFireSound("weapons/p90/p90-1.wav")	
	weapon.setFireRate( .05 )
	weapon.setAutomatic(true)
	weapon.setDamage(10)
	weapon.setAccuracy(.03)
	weapon.setClipSize(50)
	weapon.setModel("models/weapons/w_smg_p90.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(4, class)
end