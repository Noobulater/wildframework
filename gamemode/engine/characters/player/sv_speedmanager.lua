classSpeedManager = {}

local thinkSpeed = 0.5 
local nextThink = 0


local PMETA = FindMetaTable("Player")


function PMETA:updateSpeed()
	local stats = self:getCharacter().getStats()
	self:SetRunSpeed( math.Clamp(stats.getStatValue("defaultRunSpeed") + stats.getStatValue("runSpeedModifier"), 1, 1000) )
	self:SetWalkSpeed( math.Clamp(stats.getStatValue("defaultWalkSpeed") + stats.getStatValue("walkSpeedModifier"), 1, 1000) )
end

function PMETA:addWalkModifier( newValue )
	local stats = self:getCharacter().getStats()
	stats.setStatValue("walkSpeedModifier", stats.getStatValue("walkSpeedModifier") + newValue)
end

function PMETA:getWalkModifier( )
	local stats = self:getCharacter().getStats()
	return stats.getStatValue("walkSpeedModifier")
end

function PMETA:addRunModifier( newValue )
	local stats = self:getCharacter().getStats()
	stats.setStatValue("runSpeedModifier", stats.getStatValue("runSpeedModifier") + newValue)
end

function PMETA:getRunModifier( )
	local stats = self:getCharacter().getStats()
	return stats.getStatValue("runSpeedModifier")
end

function PMETA:addSpeedModifier( walkSpeed, runSpeed )
	self:addWalkModifier( walkSpeed )
	self:addRunModifier( runSpeed )
	self:updateSpeed()
end

-- function classSpeedManager.think()
-- 	if nextThink < CurTime() then
-- 		for key, ply in pairs(util.getAlivePlayers()) do
-- 			if ply:Alive() then

-- 			end
-- 		end
-- 	end
-- end

-- hook.Add("Think", "speedManagerThink", classSpeedManager.think)