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
		GAMEMODE:SetPlayerSpeed( victim, GAMEMODE.WalkSpeed, GAMEMODE.RunSpeed )
	end

	if CLIENT then 
		effect.hudPaint = function()
			if effect.getVictim() != LocalPlayer() then return end
			-- Careful, if you don't call this ^ then all players will see this v
			draw.DrawText("You are slowed", "default" , 20, 20, Color(255,255,255,255) )
		end
	end

	return effect
end

classEffectData.register( class, generate )