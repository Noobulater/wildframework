SWEP.PrintName		= "C4 Explosives"
SWEP.Description	= "Plant c4"
SWEP.ViewModel		= "models/weapons/v_c4.mdl"
SWEP.WorldModel		= "models/weapons/w_c4.mdl"
SWEP.AnimPrefix		= "python"
SWEP.HoldType		= "slam"
SWEP.IconLetter		= "I"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 3
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "slam"

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0


function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
end

function SWEP:createBomb()
	if CLIENT then return end
	if not IsValid(self:GetOwner()) or not self:GetOwner():Alive() then return end
	self:Remove()

	local entBomb = ents.Create("c4")
	local angle = Angle(0,self.Owner:EyeAngles().y,0)

	local eyeTrace = self:GetOwner():GetEyeTrace()

	local dist = 25
	local pos = self.Owner:EyePos() + self.Owner:GetAimVector() * dist

	if eyeTrace.Hit && eyeTrace.HitPos:Distance(self:GetOwner():EyePos()) < 200 then
		pos = eyeTrace.HitPos
		angle = eyeTrace.HitNormal:Angle()

		angle.y = angle.y + 180
		if angle.p / 180 <= 1 then
			angle.p = angle.p - 90
		else
			angle.p = angle.p + 90
		end
	end

	entBomb:SetPos(pos)
	entBomb:SetAngles(angle)
	entBomb:Spawn()
	entBomb:SetDTEntity(0,self:GetOwner())	
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		self:createBomb()

		local inventory = self:GetOwner():getInventory()
		for slot, item in pairs(inventory.getItems()) do
			if slot < 0 && item != 0 && item.getClass() == "c4" then
				inventory.removeItem(slot)
				break
			end
		end	
	end
end

function SWEP:CanPrimaryAttack()
	return true
end