local class = "infection"

local function generate()
	local effect = classEffectData.new()
	effect.setClass(class)
	effect.setDuration( 120 )
	effect.setThinkSpeed( 1 )

	if SERVER then
		effect.setNetworkAll( true )
	end

	effect.applyEffect = function( victim )	end
	effect.sustainEffect = function( victim )  end
	effect.endEffect = function( victim ) if SERVER then if victim:IsPlayer() then victim:Kill() end end effect.cleanUp( victim ) end

	effect.cleanUp = function( victim )
		if !victim:IsPlayer() then return end 
	end

	if CLIENT then 
		effect.hudPaint = function()
			if IsValid(effect.getVictim()) then
				if effect.getVictim() == LocalPlayer() && effect.getVictim():Alive() then 

					local xPos = 128
					local yPos = ScrH() - 30

					local barWidth, barHeight = ScrW() - xPos, 30

					surface.SetDrawColor(0,0,0,155)
					surface.DrawRect(xPos, yPos, barWidth, barHeight)
					surface.DrawOutlinedRect(xPos, yPos, barWidth, barHeight)

					local percentInfected = 1-(effect.getEndTime() - CurTime()) / effect.getDuration()

					local barWidth = (ScrW() - xPos) * percentInfected
					surface.SetDrawColor(0,155,55,155)
					surface.DrawRect(xPos, yPos, barWidth, barHeight)

					surface.SetDrawColor(0,0,0,55)
					surface.DrawOutlinedRect(xPos, yPos, barWidth, barHeight)

					local textWide, textTall = getTextSize("Infected", "zgEffectText")
					paintText("Infected", "zgEffectText", xPos + 10, yPos + barHeight/2, col, false, true)

					percentInfected = math.Round(percentInfected*100)
					if percentInfected > 10 then
						percentInfected = "% " .. percentInfected
						local textWide, textTall = getTextSize(percentInfected, "zgEffectText")
						paintText(percentInfected, "zgEffectText", xPos + barWidth - textWide, yPos + barHeight/2, col, true, true)
					end
				else
					if effect.getVictim():IsPlayer() && effect.getVictim():Alive() then 
						local entity = effect.getVictim()
						local distance = entity:GetPos():Distance(LocalPlayer():GetPos())
						alpha = math.Clamp(60 * (1-(distance/300)),0,60)


						local barWidth, barHeight = 32, 10
						local xPos, yPos = entity:GetPos():ToScreen()["x"] - barWidth/2, entity:GetPos():ToScreen()["y"] + 50

						surface.SetDrawColor(0,0,0,alpha)
						surface.DrawRect(xPos, yPos, barWidth, barHeight)
						surface.DrawOutlinedRect(xPos, yPos, barWidth, barHeight)

						local percentInfected = 1 - ((effect.getEndTime() - CurTime()) / effect.getDuration())

						local barWidth = barWidth * percentInfected

						surface.SetDrawColor(0,155,55,alpha)
						surface.DrawRect(xPos, yPos, barWidth, barHeight)

						surface.SetDrawColor(0,0,0,alpha)
						surface.DrawOutlinedRect(xPos, yPos, barWidth, barHeight)
					end
				end
			end
		end
	end

	return effect
end

classEffectData.register( class, generate )