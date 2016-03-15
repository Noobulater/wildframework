if SERVER then

	util.AddNetworkString( "networkScreenShake" )	

	function util.screenShake( duration, ply )
		ply = ply or player.GetAll()
		net.Start( "networkScreenShake" )
			net.WriteFloat( duration )
		net.Send( ply )
	end

	function util.countAliveZombies()
		local count = 0
		for index, ent in pairs(ents.FindByClass("diggerreveal")) do
			count = count + 1
		end
		count = count + table.Count(ents.FindByClass("snpc_*"))
		return count
	end

	local hidingTable

	function util.updateHidingTable()

		local hiding = navmesh.Find( table.Random(ents.FindByClass("info_player_start")):GetPos(), 1000000, 500000, 500000)

		hidingTable = {}

		for _, data in pairs(hiding) do
			if data:GetHidingSpots() then
				for key, vector in pairs(data:GetHidingSpots()) do
					table.insert(hidingTable, vector)
				end
			end
		end
	end

	function util.findHiddenSpot( zombie, hiddenPool )
		local selection = table.Random(hiddenPool)
		if IsValid(zombie) && selection != nil then
			zombie:SetPos( selection )
			for index, ply in pairs(util.getAlivePlayers()) do
				if zombie:Visible(ply) then
			    	table.RemoveByValue(hiddenPool, selection)
			    	return util.findHiddenSpot(entity, hiddenPool)
			    end
			end 
			zombie:SetPos(util.findClearArea(selection))
			return selection
		end
		return false
	end


	function util.getRandomHidingSpot()
		if !hidingTable then util.updateHidingTable() end
		return table.Random(hidingTable)
	end

	function util.getHidingTable()
		if !hidingTable then util.updateHidingTable() end
		return hidingTable
	end

	local function swap( ply, cmd, args )
		local inventory = ply:getInventory()

		if inventory != nil then return end

		local result = inventory.getSlot(-1)

		local wep = user:GetActiveWeapon()
		if !IsValid(wep) or wep:GetClass() != "weapon_loader" then print("Weapon: Player doesn't have weapon loader") return false end

		if wep:GetWeapon() == result then	

		end
	end
	--concommand.Add("swapWeapons", swap)

	function cadeEntityTakeDamage( ent, dmginfo )
		if IsValid(ent) then
			if ent.isCade then
				if !IsValid( dmginfo:GetAttacker() ) then return end
				if dmginfo:GetAttacker():GetClass() == "player" then dmginfo:SetDamage(0) end
				if dmginfo:GetAttacker():GetClass() == "env_explosion" && dmginfo:GetAttacker().Owner:IsPlayer() then dmginfo:SetDamage(0) end
				ent:SetHealth(ent:Health() - dmginfo:GetDamage())
				if ent:Health() <= 0 then
					if ent.breakFunc then
						ent.breakFunc( dmginfo )
					else
						ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						ent.isCade = false
						ent:GetPhysicsObject():EnableMotion(true)
						ent:GetPhysicsObject():Wake()
						if ent:GetPhysicsObject():IsDragEnabled() then
							ent:GetPhysicsObject():SetDragCoefficient(0.2)
						end
						ent:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce())
					end
				end
			end
		end
	end
	hook.Add("EntityTakeDamage", "cadeEntityTakeDamage", cadeEntityTakeDamage)


	function util.areaClear( pos )
		if !util.IsInWorld( pos ) then return false end

		local mins = Vector(-16,-16,0)
		local maxs = Vector(16,16,72)
		local startpos = pos + Vector(0,0,5) -- just get it off the ground for sure ( that way when spawnign on terrain/slopes there are less checks)
		local dir = Vector(0,0,1)
		local len = 70 -- we go up cuz are sure we are on flat ground 
		
		
		local tr = util.TraceHull( {
			start = startpos,
			endpos = startpos + dir * len,
			maxs = maxs,
			mins = mins,
		} )

	   	return !(tr.Hit)
	end

	function util.findClearArea( origin )
		if util.areaClear(origin) then
			return origin
		end
		local pos
		for i = 0, 50 do 
			pos = util.randRadius( origin, 40, 100)		
			if util.areaClear(pos) then
				return pos
			end
		end
		return origin
	end

end