function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity()
    	self._lastTimeJump = 0
	self:BindFX('saliva')
end

function o:OnPrecache()
	Cache:PrecacheParticleFX("Scarabeus_saliva")
end

