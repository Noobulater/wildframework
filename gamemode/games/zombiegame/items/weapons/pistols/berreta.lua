local class = "berreta"

local function generate()
	local weapon = classItemData.genItem("pistolBase")
	weapon.setClass(class)
	weapon.setName("FN Five-Seven")
	weapon.setDescription("Pow pow its a gun")
	weapon.setFireSound("weapons/elite/elite-1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(21)
	weapon.setAccuracy(.06)
	weapon.setClipSize(15)
	weapon.setModel("models/weapons/w_pist_elite_single.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON