function plySpawn( ply )
	if ply:getData() != nil then
		ply:Save()
	end
end
hook.Add("PlayerSpawn", "defaultLoadout", plySpawn)

function GM:GetFallDamage( ply, speed )
	speed = speed - 580
	local damage = speed * (100/(1024-580))
	if math.random(0,8) * damage >= 80 then 
		ply:applyEffect("cripple")
	end
	return damage
end

local function defaultGun(ply, char)
	char.getInventory().addItem(classItemData.genItem("glock18"))
	char.getInventory().addItem(classItemData.genItem("detonator"))
	char.getInventory().addItem(classItemData.genItem("knife"))
end
hook.Add("CharacterCreated", "defaultGun", defaultGun)

function spillInventory(plyVictim, plyAttacker, dmginfo)
	if util.isActivePlayer(plyVictim) && getGame().getStage() > 1 then
		local inventory = plyVictim:getInventory()

		if !inventory then return end 

		for slot, itemData in pairs(inventory.getItems()) do
			if itemData != 0 then
				if itemData.getTemporary() then
					inventory.dropItem(slot)
				else
					local item = table.Copy(itemData)
					item.setTemporary(true)
					item.drop(plyVictim)
				end
			end
		end
	end
end
hook.Add("DoPlayerDeath", "spillInventory", spillInventory)

function initialSpawnHook(ply)
	-- Set to a random model for now this works.
	timer.Simple(3, function()
		if IsValid(ply) then
			networkGame( getGame().getClass(), ply )
			networkGameStage( getGame().getStage(), ply)
		end
	end)
end
hook.Add("PlayerInitialSpawn", "initialSpawnHook", initialSpawnHook)