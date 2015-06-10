classEffectManager = {}
classEffectManager.currentEffects = {} 

if SERVER then

	util.AddNetworkString( "updateEffectData" )	
	util.AddNetworkString( "clearEffectData" )

	function networkEffectData( effectData, ply )
		ply = ply or player.GetAll()
		net.Start( "updateEffectData" )
			net.WriteString( effectData.getClass() )
			net.WriteEntity( effectData.getVictim() )			
			net.WriteUInt( effectData.getDuration(), 32 )
		net.Send( ply )
	end

	function networkClearEffectData( ply, victim, class )
		ply = ply or player.GetAll()
		net.Start( "clearEffectData" )
			net.WriteEntity( victim )
			net.WriteString( class or "NIL" )
		net.Send( ply )
	end

end

if CLIENT then

	net.Receive( "updateEffectData", function(len)   
		local class = net.ReadString()
		local victim = net.ReadEntity()
		local duration = net.ReadUInt(32)
 		local effectData = victim:applyEffect( class, duration )
	end)	

	net.Receive( "clearEffectData", function(len)
		local victim = net.ReadEntity() 
		local class = net.ReadString()
		if victim:IsWorld() then
			victim = LocalPlayer()
		end

		if class == "NIL" then  
			victim:clearEffects()
		else
			victim:clearEffect( class )
		end
	end)	

end

function classEffectManager.add( effectData ) 
	if effectData == nil or !IsValid(effectData.getVictim()) then return false end

	if effectData.getDuration() != 0 then
		effectData.setEndTime( CurTime() + effectData.getDuration() )
	end
	effectData.applyEffect( effectData.getVictim() )

	if SERVER then
		networkEffectData(effectData)
	end

	table.insert(classEffectManager.currentEffects, effectData)

	return true
end

function classEffectManager.getEffects( effectData ) 
	return classEffectManager.currentEffects
end

function classEffectManager.think()
	local cleanUpEvents = {}

	local victim
	local endTime 
	local nextThink 
	for key, effectData in pairs( classEffectManager.currentEffects ) do
		victim = effectData.getVictim()
		if IsValid( victim ) then
			nextThink = effectData.getNextThink()
			if nextThink < CurTime() then
				endTime = effectData.getEndTime()
				if endTime < CurTime() && effectData.getDuration() != 0 then
					effectData.endEffect( victim )
					table.insert(cleanUpEvents, key)
				else
					effectData.sustainEffect( victim )
					effectData.setNextThink( CurTime() + effectData.getThinkSpeed() )
				end
			end
		else
			table.insert(cleanUpEvents, key)
		end
	end

	for id, key in pairs( cleanUpEvents ) do
		table.remove(classEffectManager.currentEffects, key)
	end
end
hook.Add("Think", "effectManagerThink", classEffectManager.think )


if CLIENT then

function classEffectManager.hudPaint()
	for key, effectData in pairs( classEffectManager.currentEffects ) do
		effectData.hudPaint()
	end
end
hook.Add("HUDPaint", "effectManagerHudPaint", classEffectManager.hudPaint )	

end