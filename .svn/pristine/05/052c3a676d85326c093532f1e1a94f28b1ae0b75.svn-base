local PANEL = {}

function PANEL:Init()
	self.fadeTime = CurTime() + 10
	self.text = {} -- we will make it string/color 
	self:SetKeyBoardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:SetText( packedTable )
	local waiting = {}
	for i = 1, table.Count(packedTable) do
		local data = packedTable[i]
		if type(data) == "string" then
			waiting["string"] = data
		elseif type(data) == "table" then
			if waiting != {} then
				table.insert(self.text, waiting)
				waiting = {}
			end			
			waiting["color"] = data
		end
	end
	if waiting != {} then
		table.insert(self.text, waiting)
	end
	table.remove(self.text, 1)
end

function PANEL:PaintOver()

	local xPos, yPos = 5, 10

	local percentAlpha = 1

	if getChatBox() && getChatBox():isHiding() && self.fadeTime < CurTime() then
		percentAlpha = 1 - math.Clamp((CurTime() - self.fadeTime)/5, 0, 1)
	end

	for i = 1, table.Count(self.text) do
		local data = self.text[i]
		if data != nil then
			local wide, tall = getTextSize(data["string"], "wildChatText")

			local color = Color(255, 255, 255, 255  * percentAlpha)

			if data["color"] != nil then
				color = Color(data["color"].r,data["color"].g, data["color"].b, data["color"].a * percentAlpha )
			end

			if xPos + wide > self:GetWide() - 5 then

				local percent = ((xPos + wide) - (self:GetWide() - 5)) / wide
				local length = string.len(data["string"])
				local cutOff = length - math.Round(length * percent)
				local stringPiece = string.sub(data["string"] , 0, cutOff - 1 )

				paintText(stringPiece, "wildChatText", xPos, yPos, color, false, true )

				self:SetTall(20 + 20)
				yPos = yPos + 20
				xPos = 5

				local stringPiece = string.sub(data["string"] , cutOff, length)

				paintText(stringPiece, "wildChatText", xPos, yPos, color, false, true )
			else
				paintText(data["string"], "wildChatText", xPos, yPos, color, false, true )	
				xPos = xPos + wide	
			end		

		end
	end
end

vgui.Register( "chatLine", PANEL, "Panel" )