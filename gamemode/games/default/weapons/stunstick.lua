local class = "weapon_stunstick"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Stun-Stick")
	weapon.setCustom(false) -- this is important, it disables all shit that goes with the weapon system
	weapon.setWClass("weapon_stunstick")
	weapon.setModel("models/weapons/w_stunbaton.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A PRE-EXISTING WEAPON, THIS WORKS FOR SWEPS