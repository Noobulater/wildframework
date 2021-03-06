classRenderEntry = {}
classRenderEntry.totalEntries = {}

function classRenderEntry.new( ) 
	local public = {}

	local uniqueID
	local class
	local model
	local health 
	local ent 		
	local skin = 0 	
	local pos = Vector( 0, 0, 0 )
	local ang = Angle( 0, 0, 0 )
	local static = true	
	local solidDistance 

	if IsValid(entity) then
		model = ent:GetModel() or model
		skin = ent:GetSkin() or skin 
		pos = ent:GetPos() or pos
		ang = ent:GetAngles() or ang
	end

	function public.setClass( newClass )
		class = newClass 
	end
	function public.getClass( )
		return class
	end

	function public.setModel( newModel )
		if newModel == "|" then return false end
		model = newModel 
	end
	function public.getModel( )
		return model
	end

	function public.setSkin( newSkin )
		skin = newSkin
	end
	function public.getSkin()
		return skin
	end
	
	function public.setPos( newPos )
		pos = newPos
	end
	function public.getPos() 
		return pos
	end

	function public.setAngles( newAng )
		ang = newAng
	end
	function public.getAngles()
		return ang
	end

	function public.setHealth( newHealth )
		health = newHealth
	end
	function public.getHealth()
		return health
	end	
 
	function public.setStatic( newStatic )
		static = newStatic
	end
	function public.getStatic()
		return static
	end	

	function public.setSolidDistance( newSolidDistance ) 
		if newSolidDistance == 0 then return false end
		solidDistance = newSolidDistance
	end
	function public.getSolidDistance()
		return solidDistance
	end

	-- this is so you can add additional functionality to creating stuff
	function public.createHook( ent )
		return true -- proceeds with normal spawning
	end
	function public.createEnt( )
		if IsValid(ent) then return false end 

		if SERVER then
			ent = ents.Create( class or "prop_physics" )
		else
			ent = ents.CreateClientProp( )
		end
		ent:SetSkin(skin)
		ent:SetPos(pos)
		ent:SetAngles(ang)

		if model != nil then
			ent:SetModel( model )
		end

		if health != nil then
			ent:SetHealth( health )
		end

		if public.createHook( ent ) then
			ent:Spawn()
			ent:Activate()
			ent:SetRenderMode( RENDERMODE_TRANSALPHA )	
			if SERVER then
				ent:DrawShadow(false)
				if ent:GetPhysicsObject():IsValid() then
					ent:GetPhysicsObject():SetMaterial("concrete_block")
					ent:GetPhysicsObject():EnableMotion(false)
					ent:GetPhysicsObject():SetPos(pos)
				end
			end	
		end

		-- if a solid entity exists, check to see if it still should exist
		if SERVER then
			if IsValid(ent) then
				solidCheck(public)
			end
		end	

	end

	function public.setEnt( newEnt )
		ent = newEnt
	end

	function public.getEnt()
		return ent
	end
	-- this is so you can add additional functionality to creating stuff
	function public.removeHook( ent )
		return true -- proceeds wtih normal removing
	end	
	function public.removeEnt()
		if IsValid(ent) then
			if !static then
				public.setPos(ent:GetPos())
				public.setAngles(ent:GetAngles())
				public.setHealth(ent:Health())
				if SERVER then
					if uniqueID then
						updateNetworkedEntry(public)
					end
				end
			end
			if public.removeHook( ent ) then
				ent:Remove()
			end
		end
	end

	function public.setUniqueID( newUniqueID )
		uniqueID = tonumber(newUniqueID)
	end
	function public.getUniqueID()
		return uniqueID
	end

	return public
end


if classRenderEntry.initialize != nil then
	classRenderEntry.initialize()
end