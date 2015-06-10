local META = FindMetaTable("Entity")

function META:clearEffects()
	for key, effectData in pairs(classEffectManager.getEffects()) do
		if effectData.getVictim() == self then
			effectData.cleanUp( self )
			effectData.setVictim( nil )

			if SERVER then
				if effectData.getNetworkAll() then
					networkClearEffectData( nil, self, effectData.getClass() )
				end
			end
		end
	end
	if SERVER then
		if self:IsPlayer() then
			networkClearEffectData( self )
		end
	end
end

function META:getEffects()
	local effectTable = {}
	for key, effectData in pairs(classEffectManager.getEffects()) do
		if effectData.getVictim() == self then
			table.insert(effectTable, effectData)
		end
	end
	return effectTable
end

function META:hasEffect( class )
	local effectTable = {}
	for key, effectData in pairs(classEffectManager.getEffects()) do
		if effectData.getVictim() == self && effectData.getClass() == class then
			return effectData
		end
	end
	return false
end

function META:clearEffect( class )
	if class == nil then return end 
	local effectData = self:hasEffect(class)
	if !effectData then return end 

	if effectData.getVictim() == self then
		effectData.cleanUp( self )
		effectData.setVictim( nil )
		if SERVER then
			if !effectData.getNetworkAll() && self:IsPlayer() then
				networkClearEffectData( self, self, class )
			else
				networkClearEffectData( nil, self, class )
			end
		end			
	end
end

function META:applyEffect(class, duration, key)
	local effectData = self:hasEffect(class)
	if !effectData then 
		effectData = classEffectData.genEffect( class )
		effectData.setVictim( self )

		if duration != nil then
			effectData.setDuration( duration )
		end
		classEffectManager.add( effectData )
	end
end