function Pig_Avenger:OnInitTemplate()
    self:SetAIBrain()
end

function Pig_Avenger:OnCreateEntity()
--	self:BindFX('bd')
	self._AIBrain._lastThrowTime = -100
	self:BindSound("actor/mw_pig_avenger/pig_loop",2,20,true)

end

function Pig_Avenger:BindTrails()
self._tr1= self:BindTrail('trail_zombie','l_forearm','l_arm')
self._tr2= self:BindTrail('trail_zombie','r_forearm','r_arm')
end

function Pig_Avenger:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end
function Pig_Avenger:OnThrow()
	if self._objTakenToThrow then
			self._objTakenToThrow._throwed = 7
	end
end

function Pig_Avenger:TakeMeat()
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
	self._throwModeRagdoll = true
end

function o:CustomOnDeath()

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
