function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity()
	self._handl = self:BindFX("burningHandl")
	self._handr = self:BindFX("burningHandr")
self._bsound1=self:BindSound("actor/clown/electricity",4,30,true)
end

function o:OnThrow()
    local brain = self._AIBrain
	brain._lastHitTime = brain._currentTime
	brain._lastMissedTime = brain._currentTime - 1
    self._playSndCol = false
end

function o:OnAttack()
	self._ataklFX = self:BindFX("atakl")
    self._atakpFX = self:BindFX("atakp")
end

function o:deathpart()
self:BindFX("death1")
self:BindFX("death2")
self:BindFX("death3")
self:BindFX("death4")
self:BindFX("death5")
end