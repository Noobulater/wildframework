local class = "fiveseven"

local function generate()
	local weapon = classItemData.genItem("pistolBase")
	weapon.setClass(class)
	weapon.setName("FN Five-Seven")
	weapon.setDescription("Large Clip Size")
	weapon.setFireSound("weapons/fiveseven/fiveseven-1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(20)
	weapon.setAccuracy(.05)
	weapon.setClipSize(20)
	weapon.setModel("models/weapons/w_pist_fiveseven.mdl")

	return weapon
end

classItemData.register( class, generate )

if SERVER then
	classScarcity.addItemToCategory(2, class)
end

-- EXAMPLE OF A CUSTOM WEAPON