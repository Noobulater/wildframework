local class = "weapon_smg1"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("SMG")
	weapon.setCustom(false) -- this is important, it disables all shit that goes with the weapon system
	weapon.setWClass("weapon_smg1")
	weapon.setModel("models/weapons/w_smg1.mdl")

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A PRE-EXISTING WEAPON, THIS WORKS FOR SWEPS