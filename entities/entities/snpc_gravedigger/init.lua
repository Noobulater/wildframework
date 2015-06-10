
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include("controls.lua")

function ENT:Initialize()
    if self:GetModel() == nil or self:GetModel() == "models/error.mdl" then
        self:SetModel("models/Zombie/poison.mdl")
    end

    self.Entity:SetCollisionGroup( COLLISION_GROUP_NPC )
    self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming

    self.loco:SetDeathDropHeight(400)   //default 200
    self.loco:SetAcceleration(1000)      //default 400
    self.loco:SetDeceleration(1000)      //default 400
    self.loco:SetStepHeight(18)         //default 18
    self.loco:SetJumpHeight(50)     //default 58

    if !IsValid(self.grave) then
        self.grave = ents.Create("prop_physics")
        self.grave:SetModel("models/props_c17/gravestone003a.mdl")
        self.grave:Spawn()

        local phys = self.grave:GetPhysicsObject()
        if IsValid(phys) then
            phys:SetMass(1000)
        end
    end

end

ENT.stuckPos = Vector(0,0,0)
ENT.times = 0
ENT.nextCheck = 0
local delay = 1
function ENT:BehaveUpdate( fInterval )

    if ( !self.BehaveThread ) then return end
    
    -- If you are not jumping yet and a player is close jump at them
    local modifier = 1
    if self:getRunning() then modifier = 2 end
    if self.nextCheck < CurTime() then
        if self.stuckPos:Distance(self:GetPos()) < 5 then
            self.times = self.times + 1         
            if self.times > 10/modifier then
                if CurTime() - self:getLastAttack() > 5 then
                    self:BecomeRagdoll( DamageInfo() )
                else
                    if self.times > 20/modifier then
                        self:BecomeRagdoll( DamageInfo() )
                    end
                end
            end
        else
            self.stuckPos = self:GetPos()
            self.times = 0
        end  
        self.nextCheck = CurTime() + delay
    end

    local ok, message = coroutine.resume( self.BehaveThread )
    if ( ok == false ) then

        self.BehaveThread = nil
        Msg( self, "error: ", message, "\n" );

    end
end
local nextthink = 0
function ENT:RunBehaviour()

    while ( true ) do
--        Find the player
        if self:CanRelease() then
            self:StartActivity( ACT_WALK )
            self.loco:SetDesiredSpeed( self:getWalkSpeed() )  

            local hiding = self:FindSpots({type = 'hiding', radius = 1000000, stepdown = 500, stepup = 500}) 
            local desiredPos
            if table.Count(hiding) > 0 then
                desiredPos = table.Random(hiding)["vector"]

                local origin = util.getPlayersOrigin(util.getAlivePlayers())
                if origin != nil then
                    for index, data in pairs(hiding) do
                        if data["vector"]:Distance(origin) < desiredPos:Distance(origin) then
                            desiredPos = data["vector"]
                        end
                    end
                end
            else
                desiredPos = table.Random(player.GetAll()):GetPos()
            end
            self:MoveToPos( desiredPos ) -- walk to a random place within about 200 units (yielding)    
            -- if math.random(1,4) == 1 then   
                self:ReleaseGrave()
            -- end  
            self:setWalkSpeed(self:getWalkSpeed() * 2)
        else            
            local target = nil
            for key, ply in pairs(player.GetAll()) do
                if ply:Alive() && (!IsValid(target) or ply:GetPos():Distance( self:GetPos() ) < target:GetPos():Distance(self:GetPos())) then
                    target = ply
                end
            end
            self:SetEnemy( target )
            local enemy = self:GetEnemy()
            -- if the position is valid
            if ( IsValid(enemy) ) then
                self.loco:SetDesiredSpeed( self:getWalkSpeed() )   
                self:StartActivity( ACT_WALK )    
                                                -- run speed    
                local options = {  lookahead = 300,
                                tolerance = 20,
                                draw = false,
                                maxage = 1,
                                repath = 0.1    }
                if !self:CanAttack( self:GetEnemy() ) then
                    self:MoveToEnemy( options )             
                else
                    self:AttackEnemy()
                end 
            else
                self:StartActivity( ACT_WALK )
                self.loco:SetDesiredSpeed( self:getWalkSpeed() )      
                self:MoveToPos( util.randRadius(self:GetPos(), 70, 150) ) -- walk to a random place within about 200 units (yielding)                           
            end
        end
        coroutine.yield()
    end

end

function ENT:OnLandOnGround()
    if self:getRunning() then
        self:StartActivity( ACT_RUN )             
    else
        self:StartActivity( ACT_WALK )    
    end
end

function ENT:Use( activator, caller, type, value )

end

ENT.grave = nil
function ENT:Think()
    if self:Health() >= 0 then
        if IsValid(self.grave) then
            if self.releasing then
                local BoneIndx = self:LookupBone("ValveBiped.Bip01")
                local BonePos , BoneAng = self:GetBonePosition( BoneIndx )

                self.grave:SetPos(BonePos + BoneAng:Right() * -10 + BoneAng:Up() * -10)
                self.grave:SetAngles(BoneAng + Angle(180,90,90))       
            else
                local BoneIndx = self:LookupBone("ValveBiped.Bip01_Spine")
                local BonePos , BoneAng = self:GetBonePosition( BoneIndx )

                self.grave:SetPos(BonePos + BoneAng:Forward() * 10 + BoneAng:Up() * -5)
                self.grave:SetAngles(BoneAng + Angle(120,0,160))
            end
        end
    end
end

function ENT:OnInjured(dmginfo)

end

function ENT:OnKilled( dmginfo )
    classAIDirector.npcDeath( self, dmginfo:GetAttacker(), dmginfo:GetInflictor())
    if dmginfo:IsExplosionDamage() then
        print(self:Health())
        print(dmginfo:GetDamage())
        if dmginfo:GetDamage() > 100 then
            self:Gib(dmginfo)
            return
        end
        dmginfo:SetDamageForce(dmginfo:GetDamageForce() * dmginfo:GetDamage())
    end
    self:BecomeRagdoll( dmginfo ) 
end

function ENT:OnStuck( )

end

function ENT:HandleStuck()

    self.loco:ClearStuck()

end

local gibmods = { 
    {Model = "models/props_junk/watermelon01_chunk02a.mdl", Material = "models/flesh"},
    {Model = "models/props_junk/watermelon01_chunk01a.mdl", Material = "models/flesh"},
    {Model = "models/props/cs_italy/orangegib1.mdl", Material = "models/flesh"},      
    {Model = "models/props/cs_italy/orangegib2.mdl", Material = "models/flesh"},  
    {Model = "models/gibs/hgibs.mdl", Material = "models/flesh"},
    -- {Model = "models/Gibs/HGIBS_rib.mdl", },
    -- {Model = "models/Gibs/HGIBS_scapula.mdl", },
    -- {Model = "models/Gibs/HGIBS_spine.mdl", },
}


function ENT:Gib(dmginfo)  
    local gibs = {}
    for i = 1, math.random(2,6) do
        local data = table.Random(gibmods)
        local gib = ents.Create("prop_physics")
        gib:SetModel(data.Model)
        gib:SetMaterial(data.Material or "")
        gib:SetPos(self:GetPos() + self:GetAngles():Up() * math.random(20,70))
        gib:Spawn()
        gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        gib:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce() * (math.random(1,20)/20))
        
        table.insert(gibs,gib)
    end
    local pos = self:GetPos()

    self:Remove() 

    local visual = EffectData()
    visual:SetOrigin( pos + Vector(0,0,40) )
    util.Effect("BloodImpact", visual )

    util.Decal( "Blood", pos,  pos - Vector(0,0,20)) 

    for i = 1, math.random(1,4) do
        local surroundPos = util.randRadius( pos, 10, 20 )
        util.Decal( "Blood", surroundPos,  surroundPos - Vector(0,0,20)) 

        local visual = EffectData()
        visual:SetOrigin( pos + Vector(0,0,40) )
        util.Effect("BloodImpact", visual )

    end

    timer.Simple(30,function() for _,gib in pairs(gibs) do if gib:IsValid() then gib:Remove() end end end )
end

function ENT:hitBody( hitgroup, dmginfo )

end