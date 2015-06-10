local class = "poison"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 5 )
	effect.setThinkSpeed( 1 )
--------------------------------------------- 
--- Some interface for the bleed, makes it a bit easier to manage
---------------------------------------------

	function effect.setDamage( newDamage )
		effect.damage = newDamage
	end

	function effect.getDamage( )
		return effect.damage
	end

	effect.setDamage( 5 ) -- total Damage
	effect.effectNextDamage = 0

---------------------------------------

	effect.applyEffect = function( victim )
		-- COMPILES DAMAGE AND CALCULATES EVENLY APPLIES IT OVER TIME
		local increment = ( effect.getThinkSpeed() / effect.getDuration() ) * effect.getDamage( )
		effect.setDamage( math.Clamp( increment, 1, 100 ) )
	end

	effect.sustainEffect = function( victim ) 
		if SERVER then
			local dmginfo = DamageInfo()
			dmginfo:SetDamage( effect.getDamage() )
			dmginfo:SetDamageType( DMG_POISON )
			dmginfo:SetInflictor( victim )
			victim:TakeDamageInfo(dmginfo)
		end
	end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )	end

	if CLIENT then 
		local inserted = false
		effect.hudPaint = function()
			if effect.getVictim() == LocalPlayer() && !inserted then 
				paintHookEffect( effect, "Toxin", Color(55,255,55) )
				inserted = true
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )