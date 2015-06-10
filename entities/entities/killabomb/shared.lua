if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.damage = 10 
ENT.broken = false
function ENT:Initialize() 
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:SetSkin(math.random(0,2))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
end

function ENT:setBroken( newBroken )
	self.broken = newBroken
end

function ENT:getBroken()
	return self.broken
end

function ENT:setDamage( newDamage )
	self.damage = newDamage
end

function ENT:getDamage()
	return self.damage
end
ENT.lastEffect = 0
function ENT:PhysicsCollide( collideData , physObj )
	if self:getBroken() then return false end

	local otherEnt = collideData.HitEntity

	if IsValid(otherEnt) && otherEnt:IsNPC() then
		otherEnt:TakeDamage(self.damage, self:GetOwner())
		sound.Play("physics/surfaces/underwater_impact_bullet1.wav", self:GetPos(), 75, 100, 1 )
		self:setBroken(true)
	end

	if self.lastEffect < CurTime() then
		local visual = EffectData()
		visual:SetOrigin( collideData.HitPos )

		local h = math.random(0,255)
		local r, g, b = math.random(0,55), math.random(0,55), math.random(0,55)
		visual:SetColor(h - r, h - g, h - b, 155 )

		util.Effect("gunshotsplash", visual )	

		self.lastEffect = CurTime() + 0.5
	end
end

function ENT:Draw()
	if IsValid(self) then
		self:DrawModel()
	end
end