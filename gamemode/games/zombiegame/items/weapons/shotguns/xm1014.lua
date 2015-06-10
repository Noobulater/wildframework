local class = "xm1014"

local function generate()
	local weapon = classItemData.genItem("shotgunBase")
	weapon.setClass(class)
	weapon.setName("XM1014 Auto Shotgun")
	weapon.setDescription("I double-tapped, on accident")
	weapon.setFireSound("weapons/xm1014/xm1014-1.wav")	
	weapon.setFireRate( .25 )
	weapon.setDamage(10)
	weapon.setAccuracy(.1)
	weapon.setClipSize(7)
	weapon.setNumBullets(6)
	weapon.setReloadTime(0.5)
	weapon.setAutomatic(true)
	weapon.setHoldType("shotgun")
	weapon.setModel("models/weapons/w_shot_xm1014.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON