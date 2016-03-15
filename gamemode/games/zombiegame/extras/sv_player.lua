function util.getPlayersOrigin(playerTable)
	local max, min

	for key, ply in pairs(playerTable or {}) do
		if max != nil then
			if ply:GetPos().x > max.x then
				max.x = ply:GetPos().x
			end
			if ply:GetPos().y > max.y then
				max.y = ply:GetPos().y
			end
			if ply:GetPos().z > max.z then
				max.z = ply:GetPos().z
			end	
		else
			max = ply:GetPos()
		end
		if min != nil then	
			if ply:GetPos().x < min.x then
				min.x = ply:GetPos().x
			end
			if ply:GetPos().y < min.y then
				min.y = ply:GetPos().y
			end
			if ply:GetPos().z < min.z then
				min.z = ply:GetPos().z
			end			
		else
			min = ply:GetPos()
		end						
	end
	if max != nil && min != nil then

		local xPos = max.x - (max.x - min.x)/2
		local yPos = max.y - (max.y - min.y)/2
		local zPos = max.z - (max.z - min.z)/2

		local returnVect = Vector(xPos,yPos,zPos)

		return returnVect
	else
		return Vector(0,0,0)
	end
end

function util.evaluatePlayer( ply ) -- haven't figured out how to use this yet
	if !ply:Alive() then return 0 end -- obviously if they are dead who gives a shit

	-- 0.25 is physical Health
	-- 0.1 is status conditions ( bleed/slow/crippled )
	-- 0.5 is Weapons/Ammo
	-- 0.15 is for Reserves/support items ( Medkits, Cures, etc ) 
	local score = 0

	score = score + 0.25 * (ply:Health()/100)

	-- these are for negative effects
	-- bleed = 0.15
	-- poison = 0.15
	-- crippled = 0.25
	-- slow = 0.20
	-- snare = 0.25
	score = score + 0.1
	for key, eData in pairs(ply:getEffects()) do
		if eData.getClass() == "bleed" then
			score = score - 0.15 * 0.1
		elseif eData.getClass() == "poison" then
			score = score - 0.15 * 0.1
		elseif eData.getClass() == "crippled" then
			score = score - 0.25 * 0.1
		elseif eData.getClass() == "snare" then
			score = score - 0.25 * 0.1	
		elseif eData.getClass() == "slow" then
			score = score - 0.20 * 0.1							
		end
	end

	local inventory = ply:getInventory()
	local items = inventory.getItems()

	local hasReserve = false

	local weapons = {}

	for slot, itemData in pairs(items) do
		if itemData != 0 then
			if itemData.getClass() == "medvial" or itemData.getClass() == "cure" then
				hasReserve = true
			end
			if itemData.isWeapon() then
				table.insert(weapons, itemData)
			end
		end
	end

	if hasReserve then
		score = score + 0.15
	end

	local wepCount = table.Count(weapons)
	local wepScore = 0
	local differentAmmoTypes = {}
	if wepCount != 0 then
		for _, weaponData in pairs(weapons) do
			if weaponData.getAmmoType() then
				differentAmmoTypes[weaponData.getAmmoType()] = 1
				-- if the player has 3 clips for this weapon it is considered prepared. ( scales with # weapons ) 
				local preparedPool = math.Round(weaponData.getClipSize() * 3 * ( 3/wepCount ))
				local ammoPool = 0 

					if IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() == "weapon_loader" then
						local weapon = ply:GetActiveWeapon():GetWeapon()
						if weapon.getClass() == weaponData.getClass() then
							ammoPool = ammoPool + ply:GetActiveWeapon():Clip1()
						else
							ammoPool = ammoPool + (weaponData.primClip or 0)
						end
					else
						ammoPool = ammoPool + (weaponData.primClip or 0)
					end

				for slot, itemData in pairs(items) do
					if itemData != 0 && itemData.getClass() == weaponData.getAmmoType() then
						ammoPool = ammoPool + tonumber(itemData.getExtras())
					end
				end
				-- print("weapon : " .. weaponData.getName())
				-- print(wepScore)
				wepScore = wepScore + math.Clamp(ammoPool / preparedPool, 0, 1) 
				-- print(wepScore)
			end
		end
	end
	-- print("Scores")
	-- print(wepScore / wepCount)
	-- print(math.Clamp(wepScore / wepCount, 0, 0.5))
	-- print("---")
	score = score + math.Clamp((table.Count(differentAmmoTypes) - 1) * 0.075, 0, 0.3)
	-- print(score)
	score = score + math.Clamp(wepScore / wepCount, 0, 1) * (0.5 - (table.Count(differentAmmoTypes) - 1) * 0.075)
	-- print(score)
	-- print("____")

	local infected = ply:hasEffect("infection")
	if infected then
		infected = (infected.getEndTime() - CurTime())/infected.getDuration()
	else
		infected = 1
	end

	return score * infected
end


local plyPos = {}
function util.antiCampUpdate()
	for key, ply in pairs(util.getAlivePlayers()) do
		if ply:Alive() then
			if plyPos[ply] != nil then
				plyPos[ply].lastPos = plyPos[ply].pos
				plyPos[ply].pos = ply:GetPos()
				if plyPos[ply].lastPos:Distance(plyPos[ply].pos) < 100 then
					plyPos[ply].threshHold = math.Clamp(1 - plyPos[ply].lastPos:Distance(plyPos[ply].pos)/100, 0, 1)
				else
					plyPos[ply].threshHold = 0
				end
			else
				plyPos[ply] = {pos = ply:GetPos()}
			end
		end
	end
end

function util.setCampTable( newTable )
	plyPos = newTable
end

function util.getCampTable()
	return plyPos
end

function util.clearCampTable()
	plyPos = {}
end