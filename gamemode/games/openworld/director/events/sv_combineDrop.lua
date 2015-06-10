local event = classEvent.new()

event.initialize = function( ply )
		dropPart = ents.Create("prop_dynamic")
		dropPart:SetModel( "models/combine_dropship_container.mdl" )  
	 	dropPart:SetPos(Vector(0,0,463))
	 	dropPart:Spawn()
		dropPart:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		dropPart:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		dropPart:SetSolid( SOLID_VPHYSICS )

	    local phys = dropPart:GetPhysicsObject()
		if (phys:IsValid()) then
			--phys:EnableMotion(false)
			phys:Wake()
		end

		dropShip = ents.Create("prop_dynamic")
		dropShip:SetModel( "models/combine_dropship.mdl" )  
		dropShip:SetPos(dropPart:GetPos() + Vector(0,0,-30))
	 	dropShip:Spawn()
		dropShip:Fire("SetAnimation", "cargo_hover", 0) 		
		dropShip:SetParent(dropPart)

		timer.Simple(5, function() dropPart:Remove() end)

		local attachment = dropPart:LookupAttachment("Deploy_Start")
		local pos = dropPart:GetAttachment( attachment )["Pos"]
		local ang = dropPart:GetAttachment( attachment )["Ang"]

		-- All the commented stuff was for a parented Way of deploying, its possible but not very useful. 
		-- Such as combine deploying from da sky

		local endAttachment = dropPart:LookupAttachment("deploy_landpoint")
		local endPos = dropPart:GetAttachment( attachment )["Pos"]
		local endAng = dropPart:GetAttachment( attachment )["Ang"]

		print(tostring(endPos))

		local npc = ents.Create("npc_combine_s")
		local name = npc:GetClass() .. "_" .. npc:EntIndex()
		npc:SetPos(pos)
		npc:SetAngles(ang)
		npc:SetKeyValue("targetname", name)
		npc:Spawn()
		npc:SetParent(dropPart)

		local scriptedSeq = ents.Create("scripted_sequence")
		local sequenceName = name .. "_seq"
		scriptedSeq:SetKeyValue("m_iszEntity", name)
		scriptedSeq:SetKeyValue("m_iszPlay", "Dropship_Deploy")
		scriptedSeq:SetKeyValue("targetname", sequenceName)
		scriptedSeq:SetKeyValue("OnEndSequence", name .. ",ClearParent")
	 	scriptedSeq:Spawn()
	 	scriptedSeq:Fire("BeginSequence", "", 0)
		dropPart:Fire("SetAnimation", "open", 0) 
end
classEvent.add( "combineDrop" , event )