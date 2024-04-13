function Hen_Gun_Bigger:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-3, 3)
	self._dontPinStake = true
end


function Hen_Gun_Bigger:OnThrow()
AddPFX('peri',0.3,Vector:New(self:GetJointPos("spawn")))	
end

function Hen_Gun_Bigger:OnCreateEntity()
	MDL.SetRagdollCollisionGroup(self._Entity, ECollisionGroups.HCGNormalNCWithSelf)
	ENTITY.PO_SetCollisionGroup(self._Entity, ECollisionGroups.HCGNormalNCWithSelf)
	--self:BindSound("actor/tank/tank-idle-loop",20,100,true)
	--self._moveSnd = nil
	self._turretSnd = nil
	self._turretSound = nil
	self._lastAngleAttackX = 0
	self._barrelPitch = 0
	self._sph={}
    self._disableGibSound = true
	----self:BindFX("pochodnia",0.3,"lufa",0,0.6,-5.6)
	--if debugMarek then ENTITY.PO_EnableGravity(self._Entity, false) end
	self:AddTimer("pin",1.0)
	local count = 1
	for i,v in self.Houses do
		local obj = AddObject("Spawn.CSpawnPoint",nil,v.pos,nil,true)
		obj.SpawnTemplate = "Hen_Gun_Charger.CActor"
		obj.SpawnFX = "MonsterSpawnFromGround.CAction"
		obj.NotCountable = true
		obj.StartDelay = 0
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
	        obj:Apply()
	        obj:OnLaunch()
		v.obj=obj
	end
end

function Hen_Gun_Bigger:pin()
    ENTITY.PO_SetPinned(self._Entity, true)
    self:ReleaseTimers()
end


function Hen_Gun_Bigger:OnTick(delta)
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

function Hen_Gun_Bigger:RotateToVector(tx,ty,tz)
	self._angleDest = math.atan2(tx - self._groundx, tz - self._groundz)
	self:RotHen_Gun_Bigger()
end

function Hen_Gun_Bigger:RotHen_Gun()
	local angDest = AngDist(self.angle, self._angleDest)
	local angDest2 = AngDist(self.angle, self._angleDest + math.pi)
	if math.abs(angDest2) < math.abs(angDest) then
		self._angleDest = self._angleDest + math.pi
	end
	self._isRotating = true
end

function Hen_Gun_Bigger:Rotate(ang)
	self._angleDest = math.mod(self.angle + ang * math.pi/180, math.pi*2)
	self:RotHen_Gun_Bigger()
end

function Hen_Gun_Bigger:RotateTo(ang)
	self._angleDest = math.mod(ang * math.pi/180, math.pi*2)
	self:RotHen_Gun_Bigger()
end




function Hen_Gun_Bigger:Charge()
	--Game:Print("charge!")
	if self.Health < self._HealthMax then
		for i,v in self._chickens do
			if v.Health > 0 then
				self.Health = self.Health + self._HealthMax * 1/6
			end
		end
	end
	if self.Health > self._HealthMax then
		self.Health = self._HealthMax
	end
end

function Hen_Gun_Bigger:Render(delta)
	if self.dorender then
	local t = Templates["DriverElectro.CWeapon"]
	if not self._died then
		for i,v in self.Houses do
			if v.obj and v.obj._SpawnedMonsters[1] and  not v.obj._SpawnedMonsters[1]._died then
				self._points = {}
				self._points[1]= Vector:New(self:GetJointPos("spawn"))
				self._points[2]= Vector:New(v.obj._SpawnedMonsters[1]:GetJointPos("spawn"))
				t:DrawBezierLine(self._points,10,3, FRand(0.3, 0.4), R3D.RGB(FRand(175,200),FRand(15,25),FRand(10,15)))
				t:DrawBezierLine(self._points,10,3, FRand(0.3, 0.4), R3D.RGB(FRand(175,200),FRand(15,25),FRand(10,15)))
				t:DrawBezierLine(self._points,10,3, FRand(0.3, 0.4), R3D.RGB(FRand(175,200),FRand(15,25),FRand(10,15)))
				t:DrawBezierLine(self._points,10,3, FRand(0.3, 0.4), R3D.RGB(FRand(175,200),FRand(15,25),FRand(10,15)))
				t:DrawBezierLine(self._points,10,3, FRand(0.3, 0.4), R3D.RGB(FRand(175,200),FRand(15,25),FRand(10,15)))
			end
		end
	end
end

end
Hen_Gun_Bigger._CustomAiStates.Chargeme = {
	name = "Chargeme",
	active= false,
}

function Hen_Gun_Bigger._CustomAiStates.Chargeme:OnInit(brain)
	local actor = brain._Objactor
	self.active = true
	actor.Immortal=true
	self.timer = 60
	actor.dorender = true
	actor.chargecloud=actor:BindFX("House_charge",4,"leg_up",0,7,0)
end

function Hen_Gun_Bigger._CustomAiStates.Chargeme:OnUpdate(brain)
	local actor = brain._Objactor
	self.timer = self.timer - 1
	if self.timer < 0 then self.active= false end
	actor.Health=actor.Health + (actor.MaxHealth - actor.ChargeHealth)/240
	if actor.Health > actor.MaxHealth then actor.Health = actor.MaxHealth end
end



function Hen_Gun_Bigger._CustomAiStates.Chargeme:OnRelease(brain)
	local actor = brain._Objactor
	actor.Immortal=false
	actor.dorender = false 
	PARTICLE.Die(actor.chargecloud)
end

function Hen_Gun_Bigger._CustomAiStates.Chargeme:Evaluate(brain)
	local actor = brain._Objactor
	local charge =false
	if self.active or (actor.Health < actor.ChargeHealth)  then 
		for i,v in actor.Houses do
			if v.obj and v.obj._SpawnedMonsters[1] and not v.obj._SpawnedMonsters[1]._died then charge =true end
		end
		if charge then
			return 0.8
		end
	end
	return 0.1
end


