function BrainEater:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-4, 0.5)
end

function BrainEater:OnPrecache()
end


function BrainEater:OnCreateEntity()
end

function o:BindTrails1()
self._tr1= self:BindTrail('trail_kolek','r_nipper_forearm','r_nipper','r_nipper_tip')
self._tr2= self:BindTrail('trail_kolek','l_nipper_forearm','l_nipper','l_nipper_tip')
end

function o:EndTrails1()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end

function o:BindTrails2()
self._tr1= self:BindTrail('trail_kolek','l_hand','l_finger1','l_finger1_tip')
self._tr2= self:BindTrail('trail_kolek','r_hand','r_finger1','r_finger1_tip')
end

function o:EndTrails2()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end

function o:CustomOnDeath()
end

function BrainEater:handoff()
end
function BrainEater:handon()
end

function BrainEater:foff()
end
function BrainEater:forkon()
end



