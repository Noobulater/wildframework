local class = "smgBase"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Base_SMG")
	weapon.setDescription("A SMG")
	weapon.setFireSound("weapons/mac10/mac10-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(19)
	weapon.setAccuracy(.03)
	weapon.setClipSize(36)
	weapon.setHoldType("smg")
	weapon.setAmmoType("automaticAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_smg_mac10.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON