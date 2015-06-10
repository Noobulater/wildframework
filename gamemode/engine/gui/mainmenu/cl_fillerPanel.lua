classFillerPanel = {}

function classFillerPanel.new( parent )
	local public = vgui.Create("DPanel", parent)
	local xPos = 0

	function public.addItem( panel )
		panel:SetParent(public)
		panel:SetPos(xPos, 0)
		xPos = xPos + panel:GetWide()
	end
	
	return public

end