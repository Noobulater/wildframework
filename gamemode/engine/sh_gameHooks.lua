function GM:Initialize()
	-- ToDo: Start up any global systems.
end
function GM:PostGamemodeLoaded()
	-- After Initialize before InitPostEntity.
end
function GM:InitPostEntity()
	-- Called once the map and entities have loaded.
end

function GM:ShutDown()
	-- Don't save here there won't be enough time.
end

function GM:CreateTeams()
	-- No Teams
end

function GM:ShouldCollide(ent1, ent2)
	-- Player's don't collide, but everything else does.
	if ent1:IsPlayer() and ent2:IsPlayer() then
		return false
	end
	return true
end

function GM:Think()
	-- Try not to put anything in here.
end
function GM:Tick()
	-- Try not to put anything in here.
	-- Runs slower than think aparently.
	-- Only runs if there is a player on the server.
end
