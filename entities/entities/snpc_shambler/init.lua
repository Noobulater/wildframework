
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include("controls.lua")

function ENT:Initialize()
    if self:GetModel() == nil or self:GetModel() == "models/error.mdl" then
        self:SetModel("models/nmr_zombie/berny.mdl")
    end

    self.Entity:SetCollisionGroup( COLLISION_GROUP_NPC )
    self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming

    self.loco:SetDeathDropHeight(200)   //default 200
    self.loco:SetAcceleration(400)      //default 400
    self.loco:SetDeceleration(400)      //default 400
    self.loco:SetStepHeight(18)         //default 18
    self.loco:SetJumpHeight(50)     //default 58
        
end

ENT.stuckPos = Vector(0,0,0)
ENT.times = 0
ENT.nextCheck = 0
local delay = 1
function ENT:BehaveUpdate( fInterval )

    if ( !self.BehaveThread ) then return end
    
    -- -- If you are not jumping yet and a player is close jump at them
    -- local ent = ents.FindInSphere( self:GetPos(), 30 )
    -- for k,v in pairs( ent ) do
    --     if v:IsPlayer() then
    --         self:SetSequence( "attackC" )  
    --     end
    -- end
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

function ENT:RunBehaviour()

    while ( true ) do
        -- Find the player

        local enemy = self:findEnemy()
        -- if the position is valid
        if ( IsValid(enemy) ) then
            if self:getRunning() then
                self.loco:SetDesiredSpeed( self:getRunSpeed() )   
                self:StartActivity( ACT_RUN )             
            else
                self.loco:SetDesiredSpeed( self:getWalkSpeed() )   
                self:StartActivity( ACT_WALK )    
            end
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

function ENT:Think()

end

function ENT:OnInjured(dmginfo)

end

function ENT:OnKilled( dmginfo )
    classAIDirector.npcDeath( self, dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo)
    if dmginfo:IsExplosionDamage() then
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

-- function ENT:OnTakeDamage(dmg)
--     self:SetHealth(self:Health() - dmg:GetDamage())
--     if self:Health() <= 0 then
--         self:Perish(dmg)
--     end
-- end 

-- function ENT:Perish(dmg)
--     if self:Health() < -35 && dmg:IsExplosionDamage() then
--         self:Explode(dmg)
--     else
--         self:Ragdoll(dmg)
--     end
--     classAIDirector.npcDeath(self, dmg:GetAttacker(), dmg:GetInflictor())
--     self:Remove()
-- end

-- -- ONLY NEED THIS FOR A BODY
-- function ENT:Ragdoll(dmgforce)
--     local ragdoll = ents.Create("prop_ragdoll")
--     ragdoll:SetModel(self:GetModel())
--     ragdoll:SetPos(self:GetPos())
--     ragdoll:SetAngles(self:GetAngles())
--     ragdoll:SetVelocity(self:GetVelocity())
--     ragdoll:Spawn()
--     ragdoll:Activate()
--     ragdoll:SetCollisionGroup(1)
--     ragdoll:GetPhysicsObject():ApplyForceCenter(dmgforce:GetDamageForce())

--     local function FadeOut(ragdoll)
--         --Polkm: This will work better then the old one
--         local Steps = 30
--         local TimePerStep = 0.05
--         local CurentAlpha = 255
--         for i = 1, Steps do
--             timer.Simple(i * TimePerStep, function()
--                 if ragdoll:IsValid() then
--                     CurentAlpha = CurentAlpha - (255 / Steps)
--                     ragdoll:SetColor(255, 255, 255, CurentAlpha)
--                 end
--             end)
--         end
--         timer.Simple(Steps * TimePerStep, function() if ragdoll:IsValid() then ragdoll:Remove() end end)
--     end
--     timer.Simple(15, function() if ragdoll:IsValid() then FadeOut(ragdoll) end end)
-- end

-- local delay = 0
-- function ENT:Think()

-- end

-- function ENT:SelectSchedule( INPCState )

-- end
