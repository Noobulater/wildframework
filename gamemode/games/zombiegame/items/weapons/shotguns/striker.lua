local class = "striker"

local function generate()
	local weapon = classItemData.genItem("shotgunBase")
	weapon.setClass(class)
	weapon.setName("Striker Shotgun")
	weapon.setDescription("I double-tapped, on accident")
	weapon.setFireSound("weapons/striker/m3-2.wav")	
	weapon.setFireRate( .2 )
	weapon.setDamage(16)
	weapon.setAccuracy(.1)
	weapon.setClipSize(12)
	weapon.setNumBullets(5)
	weapon.setReloadTime(0.5)
	weapon.setAutomatic(false)
	weapon.setHoldType("shotgun")
	weapon.setModel("models/weapons/w_shot_strike.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON
if SERVER then
	classScarcity.addItemToCategory(4, class)
end