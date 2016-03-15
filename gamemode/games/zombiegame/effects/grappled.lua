local class = "grappled"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 3 )
	effect.setThinkSpeed( 1 )
	effect.grappler = nil

	effect.applyEffect = function( victim )
		if !victim:IsPlayer() then print("Grappled: This effect can't be applied to anything but a player") return end 
		GAMEMODE:SetPlayerSpeed( victim , 1, 1 )
		victim:SetJumpPower(1)
	end

	effect.sustainEffect = function( victim ) if IsValid(effect.grappler) then GAMEMODE:SetPlayerSpeed( victim , 1, 1 ) else effect.endEffect() end end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )
		if !victim:IsPlayer() then return end 
		-- Restores the player to normal status
		victim:SetJumpPower(160)

	end

	if CLIENT then 
		local inserted = false
		effect.hudPaint = function()
			if effect.getVictim() == LocalPlayer() && !inserted then 
				paintHookEffect( effect, "Grappled", Color(155,155,155) )
				inserted = true
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )