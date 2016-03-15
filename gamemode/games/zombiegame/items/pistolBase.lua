local class = "pistolBase"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Base_Pistol")
	weapon.setDescription("A Pistol")
	weapon.setFireSound("weapons/p220/p228-1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(19)
	weapon.setAccuracy(.04)
	weapon.setClipSize(9)
	weapon.setHoldType("pistol")
	weapon.setAmmoType("pistolAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_pist_p228.mdl")
	weapon.setDualWield(true)

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON