local class = "magnumBase"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Base_Magnum")
	weapon.setDescription("magnum")
	weapon.setFireSound("weapons/deagle/deagle-1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(25)
	weapon.setAccuracy(.04)
	weapon.setClipSize(7)
	weapon.setHoldType("357")
	weapon.setAmmoType("magnumAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_pist_deagle.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON