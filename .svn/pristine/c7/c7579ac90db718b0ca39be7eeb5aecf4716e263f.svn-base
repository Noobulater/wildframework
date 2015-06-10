local class = "medkit"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Medkit")
	item.setDescription("Heals the user for 100 health")
	item.setModel("models/healthvial.mdl")
	item.use = function( user ) if SERVER then sound.Play( "items/smallmedkit1.wav", user:GetPos() + Vector(0,0,30), 75, 100, 1 ) user:SetHealth(100) end end

	return item
end

classItemData.register( class, generate )