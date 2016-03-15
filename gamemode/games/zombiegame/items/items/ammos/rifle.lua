local class = "rifleAmmo"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Rifle Ammo")
	item.setDescription("Generic Rifle Ammo")
	item.setModel("models/items/boxhrounds.mdl")
	item.setReusable(true)
	item.setExtras( "90" ) -- Default holds 8 rounds
	if CLIENT then
		item.paintOverHook = function( panel )
			local ammoLeft = tostring(item.getExtras()) or 0
			local x, y = panel:GetWide(), panel:GetTall()

			paintText("x" .. ammoLeft, "zgEffectText", 2, y - 10, nil, false, true)
		end
	end
	return item
end

classItemData.register( class, generate )