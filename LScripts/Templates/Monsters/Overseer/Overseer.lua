function Overseer:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-3, 3)
end

function Overseer:OnPrecache()
    Cache:PrecacheParticleFX(self.AiParams.ragdollThrowFX)
    Cache:PrecacheParticleFX(self.AiParams.bindedRagdollFX.name)
end

function Overseer:CustomOnDeath()
	if self._rtfx then
		PARTICLE.Die(self._rtfx)
		self._rtfx = nil
	end
	ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
	local brain = self._AIBrain
	if brain.Objhostage2 then
		MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, false)
		brain.Objhostage2._locked = nil
		brain.Objhostage2._pinnedByAI = nil
		brain.Objhostage2 = nil
		if self._bindedRagdollFX then
			for i,v in self._bindedRagdollFX do
				PARTICLE.Die(v)
			end
			self._bindedRagdollFX = nil
		end
		if self._bindedRagdollSound then
			local e = ENTITY.GetPtrByIndex(self._bindedRagdollSound)
			if e then
				ENTITY.Release(e)
			end
			self._bindedRagdollSound = nil
		end
	end
end

function Overseer:CustomOnGib()
end

function o:OnCreateEntity()
self:BindSound("actor/mw_overseer/chain",4,30,true)
	self.__oc=0
end

function o:Wav()
	MDL.SetMeshVisibility(self._Entity,"ToolsShape",false)
--	MDL.SetMeshVisibility(self._Entity,"Chain_2sidedShape",false)
	self.weaponaway = true
end


function Overseer:GetThrowItemRotation()
	local q = Quaternion:New()
	q:FromEuler( 0, -self.angle, math.pi/2)
	self._AIBrain._throwed = true
	return q
end

function Overseer:Take()
	--Game:Print("start trzymania: take")
    local brain = self._AIBrain
    if brain.Objhostage2 then
        local aiParams = self.AiParams
        
        local x,y,z = self:GetJointPos(aiParams.holdJointSrc)
        local x2,y2,z2 = brain.Objhostage2:GetJointPos(aiParams.holdJointDst)
        brain._JointH = MDL.GetJointIndex(brain.Objhostage2._Entity, aiParams.holdJointDst)
        
        if brain._JointH > 0 then
			if debugMarek then
				self.DEBUGl4 = x
				self.DEBUGl5 = y
				self.DEBUGl6 = z

				self.DEBUGl1 = x2
				self.DEBUGl2 = y2
				self.DEBUGl3 = z2
			end

			MDL.SetRagdollLinearDamping(brain.Objhostage2._Entity, aiParams.hostagesRagdollDamping)
			MDL.SetRagdollAngularDamping(brain.Objhostage2._Entity, aiParams.hostagesRagdollDamping)
			MDL.ApplyVelocitiesToAllJoints(brain.Objhostage2._Entity, 0,0,0, 0,0,0)

            --Game:Print("take "..brain._JointH.." dist to move: "..Dist3D(x,y,z,x2,y2,z2))

            MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, true)
			MDL.SetPinned(brain.Objhostage2._Entity, true)
			self._test = true

			if self.AiParams.rotateRagdollToPlayer then
				local v = Vector:New(Player._groundx - x2, Player._groundy - y2, Player._groundz - z2)
				v:Normalize()
				local angle = math.atan2(v.X, v.Z)
				if aiParams.throwRagdollRotationInterpolation then
					self._qsrc = Quaternion:New(MDL.GetJointRotation(brain.Objhostage2._Entity, brain._JointH))
					self._qdst = Quaternion:New_FromEuler(0, angle, 0)
					self._qrot = 0.0
				else
					self._angleRagdoll = angle
					MDL.ApplyRotationToJoint(brain.Objhostage2._Entity, brain._JointH,0, angle, 0)
				end
			else
				if aiParams.throwRagdollRotationInterpolation then
					self._qsrc = Quaternion:New(MDL.GetJointRotation(brain.Objhostage2._Entity, brain._JointH))
					self._qdst = Quaternion:New(1,0,0,0)
					self._qrot = 0.0
				else
					MDL.ApplyRotationToJoint(brain.Objhostage2._Entity, brain._JointH, 1, 0, 0, 0)
				end
			end
            
            --MDL.SetRagdollCollisionGroup(brain.Objhostage2._Entity, ECollisionGroups.Noncolliding)
            self._holdBastardPos = Vector:New(x2,y2,z2)
            self._bindedRagdollFX = {}
			if aiParams.bindedRagdollFX and brain.Objhostage2.s_SubClass.DeathJoints then
				for i,v in brain.Objhostage2.s_SubClass.DeathJoints do
					--if math.random(100) < 60 then
						local fx = brain.Objhostage2:BindFX(aiParams.bindedRagdollFX.name,aiParams.bindedRagdollFX.scale,v)
						table.insert(self._bindedRagdollFX, fx)
					--end
				end
				local snd
				snd, self._bindedRagdollSound = brain.Objhostage2:BindSound("actor/leper_monk/lepper-charm-loop",5,20,true, MDL.GetJointIndex(brain.Objhostage2._Entity,"root"))
				local sndPtr = SND.GetSound3DPtr(snd)
				SOUND3D.SetVolume(sndPtr, 0, 0)
				SOUND3D.SetVolume(sndPtr, 100, 2.0)
			end
			brain.Objhostage2._pinnedByAI = true
            
        else
            --Game:Print("missed!")
            brain.Objhostage2._locked = nil
            brain.Objhostage2 = nil
        end
    end
end




function Overseer:OnTick(delta)
    if not self.AIenabled then return end
	local jjoint = MDL.GetJointIndex(self._Entity, "k_szyja")
	MDL.ApplyJointRotation(self._Entity, jjoint , math.pi/300*self.__oc ,0,0) 
	self.__oc =self.__oc +1
	if self.__oc >600 then self.__oc = 0 end

	if self._holdBastardPos then
		local brain = self._AIBrain	
        local aiParams = self.AiParams
		MDL.ApplyPositionToJoint(brain.Objhostage2._Entity, brain._JointH, self._holdBastardPos.X, self._holdBastardPos.Y, self._holdBastardPos.Z)
		self._holdBastardPos.Y = self._holdBastardPos.Y + delta * aiParams.ragdollLiftSpeed
		--local v = Vector:New(Player._groundx - self._holdBastardPos.X, Player._groundy - self._holdBastardPos.Y, Player._groundz - self._holdBastardPos.Z)
		if aiParams.throwRagdollRotationInterpolation then
			if aiParams.ragdollLiftRotationSpeed then
				self._qrot = self._qrot + delta * aiParams.ragdollLiftRotationSpeed
			end
			if self._qrot < 1.0 then
				--Game:Print("interpolacja quaternionow "..self._qrot)
				-- interpolacja quaternionow
				local qtemp = Quaternion:New(1,0,0,0)
				local flip = false
				local coeff0
				local coeff1
				local qdot = self._qsrc.X * self._qdst.X + self._qsrc.Y * self._qdst.Y + self._qsrc.Z * self._qdst.Z + self._qsrc.W * self._qdst.W
				if qdot < 0 then
					flip = true
				end
				coeff0 = 1 - self._qrot
				coeff1 = self._qrot
				if flip then
					qtemp.X = self._qsrc.X*coeff0 - self._qdst.X*coeff1
					qtemp.Y = self._qsrc.Y*coeff0 - self._qdst.Y*coeff1
					qtemp.Z = self._qsrc.Z*coeff0 - self._qdst.Z*coeff1
					qtemp.W = self._qsrc.W*coeff0 - self._qdst.W*coeff1
				else
					qtemp.X = self._qsrc.X*coeff0 + self._qdst.X*coeff1
					qtemp.Y = self._qsrc.Y*coeff0 + self._qdst.Y*coeff1
					qtemp.Z = self._qsrc.Z*coeff0 + self._qdst.Z*coeff1
					qtemp.W = self._qsrc.W*coeff0 + self._qdst.W*coeff1
				end
                qtemp:Normalize()
				MDL.ApplyRotationToJoint(brain.Objhostage2._Entity, brain._JointH, qtemp.W, qtemp.X, qtemp.Y, qtemp.Z)
			else
				MDL.ApplyRotationToJoint(brain.Objhostage2._Entity, brain._JointH, self._qdst.W,self._qdst.X,self._qdst.Y,self._qdst.Z)	-- moze pozniej do oryginalnej rot jointa?
			end
		else
			if aiParams.rotateRagdollToPlayer then
				MDL.ApplyRotationToJoint(brain.Objhostage2._Entity, brain._JointH, 0, self._angleRagdoll, 0)
			else
				MDL.ApplyRotationToJoint(brain.Objhostage2._Entity, brain._JointH, 1,0,0,0)	-- moze pozniej do oryginalnej rot jointa?
			end
		end

		if self._test then
			MDL.SetPinned(brain.Objhostage2._Entity, false)
			MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, true)
			self._test = false
		end

	end
end

--[[
function Overseer:Render(delta)
	if self._holdBastardPos then
		local x,y,z = self:GetJointPos(self.AiParams.holdJointSrc)
		R3D.DrawSprite1DOF(x,y,z,self._holdBastardPos.X, self._holdBastardPos.Y, self._holdBastardPos.Z,0.1,R3D.RGB(255,55,55),"particles/trailpainkiller") 
	end
end
--]]

----------------------------
Overseer._CustomAiStates = {}
Overseer._CustomAiStates.throwCorpse = {
	name = "throwCorpse",
	delayRandom = FRand(0,1),
}

function Overseer._CustomAiStates.throwCorpse:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	--Game:Print("start trzymanie")
	actor:Stop()
	actor:SetAnim("attack3", false)
	actor._rtfx = actor:BindFX(aiParams.ragdollThrowFX,aiParams.ragdollThrowFXScale,"RightHand")
	actor._disableHits = true
	self.active = true
	if brain.Objhostage2 then
		brain.Objhostage2.enableGibWhenHPBelow = nil
	end
end

function Overseer._CustomAiStates.throwCorpse:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	
	if self._animating then
		if not actor._isAnimating or actor.Animation ~= self._animating then
			self.active = false
			self._animating = nil
		end
		return
	end
	
	if brain.Objhostage2 then
		if brain.Objhostage2._deathTimer and brain.Objhostage2._deathTimer > 2 then
			brain.Objhostage2._deathTimer = brain.Objhostage2._deathTimer + 1
		else
			if debugMarek then Game:Print("death timer too low!") end
			 actor:SetAnim("idle",false)
			--actor:SetIdle()
			--self.active = false
			self._animating = "idle"
			return
		end
		if brain.Objhostage2.Pinned then
			if debugMarek then Game:Print("ktos przybil kolkiem kolesia!") end
			actor:SetAnim("idle",false)
			--actor:SetIdle()
			--self.active = false
			self._animating = "idle02"
			return
		end
	end
	
	if not actor._isAnimating or actor.Animation ~= "attack3" then
		self.active = false
	end

	brain._lastThrowTime = brain._currentTime
end

function Overseer._CustomAiStates.throwCorpse:OnRelease(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor._holdBastardPos = nil
	self._animating = nil
    if brain.Objhostage2 then
		MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, false)
        brain.Objhostage2._locked = nil
        brain.Objhostage2._pinnedByAI = nil
        brain.Objhostage2 = nil
    end
    if actor._rtfx then
		PARTICLE.Die(actor._rtfx)
		actor._rtfx = nil
    end
    if actor._bindedRagdollFX then
		for i,v in actor._bindedRagdollFX do
			PARTICLE.Die(v)
		end
	end

	if actor._bindedRagdollSound then
		local e = ENTITY.GetPtrByIndex(actor._bindedRagdollSound)
		if e then
			ENTITY.Release(e)
		end
		actor._bindedRagdollSound = nil
	end


	self.active = false
	--Game:Print("koniec trzymania release")
	actor._disableHits = false
end

function Overseer._CustomAiStates.throwCorpse:Evaluate(brain)
	-- tu trzeba spr. czy jest ragdoll miedzy playerem a soba i mozna nim rzucic
	if self.active then
		return 0.81
	else
		local actor = brain._Objactor
		local aiParams = actor.AiParams
		if brain._seeEnemy and brain._distToNearestEnemy > aiParams.throwRangeMin and brain._distToNearestEnemy < aiParams.throwRangeMax
			and math.random(100) < 10 and not brain.Objhostage2 and not actor._hitDelay then
			if brain._lastThrowTime + aiParams.minDelayBetweenThrow < brain._currentTime then
				local maxDist = aiParams.ragdollToThrowDistSearch
				local maxDistDeadBody = aiParams.ragdollToThrowDistSearch
				for i,v in Actors do
					if v.Health <= 0 then
						if not v._locked and not v._gibbed and not v.Pinned and (not v.NotCountable or v.Model == "dead_body") and v._enabledRD then
							-- get velocity of joint, zeby lezacego ragdola bral, a nie lecacego
							local j  = MDL.GetJointIndex(v._Entity, aiParams.holdJointDst)
							if not j or j < 0 then return 0 end
							local _velocityx,_velocityy,_velocityz,_velocity = MDL.GetVelocitiesFromJoint(v._Entity, j)

							local x,y,z = MDL.GetJointPos(v._Entity,j)
							local dist = Dist3D(x,y,z, actor._groundx,actor._groundy,actor._groundz)

						Game:Print(actor._Name.." possible target "..v._Name)
							if _velocity < 1.0 and ((dist < maxDist) or (v.Model == "dead_body" and dist < maxDistDeadBody)) then
								if debugMarek then
									Game:Print(actor._Name.."possible target1"..v._Name)
									actor.d1 = actor._groundx
									actor.d2 = actor._groundy + 1.5
									actor.d3 = actor._groundz
									actor.d4 = x
									actor.d5 = y
									actor.d6 = z
								end
								local b,d,x,y,z,nx,ny,nz = WORLD.LineTraceFixedGeom(actor._groundx,actor._groundy + 1.5, actor._groundz, x,y,z)
								if not b then
									--if debugMarek then Game:Print("possible target2") end
									local x,y,z = v:GetJointPos(aiParams.holdJointDst)
									local b = WORLD.LineTraceFixedGeom(x,y,z, x,y + 3.0,z)
									if not b then
										if v.Model == "dead_body" then
											if dist < maxDistDeadBody then
												Game:Print("DEAD FOUND")
												maxDistDeadBody = dist
												self._deadbody = v
											else
												Game:Print("DEAD FOUND poza zasiegiem")
											end
										else
											Game:Print("NORMAL FOUND")
											brain.Objhostage2 = v
											maxDist = dist
										end
									else
										--if debugMarek then Game:Print(actor._Name.."niemogly by go podniesc, bo niski sufit") end
									end
								else
									--if debugMarek then Game:Print(actor._Name.."nie widzi ragdola: "..v._Name) end
								end
							end
						--[[else
							if v._locked then
								Game:Print("locked")
							end
							if v._gibbed then
								Game:Print("gibbed")
							end
							if v.Pinned then
								Game:Print("gibbed")
							end
							if v.NotCountable then
								Game:Print("nc")
							end
							if not v._enabledRD then
								Game:Print("not rg")
							end--]]
						end
					end
				end
				if brain.Objhostage2 then
						brain.Objhostage2._locked = true
						self._deadbody = nil
					return 0.81	
				else
					if self._deadbody then
							brain.Objhostage2 = self._deadbody
							brain.Objhostage2._locked = true
							self._deadbody = nil
							return 0.81
					end
				end
			end
		end
	end
	return 0.0
end
function o:Showweapon()
		MDL.SetMeshVisibility(self._Entity,"ToolsShape",true)
--		MDL.SetMeshVisibility(self._Entity,"Chain_2sidedShape",true)
end

function o:OnFinishAnim(anim)
	if anim == "a2catch" then
		self.weaponaway = false
	end
end
Overseer._CustomAiStates.waitforWeapon = {
	name = "waitforWeapon",
}

function Overseer._CustomAiStates.waitforWeapon:OnInit(brain)
	local actor = brain._Objactor
	actor:SetAnim("a2wait","true")
end

function Overseer._CustomAiStates.waitforWeapon:OnUpdate(brain)
	local actor = brain._Objactor
	if actor.weaponhit then 
		actor:SetAnim("a2catch",false)
	end
end

function Overseer._CustomAiStates.waitforWeapon:OnRelease(brain)
end

function Overseer._CustomAiStates.waitforWeapon:Evaluate(brain)
	local actor = brain._Objactor
	if actor.weaponaway then
		return 0.81
	end
	return -1.0
end


function Overseer:ThrowRagdoll()
	local brain = self._AIBrain
	local aiParams = self.AiParams

    local x,y,z

	MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, false)
	
	local v = Vector:New(Player._groundx - self._holdBastardPos.X, Player._groundy - self._holdBastardPos.Y, Player._groundz - self._holdBastardPos.Z)
	local distToTarget = v:Len()
	v:Normalize()
	local angle = math.atan2(v.Z, v.X)
	
	if aiParams.throwRagdollAngle then
		x,y,z = CalcThrowVectorGivenAngle(distToTarget - aiParams.throwRagdollDistMinus, aiParams.throwRagdollAngle, angle, Player._groundy + 1.6 - self._holdBastardPos.Y)
	else
		x,y,z = CalcThrowVectorGivenVelocity(distToTarget - aiParams.throwRagdollDistMinus, aiParams.throwRagdollVelocity, angle, Player._groundy + 1.6 - self._holdBastardPos.Y, math.pi/2)
	end
	--PHYSICS.SetHavokBodyVelocity(brain.Objhostage2._Entity,x,y,z) 
	
	brain.Objhostage2.RagdollCollDamage = aiParams.damageByThrowenRagdoll
	
	-- fake: zeby lepiej wygladalo, glowie wieksza predkosc
	MDL.ApplyVelocitiesToAllJoints(brain.Objhostage2._Entity, x,y,z, 0,0,0)
	local mul = 1.8
	MDL.ApplyVelocitiesToJoint(brain.Objhostage2._Entity, brain._JointH, x*mul,y*mul,z*mul, 0,0,0)
	--
	if brain.Objhostage2._deathTimer < 200 then
		brain.Objhostage2._deathTimer = brain.Objhostage2._deathTimer + FRand(60,70)
	end
	brain.Objhostage2:BindSound("actor/devilmonk/devil_swish1", 24, 60, false)
	brain.Objhostage2._locked = nil
	brain.Objhostage2._pinnedByAI = nil
	brain.Objhostage2 = nil
	self._holdBastardPos = nil
	
    if self._rtfx then
		PARTICLE.Die(self._rtfx)
		self._rtfx = nil
    end
	
	for i,v in self._bindedRagdollFX do
		PARTICLE.Die(v)
	end
	self._bindedRagdollFX = nil
	if self._bindedRagdollSound then
		local e = ENTITY.GetPtrByIndex(self._bindedRagdollSound)
		if e then
			ENTITY.Release(e)
		end
		self._bindedRagdollSound = nil
	end
end


