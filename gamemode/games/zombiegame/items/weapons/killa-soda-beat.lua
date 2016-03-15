local class = "killa-soda-beat"

local function generate()
	local weapon = classItemData.genItem("projectileBase")
	weapon.setClass(class)
	weapon.setName("killa-soda-beat")
	weapon.setDescription("This is killabeat's awesome gun!")
	weapon.setFireSound("physics/plastic/plastic_barrel_impact_bullet3.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(10)
	weapon.setAccuracy(0.05)
	weapon.setClipSize(30)
	weapon.setHoldType("pistol")
	weapon.setAmmoType("AR2")
	weapon.setModel("models/weapons/w_IRifle.mdl")
	weapon.setAutomatic( true )

	function weapon.projectile( user, swep )
		if SERVER then
			local attachment = swep:LookupAttachment("muzzle")
			local pos = swep:GetAttachment(attachment)["Pos"]
			local ang = swep:GetAttachment(attachment)["Ang"]

			local entity = ents.Create("prop_physics")
			entity:SetModel( "models/props_junk/PopCan01a.mdl" )
			entity:SetPos(pos + Vector(0,0,5))
			entity:SetAngles( user:GetAimVector():Angle() + Angle(90, 0, 0) )
			entity:Spawn()
			entity:SetSolid(0)
			entity.owner = user

			local phys = entity:GetPhysicsObject()

			if IsValid(phys) then
				phys:ApplyForceCenter( user:GetAimVector() * 30000 )
			end

			return entity
		end
		return nil
	end

	function weapon.callBack( ply, tr, dmgInfo, projectile ) 
		if tr.Hit then	
			timer.Simple(tr.HitPos:Distance(ply:GetShootPos())/10000, function()

				local visual = EffectData()
				visual:SetOrigin( tr.HitPos )
				visual:SetScale(2)
				visual:SetAngles( (ply:GetShootPos() - tr.HitPos):Angle() )
				local h = math.random(0,255)
				local r, g, b = math.random(0,55), math.random(0,55), math.random(0,55)
				visual:SetColor(h - r, h - g, h - b, 155 )

				sound.Play("physics/surfaces/underwater_impact_bullet1.wav", tr.HitPos, 75, 100, 1 )

				util.Effect("gunshotsplash", visual )
				if IsValid( projectile ) then
					local dummy = ents.Create("prop_physics")
					dummy:SetPos(tr.HitPos)
					dummy:SetAngles( Angle(math.random(0,360), math.random(0,360), math.random(0,360)) )
					dummy:SetModel( "models/props_junk/PopCan01a.mdl" )
					dummy:Spawn()
					dummy:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					
					local phys = dummy:GetPhysicsObject()

					if IsValid(phys) then
						phys:ApplyForceCenter(Vector(math.random(-500,500), math.random(-500,500), math.random(-500,500)))
					end

					timer.Simple(5, function() if IsValid(dummy) then dummy:Remove() end end )
					projectile:Remove()
				end
			end)
		end
	end	

	return weapon
end

classItemData.register( class, generate )
