local class = "smgBase"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Base_SMG")
	weapon.setDescription("A SMG")
	weapon.setFireSound("weapons/mac10/mac10-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(19)
	weapon.setAccuracy(.03)
	weapon.setClipSize(36)
	weapon.setHoldType("smg")
	weapon.setAmmoType("automaticAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_smg_mac10.mdl")

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
			prop:SetPos(BonePos + BoneAng:Forward() * 4 + BoneAng:Up() * 3 + BoneAng:Right() * 0.25 )
			prop:SetModel(weapon.getModel())
		end
	end
	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON