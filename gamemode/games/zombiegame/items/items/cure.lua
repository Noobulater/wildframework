local class = "cure"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Venom Cure")
	item.setDescription("Removes the infection venom")
	item.setModel("models/items/healthkit.mdl")
	item.setReusable(true)
	item.setHotBar(true)
	item.use = function( user ) 
				if SERVER then 
					local key = user:hasEffect("infection") 
					if key then 
						sound.Play( "HL1/fvox/antidote_shot.wav", user:GetPos() + Vector(0,0,30), 75, 100, 1 )	
						user:clearEffect("infection") 
						user:getInventory().removeItem(nil, item) 
					end 
				end 
			end 

	return item
end

classItemData.register( class, generate )