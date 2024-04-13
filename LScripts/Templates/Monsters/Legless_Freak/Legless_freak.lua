function Legless_freak:OnInitTemplate()
    self:SetAIBrain()
end



function Legless_freak:OnCreateEntity()
    self._AIBrain._lastThrowTime = FRand(-5, 1) 
    if debugMarek then
		self._AIBrain._lastThrowTime = -100
    end
    self._AIBrain._lastRollTime = -100
end


function Legless_freak:TakeMeat()
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
self:BindFX('blooddrop')
end


function o:CustomOnDeath()
if self._objTakenToThrow then
		GObjects:ToKill(self._objTakenToThrow)

	end
end

function Legless_freak:SetnextThrow()

	if math.random(100) < 50 then
	self._throwModeRagdoll = true
	self.AiParams.throwAnim = "a3"	
	self.AiParams.throwRangeMin = 5
	self.AiParams.throwRangeMax = 30
	self.AiParams.ThrowableItem = "meat.CItem"
	self.AiParams.throwAngularVelocitySpeed = 20
	self.AiParams.throwAngle = 30
	self.AiParams.throwDistMinus = 0
	self.AiParams.ThrowSpeed = 30
	self.AiParams.throwVelOnly = false
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	else
	self._throwModeRagdoll = false
	self.AiParams.throwAnim = "a1"	
	self.AiParams.throwRangeMin = 5
	self.AiParams.throwRangeMax = 400
	self.AiParams.ThrowableItem = "GlowBall.CItem"
	self.AiParams.throwItemBindToOffset = Vector:New(0,4,0)
	--	self.AiParams.throwAngle = -1
	self.AiParams.throwVelOnly = true
	self.AiParams.throwDistMinus = 0
	self.AiParams.ThrowSpeed = 10
	self.AiParams.throwVelocity = 10
	end

end
function Legless_freak:OnThrow()
	if self._objTakenToThrow then
			self._objTakenToThrow._throwed = 7
	end
end


function Legless_freak:Glowhand()
	self._handglow=self:BindFX('Handglow')
end

function Legless_freak:Dieglow()
	PARTICLE.Die(self._handglow)
end
