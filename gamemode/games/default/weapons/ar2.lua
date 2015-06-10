local class = "weapon_ar2"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Ar2-Pulse Rifle")
	weapon.setCustom(false) -- this is important, it disables all shit that goes with the weapon system
	weapon.setWClass("weapon_ar2")
	weapon.setModel("models/weapons/w_IRifle.mdl")
	
	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A PRE-EXISTING WEAPON, THIS WORKS FOR SWEPS