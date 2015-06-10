
include("shared.lua")
AddCSLuaFile("cl_init.lua")

local graveModels = {
	"models/props_c17/gravestone001a.mdl",
	"models/props_c17/gravestone002a.mdl",
	--"models/props_c17/gravestone003a.mdl",-- dont want this cuz it will confuse the players
	"models/props_c17/gravestone004a.mdl",
	"models/props_c17/gravestone_coffinpiece001a.mdl",
	"models/props_c17/gravestone_coffinpiece002a.mdl",
	"models/props_c17/gravestone_cross001a.mdl",
	"models/props_c17/gravestone_cross001b.mdl",
}


function ENT:Initialize() 
	local dropBool = false
	if self:GetModel() == nil or self:GetModel() == "models/error.mdl" then
		self:SetModel(table.Random(graveModels))
		dropBool = true
	end
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end	
	if dropBool then
		local min, max = self:GetCollisionBounds()
		local propHeight = max.z - min.z
		self:SetPos(self:GetPos() + Vector(0,0,propHeight))
		self:DropToFloor()
	end
end

ENT.spawnDelay = 3
function ENT:setSpawnDelay(newDelay) 
	self.spawnDelay = newDelay
end

function ENT:getSpawnDelay() 
	return self.spawnDelay
end

ENT.nextSpawn = 0

function ENT:setNextSpawn( newSpawn ) 
	self.nextSpawn = newSpawn
end

function ENT:getNextSpawn() 
	return self.nextSpawn
end

function ENT:OnTakeDamage( dmginfo )
	if self:Health() <= 0 then return end

    self:SetHealth(self:Health() - dmginfo:GetDamage())
    if self:Health() <= 0 then
        self:Remove()
        hook.Call("GraveDestroyed", GAMEMODE, dmginfo)
    end
end

function areaClear( pos )
	if !util.IsInWorld( pos ) then return false end
	local ent = ents.FindInSphere( pos, 30 )
    for k,v in pairs( ent ) do
   		if v:IsPlayer() or v:IsNPC() then
   			return false
   		end
   	end
   	return true
end

function findClearArea( origin )
	local pos
	for i = 0, 50 do 
		pos = util.randRadius( origin, 40, 100)		
		if areaClear(pos) then
			return pos
		end
	end
	return origin
end

function ENT:spawnZombie()
	local returndPos = findClearArea( self:GetPos() )
	classAIDirector.spawnGeneric("shambler", returndPos )
	timer.Simple(self:getSpawnDelay(), function() if IsValid(self) then self:spawnZombie() end end )
end

