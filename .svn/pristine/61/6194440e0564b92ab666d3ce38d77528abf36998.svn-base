local class = "pistolAmmo"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Pistol Ammo")
	item.setDescription("Generic Pistol Ammo")
	item.setModel("models/items/boxsrounds.mdl")
	item.setReusable(true)
	item.setExtras( "120" ) -- Default holds 8 rounds
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