local class = "fo_cartire"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Car Tire")
	item.setDescription("Well... at least it isn't a flat")
	item.setModel("models/props_vehicles/carparts_wheel01a.mdl")
	item.setTemporary(true)
	item.setReusable(true)

	item.use = function( user ) 
				if SERVER then 
					if user:IsPlayer() then
						local trace = user:GetEyeTraceNoCursor()
						if trace.Hit then
							-- local keypad = table.Random(ents.FindByName("keypad"))
							-- if IsValid(trace.Entity) && trace.Entity == keypad then
							-- 	keypad.useFunc(user)
							-- end
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