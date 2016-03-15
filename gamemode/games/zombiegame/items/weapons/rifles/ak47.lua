local class = "ak47"

local function generate()
	local weapon = classItemData.genItem("rifleBase")
	weapon.setClass(class)
	weapon.setName("Soviet Ak-47")
	weapon.setDescription("Reknown and Durable")
	weapon.setFireSound("weapons/ak47/ak47-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(22)
	weapon.setAccuracy(.04)
	weapon.setClipSize(30)
	weapon.setModel("models/weapons/w_rif_ak47.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(4, class)
end