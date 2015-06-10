local class = "deagle"

local function generate()
	local weapon = classItemData.genItem("magnumBase")
	weapon.setClass(class)
	weapon.setName("Deagle")
	weapon.setDescription("Packs a punch")
	weapon.setFireSound("weapons/deagle/deagle-1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(25)
	weapon.setAccuracy(.04)
	weapon.setClipSize(7)
	weapon.setHoldType("pistol")
	weapon.setModel("models/weapons/w_pist_deagle.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON