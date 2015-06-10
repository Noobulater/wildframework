
if GM.useTopDown then

function hudPaint()
	if vgui.GetWorldPanel().mouseInside then 
		local x,y = gui.MouseX(), gui.MouseY()
		surface.SetDrawColor( 155, 0, 0, 255 )
		surface.DrawRect(x ,y, 2, 2)

		surface.DrawOutlinedRect(x - 4 ,y - 4, 10, 10)
	end
end
hook.Add("HUDPaint", "cursorPaint", hudPaint)
vgui.GetWorldPanel():SetCursor("blank")

end