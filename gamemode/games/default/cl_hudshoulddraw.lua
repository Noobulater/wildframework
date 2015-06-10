function globalShouldDraw( name )
	if (name == "CHudCrosshair") or (name == "CHudDamageIndicator") then
		return false
	end
end
hook.Add("HUDShouldDraw", "globalShouldDraw", globalShouldDraw)