local class = "heavyAmmo"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Heavy Ammo")
	item.setDescription("Generic Heavy Ammo")
	item.setModel("models/items/boxsrounds.mdl")
	item.setReusable(true)
	item.setExtras( "30" ) -- Default holds 8 rounds
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