function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
	Cache:PrecacheParticleFX(self.eyeFX)
	Cache:PrecacheParticleFX(self.clawFX)
	Cache:PrecacheParticleFX(self.transformIntoBigVampFX)
	Cache:PrecacheActor("Scarabeus.CActor")
end

function o:OnCreateEntity()
--	self._AIBrain._lastThrowTime = FRand(-2, 2)
--	self:BindFX("pochodnia",0.1,self.AiParams.weaponBindPos,self.AiParams.weaponBindPosShift.X,self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
	self:BindFX(self.eyeFX,0.03,"TailF",0.1,0.2,0)
	self:BindFX(self.eyeFX,0.03,"TailF",-0.1,0.2,0)
	self._lastTimeJump = 0
	self:BindFX(self.clawFX,0.03,"LeftHandThumb1",0,0,0)
	self:BindFX(self.clawFX,0.03,"LeftHand",0,0,0)
	self:BindFX(self.clawFX,0.03,"RightHandThumb1",0,0,0)
	self:BindFX(self.clawFX,0.03,"RightHand",0,0,0)
end

