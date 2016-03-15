local class = "meleeBase"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Base_Melee")
	weapon.setDescription("melee")
	weapon.setFireSound({["hitwall"] = "weapons/knife/knife_hitwall1.wav",["miss"] = "weapons/knife/knife_slash1.wav" ,
		"weapons/knife/knife_hit1.wav", "weapons/knife/knife_hit2.wav", 
		"weapons/knife/knife_hit3.wav", "weapons/knife/knife_hit4.wav"})
	weapon.setFireRate( .3 )
	weapon.setDamage(10)
	weapon.setClipSize(-1)
	weapon.setHoldType("knife")
	weapon.setModel("models/weapons/w_knife.mdl")

	local range = 70
	function weapon.setAttackRange( newRange )
		range = newRange
	end

	function weapon.getAttackRange()
		return range
	end

    function weapon.onMiss( self, entity, trace )
    	if SERVER then
       		sound.Play(weapon.getFireSound()["miss"], self:GetPos() + Vector(0,0,40), 75, 100, 1 )
       	end
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

		   	weapon.hitEntity(self, entity, trace)

		    dmginfo:SetAttacker(self)

		    entity:TakeDamageInfo(dmginfo)
		end
    end

	function weapon.primaryFire( user, swep )
		--"weapons/iceaxe/iceaxe_swing1.wav"
		if !user:IsPlayer() then return false end


		local mins = Vector(-5,-5,-5)
		local maxs = Vector(5,5,5)
		local startpos = user:GetShootPos() -- just get it off the ground for sure ( that way when spawnign on terrain/slopes there are less checks)
		local dir = user:GetAimVector()
		local len = weapon.getAttackRange() -- we go up cuz are sure we are on flat ground 
		
		
		local tr = util.TraceHull( {
			start = startpos,
			endpos = startpos + dir * len,
			maxs = maxs,
			mins = mins,
			filter = user,
		} )

	 	user:SetAnimation(PLAYER_ATTACK1)

	 	if tr.Hit then
	 		if tr.HitPos:Distance(user:GetShootPos()) < range then
		 		if IsValid(tr.Entity) then
		 			weapon.onHit( user, tr.Entity, tr )
				elseif tr.HitWorld then
					util.Decal("ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
					if SERVER then
						sound.Play(weapon.getFireSound()["hitwall"], tr.HitPos + Vector(0,0,10), 75, 100, 1 )
					end
				end
			else
				weapon.onMiss( user, nil, tr )
			end
	 	else
	 		-- TO DO MAKE THIS CODE APPLICABLE TO CURRENT MELEE WEAPONS
			-- local zomb_pos = self:GetPos() + self:OBBCenter()
			-- local zomb_facing = (self:GetAngles():Forward()):Normalize()
			-- local ply_pos = self.EnemyData.CurEnemy:GetPos() + self.EnemyData.CurEnemy:OBBCenter()

			-- local zomb_to_ply = (ply_pos - zomb_pos):Normalize()
			
			-- local angle = math.acos(zomb_facing:DotProduct(zomb_to_ply));
				
			-- local dist = self.EnemyData.CurEnemy:GetPos():Distance(self:GetPos())
			-- if (dist < 140) && (angle < 0.80 || (self.EnemyData.CurEnemy:GetPos().z) > (self:GetPos() + self.EnemyData.CurEnemy:OBBCenter()).z) then
			-- 	if self.EnemyData.CurEnemy:GetPhysicsObject():IsMoveable() && !self.EnemyData.CurEnemy:IsPlayer() then
			-- 		self.EnemyData.CurEnemy:GetPhysicsObject():ApplyForceCenter(self:GetAngles():Forward() * 400 * self.EnemyData.CurEnemy:GetPhysicsObject():GetMass() + self:GetAngles():Up() * 100 * self.EnemyData.CurEnemy:GetPhysicsObject():GetMass())
			-- 	end				
			-- 	self.EnemyData.CurEnemy:TakeDamage(self.Attack)
			-- end	 		
	 		weapon.onMiss( user, nil, tr )
	 	end

	 	swep:setNextPFire( CurTime() + weapon.getFireRate() )
		return false -- we use a different system
	end

	function weapon.secondaryFire( user, swep )
		return false
	end

	function weapon.isEquipment()
		return true
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON