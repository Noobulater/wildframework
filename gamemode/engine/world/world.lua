local function initPostEntity()
	if world != nil then 
		world.initialize()
	end
end
hook.Add("InitPostEntity", "worldinit", initPostEntity )

local function worldThink()
	if world != nil then 
		if world.think then
			world.think()
		end
	end
end
hook.Add("Think", "worldThink", worldThink)