function Hen_Gun:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-3, 3)
	self._dontPinStake = true
end


function Hen_Gun:OnThrow()
AddPFX('peri2',0.2,Vector:New(self:GetJointPos("spawn")))
--AddPFX('Butcher_blood_small',2,Vector:New(self:GetJointPos("spawn")))
	
end

function Hen_Gun:OnCreateEntity()
	MDL.SetRagdollCollisionGroup(self._Entity, ECollisionGroups.HCGNormalNCWithSelf)
	ENTITY.PO_SetCollisionGroup(self._Entity, ECollisionGroups.HCGNormalNCWithSelf)
	--self:BindSound("actor/tank/tank-idle-loop",20,100,true)
	--self._moveSnd = nil
	self._turretSnd = nil
	self._turretSound = nil
	self._lastAngleAttackX = 0
	self._barrelPitch = 0
    self._disableGibSound = true
	----self:BindFX("pochodnia",0.3,"lufa",0,0.6,-5.6)
	--if debugMarek then ENTITY.PO_EnableGravity(self._Entity, false) end
	self:AddTimer("pin",1.0)
end

function Hen_Gun:pin()
    ENTITY.PO_SetPinned(self._Entity, true)
    self:ReleaseTimers()
end


function Hen_Gun:OnTick(delta)
	if self._AIBrain.r_closestEnemy and Player then
		local brain = self._AIBrain
		local joint = MDL.GetJointIndex(self._Entity, "leg_up")
		local x,y,z = MDL.TransformPointByJoint(self._Entity,joint,0,0,0)	--0,0.6,-5.6)
		local v = Vector:New(Player._groundx - x, Player._groundy + 1.2 - y, Player._groundz - z)
		v:Normalize()
		local angleToPlayer = math.atan2(v.Z, v.X)
--MDL.ApplyJointRotation(self._Entity, joint,0,0,angleToPlayer)	
		
--		self:RotateToVector(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz)
	end

end

function Hen_Gun:RotateToVector(tx,ty,tz)
	self._angleDest = math.atan2(tx - self._groundx, tz - self._groundz)
	self:RotHen_Gun()
end

function Hen_Gun:RotHen_Gun()
	local angDest = AngDist(self.angle, self._angleDest)
	local angDest2 = AngDist(self.angle, self._angleDest + math.pi)
	if math.abs(angDest2) < math.abs(angDest) then
		self._angleDest = self._angleDest + math.pi
	end
--[[	if angDest > math.pi/2 then
		Game:Print(self._Name.." +a")	-- to zle
		self._angleDest = math.pi - self._angleDest
	end
	if angDest < -math.pi/2 then
		Game:Print(self._Name.." +b")
		self._angleDest = math.pi + self._angleDest
	end--]]
	self._isRotating = true
end

function Hen_Gun:Rotate(ang)
	self._angleDest = math.mod(self.angle + ang * math.pi/180, math.pi*2)
	self:RotHen_Gun()
end

function Hen_Gun:RotateTo(ang)
	self._angleDest = math.mod(ang * math.pi/180, math.pi*2)
	self:RotHen_Gun()
end




--------------------------------------

Hen_Gun._CustomAiStates = {}

Hen_Gun._CustomAiStates.FireHen = {
	name = "FireHen",
    delayRandom = 1,
}

function Hen_Gun._CustomAiStates.FireHen:OnInit(brain)
local actor = brain._Objactor
actor:ForceAnim("atak", true)
end

function Hen_Gun._CustomAiStates.FireHen:OnUpdate(brain)
--[[	local actor = brain._Objactor
	local aiParams = actor.AiParams
    if brain.r_closestEnemy and not self.delay then
		local actor = brain._Objactor
		local aiParams = actor.AiParams
        if brain._lastThrowTime + self.delayRandom + aiParams.minDelayBetweenThrow < brain._currentTime then
			if aiParams.throwAmmo > 0 then
				if brain._distToNearestEnemy < aiParams.throwRangeMax and brain._distToNearestEnemy > aiParams.throwRangeMin then
					self.delay = 9 
				end
			end
		end
	end
	
	if self.delay then
		self.delay = self.delay - 1
		if self.delay == 1 then
			local e
			local idx  = MDL.GetJointIndex(actor._Entity, "house_p4")
			local q = Quaternion:New_FromEuler(0, -actor._angleAttackX - actor.angle + math.pi/2, math.pi/2)
			local x,y,z = MDL.TransformPointByJoint(actor._Entity, idx, 0,-5,0)
			e, actor._objTakenToThrow = AddItem(aiParams.ThrowableItem, nil, Vector:New(x,y,z),true,q)

			actor._objTakenToThrow.ObjOwner = actor
			actor:BindFX("shot")

			self.lockedAngle = actor._angleAttackX
			ENTITY.PO_Enable(e,false)
		end
		if self.delay <= 0 then
			self.delay = nil
			actor:PlaySound({"$/actor/tank/tank-shoot1","$/actor/tank/tank-shoot2"},80,120)
			actor:ThrowTaken(math.pi/2 - self.lockedAngle - actor.angle)
			brain._lastThrowTime = brain._currentTime
			self.delay = nil
            self.delayRandom = FRand(0.0,1.0)
            brain._lastThrowTime = brain._currentTime 
		end
	end--]]
end

function Hen_Gun._CustomAiStates.FireHen:OnRelease(brain)
end

function Hen_Gun._CustomAiStates.FireHen:Evaluate(brain)
	return 0.1
end

