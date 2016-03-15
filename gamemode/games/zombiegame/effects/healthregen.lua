local class = "healthregen"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 5 )
	effect.setThinkSpeed( 1 )
--------------------------------------------- 
--- Some interface for the bleed, makes it a bit easier to manage
---------------------------------------------

	function effect.setHealing( newHealing )
		effect.healing = newHealing
	end

	function effect.getHealing( )
		return effect.healing
	end

	effect.setHealing( 50 ) -- total Healing

---------------------------------------

	effect.applyEffect = function( victim )
		-- COMPILES Healing AND CALCULATES EVENLY APPLIES IT OVER TIME
		local increment = ( effect.getThinkSpeed() / effect.getDuration() ) * effect.getHealing( )
		effect.setHealing( math.Clamp( increment, 1, 100 ) )
	end

	effect.sustainEffect = function( victim ) 
		if SERVER then		
			victim:SetHealth( victim:Health() + effect.getHealing() )
			print(victim:Health())
		end
	end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )	end

	if CLIENT then 
		effect.hudPaint = function()
			if effect.getVictim() == LocalPlayer() && !inserted then 
				local text, drawColor, texture = util.evaluateHealth( LocalPlayer() )
				drawColor.a = 255
				paintHookEffect( effect, "Healing", drawColor )
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )