local class = "p228"

local function generate()
	local weapon = classItemData.genItem("pistolBase")
	weapon.setClass(class)
	weapon.setName("SIG Sauer P220")
	weapon.setDescription("A German Weapon")
	weapon.setFireSound("weapons/p228/p228-1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(19)
	weapon.setAccuracy(.04)
	weapon.setClipSize(9)
	weapon.setModel("models/weapons/w_pist_p228.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON