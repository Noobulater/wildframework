local META = FindMetaTable("Entity")

function META:IsNPC()
	if IsValid(self) && string.find( tostring(self:GetClass()), "npc" ) then
		return true
	end
	return false
end
