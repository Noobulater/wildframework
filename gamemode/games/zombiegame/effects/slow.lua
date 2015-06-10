local class = "slow"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration(5)

	effect.applyEffect = function( victim )
		if !victim:IsPlayer() then print("Slow: This effect can't be applied to anything but a player") return end 
		GAMEMODE:SetPlayerSpeed( victim , 100, 150 )
	end

	effect.sustainEffect = function( victim ) end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )
		if !victim:IsPlayer() then return end 
		-- Restores the player to normal status
		if victim:hasEffect("cripple") then return end
		if victim:hasEffect("snare") then return end
		GAMEMODE:SetPlayerSpeed( victim, GAMEMODE.WalkSpeed, GAMEMODE.RunSpeed )
	end

	if CLIENT then 
		local inserted = false
		effect.hudPaint = function()
			if effect.getVictim() == LocalPlayer() && !inserted then 
				paintHookEffect( effect, "Impaired", Color(255,255,255) )
				inserted = true
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )