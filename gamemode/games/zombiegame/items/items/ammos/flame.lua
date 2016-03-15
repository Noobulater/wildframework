local class = "flameAmmo"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Gas")
	item.setDescription("Used by the flame thrower")
	item.setModel("models/props_junk/gascan001a.mdl")
	item.setReusable(true)
	item.setExtras( "100" ) -- Default holds 8 rounds
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