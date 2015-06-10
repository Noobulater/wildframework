local event = classEvent.new()

event.initialize = function( ply )
	local SupplyList = {
		"item_healthvial", "item_ammo_smg1", "item_ammo_smg1", "item_ammo_pistol",
		"item_ammo_pistol", "item_ammo_pistol", "item_ammo_357", "item_ammo_ar2",
		"item_ammo_smg1_grenade", "item_box_buckshot", "item_ammo_ar2_altfire", "weapon_frag",}

	local selection = table.Random(SupplyList)
	local item = classRenderEntry.new()
	item.setClass(selection)

	local distance = math.random(10, 500)
	local angle = math.random(0, 360)
	item.setPos(ply:GetPos() + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 10))
	item.createEnt()
	item.createHook = function(ent) 
		ent:Spawn()
		ent:Activate()
		ent:DrawShadow(false)
		if ent:GetPhysicsObject():IsValid() then
			ent:GetPhysicsObject():Wake()
		end
	end
end
classEvent.add( "loot" , event )