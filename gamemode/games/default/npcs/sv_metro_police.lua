local function metroPolice( pos, ang )
	local npc = classAIDirector.newNpc()
	npc.setPos(pos)
	npc.setAngles( ang or Angle( 0, 0, 0))	
	npc.setClass("npc_metropolice")

	local kv = {additionalequipment = {"weapon_shotgun", "weapon_smg1", "weapon_pistol", "weapon_stunstick"}, manhacks = {min = 0, max = 1}}
	npc.setKeyValues(kv)
	npc.setHealth(20)

	world.data.addEntry(npc)
	npc.createEnt()
	return npc
end
classAIDirector.addGeneric( "metroPolice", metroPolice )