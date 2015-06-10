classAIDirector = {}

classAIDirector.generics = {}
function classAIDirector.addGeneric(key, func)
	classAIDirector.generics[key] = func
end

function classAIDirector.spawnGeneric( key, pos, ang )
	if classAIDirector.generics[key] != nil then
		return classAIDirector.generics[key]( pos, ang )
	else	
		print( "Attempted to Spawn : " .. key )
	end
end

function classAIDirector.npcDeath(npc, killer, weapon, dmginfo)
	local uniqueID = npc.EUID
	if uniqueID != nil then
		if world.data.getEntry(uniqueID).getClass() == npc:GetClass() then
			world.data.removeEntry(uniqueID)
		end
	end
	hook.Call("NpcDeath", GAMEMODE, npc, killer, weapon, dmginfo)	
end

