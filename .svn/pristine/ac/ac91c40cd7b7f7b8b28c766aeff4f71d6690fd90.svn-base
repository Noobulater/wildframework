classEffectData = {}

classEffectData.effects = {}
function classEffectData.register( class , genFunction )
	classEffectData.effects[class] = genFunction
end

function classEffectData.genEffect( class )
	return classEffectData.effects[class]()
end

function classEffectData.new()
	local public = {}
	local class 
	local victim -- this is a ENTITY affected by it. Some NPCS can be affectd
	local thinkSpeed = 0 -- always thinks
	local duration = 0
	local endTime = 0
	local nextThink = 0
	local networkAll = false

	function public.setClass( newClass )
		class = newClass
	end

	function public.getClass()
		return class
	end

	function public.setVictim( newVictim )
		victim = newVictim
	end

	function public.getVictim()
		return victim
	end

	function public.setDuration( newDuration )
		duration = newDuration
	end

	function public.getDuration( )
		return duration
	end

	function public.setThinkSpeed( newThinkSpeed )
		thinkSpeed = newThinkSpeed
	end

	function public.getThinkSpeed( )
		return thinkSpeed
	end	

	function public.setEndTime( newEndTime )
		endTime = newEndTime
	end

	function public.getEndTime( )
		return endTime
	end	

	function public.setNextThink( newNextThink )
		nextThink = newNextThink
	end

	function public.getNextThink( )
		return nextThink
	end	

	if SERVER then
		function public.setNetworkAll( newNetworkAll )
			networkAll = newNetworkAll
		end

		function public.getNetworkAll( )
			return networkAll
		end	
	end

	function public.applyEffect( affectedEntity ) -- Start the effect 

	end

	function public.sustainEffect( affectedEntity ) -- this is basically a think. It is called every think speed  

	end

	-- cleanUp all dammage done by the effect. DONT FORGET ANYTHING HERE, OR YOU WILL SEVERELY MESS WITH YOUR PLAYERS
	function public.endEffect( affectedEntity ) 
		-- The final tick before cleanup
		effect.cleanUp( victim )
	end

	function public.cleanUp( affectedEntity )
		-- this is where you remove all Negatives/Bonuses of the effect
	end

	if CLIENT then

	function public.hudPaint() --HUD PAINT EFFECTS ON CLIENT 

	end

	end

	return public

end