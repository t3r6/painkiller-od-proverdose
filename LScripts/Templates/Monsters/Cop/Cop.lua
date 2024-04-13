function Cop:OnInitTemplate()
    self:SetAIBrain()
end

function Cop:OnCreateEntity()
	self._AIBrain._lastThrowTime = -100

end

function Cop:BindTrails()
self._tr1= self:BindTrail('trail_zombie','l_forearm','l_arm')
self._tr2= self:BindTrail('trail_zombie','r_forearm','r_arm')
end

function Cop:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end

function Cop:TakeMeat()
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

function o:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Demon then
        return false
    end

    if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "L_weapon"  then
            if type == AttackTypes.Shotgun or type == AttackTypes.MiniGun or type == AttackTypes.Painkiller or type == AttackTypes.Stake then
				self:PlaySound({"$/actor/maso/maso_hit_impact1","$/actor/maso/maso_hit_impact2"},22,52)
            end
			return true
		end
	else
		if type == AttackTypes.Physics then
			return false
		end
		if x and type == AttackTypes.Rocket then
			local x1,y1,z1 = self:GetJointPos("root")
			local dist = Dist3D(x,y,z,x1,y1,z1)
			Game:Print("odleglosc wybuchu od jointa : "..dist.." "..damage)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15
				return false, damage
			end
		end
	end
	return false
end

