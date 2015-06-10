function GM:OnNPCKilled(npc, killer, weapon)
	classAIDirector.npcDeath(npc, killer, weapon)
end

local NPC = FindMetaTable("NPC")

function NPC:TakeDamageInfo(dmginfo)
	self:TakeDamage( dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor() )
end

function NPC:Walk( pos )
	self:SetLastPosition( pos )
	self:SetSchedule( SCHED_FORCED_GO )
end

function NPC:Run( pos )
	self:SetLastPosition( pos )
	self:SetSchedule( SCHED_FORCED_GO_RUN )
end
