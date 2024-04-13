function Burned_one:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-4, 0.5)

    self._animMode = math.random(1,6)
    self._forceWalkAnim = self.s_SubClass.walkList[self._animMode]
    self._lastTimeChangeAnim = 0
    self._changeAnimIn = FRand(20.0, 50.0)	-- sec.
end

function Burned_one:OnPrecache()
end


function Burned_one:GetThrowItemRotation()
	if self._torchFX then
		ENTITY.Release(self._torchFX)
		self._torchFX = nil
	end

	local q = Quaternion:New()
	q:FromEuler( 0, -self.angle+math.pi/2, math.pi)	-- -self.angle - math.pi/2
	return q
end

function Burned_one:CustomOnDeath()
	if self._proc then
		GObjects:ToKill(self._proc)
		self._proc = nil
	end

	if self._objTakenToThrow then
		local brain = self._AIBrain
		if brain._JointH then
			MDL.SetPinned(self._objTakenToThrow._Entity, false)	
			MDL.SetPinnedJoint(self._objTakenToThrow._Entity, brain._JointH, false)	
		end
		MDL.SetRagdollCollisionGroup(self._objTakenToThrow._Entity, ECollisionGroups.RagdollNonColliding)
		self._objTakenToThrow = nil
	end
end




function Burned_one:OnCreateEntity()
	self._visibleParts = {}
	for i,v in self.s_SubClass.bodyParts do
		local cnt = table.getn(v)
		local no = math.random(1,cnt)
		if debugMarek then
			if cnt >= 5 then
				no = 5
			end
		end
		self._visibleParts[i] = no
		for j=1,cnt do
			if j ~= no then
				MDL.SetMeshVisibility(self._Entity, v[j], false)
			end
		end
	end
	
	local weapon = self._visibleParts[1]
	MDL.SetMeshVisibility(self._Entity, self.s_SubClass.bodyParts[1][weapon], false)
	self:BindFX("handdust")
	self:BindFX("handdust")
	self:BindFX("bodydust2")
	self:BindFX("bodydust1")
	self:BindFX("legdust2")
	self:BindFX("legdust1")

	self:BindSound("actor/mw_burned_one/burned-loop1",3,30,true)
	self:BindSound("actor/mw_burned_one/burned-loop2",3,30,true)
	self:BindSound("actor/mw_burned_one/burned-loop3",5,30,true)

end

function Burned_one:SetIdle(once)
	self:Stop()	
	local loop = true
	if once then
		loop = once
	end
	self:SetAnim(self.s_SubClass.idlesList[self._animMode], loop)
end

function Burned_one:CustomUpdate()
	if self._lastTimeChangeAnim + self._changeAnimIn < self._AIBrain._currentTime and not self._isWalking and not self._notIsWalkingTimer then
		self._changeAnimIn = FRand(20.0, 50.0)	-- sec.
		self._lastTimeChangeAnim = self._AIBrain._currentTime
	    self._animMode = math.random(1,6)
		self._forceWalkAnim = self.s_SubClass.walkList[self._animMode]
	end
end

function Burned_one:OnThrow()
		if self._objTakenToThrow then
			self._objTakenToThrow._throwed = 7
		end
end


function Burned_one:TakeMeat()
    local aiParams = self.AiParams
    local brain = self._AIBrain
	local x,y,z = self:GetJointPos(aiParams.throwItemBindTo)
	local e
	local obj
	local e,obj = AddItem(aiParams.ThrowableItem, nil, Vector:New(x,y,z), true)
	self._objTakenToThrow = obj

    brain._JointH = MDL.GetJointIndex(e, "root")
    MDL.SetPinnedJoint(e, brain._JointH, true)
    obj._pinnedJoint = brain._JointH
    self._proc = Templates["PBindJointToJoint.CProcess"]:New(self._Entity, self, aiParams.throwItemBindTo, brain._JointH, e)
    self._proc:Tick(0, true)
    --MDL.ApplyRotationToJoint(e, brain._JointH, FRand(0,6.28) , FRand(0,6.28), FRand(0,6.28))	-- chyba to nie dziala...?
	GObjects:Add(TempObjName(),self._proc)
end


function o:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Fire or type == AttackTypes.Fireball or type == AttackTypes.Lava or type == AttackTypes.FlameThrower then
        return true
    end
	return false
end


