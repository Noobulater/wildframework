local class = "powerHammer"

local function generate()
	local weapon = classItemData.genItem("meleeBase")
	weapon.setClass(class)
	weapon.setFireSound({["hitwall"] = "physics/metal/metal_box_impact_bullet1.wav",["miss"] = "weapons/iceaxe/iceaxe_swing1.wav",
		"physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav", 
		"physics/body/body_medium_impact_hard5.wav"})
	weapon.setName("Lead Pipe")
	weapon.setModel("models/weapons/c_models/c_rfa_hammer/c_rfa_hammer.mdl")
	weapon.setFireRate(0.7)
	weapon.setDamage(50)
	weapon.setHoldType("melee2")
	weapon.setPrimaryEQSlot(-2)
	weapon.setAttackRange(90)
	weapon.setShouldDraw(false)

	-- local mode = false
	-- function weapon.changeMode( newMode )
	-- 	mode = newMode
	-- end

	-- function weapon.mode()
	-- 	return mode
	-- end

	-- function weapon.secondaryFire( user, swep )
	-- 	if mode then
	-- 		weapon.changeMode( false )
	-- 		weapon.setDamage(15)
	-- 		weapon.setFireRate(0.7)
	-- 		weapon.setAttackRange(90)
	-- 		user:SetNWString("weaponHoldType", "melee2")	
	-- 	else
	-- 		weapon.changeMode( true )
	-- 		weapon.setFireRate( 0.5 )
	-- 		user:SetNWString("weaponHoldType", "knife")		
	-- 	end
	-- 	swep.nextSFire = CurTime() + 0.2
	-- 	return false
	-- end

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(3.2,2.5,-7.5)
	    tempData.ang = Angle(180,180,0)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end

	function weapon.deploy( user )
		if IsValid(user) then 
			getPaperdollManager().register(user, class, weapon.paperDoll( user:IsPlayer() )) 
		end
	end

	function weapon.holster( user )
		if IsValid(user) then 
			getPaperdollManager().clearTag(user, class)
		end
	end	

	function weapon.hitEntity(self, entity, trace )
		if self:IsPlayer() && entity:IsPlayer() && !GAMEMODE.FriendlyFire then return false end
	    if math.random(1, 1/0.1) == 1 then
	        entity:applyEffect("cripple")
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
	classScarcity.addItemToCategory(5, class)
end