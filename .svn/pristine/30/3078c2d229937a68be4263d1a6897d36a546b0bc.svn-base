
local radius = 600 -- units
local density = 1
local startheight = 1000
local frequency = 0.5 -- emits once per second
-- 


local function Splash(particle, pos, norm)
	particle:SetDieTime(0)

	local effectdata = EffectData() 
	effectdata:SetStart(pos)
	effectdata:SetOrigin(pos) 
	effectdata:SetScale( math.randomf( 0.3, 1.3 ) )
	effectdata:SetColor( 2000 )

	util.Effect( "watersplash", effectdata )  
end

function EFFECT:Init(data)
	self.Emitter = ParticleEmitter(LocalPlayer():GetPos(), true)
	self.nextEmit = 0
end

function EFFECT:Think()
	if self.nextEmit > CurTime() then return true end -- stops for now but will continue later returning false will stop it
	local particles = radius * density
	local emitter = self.Emitter

	for i = 1, particles do
		local randomAngle = math.randomf(0.0, 2 * math.pi)
		local randomRadius = math.randomf(0, radius)
		local randomX = math.cos(randomAngle) * randomRadius
		local randomY = math.sin(randomAngle) * randomRadius

		local position = LocalPlayer():GetPos() + LocalPlayer():GetVelocity() + Vector(randomX, randomY, 0) -- Raises the rain above the players head

		position.z = startheight

		local particle = emitter:Add("particle/Water/WaterDrop_001a", position)

		particle:SetLifeTime(0)
		particle:SetDieTime(4)

		particle:SetStartSize(math.randomf(1.5,2.5))		
		
		particle:SetAngles(Angle(0, 0, 90))
		particle:SetVelocity(physenv:GetGravity() + Vector(0, 0, -100 + -300 * math.randomf(-1.0, 1.0)))
		
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(25)

		particle:SetBounce(0)
		particle:SetCollide(true)
		particle:SetCollideCallback(Splash)
	end

	for i = 1, particles / 4 do
		local randomAngle = math.randomf(0.0, 2 * math.pi)
		local randomRadius = radius + math.randomf(0.0, radius * 2)
		local randomX = math.cos(randomAngle) * randomRadius
		local randomY = math.sin(randomAngle) * randomRadius

		local position = LocalPlayer():GetPos() + LocalPlayer():GetVelocity() + Vector(randomX, randomY, 0) -- Raises the rain above the players head

		position.z = startheight

		local particle = emitter:Add("particle/Water/WaterDrop_001a", position)

		particle:SetLifeTime(0)
		particle:SetDieTime(4)

		particle:SetStartSize(math.randomf(1.5,2.5))		
		
		particle:SetAngles(Angle(0, 0, 90))
		particle:SetVelocity(physenv:GetGravity() + Vector(0, 0, -100 + -300 * math.randomf(-1.0, 1.0)))
		
		particle:SetStartAlpha(25)
		particle:SetEndAlpha(25)

		particle:SetBounce(0)
		particle:SetCollide(true)
		particle:SetCollideCallback(Splash)
	end

	--self:Remove()
	self.nextEmit = CurTime() + frequency 
	return true
end

function EFFECT:Render()
end

