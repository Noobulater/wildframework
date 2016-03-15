local class = "raging"

local function generate()
	local weapon = classItemData.genItem("magnumBase")
	weapon.setClass(class)
	weapon.setName("raging")
	weapon.setDescription("Packs a punch")
	weapon.setFireSound("weapons/raging/revolver.wav")	
	weapon.setFireRate( .5 )
	weapon.setDamage(50)
	weapon.setAccuracy(.02)
	weapon.setClipSize(6)
	weapon.setHoldType("pistol")
	weapon.setModel("models/weapons/w_relv_raging.mdl")

	return weapon
end

classItemData.register( class, generate )

if SERVER then
	classScarcity.addItemToCategory(3, class)
end

-- EXAMPLE OF A CUSTOM WEAPON