function classAIDirector.newNpc()
	local public = classRenderEntry.new()
	public.setStatic(false)
	public.setSolidDistance(1000)
	local material

	-- if difficulty == "Hard" then
	-- 	npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_GOOD)
	-- elseif  CIVRP_DIFFICULTY == "Hell" then
	-- 	npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_VERY_GOOD)
	-- end

	local keyValues = {}
	keyValues["spawnflags"] = 1 + 8192

	function public.setKeyValues( newKeyValues )
		keyValues = newKeyValues
	end
	
	function public.getKeyValues( )
		return keyValues		
	end

	function public.setMaterial( newMaterial )
		material = newMaterial
	end
	function public.getMaterial()
		return material
	end

	function public.postCreateHook( ent )

	end

	function public.createHook( ent )
		local class = public.getClass()
		local health = public.getHealth() or 50

		if material != nil then
			ent:SetMaterial(material)
		end

		if health != nil then
			ent:SetHealth( health )
			if health <= 0 then
				ent:Kill()
			end
		end

		if keyValues != nil then
			for key, value in pairs(keyValues) do
				if istable(value) then
					if value.min && value.max then
						ent:SetKeyValue(key, math.random(value.min, value.max))
					else
						ent:SetKeyValue(key, tostring(table.Random(value)))
					end
				else
					ent:SetKeyValue(key, tostring(value))
				end
			end
		end	

		ent:Spawn()
		ent:Activate()
		ent.EUID = public.getUniqueID()
		ent:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_AVERAGE )
 		public.postCreateHook( ent )
		return false
	end

	function public.removeHook( ent )
		for key, value in pairs(keyValues) do
			keyValues[key] = ent:GetKeyValues()[key]
		end

		public.setHealth(ent:Health())
		return true
	end

	return public

end