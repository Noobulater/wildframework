AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	timer.Simple(3 + self:EntIndex() / 10, function() 

	local class = util.randomItem("itemequipment")

	local item = classItemData.genItem( class )
	item.setTemporary(true)
	
	local entData = classRenderEntry.new()
	entData.setPos( self:GetPos() )
	entData.setAngles( self:GetAngles() )
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
									phys:Wake()
								end
								ent.useFunc = function( ply, self )
									if ply:getInventory().addItem( item ) then
										world.data.removeEntry(entData.getUniqueID())
									end
								end
								return false
							end
	entData.createEnt()
	world.data.addEntry(entData)


	self:Remove()
	end)
end
