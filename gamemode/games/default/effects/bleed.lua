local class = "bleed"

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
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetInflictor( victim )
			victim:TakeDamageInfo(dmginfo)
 
			if IsValid(victim) && victim:Health() > 0 then

				local visual = EffectData()
				visual:SetOrigin( victim:GetPos() + Vector(0,0,40) )
				util.Effect("BloodImpact", visual )

				local pos = util.randRadius( victim:GetPos(), 20, 30)
				util.Decal( "Blood", pos, pos - Vector(0,0,20))
			end
		end
	end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )	end

	if CLIENT then 
		effect.hudPaint = function()
			if effect.getVictim() != LocalPlayer() then return end
			-- Careful, if you don't call this ^ then all players will see this v
			draw.DrawText("You are bleeding", "default" , 20, 40, Color(255,50,50,255) )
		end
	end

	return effect
end

classEffectData.register( class, generate )