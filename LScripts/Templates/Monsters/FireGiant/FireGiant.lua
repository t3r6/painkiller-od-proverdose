function o:OnInitTemplate()
    self:SetAIBrain()
    self._disableHits = true
    self._hitsCounter = 0
    self._AIBrain._lastThrowTime = FRand(-4, -1)
    self._AIBrain._lastTimeRaid =  FRand(-4, -1)
end

function o:OnCreateEntity()
	self.FLX=self:BindFX('flame')
end

function o:eflame()
	PARTICLE.Die(self.FLX)
end


function o:OnPrecache()
	Cache:PrecacheParticleFX("Snow_Giant_Flame")
	Cache:PrecacheParticleFX("Snow_Giant_hitground")
	Cache:PrecacheParticleFX("Snow_Giant_blast")
	Cache:PrecacheParticleFX("Snow_Giant_Flame2")
	Cache:PrecacheParticleFX("Snow_Giant_Walk")
	Cache:PrecacheParticleFX("Snow_Giant_breath")
end

function o:Throw()
	if self._AIBrain and self._AIBrain._enemyLastSeenTime > 0 then
		local aiParams = self.AiParams
		local obj = GObjects:Add(TempObjName(),CloneTemplate(aiParams.ThrowableItem))
		self.Joint = MDL.GetJointIndex(self._Entity, aiParams.throwItemBindTo)
	    local x,y,z = MDL.TransformPointByJoint(self._Entity,self.Joint,aiParams.throwItemBindToOffset.X,aiParams.throwItemBindToOffset.Y, aiParams.throwItemBindToOffset.Z)

		obj.ObjOwner = self
		obj.Pos.X = x
		obj.Pos.Y = y
		obj.Pos.Z = z

		local v = Vector:New(Player._groundx - x, 0, Player._groundz - z)
		v:Normalize()
		
		local angleToPlayer = -math.atan2(v.X, v.Z)
		
		local aDist = AngDist(self.angle, angleToPlayer)
		--Game:Print("dist Angles = "..(aDist*180/3.14))
		if math.abs(aDist) > 30 * 3.14/180 then
			--Game:Print("z orienacji")
			v = Vector:New(math.sin(self.angle), 0, math.cos(self.angle))
			v:Normalize()
		end

--		self:BindFX("fire")

		local distToPlayer = Dist3D(x,0,z, Player._groundx, 0, Player._groundz)
		v.X = v.X * distToPlayer
		v.Y = v.Y * distToPlayer
		v.Z = v.Z * distToPlayer

        obj.PosDest = {}
        obj.PosDest.X = v.X + x
        obj.PosDest.Z = v.Z + z
		obj.PosDest.Y = Player._groundy + 1.7
	Game:Print("angle="..self.angle)	
		obj.Rot:FromEuler(0, math.pi-self.angle, 0)
		obj._RotAngle = self.angle
		obj:Apply()

		obj:Synchronize()
		--self._AIBrain._AxethrowedRight = true
		
	end
end



function o:CustomOnHit()
	if not self.s_SubClass.Hits then return end
	self._hitsCounter = self._hitsCounter + 1
	if self._hitsCounter >= 4 and not self._isRotating then
		self._hitsCounter = 0

		if not self._speeded then
			self._randomizedParams.WalkSpeed = self._randomizedParams.WalkSpeed * 1.1
			self._speeded = true
		end

		local animName = self.s_SubClass.Hits[math.random(1,table.getn(self.s_SubClass.Hits))]
						
		if not self.AIenabled and self._isAnimating then
			self._animationBeforeHit = self.Animation
		end
		if self:ForceAnim(animName, false) then
			self._lastHitAnim = animName
			self._hitDelay = self.minimumTimeBetweenHitAnimation
			if not self._hitDelay then
				self._hitDelay = 4
			end
			if self.AIenabled then
				self:Stop()
			else
				self._hitDelay = 99999	-- az do zakonczenia animacji
			end
		end
	end
	if self._firstflame then
		 PARTICLE.Die(self._firstflame)
		 PARTICLE.Die(self._sflame)
		 PARTICLE.Die(self._tflame)
		 self._tflame=nil
		 self._sflame=nil
		 self._firstflame=nil
	end
	
end

o._CustomAiStates = {}
o._CustomAiStates.Icicle = {
	name = "Icicle",
}


function o._CustomAiStates.Icicle:OnInit(brain)
	local actor = brain._Objactor
	actor:Stop()
	self.active = true
	actor:SetAnim("atak3", false)
end

function o._CustomAiStates.Icicle:OnUpdate(brain)
	local actor = brain._Objactor
	if actor.Animation ~= "atak3" or not actor._isAnimating then
		self.active = false
		brain._lastTimeRaid = brain._currentTime + FRand(0,actor.AiParams.timeBetweenRaids*0.3)
	end
end

function o._CustomAiStates.Icicle:OnRelease(brain)
	local actor = brain._Objactor
end

function o._CustomAiStates.Icicle:Evaluate(brain)
	if self.active then
		return 0.65
	end
	local actor = brain._Objactor
	if brain.r_closestEnemy and not actor._state ~= "ATTACKING" then
		if brain._lastTimeRaid + actor.AiParams.timeBetweenRaids < brain._currentTime then
			if brain._distToNearestEnemy > actor.AiParams.minDistToPlayerRaid then
				--Game:Print((brain._lastTimeRaid + actor.AiParams.timeBetweenRaids).." !!!! "..brain._currentTime)
			    return 0.7
			end
        end
	end
	return 0
end



function o:Quake()
Game._EarthQuakeProc:Add(self.Pos.X, self.Pos.Y, self.Pos.Z, 2*30, 10 , 0.2, 0.2, 1.0)
end


function o:Skycicle()
	local v = Vector:New(Player._groundx, Player._groundy + self.Icicleheight,  Player._groundz)
	local number = FRand(3,7)
	local i = 0
	while (i < number) do
		local v = Vector:New(Player._groundx+FRand(-4,4), Player._groundy + self.Icicleheight+FRand(0,8),  Player._groundz+FRand(-4,4))
		local ke,obj = AddItem("lavaRain_item.CItem",FRand(2,5),v,true)
		 obj._desiredVel = Vector:New(0, 50, 0)
		 obj.Rot:FromNormalZ(0,1,0)
 		obj:Apply()
		obj:Synchronize()
	i=i+1
	end 
		local v = Vector:New(Player._groundx, Player._groundy + self.Icicleheight,  Player._groundz)
		local ke,obj = AddItem("lavaRain_item.CItem",FRand(2,5),v,true)
		 obj._desiredVel = Vector:New(0, 50, 0)
		 obj.Rot:FromNormalZ(0,1,0)
 		obj:Apply()
		obj:Synchronize()

	
end


function o:StartFlames()
if not self._firstflame then
	self._firstflame=self:BindFX('bodyfire')
	self._sflame=self:BindFX('lhfire')
	self._tflame=self:BindFX('rhfire')
end
	
end


function o:EndFlames()
if self._firstflame then
 PARTICLE.Die(self._firstflame)
 PARTICLE.Die(self._sflame)
 PARTICLE.Die(self._tflame)
 self._tflame=nil
 self._sflame=nil
 self._firstflame=nil
end
end

function o:CustomOnDeath()
if self._firstflame then
	PARTICLE.Die(self._firstflame)
	PARTICLE.Die(self._sflame)
	PARTICLE.Die(self._tflame)
end
end
