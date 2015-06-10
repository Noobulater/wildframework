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
end
hook.Add("CharacterCreated", "defaultGun", defaultGun)