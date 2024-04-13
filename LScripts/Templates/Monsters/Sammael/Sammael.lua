function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity()
	self._AIBrain._lastThrowTime = FRand(-4, -1)
	self._AIBrain._lastExplode = FRand(-4, -1)
	self._nextexplode=1
	self:BindSound("actor/mw_sammael/sammael_wings",8,30,true)
ENTITY.PO_EnableGravity(self._Entity,false)
	self._flyWithAngle = true
    self.Retreattag = false
    MDL.SetMeshVisibility(self._Entity,"soutaneSShape_add",false)
    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape16_add",false)
    MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape4_add",false)
    MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape5_add",false)
    MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape6_add",false)
    MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape4_add",false)
    MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape5_add",false)
    MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape6_add",false)
    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape21_add",false)
    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape23_add",false)
    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape31_add",false)
    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape25_add",false)
    self:BindSwordFlames()
	Game.MegaBossHealthMax = self.Health
	Game.MegaBossHealth = self.Health
	Game.Samael= true
	local	l = self.s_SubClass.BillBoard
		if l then
			local obj = CloneTemplate(l.template)
			if l.offset then obj.Pos:Set(l.offset.X,l.offset.Y,l.offset.Z) 
			else
			obj.Pos:Set(1.0,0.0,-0.1)
			end
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill = obj
		end
	l = self.s_SubClass.Light
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(1.0,0.0,-0.1)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedLight = obj
		end

end

function o:BindSwordFlames()
  self._swfl1=self:BindFX("swflames1")
  self._swfl2=self:BindFX("swflames2")
  self._swfl3=self:BindFX("swflames3")
  self._swfl4=self:BindFX("rootflame2")
end



function o:EndSwordFlames()
PARTICLE.Die(self._swfl1)
PARTICLE.Die(self._swfl2)
PARTICLE.Die(self._swfl3)
PARTICLE.Die(self._swfl4)
end

function o:CustomOnDamage(he,x,y,z,obj, damage, type)
   if self.Health < damage  then
	    self.Immortal = true
		Game.Samael= false
        	Game.MegaBossHealth = nil
	    self.Retreattag = true
	    Game.MegaBossHealthMax = nil
	    return true
    end
    if type == AttackTypes.Demon then
        return true
    end

    if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "l_wing1" or jName == "r_wing1" or jName == "k_szyja" then
			return false
		end
	else
	if type == AttackTypes.Physics then
			return false
		end
	if x and type == AttackTypes.Rocket then
		for ii,iv in self.vulnjoints do
			local x1,y1,z1 = self:GetJointPos(self.vulnjoints[ii])
			local dist = Dist3D(x,y,z,x1,y1,z1)
			Game:Print("odleglosc wybuchu od jointa : "..dist.." "..damage)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15*self.Explosionmodifier
				return false, damage
			end
		end
	end

    end

return true
end

function o:CustomUpdate()
	if not self._died then
		local brain = self._AIBrain
		Game.MegaBossHealth = self.Health
	end
end

function o:OnThrow(aX, aY,aZ, angle, pitch)

	if math.random(100) < 50 then
	self.AiParams.throwAnim = "fireball"	
	self.AiParams.throwRangeMin = 1
	self.AiParams.throwRangeMax = 300
	self.AiParams.ThrowableItem = "Sammael_Fireball.CItem"
	self.AiParams.throwVelOnly = true
	self.AiParams.throwDistMinus = 0
	self.AiParams.ThrowSpeed = 10
	self.AiParams.throwVelocity = 40
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	else
	self.AiParams.throwAnim = "swarm"	
	self.AiParams.throwRangeMin = 1
	self.AiParams.throwRangeMax = 400
	self.AiParams.ThrowableItem = "Sammael_Swarm.CActor"
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	end

end

o._CustomAiStates = {}

o._CustomAiStates.FlyingIdle = {
	name = "FlyingIdle",
	active = false,
	flyPoints = {},
	once = false,
	lastPoint = nil,
    timer = 0,
    }

function o._CustomAiStates.FlyingIdle:OnInit(brain)			-- dodac delay pomiedzy atakami
	self._notMoving = 0
end

function o._CustomAiStates.FlyingIdle:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams

	if actor.Animation == "fly" and actor._isAnimating then
		return
	end

	if actor._flying then
		if brain._seeEnemy and brain._distToNearestEnemy < aiParams.throwRangeMax and brain._distToNearestEnemy > aiParams.throwRangeMin then
			if brain._lastThrow + aiParams.minDelayBetweenThrow < brain._currentTime then
				local angle = actor.angle
				local v = Vector:New(brain.r_closestEnemy._groundx - actor._groundx, 0, brain.r_closestEnemy._groundz - actor._groundz)
				v:Normalize()
				local angleToPlayer = math.atan2(v.X, v.Z)
				local aDist = AngDist(angle, angleToPlayer)
				if math.abs(aDist) < aiParams.throwMaxAngleYawDiff * 3.14/180 then
					 actor:Stop()
					actor:RotateToVector(brain.r_closestEnemy._groundx,0,brain.r_closestEnemy._groundz)
					actor:SetAnim("fly",false)
					brain._lastThrow = brain._currentTime + FRand(0, 0.5)
					return
				end

				
			end
		end

		local zakres = actor._SphereSize * 0.6

		local rnd1 = FRand(-zakres, zakres)
		local rnd2 = FRand(-zakres, zakres)
		local rnd3 = FRand(-zakres, zakres)
		local v = Vector:New(0,0,0)
		local v2 = Vector:New(0,1,0)

		if self._lastPos then
			v2 = Vector:New(self._lastPos.X - actor.Pos.X,self._lastPos.Y - actor.Pos.Y,self._lastPos.Z - actor.Pos.Z)
			v = Vector:New(math.sin(actor._angleDest), 0, math.cos(actor._angleDest))
			v:Normalize()
			local zakres = actor._SphereSize * 0.6

		end
		self._lastPos = Clone(actor.Pos)
		self.timer = self.timer - 1
		if self.timer < 0 then
			if true then
				self.timer = aiParams.traceSpeed1
		
				ENTITY.RemoveRagdollFromIntersectionSolver(actor._Entity)
				local b,d,x,y,z,nx,ny,nz = WORLD.LineTrace(actor._groundx+rnd1,actor.Pos.Y+rnd2,actor._groundz+rnd3,
					actor._groundx+rnd1+v.X*3.0, actor.Pos.Y+rnd2+v.Y*3.0, actor._groundz+rnd3+v.Z*3.0)
				if d then
					local mul = FRand(2.0, 2.2)
					if math.random(100) < 50 then
						actor:FlyTo(x + nx*mul,y + ny*mul ,z + nz*mul, nil,nil,nil, 20)
					else
						actor:FlyForward(-mul*FRand(1,2), FRand(-30,30), FRand(-2,2),nil,true)
						return
					end
				end
			end
			if v2:Len() < 0.01 then
				self._notMoving = self._notMoving + 1
				if self._notMoving == 4 then
					actor:Stop()
				end
			else
				self._notMoving = 0
			end
			ENTITY.AddRagdollToIntersectionSolver(actor._Entity)
		end
	else
	
		self._notMoving = 0
		self.timer = -1
	
		if brain._distToNearestEnemy > 40 then
			local heig = 0
			if brain._distToNearestEnemy > 60 then
				actor._randomizedParams.FlySpeed = FRand(actor.FlySpeed * 2, actor.FlySpeed * 3)
			else
				actor._randomizedParams.FlySpeed = FRand(actor.FlySpeed * 1, actor.FlySpeed * 2)
			end
			actor:FlyTo(brain._enemyLastSeenPoint.X, brain._enemyLastSeenPoint.Y + heig, brain._enemyLastSeenPoint.Z, nil,nil,nil, 30)
			self.flyrandcnt = 0
		else

			actor._randomizedParams.FlySpeed = FRand(actor.FlySpeed * 0.9, actor.FlySpeed * 1.1)
			if brain._seeEnemy then
				actor:FlyTo(brain._enemyLastSeenPoint.X + FRand(-18,18), brain._enemyLastSeenPoint.Y + FRand(-1,5)+ aiParams.keepMinHeight, brain._enemyLastSeenPoint.Z + FRand(-18,18), nil,nil,nil, 30)
			else
				actor:FlyTo(brain._enemyLastSeenPoint.X + FRand(-8,8), brain._enemyLastSeenPoint.Y + FRand(-1,2)+ aiParams.keepMinHeight, brain._enemyLastSeenPoint.Z + FRand(-8,8), nil,nil,nil, 30)
			end
		
		end
	end
end


function o._CustomAiStates.FlyingIdle:Evaluate(brain)
	return 0.11
end

o._CustomAiStates.Retreat = {
	name = "Retreat",
	active = false,
	state=0
    }


function o._CustomAiStates.Retreat:Evaluate(brain)
	local actor = brain._Objactor
	if actor.Retreattag or self.active then
		return 0.9
	end
		return 0.01
end

function o._CustomAiStates.Retreat:OnUpdate(brain)
	local actor = brain._Objactor
	if actor.Animation ~= "summon" then
		for i,v in Actors do
			if v.Health > 0 and v.Model ~= "ghost" and v.Model ~= "sammael" then
				local obj = GObjects:Add(TempObjName(),CloneTemplate("Ghost_sammael.CActor"))
				obj.Pos.X = actor.Pos.X
				obj.Pos.Y = actor.Pos.Y
				obj.Pos.Z = actor.Pos.Z
				obj.angle = actor.angle
				obj._angleDest = actor._angleDest
				obj.Destpos.X = v.Pos.X
				obj.Destpos.Y = v.Pos.Y
				obj.Destpos.Z = v.Pos.Z
				obj:Apply()
				if obj.TimeToLive then
					obj.TimeToLive = FRand(obj.TimeToLive * 0.9, obj.TimeToLive * 1.1)
				end
				obj:Synchronize()
			end
		end
		GObjects:ToKill(actor)
    MDL.SetMeshVisibility(actor._Entity,"soutaneSShape_add",true)
    MDL.SetMeshVisibility(actor._Entity,"polySurfaceShape16_add",true)
    MDL.SetMeshVisibility(actor._Entity,"r_polySurfaceShape4_add",true)
    MDL.SetMeshVisibility(actor._Entity,"r_polySurfaceShape5_add",true)
    MDL.SetMeshVisibility(actor._Entity,"r_polySurfaceShape6_add",true)
    MDL.SetMeshVisibility(actor._Entity,"l_polySurfaceShape4_add",true)
    MDL.SetMeshVisibility(actor._Entity,"l_polySurfaceShape5_add",true)
    MDL.SetMeshVisibility(actor._Entity,"l_polySurfaceShape6_add",true)
    MDL.SetMeshVisibility(actor._Entity,"polySurfaceShape21_add",true)
    MDL.SetMeshVisibility(actor._Entity,"polySurfaceShape23_add",true)
    MDL.SetMeshVisibility(actor._Entity,"polySurfaceShape31_add",true)
    MDL.SetMeshVisibility(actor._Entity,"polySurfaceShape25_add",true)
		actor._randomizedParams.FlySpeed = FRand(actor.FlySpeed * 2, actor.FlySpeed * 3)
		if self.state == 1 then
			if Dist3D(actor.retreatpoints[1].X,actor.retreatpoints[1].Y,actor.retreatpoints[1].Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 1 then
				self.state=2
			else
				actor:FlyTo(actor.retreatpoints[1].X,actor.retreatpoints[1].Y,actor.retreatpoints[1].Z)
			end
		elseif self.state == 2 then
			if Dist3D(actor.retreatpoints[2].X,actor.retreatpoints[2].Y,actor.retreatpoints[2].Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 1 then
				self.state=3
			else
				actor:FlyTo(actor.retreatpoints[2].X,actor.retreatpoints[2].Y,actor.retreatpoints[2].Z)
			end
		elseif self.state == 3 then
			if Dist3D(actor.retreatpoints[3].X,actor.retreatpoints[3].Y,actor.retreatpoints[3].Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 5 then
				self.active=false
				actor.Immortal = false
				GObjects:ToKill(actor)
			else
				actor:FlyTo(actor.retreatpoints[3].X,actor.retreatpoints[3].Y,actor.retreatpoints[3].Z)
			end
		end
	end

end

function o._CustomAiStates.Retreat:OnInit(brain)
	local actor = brain._Objactor
	self.active=true
	self.state=1
	local aiParams = actor.AiParams
	actor:SetAnim("summon",false)

end
o._CustomAiStates.Comeback = {
	name = "Comeback",
	active = false,
	state=0
    }


function o._CustomAiStates.Comeback:Evaluate(brain)
	local actor = brain._Objactor
	if actor.Comebacktag or self.active then
		return 0.9
	end
		return 0.01
end

function o._CustomAiStates.Comeback:OnUpdate(brain)
	local actor = brain._Objactor
		actor._randomizedParams.FlySpeed = FRand(actor.FlySpeed * 2, actor.FlySpeed * 3)
		if self.state == 1 then
			if Dist3D(actor.comebackpoints[3].X,actor.comebackpoints[3].Y,actor.comebackpoints[3].Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 5 then
				self.state=2
			else
				actor:FlyTo(actor.comebackpoints[3].X,actor.comebackpoints[3].Y,actor.comebackpoints[3].Z)
			end
		elseif self.state == 2 then
			if Dist3D(actor.comebackpoints[2].X,actor.comebackpoints[2].Y,actor.comebackpoints[2].Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 1 then
				self.state=3
			else
				actor:FlyTo(actor.comebackpoints[2].X,actor.comebackpoints[2].Y,actor.comebackpoints[2].Z)
			end
		elseif self.state == 3 then
			if Dist3D(actor.comebackpoints[1].X,actor.comebackpoints[1].Y,actor.comebackpoints[1].Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 5 then
				self.active=false
				actor.Comebacktag=false
			else
				actor:FlyTo(actor.comebackpoints[1].X,actor.comebackpoints[1].Y,actor.comebackpoints[1].Z)
			end
		end

end

function o._CustomAiStates.Comeback:OnInit(brain)
	local actor = brain._Objactor
	self.active=true
	self.state=1

end


o._CustomAiStates.Change = {
	name = "Change",
	active = false,
	state=0
    }


function o._CustomAiStates.Change:Evaluate(brain)
	local actor = brain._Objactor
	if actor.Retreattag or self.active then
		return 0.9
	end
		return 0.01
end

function o._CustomAiStates.Change:OnUpdate(brain)
	local actor = brain._Objactor
	if actor.Animation ~= "angry" then
				GObjects:ToKill(actor)
	end

end

function o._CustomAiStates.Change:OnInit(brain)
	local actor = brain._Objactor
	self.active=true
	self.state=1
	local aiParams = actor.AiParams
	actor:SetAnim("angry",false)

end


o._CustomAiStates.Explodeearth = {
	name = "Explodeearth",
	active = false,
    timer = 0,
    }

function o._CustomAiStates.Explodeearth:OnInit(brain)
	local actor = brain._Objactor
	 brain._lastExplode = brain._currentTime
	 actor:SetAnim("firerain",false)
	 self.active=true
end
function o._CustomAiStates.Explodeearth:OnUpdate(brain)
	local actor = brain._Objactor
	if actor.Animation ~= "firerain" then
	 	actor._vulnerable =  true
		actor:EndSwordFlames()
		self.active= false
	end
end
function o._CustomAiStates.Explodeearth:OnRelease(brain)
end
function o._CustomAiStates.Explodeearth:Evaluate(brain)
	local actor = brain._Objactor
	if self.active or brain._lastExplode + actor._explodedelay + actor._earthexplodetime < brain._currentTime then
		return 0.8
	end
	return 0.1
end
