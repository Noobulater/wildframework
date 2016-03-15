local class = "fo_plug"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Plug")
	item.setDescription("Can transfer electrical currents")
	item.setModel("models/props_lab/tpplug.mdl")
	item.setTemporary(true)
	item.setReusable(true)

	item.use = function( user ) 
				if SERVER then 
					if user:IsPlayer() then
						local trace = user:GetEyeTraceNoCursor()
						if trace.Hit then
							if IsValid(trace.Entity) && trace.Entity:GetModel() == "models/props_lab/tpplugholder_single.mdl"  && !trace.Entity.taken then
								trace.Entity.taken = true
								SV_FORESTOUTPOST_POWERPLUGS = SV_FORESTOUTPOST_POWERPLUGS + 1

								local plug = ents.Create("prop_physics")
								plug:SetModel("models/props_lab/tpplug.mdl")
								plug:SetPos(trace.Entity:GetPos() + trace.Entity:GetAngles():Forward() * 5 + trace.Entity:GetAngles():Up() * 10 + trace.Entity:GetAngles():Right() * -13 )--Vector(1639,1856,66 + i * 10))
								plug:Spawn()
								local phys = plug:GetPhysicsObject()
								if IsValid(phys) then
									phys:EnableMotion(false)
								end

								local ropeplug = ents.Create("move_rope")
								ropeplug:SetKeyValue("targetname", "gen_ropeplug"..(ropeplug:EntIndex()))
								ropeplug:SetPos(plug:GetPos() + plug:GetAngles():Forward() * 12)
								ropeplug:SetParent(plug)
								ropeplug:Spawn()
								ropeplug:Activate()
							
								local rope = ents.Create("move_rope")
								rope:SetKeyValue("NextKey", "gen_ropeplug"..ropeplug:EntIndex())
								rope:SetKeyValue("targetname", "gen_rope"..rope:EntIndex())
								rope:SetPos(table.Random(ents.FindByName("gen_rope3")):GetPos())
								rope:Spawn()
								rope:Activate()

								user:getInventory().removeItem(nil, item)

								if SV_FORESTOUTPOST_POWERPLUGS >= 5 then
									local button = table.Random(ents.FindByName("power_on_button"))
									button:Fire("Unlock", '', 0)
								end
							end
						end
					end 
				end 
			end 

	function item.isItem()
		return false
	end

	return item
end

classItemData.register( class, generate )