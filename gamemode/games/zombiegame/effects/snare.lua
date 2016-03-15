local class = "snare"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 3 )
	effect.setThinkSpeed( 1 )

	effect.applyEffect = function( victim )
		if !victim:IsPlayer() then print("Snare: This effect can't be applied to anything but a player") return end 
		if SERVER then
			victim:addSpeedModifier(-1000, -1000)
			victim:SetJumpPower(1)
		end
	end

	effect.sustainEffect = function( victim ) GAMEMODE:SetPlayerSpeed( victim , 1, 1 ) end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )
		if !victim:IsPlayer() then return end 
		-- Restores the player to normal status
		if SERVER then
			victim:SetJumpPower(200)
			victim:addSpeedModifier(1000, 1000)
		end
	end

	if CLIENT then 
		local inserted = false
		effect.hudPaint = function()
			if effect.getVictim() == LocalPlayer() && !inserted then 
				paintHookEffect( effect, "Snared", Color(155,155,155) )
				inserted = true
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )