local goalClass = "scavenger"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Scavenger")
	goal.setDescription("There was some tech reported in this area, perhaps a look around will prove rewarding")

	if SERVER then

		local winners = {}

		function goal.condition()
			return true
		end

		function goal.initialize()
			goal.setPrizes({})
			local class = classScarcity.rollItem( )

			local item = classItemData.genItem( class )

			timer.Simple(math.random(120,300), function()

				local hidingSpot = util.getRandomHidingSpot()

				local entData = classRenderEntry.new()

				entData.setPos( hidingSpot + Vector(0,0,10) )
				entData.setAngles( Angle(0, math.random(0,360), 0) )
				entData.setModel( item.getModel() )
				entData.setSolidDistance(800)
				entData.setStatic(false)
				entData.createHook = function( ent )
											if item.getMaterial() != nil then
												ent:SetMaterial(item.getMaterial())
											end
											ent:DrawShadow(false)
											ent:Spawn()
											ent:Activate()
											local phys = ent:GetPhysicsObject()
											if IsValid(phys) then
												phys:SetMass(10)
												phys:Wake()
											end
											ent.useFunc = function( ply, self )
												if ply:getInventory().addItem( item ) then
													world.data.removeEntry(entData.getUniqueID())
												end
												if IsValid(ply) then
													goal.addWinner(ply)
												end
											end
											return false
										end
				entData.createEnt()
				world.data.addEntry(entData)
			end)
		end

		function goal.cleanUp()

		end
	end

	return goal
end

classGoal.register( goalClass, generate )