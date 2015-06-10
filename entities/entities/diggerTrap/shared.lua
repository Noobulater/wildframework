if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"

if CLIENT then

function ENT:Draw()
	if IsValid(self) then
		self:DrawModel()
	end
end


end