function Spike_Demon_Big_Red:OnInitTemplate()
    self:SetAIBrain()
end



function Spike_Demon_Big_Red:OnCreateEntity()
    self._AIBrain._lastThrowTime = FRand(-5, 1) 
    self:BindFX("spike_demon_red",0.3,'k_szyja',0,0.8,0)
end

function Spike_Demon_Big_Red:BindTrails()
self._tr1= self:BindTrail('trail_zombie','RightForeArm','RightHand')
self._tr2= self:BindTrail('trail_zombie','LeftForeArm','LeftHand')
end

function Spike_Demon_Big_Red:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end

function Spike_Demon_Big_Red:Shotflash()
self._ap=self:BindFX('shotfx')
end

function Spike_Demon_Big_Red:StartWalk()
if not self._brt then
	self._brt=self:BindFX('runcloud')
end
end

function Spike_Demon_Big_Red:EndWalk()
if self._brt then
	PARTICLE.Die(self._brt)
	self._brt=nil
end
end

