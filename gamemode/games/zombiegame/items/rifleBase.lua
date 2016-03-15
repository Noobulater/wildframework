local class = "rifleBase"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Base_Rifle")
	weapon.setDescription("A Rifle")
	weapon.setFireSound("weapons/m4a1/m4a1_unsil-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(19)
	weapon.setAccuracy(.03)
	weapon.setClipSize(30)
	weapon.setHoldType("ar2")
	weapon.setAmmoType("rifleAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_rif_m4a1.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON