local function rebel( pos, ang )
	local npc = classAIDirector.newNpc()
	npc.setPos(pos)
	npc.setAngles( ang or Angle( 0, 0, 0))
	npc.setClass("npc_citizen")

	local kv = {additionalequipment = {"weapon_shotgun", "weapon_smg1", "weapon_ar2",}, citizentype = "3",}
	npc.setKeyValues(kv)
	npc.setHealth(30)

	npc.postCreateHook = function(ent)
		--ent:AddRelationship("player D_HT 999")
	end

	world.data.addEntry(npc)
	npc.createEnt()
	return npc
end
classAIDirector.addGeneric( "rebel", rebel )
