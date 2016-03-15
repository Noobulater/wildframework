if SERVER then

	util.AddNetworkString("networkForceReload")

	function networkForceReload( ply)
		net.Start( "networkForceReload" )
		net.Send( ply )	
	end	
end
if CLIENT then

	net.Receive( "networkForceReload", function(len)   
		RunConsoleCommand("+reload")
		timer.Simple(0.05, function() RunConsoleCommand("-reload") end)		
	end)
	
end

local class = "shotgunBase"

local function generate()
	local weapon = classItemData.genItem("gunBase")
	weapon.setClass(class)
	weapon.setName("Shotty Gun")
	weapon.setDescription("This is an example of a custom weapon")
	weapon.setFireSound("weapons/shotgun/shotgun_fire6.wav")	
	weapon.setFireRate( .3 )
	weapon.setDamage(10)
	weapon.setAccuracy(.1)
	weapon.setClipSize(6)
	weapon.setNumBullets(8)
	weapon.setReloadTime(1)
	weapon.setHoldType("shotgun")
	weapon.setAmmoType("shotgunAmmo") -- I'm doing a hacky way, I set it to the classname of the item it uses as ammo. It is used by custom hud 
	weapon.setModel("models/weapons/w_shotgun.mdl")

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
			
			local removePool = math.Clamp(weapon.getClipSize() - swep:Clip1(), 0, 1)

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
			if swep:Clip1() < weapon.getClipSize() then
				networkForceReload(user)
			end			
		end
	end


	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON