local class = "cripple"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 0 )
	effect.setThinkSpeed( 5 )

	effect.applyEffect = function( victim )
		if victim:IsNPC() then if SERVER then victim:setRunning(0) end return end
		if !victim:IsPlayer() then print("Cripple: This effect can't be applied to anything but a player") return end
		if SERVER then
			victim:addSpeedModifier(-80, -150)
		end
	end

	effect.sustainEffect = function( victim ) end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )
		if !victim:IsPlayer() then return end 
		-- Restores the player to normal status
		if SERVER then
			victim:addSpeedModifier(80, 150)
		end
	end

	if CLIENT then 
		local inserted = false
		effect.hudPaint = function()
			if effect.getVictim() == LocalPlayer() && !inserted then 
				paintHookEffect( effect, "Crippled", Color(255,255,0) )
				inserted = true
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )