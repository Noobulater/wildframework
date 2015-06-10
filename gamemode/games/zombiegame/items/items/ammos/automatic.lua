local class = "automaticAmmo"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Automatic Ammo")
	item.setDescription("Generic Autmatic Ammo")
	item.setModel("models/items/boxmrounds.mdl")
	item.setReusable(true)
	item.setExtras( "180" ) -- Default holds 8 rounds
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