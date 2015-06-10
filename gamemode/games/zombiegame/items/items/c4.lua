local class = "c4"

local function generate()
	local item = classWeaponData.new()
	item.setClass(class)
	item.setWClass("weapon_c4")
	item.setCustom(false)
	item.setName("C4 Plastic Explosive")
	item.setDescription("Requires a Detonator to use")
	item.setModel("models/weapons/w_c4_planted.mdl")
	item.setPrimaryEQSlot(-3)
	return item
end

classItemData.register( class, generate )