local class = "weapon_crowbar"

local function generate()
	local weapon = classItemData.genItem("meleeBase")
	weapon.setClass(class)
	weapon.setName("Crowbar")
	weapon.setCustom(false) -- this is important, it disables all shit that goes with the weapon system
	weapon.setWClass("weapon_crowbar")
	weapon.setModel("models/weapons/w_crowbar.mdl")
	weapon.setFireSound({["hitwall"] = "physics/metal/metal_box_impact_bullet1.wav",["miss"] = "weapons/iceaxe/iceaxe_swing1.wav",
		"physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav", 
		"physics/body/body_medium_impact_hard5.wav"})	
	weapon.setPrimaryEQSlot(-2)
	weapon.setAttackRange(90)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_L_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(4,2,-5)
	    tempData.ang = Angle(0,-90,90)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end

	function weapon.hitEntity(self, entity, trace )
	    if math.random(1, 1/0.1) == 1 then
	        entity:applyEffect("cripple")
	    end
	    if entity:IsPlayer() or entity:IsNPC() then
		   	local visual = EffectData()
		   	if trace then
				visual:SetOrigin( trace.HitPos )
			else
				visual:SetOrigin( entity:GetPos() )
			end
			util.Effect("BloodImpact", visual )
		end
	end

	function weapon.equipEffect( self )
	    self:setAttackSpeed(1.7)
	    self:setAttackDamage(math.Round(self:getAttackDamage() * 1.5))
	end

	return weapon
end

classItemData.register( class, generate )

if SERVER then
	classScarcity.addItemToCategory(2, class)
end
