local class = "proxMine"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Proximity Mine")
	item.setDescription("Will detonate when close to zombies")
	item.setModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	item.setHotBar(true)

	item.use = function( user ) 
				if SERVER then 
					local mine = ents.Create("prop_physics")
					mine:SetModel(item.getModel())
					mine:SetPos(user:GetPos() + Vector(0,0,-12))
					mine:Spawn()
					mine:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

					mine.useFunc = function( ply, self )
						if ply == user && ply:getInventory().addItem( item ) then
							mine:Remove()
						end
					end

					local phys = mine:GetPhysicsObject()
					if IsValid(phys) then
						phys:EnableMotion(false)
					end

					function mine.explode()
						if IsValid(mine) then
							util.BlastDamage(mine, user, mine:GetPos() + Vector(0,0,12), 200, 200)

							local visual = EffectData()
							visual:SetOrigin( mine:GetPos() + Vector(0,0,12) )

							util.Effect("Explosion", visual )
							mine:Remove()
						end
					end

					function mine.checkZombies()
						for key, zombie in pairs(ents.FindByClass("snpc_*")) do
							if zombie:GetPos():Distance(mine:GetPos()) < 100 then
								mine.explode()
							end
						end
						timer.Simple(1, function() if IsValid(mine) then mine.checkZombies() end end)
					end	
					timer.Simple(1, function() if IsValid(mine) then mine.checkZombies() end end)
				end 
			end 

	return item
end

classItemData.register( class, generate )