local class = "snare"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 3 )
	effect.setThinkSpeed( 1 )

	effect.applyEffect = function( victim )
		if !victim:IsPlayer() then print("Snare: This effect can't be applied to anything but a player") return end 
		GAMEMODE:SetPlayerSpeed( victim , 1, 1 )
		victim:SetJumpPower(1)
	end

	effect.sustainEffect = function( victim ) GAMEMODE:SetPlayerSpeed( victim , 1, 1 ) end
	effect.endEffect = function( victim ) effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )
		if !victim:IsPlayer() then return end 
		-- Restores the player to normal status
		victim:SetJumpPower(200)
		if victim:hasEffect("slow") then return end
		if victim:hasEffect("cripple") then return end
		if victim:hasEffect("grappled") then return end
		GAMEMODE:SetPlayerSpeed( victim, GAMEMODE.WalkSpeed, GAMEMODE.RunSpeed )
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