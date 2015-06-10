include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_c4_planted.mdl")

	-- Physics stuff
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	-- Make prop to fall on spawn
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:EnableMotion(false) end

end

function ENT:explode()
	util.BlastDamage(self, self, self:GetPos(), 100, 400)
	util.ScreenShake( self:GetPos(), 5, 5, 1, 600 )
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)

	-- sound.Play("weapons/explode3.wav", self:GetPos() + Vector(0, 0, 10))
	
	self:Remove()
end

function ENT:Use( activator, caller )
	if activator == self:GetDTEntity(0) then
		if activator:getInventory().addItem(classItemData.genItem("c4")) then
			self:Remove()
		end
	end
end

function ENT:SetupDataTables()
	self:SetDTEntity(0, nil)
end