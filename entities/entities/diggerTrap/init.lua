include("shared.lua")

function ENT:Initialize() 
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:SetSkin(math.random(0,2))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetNoDraw(true)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	self.ghosts = {}
	self.grappler = nil
	self.endTime = -1
	if self.diggers == nil then
		self.diggers = 1
	end
	if self.active == nil then
		self.active = true
	end
end

function ENT:setActive(newBool)
	self.active = newBool
end

function ENT:getActive()
	return self.active
end

function ENT:setDiggers( newDiggers )
	self.diggers = newDiggers
end

function ENT:getDiggers()
	return self.diggers
end

function ENT:OnTakeDamage( dmginfo )
	if IsValid(self.grappler) then
		if IsValid(self.grappler.enemy) then
	    	hook.Call("FreedFromDigger", GAMEMODE, dmginfo, self.grappler.enemy)				
			self.grappler.enemy:clearEffect("snare")
		end
		self.grappler:Remove()
	    local ragdoll = ents.Create("prop_ragdoll")
	    ragdoll:SetModel("models/Zombie/fast_torso.mdl")
	    ragdoll:SetPos(self:GetPos())
	    ragdoll:SetAngles(self:GetAngles())
	    ragdoll:SetVelocity(self:GetVelocity())
	    ragdoll:Spawn()
	    ragdoll:Activate()
	    ragdoll:SetCollisionGroup(1)
	    ragdoll:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce())

	    timer.Simple(15, function() if IsValid(ragdoll) then ragdoll:Remove() end end)	
	end
end

local function attackEnemy(self, ply)
	if IsValid(self) then
		if IsValid(ply) then
			ply:applyEffect("bleed")
		end
		timer.Simple(5, function() attackEnemy(self, ply) end)
	end
end

function ENT:BeginBustout( plyTrigged )
	if IsValid(plyTrigged) then
		local ghost = ents.Create("prop_dynamic")
		ghost:SetModel("models/Zombie/Fast.mdl")
		ghost:SetAngles(Angle(0,self:GetAngles().y,0))
		ghost:SetPos(self:GetPos() - Vector(0,0,40))
		ghost:Spawn()
		ghost:Fire("SetAnimation", "climbloop", 0)
		ghost.enemy = plyTrigged

		plyTrigged:applyEffect("snare", 0)		

		attackEnemy(ghost, plyTrigged)

		sound.Play("npc/fast_zombie/fz_frenzy1.wav", ghost:GetPos() + Vector(0,0,30), 75, 100, 1 )

		self.grappler = ghost 
	else
		local ghost = ents.Create("prop_dynamic")
		ghost:SetModel("models/Zombie/Fast.mdl")
		ghost:SetPos( self:GetPos() - Vector(0,0,40) )
		ghost:Spawn()
		ghost:Fire("SetAnimation", "climbdismount", 0)
		table.insert(self.ghosts, ghost)
	end

	local distance = 40
	local angle = 0
	local zombies = self.diggers
	for i = 1, zombies do 
		local pos = self:GetPos() + Vector(math.cos(math.rad(angle)) * distance, math.sin(math.rad(angle)) * distance, 0)

		local ghost = ents.Create("prop_dynamic")
		ghost:SetPos( pos )
		ghost:SetModel("models/Zombie/Fast.mdl")
		ghost:SetAngles((self:GetPos() - ghost:GetPos()):Angle())
		ghost:SetPos( ghost:GetPos() - Vector(0,0,40) )
		ghost:Spawn()
		ghost:Fire("SetAnimation", "climbdismount", 0)
		table.insert(self.ghosts, ghost)

		angle = angle + 360/zombies
	end

	self.endTime = CurTime() + 1.6	
end

function ENT:BustoutThink()
	local percent = ((self.endTime - CurTime()) / 1.6)
	if percent < 0.5 then
		for index, ghost in pairs(self.ghosts) do
			if IsValid(ghost) then
				ghost:SetPos(ghost:GetPos() + Vector(0,0,3))
			end
		end
		return
	end
	if percent < 0.75 then
		for index, ghost in pairs(self.ghosts) do
			if IsValid(ghost) then
				ghost:SetPos(ghost:GetPos() + Vector(0,0,8))
			end
		end	
		return
	end
	for index, ghost in pairs(self.ghosts) do
		if IsValid(ghost) then
			ghost:SetPos(ghost:GetPos() + Vector(0,0,1))
		end
	end	
end

function ENT:FinishBustout()
	for index, ghost in pairs(self.ghosts) do
		if IsValid(ghost) then
			local zombie = classAIDirector.spawnGeneric("digger", ghost:GetPos(), ghost:GetAngles() )
			ghost:Remove()
		end
	end
	if !IsValid(self.grappler) then
		self:Remove()
	end
end

function ENT:IsBusting()
	if self.endTime != -1 then 
		if self.endTime >= CurTime() then	
			return true
		end
	end
	return false
end

function ENT:Think()
	if IsValid(self.grappler) then
		if IsValid(self.grappler.enemy) then
			if self.grappler.enemy:GetObserverMode() != OBS_MODE_NONE or !self.grappler.enemy:Alive() then
				self.grappler:Remove()
			end
		else
			self.grappler:Remove()
		end
	end
	if self.endTime == -1 then 
		if !self:getActive() then return end
		for index, ply in pairs(player.GetAll()) do
			if ply:GetObserverMode() == OBS_MODE_NONE && ply:GetPos():Distance(self:GetPos()) < 40 then
				local pos = ply:GetPos() + ply:GetAngles():Forward() * 25 
				self:SetPos(Vector(pos.x,pos.y, ply:GetPos().z))
				self:SetAngles(Angle(0,(ply:GetPos() - self:GetPos()):Angle().y,0))
				ply:SetLocalVelocity(Vector(0,0,0))
				self:BeginBustout( ply )
				return
			end
		end
	else
		if self.endTime < CurTime() then
			self:FinishBustout()
			return
		end
		self:BustoutThink()	
	end
end
