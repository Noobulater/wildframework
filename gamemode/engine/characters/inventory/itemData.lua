classItemData = {}
classItemData.items = {}

function classItemData.getItems()
	return classItemData.items
end

function classItemData.getTemplate( class )
	if classItemData.items[class] && classItemData.items[class].template then
		return classItemData.items[class].template
	else
		return nil
	end
end

function classItemData.register( class , genFunction )
	classItemData.items[class] = {gen = genFunction, template = genFunction()}
end

function classItemData.genItem( class )
	if classItemData.items[class] && classItemData.items[class].gen then
		return classItemData.items[class].gen()
	else
		return nil
	end
end

function classItemData.new( refOwner )
	
	local public = {}
	local owner = refOwner or nil -- this could be the person Who Crafted it/inially found it w.e
	local name
	local description 
	local reusable
	local model
	local class 
	local material 
	local temporary = false
	local extras = ""
	local hotBar = false
	local physicsOverride

	function public.setOwner( newOwner )
		if !IsValid(newOwner) then print("itemData: not a valid owner") end
		owner = newOwner
	end

	function public.getOwner()
		return owner
	end

	function public.setName( newName )
		name = newName
	end

	function public.getName()
		return name
	end

	function public.setDescription( newDescription )
		description = newDescription
	end

	function public.getDescription()
		return description
	end

	function public.setReusable( newReusable )
		reusable = newReusable
	end

	function public.getReusable()
		return reusable
	end

	function public.setModel( newModel )
		model = newModel 
	end

	function public.getModel( )
		return model
	end

	function public.setClass( newClass )
		class = newClass 
	end

	function public.getClass( )
		return class
	end

	function public.setMaterial( newMaterial )
		material = newMaterial
	end
	function public.getMaterial()
		return material
	end

	function public.setTemporary( newTemporary ) -- temporary weapons don't save
		temporary = newTemporary 
	end

	function public.getTemporary( )
		return temporary
	end

	function public.setExtras( newExtras ) -- These are extra variables (all in one string, you need to manually seperate them) that are saved with the item
		extras = newExtras 
	end

	function public.getExtras( )
		return extras
	end

	function public.setHotBar(newHotBar)
		hotBar = newHotBar
	end

	function public.getHotBar()
		return hotBar
	end

	function public.drop( user )
		-- user is the person who is being affected ( not guarenteed to be the person with it in the inventory )
		-- called Immediately after the Item is removed From the inventory

		if SERVER then
			local entData = classRenderEntry.new()
			entData.setModel( model )

			local pos = user:GetPos()
			if user:IsPlayer() then
				pos = user:GetShootPos()
			end
			entData.setPos( pos + user:GetAngles():Forward() * 30 )
			entData.setSolidDistance(800)
			entData.setStatic(false)
			entData.createHook = function( ent )
				if material != nil then
					ent:SetMaterial(material)
				end
				ent:Spawn()
				ent:Activate()
				ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)

				if physicsOverride then
					local maxs = ent:OBBMaxs()
					local mins = ent:OBBMins()

					ent:PhysicsInitBox(Vector(maxs.z,0,0),Vector(maxs.z,0,0))
				end

				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
				end
				ent.useFunc = function( ply, self )
					if ply:getInventory().addItem( public ) then
						world.data.removeEntry(entData.getUniqueID())
					end
				end
				return false
			end
			entData.createEnt()
			world.data.addEntry(entData)

			return entData
		end
	end

	function public.use( user )
		-- user is the person who is being affected ( not guarenteed to be the person with it in the inventory )
		-- called Immediately after the Item is removed From the inventory
	end
	
	function public.remove( user )
		-- user is the person who is being affected ( not guarenteed to be the person with it in the inventory )
	end

	if CLIENT then
		function public.paintOverHook( panel ) 
			-- This is to be used for drawing over the Icon of the item
		end
	end

	function public.setPhysicsOverride( newPhysicsOverride )
		physicsOverride = newPhysicsOverride
	end

	function public.getPhysicsOverride()
		return physicsOverride
	end

	function public.isItem()
		return true
	end

	function public.isEquipment()
		return false
	end

	function public.isWeapon()
		return false
	end

	function public.isAttachment()
		return false
	end

	return public

end