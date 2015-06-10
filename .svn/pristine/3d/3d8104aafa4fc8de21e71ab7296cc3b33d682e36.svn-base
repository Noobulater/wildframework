
if SERVER then

function voteSkip( ply )
	ply:SetNWBool("voteSkip", !ply:GetNWBool("voteSkip") )
	if GAMEMODE.CanSkip then
		for index, ply in pairs(player.GetAll()) do
			if !ply:GetNWBool("voteSkip") then
				return
			end
		end
		if getMode() then
			getMode().cleanUp()
			for index, ply in pairs(player.GetAll()) do
				ply:SetNWBool("voteSkip", false) 
			end			
		end
	end
end
hook.Add("ShowSpare2", "voteSkip", voteSkip)

end


if CLIENT then
	
local padding = 10

local gradient = Material("gui/gradient")

function voteSkipPaint()
	if GAMEMODE.CanSkip then
		local cleanupKeys = {}

		local xPos, yPos = 10, ScrH() * (1/6)

		paintText("Skip phase", "zgEffectText", xPos, yPos - 10, nil, false, true)

		for key, ply in pairs(player.GetAll()) do

			local text = ply:Nick()
			local col = Color(255,255,255)
					
			local textWide, textTall = getTextSize(text, "zgEffectText")

			local width, height = textWide + 20, textTall + 5

			surface.SetDrawColor(0,0,0,155)
			if ply:GetNWBool("voteSkip") then
				surface.SetDrawColor(0,255,0,155)
			end
			surface.SetMaterial( gradient )
			surface.DrawTexturedRect( 0, yPos, width + textWide, height )

			paintText(text, "zgEffectText", xPos, yPos + height/2, col, false, true)

			yPos = yPos + height + padding
		end
	end
end
hook.Add("HUDPaint", "voteSkipPaint", voteSkipPaint)

end