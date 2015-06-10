local map = "wild_flatground_003"

local treeList = {
	"models/props_foliage/tree_poplar_01.mdl",
	"models/props_foliage/tree_deciduous_01a.mdl",
	"models/props_foliage/tree_deciduous_03a.mdl",
	"models/props_foliage/tree_deciduous_03b.mdl",
}

local function generate()
	for i = 1, 2000 do
		local x = math.randomf(-4000, 4000)
		local y = math.randomf(-4000, 4000)		
		if Vector( 0, 0, 0 ):Distance(Vector( x, y, 0 )) > 500 then
			local ent = classRenderEntry.new()

			ent.setPos(Vector(x, y, 0))
			ent.setAngles(Angle(0, math.randomf(0, 360), 0))
			ent.setModel(table.Random(treeList))

			world.data.addEntry(ent)
		end
	end	

	for i = 1, 300 do
		local x = math.randomf(-4000, 4000)
		local y = math.randomf(-4000, 4000)		
		if Vector( 0, 0, 0 ):Distance(Vector( x, y, 0 )) > 500 then
			local ent = classRenderEntry.new()

			ent.setPos(Vector(x, y, 0))
			ent.setAngles(Angle(0, math.randomf(0, 360), 0))
			ent.setModel("models/props_lab/bigrock.mdl")
			ent.setSolidDistance(500)
			
			world.data.addEntry(ent)
		end
	end	

		local ent = classRenderEntry.new()
		ent.setPos(Vector(0, 0, -4))
		ent.setAngles(Angle(0, 0, 0))
		ent.setModel("models/props/buildings/residential/floors/500x500x8/wood_001.mdl")
		ent.setSolidDistance(800)
		world.data.addEntry(ent)	

		local ent = classRenderEntry.new()
		ent.setPos(Vector(256, 0, 0))
		ent.setAngles(Angle(0, 0, 0))
		ent.setModel("models/props/buildings/residential/walls/128x6x120/brickb_2wlr_001.mdl")
		ent.setSolidDistance(800)
		world.data.addEntry(ent)		

		local ent = classRenderEntry.new()
		ent.setPos(Vector(-256, 0, 0))
		ent.setAngles(Angle(0, 180, 0))
		ent.setModel("models/props/buildings/residential/walls/128x6x120/brickb_dnw_001.mdl")
		ent.setSolidDistance(800)
		world.data.addEntry(ent)	

		local ent = classRenderEntry.new()
		ent.setPos(Vector(0, 256, 0))
		ent.setAngles(Angle(0, 90, 0))
		ent.setSkin(1)
		ent.setModel("models/props/buildings/residential/walls/128x6x120/brickb_001.mdl")
		ent.setSolidDistance(800)
		world.data.addEntry(ent)	
	
		local ent = classRenderEntry.new()
		ent.setPos(Vector(0, -256, 0))
		ent.setAngles(Angle(0, -90, 0))
		ent.setModel("models/props/buildings/residential/walls/128x6x120/brickb_001.mdl")
		ent.setSolidDistance(800)
		world.data.addEntry(ent)	

		local ent = classRenderEntry.new()
		ent.setClass("prop_door_rotating")
		ent.setPos(Vector(-253, -23, 58))
		ent.setModel("models/props_c17/door01_left.mdl")
		ent.setAngles(Angle(0, 0, 0))
		ent.setSolidDistance(800)

		ent.createHook = function( entity )
			entity:SetKeyValue("forceclosed", "1")
			
			entity:Spawn()
			entity:Activate()

			return false
		end
		world.data.addEntry(ent)

		local ent = classRenderEntry.new()
		ent.setPos(Vector(0, 0, 128))
		ent.setAngles(Angle(0, 0, 0))
		ent.setModel("models/props/buildings/residential/ceiling/512x512/wood_flat_8_001.mdl")
		ent.setSolidDistance(800)
		world.data.addEntry(ent)	

		local pos = Vector(0, -200, 24)
		local ammotype = 0

		local crate = classRenderEntry.new()
		crate.setClass("item_ammo_crate")
		crate.setPos(pos)
		crate.setAngles(Angle(0, 90, 0))
		crate.setSolidDistance(800)
		crate.createHook = function()
			local ent = crate.getEnt()
			ent:SetKeyValue("AmmoType", ammotype)
			return true
		end
		world.data.addEntry(crate) 

		local ammotype = 1

		local crate = classRenderEntry.new()
		crate.setClass("item_ammo_crate")
		crate.setPos(pos)
		crate.setAngles(Angle(0, 90, 0))
		crate.setSolidDistance(800)
		crate.createHook = function()
			local ent = crate.getEnt()
			ent:SetKeyValue("AmmoType", ammotype)
			return true
		end
		crate.setPos(pos + Vector(100, 0, 0))
		world.data.addEntry(crate) 

		local ammotype = 2

		local crate = classRenderEntry.new()
		crate.setClass("item_ammo_crate")
		crate.setPos(pos)
		crate.setAngles(Angle(0, 90, 0))
		crate.setSolidDistance(800)
		crate.createHook = function()
			local ent = crate.getEnt()
			ent:SetKeyValue("AmmoType", ammotype)
			return true
		end
		crate.setPos(pos + Vector(-100, 0, 0))
		world.data.addEntry(crate) 

		local ammotype = 5

		local crate = classRenderEntry.new()
		crate.setClass("item_ammo_crate")
		crate.setPos(pos)
		crate.setAngles(Angle(0, 90, 0))
		crate.setSolidDistance(800)
		crate.createHook = function()
			local ent = crate.getEnt()
			ent:SetKeyValue("AmmoType", ammotype)
			return true
		end
		crate.setPos(pos + Vector(200, 0, 0))
		world.data.addEntry(crate) 

		local ammotype = 4

		local crate = classRenderEntry.new()
		crate.setClass("item_ammo_crate")
		crate.setPos(pos)
		crate.setAngles(Angle(0, 90, 0))
		crate.setSolidDistance(800)
		crate.createHook = function()
			local ent = crate.getEnt()
			ent:SetKeyValue("AmmoType", ammotype)
			return true
		end
		crate.setPos(pos + Vector(-200, 0, 0))
		world.data.addEntry(crate) 
end
world.registerMap( map, generate )