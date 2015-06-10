local class = "medvial"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Med-Vial")
	item.setDescription("Heals the User to full health. go ahead, Chugg it.")
	item.setModel("models/healthvial.mdl")
	item.setHotBar(true)
	item.use = function( user ) if SERVER then sound.Play("items/smallmedkit1.wav", user:GetPos() + Vector(0,0,50), 75, 100, 1 ) user:SetHealth(100) end end

	return item
end

classItemData.register( class, generate )