local class = "flamethrower"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Flame Thrower")
	weapon.setDescription("'nuff said")
	weapon.setFireSound("weapons/minigun/mini-1.wav")	
	weapon.setFireRate( 0.1 )
	weapon.setDamage(10)
	weapon.setAccuracy(.1)
	weapon.setClipSize(100)
	weapon.setReloadTime(3)
	weapon.setAutomatic(true)
	weapon.setHoldType("ar2")
	weapon.setAmmoType("flameAmmo")
	weapon.setModel("models/weapons/flamethrower.mdl")
	weapon.setShouldDraw(false)
	weapon.primClip = weapon.getClipSize()

	function weapon.paperDoll()
		local returnTBL = {}

	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(0, 6.8, -8.2)
	    tempData.ang = Angle(0,90, 200)
	    tempData.scale = Vector(1,1,1)

	    table.insert(returnTBL, tempData)

	    local tempData = {}
	    tempData.model = "models/props_junk/gascan001a.mdl"
	    tempData.bone = "ValveBiped.Bip01_Spine4"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(-5, -1.1, -5)
	    tempData.ang = Angle(342, 74, 95)
	    tempData.scale = Vector(1,1,1)

	    table.insert(returnTBL, tempData)

	    return returnTBL
	end

	function weapon.deploy( user )
		if IsValid(user) then 
			getPaperdollManager().register(user, class, weapon.paperDoll()[1]) 
			getPaperdollManager().register(user, class, weapon.paperDoll()[2]) 
		end
	end

	function weapon.holster( user )
		if IsValid(user) then 
			getPaperdollManager().clearTag(user, class)
		end
	end

	function weapon.primaryFire( user, swep )

		swep:SetClip1(math.Clamp(swep:Clip1() - 1, 0, weapon.getClipSize() or 10))

		swep:setNextPFire(CurTime() + weapon.getFireRate() )
		if SERVER then
			sound.Play("ambient/fire/mtov_flame2.wav", user:GetPos() + Vector(0,0,50), 75, 100, 1 )

			local pos,ang = user:GetBonePosition( user:LookupBone("ValveBiped.Bip01_R_Hand") )

			local attachment = swep:LookupAttachment("muzzle")
			local pos = swep:GetAttachment(attachment)["Pos"]
			local ang = swep:GetAttachment(attachment)["Ang"]


			local trace = { }
			trace.start = pos
			trace.endpos = pos + user:GetAimVector() * 150
			trace.filter = user

			local tr = util.TraceLine(trace)
			local burnPos = trace.endpos

			if tr.Hit then
				burnPos = tr.HitPos
			end

			local flamefx = EffectData()
			flamefx:SetOrigin(burnPos)
			flamefx:SetStart(pos)

			util.Effect("flamespout", flamefx, true, true)

			local flame = ents.Create("point_hurt")
			flame:SetPos(burnPos)
			flame:SetOwner(user)
			flame:SetKeyValue("DamageRadius",100)
			flame:SetKeyValue("Damage",4)
			flame:SetKeyValue("DamageDelay",0.32)
			flame:SetKeyValue("DamageType",8)
			flame:Spawn()
			flame:Fire("TurnOn","",0) 
			flame:Fire("kill","",0.72)

			for key, ent in pairs(ents.FindInSphere(burnPos, 64)) do
				if ent:IsNPC() then
					ent:Ignite(5, 0)
				else
					if !GAMEMODE.FriendlyFire && ent:IsPlayer() && ent != user then return end
					if IsValid(ent:GetPhysicsObject()) && ent:GetPhysicsObject():IsMotionEnabled() then
						ent:Ignite(3, 0)
						if ent == user then
							if math.random(0,2) == 0 then
								timer.Simple(3, function() 
									if IsValid(user) && util.isActivePlayer(user) then 
										user:Ignite(0,0) 
										user:Kill()

										local effectdata = EffectData()
										effectdata:SetOrigin(user:GetPos())
										effectdata:SetScale(1)
										util.Effect("Explosion", effectdata)
									end 
								end)
							end
						end						
					end
				end
			end
		end

		return false
	end

	function weapon.secondaryFire( user, swep )
		return false
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(5, class)
end