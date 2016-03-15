local function shambler( pos, ang )
	local npc = ents.Create("snpc_shambler")
	npc:SetPos(pos or Vector(0,0,0))
	npc:SetAngles( ang or Angle( 0, 0, 0 ) )	

    local ZombieModels = {
        "models/nmr_zombie/berny.mdl",
        "models/nmr_zombie/casual_02.mdl",
        "models/nmr_zombie/herby.mdl",
        "models/nmr_zombie/jogger.mdl",
        "models/nmr_zombie/julie.mdl",
        "models/nmr_zombie/toby.mdl",
    }
   	npc:SetModel(table.Random(ZombieModels))


    if npc:GetModel() == "models/nmr_zombie/julie.mdl" then
        local idleTable = {}
        for i = 1, 11 do 
            table.insert(idleTable, "zombie/femzom_idle".. i .. ".wav")
        end
        npc:setIdleSounds(idleTable)
    else
        local idleTable = {}
        for i = 1, 15 do 
            table.insert(idleTable, "zombie/idle".. i .. ".wav")
        end
        npc:setIdleSounds(idleTable)
    end

	npc:SetHealth(20)
	npc:Spawn()

    hook.Call("NpcSpawned", GAMEMODE, npc)
    
	return npc
end
classAIDirector.addGeneric( "shambler", shambler )