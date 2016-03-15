local class = "glock18"

local function generate()
	local weapon = classItemData.genItem("pistolBase")
	weapon.setClass(class)
	weapon.setName("Glock-18")
	weapon.setDescription("Lots of ammo")
	weapon.setFireSound("weapons/glock/glock18-1.wav")	
	weapon.setFireRate( .07 )
	weapon.setDamage(16)
	weapon.setAccuracy(.03)
	weapon.setClipSize(18)
	weapon.setModel("models/weapons/w_pist_glock18.mdl")

	return weapon
end

classItemData.register( class, generate )

-- if SERVER then
-- 	classScarcity.addItemToCategory(1, class)
-- end
-- EXAMPLE OF A CUSTOM WEAPON
