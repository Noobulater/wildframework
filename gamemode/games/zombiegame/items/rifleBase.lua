local class = "rifleBase"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Base_Rifle")
	weapon.setDescription("A Rifle")
	weapon.setFireSound("weapons/m4a1/m4a1_unsil-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(19)
	weapon.setAccuracy(.03)
	weapon.setClipSize(30)
	weapon.setHoldType("ar2")
	weapon.setAmmoType("rifleAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_rif_m4a1.mdl")

	function weapon.reload( user , swep )
		if SERVER then

			if GAMEMODE.UnlimitedAmmo then swep:SetClip1(weapon.getClipSize()) return end
			
			local pool = {}
			local inventoryID = user:getInventory().getUniqueID()
			for slot, item in pairs(user:getInventory().getItems()) do
				if item != 0 && item.getClass() == weapon.getAmmoType() then
					pool[slot] = item
				end
			end
			
			local removePool = weapon.getClipSize() - swep:Clip1()

			for slot, item in pairs(pool) do
				if removePool > 0 then
					local ammo = tonumber(item.getExtras()) or 0
					if removePool >= ammo then
						swep:SetClip1(swep:Clip1() + ammo)
						removePool = removePool - ammo
						if SERVER then
							user:getInventory().removeItem(slot)
						end
					else
						local ammoLeft = ammo - removePool
						swep:SetClip1(swep:Clip1() + removePool)					
						item.setExtras(tostring(ammoLeft)) 
						removePool = 0
						networkSlotExtras(inventoryID, slot, item, user)
						break
					end
				end
			end
		end
	end

	if CLIENT then
		function weapon.paperDoll(ply, prop)
			local BoneIndx = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			local BonePos , BoneAng = ply:GetBonePosition( BoneIndx )

			prop:SetAngles(BoneAng + Angle(-9,0,170))
			prop:SetPos(BonePos + BoneAng:Forward() * 20 + BoneAng:Up() * 1 + BoneAng:Right() * 0.25 )
			prop:SetModel(weapon.getModel())
		end
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON