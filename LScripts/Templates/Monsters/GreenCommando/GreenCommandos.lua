function o:OnCreateEntity()
	local brain = self._AIBrain
    brain._lastThrowTime = brain._currentTime + FRand(-2,1)
end

