surface.CreateFont( "zgEffectText", {
 font = "HUDNumber1",
 size = 16,
 weight = 600,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = true
} )

function paintHookEffect(effectData, description, col)
	effectData.description = description
	effectData.col = col
end

local lagTime = 1
local padding = 5

function effectPaint()
	local cleanupKeys = {}

	local xPos, yPos = 10, ScrH() * (1/6)

	for key, effectData in pairs(LocalPlayer():getEffects()) do

		local timeLeft = effectData.getEndTime() - CurTime()

		if effectData.getDuration() == 0 or timeLeft + lagTime > 0 then
			if effectData.description != nil then
				local text = effectData.description or "No Description"
				local col = effectData.col or Color(255,255,255)

				if effectData.getDuration() != 0 then
					text = text .. " : " .. math.Clamp(math.Round(timeLeft*100)/100, 0, 1000)
				end
				
				local textWide, textTall = getTextSize(text, "zgEffectText")

				local width, height = textWide + 20, textTall + 5

				surface.SetDrawColor(0,0,0,155)
				surface.DrawRect( xPos, yPos, width, height )
				surface.DrawOutlinedRect( xPos, yPos, width, height )

				paintText(text, "zgEffectText", xPos + 10, yPos + height/2, col, false, true)

				yPos = yPos + height + padding
			end
		end
	end

end
hook.Add("HUDPaint", "effectPaint", effectPaint)
