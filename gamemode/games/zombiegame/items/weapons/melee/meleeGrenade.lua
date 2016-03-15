local class = "meleeGrenade"

local function generate()
	local weapon = classItemData.genItem("meleeBase")
	weapon.setClass(class)
	weapon.setName("Butcher Knife")
	weapon.setModel("models/weapons/w_grenade.mdl")
	weapon.setFireSound({["hitwall"] = "physics/metal/metal_box_impact_bullet1.wav",["miss"] = "weapons/iceaxe/iceaxe_swing1.wav",
		"physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav", 
		"physics/body/body_medium_impact_hard5.wav"})	
	weapon.setFireRate(1)
	weapon.setDamage(5)
	weapon.setHoldType("melee")
	weapon.setPrimaryEQSlot(-2)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_L_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(2,5,0)
	    tempData.ang = Angle(-90,0,-90)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end

    function weapon.onHit( self, entity, trace )
    	if SERVER then
		  	sound.Play(weapon.getFireSound()[math.random(1,table.Count(weapon.getFireSound())-2)], entity:GetPos() + Vector(0,0,40), 75, 100, 1 )

		    local dmginfo = DamageInfo()
		    dmginfo:SetDamageType(DMG_SLASH)
		   	dmginfo:SetDamage(weapon.getDamage())

		    local force = 1
		    local phys = entity:GetPhysicsObject()
		    if IsValid(phys) then
		        force = phys:GetVolume()/phys:GetMass() * 10
		    end

		    if self:IsNPC() then
		    	dmginfo:SetDamage(self:getAttackDamage())
			    if IsValid(self:GetEnemy()) then
			        local dir = (self:GetEnemy():GetPos() - self:GetPos()):Angle()
			        dmginfo:SetDamageForce( dir:Forward() * self:getAttackDamage() * force + dir:Up() * force )
			    else
			        dmginfo:SetDamageForce( self:GetAngles():Forward() * self:getAttackDamage() * force  )
			    end
			else
				if IsValid(entity) then
			        local dir = (entity:GetPos() - self:GetShootPos()):Angle()
			        dmginfo:SetDamageForce( dir:Forward() * weapon.getDamage() * force + dir:Up() * force )
			    else
			        dmginfo:SetDamageForce( self:GetAngles():Forward() * weapon.getDamage() * force  )
			    end
		   	end

		    dmginfo:SetAttacker(self)

		    entity:TakeDamageInfo(dmginfo)

		    if math.random(0,8) == 0 then
		       util.BlastDamage(self, self, self:GetPos() + Vector(0,0,50), 100, 400)
		       util.ScreenShake( self:GetPos(), 5, 5, 1, 600 )
		      
		      local effectdata = EffectData()
		       effectdata:SetOrigin(self:GetPos() + Vector(0,0,50))
		       effectdata:SetScale(1)
		       util.Effect("Explosion", effectdata)
		    end
		end
    end

	function weapon.equipEffect( self )
	    self:setAttackSpeed(1.9)
	    self:setRunSpeed(self:getRunSpeed() + 20 )
	end
	
	return weapon
end

classItemData.register( class, generate )
