classSettlement = {}

function classSettlement.new( settlementKey )
	public = {}

	local key = settlementKey
	-- tier is the level the current settlement has progressed too
	local tier = 1
	 -- needs to be and entity, the central part of the system
	local core = nil
	local origin = Vector(0,0,0)
	local objects = {}

	function public.getKey()
		return key
	end

	function public.setTier( newTier )
		tier = newTier
	end

	function public.getTier()
		return tier
	end

	function public.setCore( newCore )
		if IsValid(newCore) && newCore:Health() > 0 then
			core = newCore
		end
	end

	function public.getCore( newCore )
		if IsValid(newCore) && newCore:Health() > 0 then
			core = newCore
		end
	end

	function public.setOrigin( newOrigin )
		origin = newOrigin
	end

	function public.getOrigin()
		return origin
	end
	
	function public.addObject( newObject )
		table.insert(objects, newObject)
	end
	
	function public.getObjects()
		return objects
	end

	function public.tech()
		if classSettlement[key] != nil && classSettlement[key].tiers[tier] != nil then
			classSettlement[key].tiers[tier]( public )
			tier = tier + 1
		end
	end

	return public

end

