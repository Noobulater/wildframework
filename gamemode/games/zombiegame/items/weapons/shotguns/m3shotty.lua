local class = "m3shotty"

local function generate()
	local weapon = classItemData.genItem("shotgunBase")
	weapon.setClass(class)
	weapon.setName("M3 Super 90")
	weapon.setDescription("Hey, I can see through you!")
	weapon.setFireSound("weapons/m3/m3-1.wav")	
	weapon.setFireRate( .25 )
	weapon.setDamage(10)
	weapon.setAccuracy(.1)
	weapon.setClipSize(4)
	weapon.setNumBullets(12)
	weapon.setReloadTime(0.5)
	weapon.setAutomatic(true)
	weapon.setHoldType("shotgun")
	weapon.setModel("models/weapons/w_shot_m3super90.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON