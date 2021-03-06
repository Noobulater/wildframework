classSettlement["combine01"] = {}
classSettlement["combine01"].Condition = function(ply) 
	return false
end

classSettlement["combine01"].tiers = {}
-- stage one.
classSettlement["combine01"].tiers[1] = function( settlement ) 

	local thumper = classRenderEntry.new()
	thumper.setClass("prop_thumper")
	thumper.setPos(settlement.getOrigin())
	thumper.setAngles(Angle(0,math.random(0,360),0))
	thumper.setSolidDistance(1000)
	world.data.addEntry(thumper) 
	thumper.createEnt()
	timer.Simple(solidCheckTime, function() solidCheck(thumper) end )

	-- This lets me track everything created by the settlement
	settlement.addObject(thumper)


	local pos = thumper.getPos() + thumper.getAngles():Right() * 120 + thumper.getAngles():Up() * 15
	local ammotype = table.Random({0, 1, 2, 3, 4, 5, 8})

	local crate = classRenderEntry.new()
	crate.setClass("item_ammo_crate")
	crate.setPos(pos)
	crate.setAngles(Angle(0, thumper.getAngles().y - 90, 0))
	crate.createHook = function()
		local ent = crate.getEnt()
		ent:SetKeyValue("AmmoType", ammotype)
		return true
	end
	world.data.addEntry(crate) 
	crate.createEnt()

	-- This lets me track everything created by the settlement
	settlement.addObject(crate)


	-- local SupplyList = {"item_healthvial","item_ammo_smg1","item_ammo_ar2","item_ammo_smg1_grenade","item_ammo_ar2_altfire", "weapon_frag",}
	-- local number = math.random(2,3)
	-- for i = 1, number do
	-- 	local item = ents.Create(table.Random(SupplyList))

	-- 	item:SetAngles(crate.getAngles())
	-- 	local width = Vector(item:OBBMaxs().x,item:OBBMaxs().y,0) - Vector(item:OBBMins().x,item:OBBMins().y,0)
	-- 	item:SetPos(crate:GetPos() + crate:GetAngles():Up()  * 30 + crate:GetAngles():Up()  * 20 * i + crate:GetAngles():Right() * -10 * i + crate:GetAngles():Right() * 20 + width + crate:GetAngles():Forward() * -10 )
	-- 	item:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	-- 	item:Spawn()
	-- 	item:DropToFloor()
	-- 	settlement.addObject(item)
	-- end
end
classSettlement["combine01"].tiers[2] = function( settlement )
	local numCades = math.random(4, 14)
	local angle = 0
	for i = 1, numCades do
		local distance = math.random(250, 350)

		local origin = settlement.getOrigin()

		local cade = ents.Create("prop_physics")
		cade:SetPos(origin + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0))
		cade:SetAngles((cade:GetPos() - origin):Angle())
		cade:SetPos(cade:GetPos() + Vector(0,0,30))
		cade:SetModel("models/props_combine/combine_barricade_short01a.mdl")
		cade:Spawn()
		cade:DropToFloor()

		settlement.addObject(cade) 

		angle = angle + (360 / numCades) 
	end
end
