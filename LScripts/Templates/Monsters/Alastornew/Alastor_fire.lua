function Alastor_fire:OnPrecache()
	Cache:PrecacheDecal(self.HitDecal)
	Cache:PrecacheParticleFX("AlastorenergyFX")
	Cache:PrecacheParticleFX(self.flamerFX)
	Cache:PrecacheParticleFX("but")
	Cache:PrecacheParticleFX(self.burnPFX)
end


function Alastor_fire:OnInitTemplate()
    self:SetAIBrain()
end

function Alastor_fire:CustomDelete()
	if self._flySound then
		ENTITY.Release(self._flySound)
		self._flySound = nil
	end
	if self._soundSampleCharge then
		SOUND2D.SetVolume(self._soundSampleCharge, 0, 0.1)
		SOUND2D.Forget(self._soundSampleCharge)
		self._soundSampleCharge = nil
	end
end

function Alastor_fire:CustomUpdate()
	if not self._died then
		local brain = self._AIBrain
		Game.MegaBossHealth = self.Health
	end
	if self._flameFX then
		if math.random(100) < 15 then		
			self:CheckDamageFromFlame()
		end
	end
--[[	if debugMarek then
		if not self.moder then
			self.moder = 0
		end
		if not self._isRotating and not self.x then
			--Game:Print("actor.angle "..(self.angle * 180/math.pi))
			--self.x = 1
			if self.moder == 0 then
				self:RotateWithAnim(45)
			end
			if self.moder == 1 then
				self:RotateWithAnim(-45)
			end
			if self.moder == 2 then
				self:RotateWithAnim(90)
			end
			if self.moder == 3 then
				self:RotateWithAnim(-90)
			end
		end
    end--]]
end



function Alastor_fire:Bindflare()
	if self.flare == 0 then
	self.flare = 1
	self:BindFX(self.burnPFX, self.burnsize, "o_l_d")
	self:BindFX(self.burnPFX, self.burnsize, "o_p_d")
	end
end

function Alastor_fire:OnCreateEntity()
	--ENTITY.PO_SetCollisionGroup(self._Entity, ECollisionGroups.OnlyWithFixedSpecial)
	ENTITY.PO_EnableGravity(self._Entity,true)
	ENTITY.PO_SetMovedByExplosions(self._Entity, false)
	self._speedDamping = true
	self._phase = 0
	self._floorNo = 1
	self.AiParams.wingJointsNo = {}
	self.ported=false
	for i,v in self.AiParams.wingJoints do
		local idx  = MDL.GetJointIndex(self._Entity,v)
		if idx == -1 then
			Game:Print(v.." not found")
		end
		table.insert(self.AiParams.wingJointsNo, idx)
	end
	self._delayExplTime = 3
	
	
    --self._HasMovingCurveRot = "ROOOT"
	--self._HasMovingCurveX = true
	self._moveWithAnimationDoNotUpdateAngle = true
	DebugSpheres = {}
	--self.moder = 0
	self._pissedOffRatio = 0

	if self.enableCollisionsToMeshes then
		self.collisionsNumber = 0
		--local count = 0
		PHYSICS.ActiveMeshGroupSetActivationParams(1, true, self.StoneParams.collisionMinimumFrequency, self.StoneParams.collisionMinimumStrength,
						self.StoneParams.miminalMassReportingCollision,self.StoneParams.maximalMassReportingCollision, self.StoneParams.amountReportingCollisions * 100,
						self.StoneParams.timeToLive,self.StoneParams.timeToLiveRandomize)
		--Game:Print("Enable collision to "..count.." meshes")
		Lev.ObjBoss = self

	end
	PHYSICS.ActiveMeshGroupEnable(1, true)

end

function Alastor_fire:OnApply()
--	self:PlayRandomSound2D({"alastor_ambient-stereo1","alastor_ambient-stereo2","alastor_ambient-stereo3",})
--	self._flySound = self:BindSound("actor/alastor/alastor_fly-loop",16, 60, true)
	self:Bindflare()
	
end

function Alastor_fire:CheckDamageFromFlame()
	-- dodac min. time between attacks
	local idx  = MDL.GetJointIndex(self._Entity,"k_szyja")
	local idx2  = MDL.GetJointIndex(self._Entity,"k_glowa")
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx2)
	local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
	v2:Normalize()
	
	-- spr. kilka sfer na drodze promienia, czy Player jest w zasiegu plomienia
	local i = 5
	if debugMarek then
		DebugSpheres = {}
	end
	
	local dist = 20
	local size =  3
	
	
	while i < dist do
		local v3 = Clone(v2)
		v3:MulByFloat(i)
		i = i + size
		local x,y,z = x3 + v3.X, y3 + v3.Y, z3 + v3.Z
		
		if debugMarek then
			local a = {}
			a.X = x
			a.Y = y
			a.Z = z
			a.Size = size
			table.insert(DebugSpheres, a)
		end
		local dist = Dist3D(x,y,z, Player._groundx, Player._groundy + 1.5, Player._groundz)
		if dist < size then
			Player:OnDamage(self.flameDamage, self)
			break
		end
	end
end


Alastor_fire._CustomAiStates = {}

Alastor_fire._CustomAiStates.idleAlastor = {
	lastTimeAmbientSound = 0,
	lastAmbient = 1.0,
	name = "idleAlastor",
}
function Alastor_fire._CustomAiStates.idleAlastor:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor:Stop()
	--Game:Print("idle oninit")
end

function Alastor_fire._CustomAiStates.idleAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	
	if self.lastAmbient + 1.0 < brain._currentTime and actor._phase == 0 then
		local tabl = aiParams.actions
		--Game:Print("losowanie check "..brain._currentTime)
		self.lastAmbient = brain._currentTime
		self._submode = nil
		local mul = 1.0
		if actor._damage then
			mul = 1.2			-- jak dostanie hita to chetniej losuje ataki
		end
		for i,v in tabl do
			if FRand(0.0, 1.0) < v[2] * mul then
				self._submode = v[1]
				break
			end
		end

		if self._submode then
			--Game:Print("losowanie "..self._submode)
			brain._submode = self._submode
			return
		end
		actor._damage = false
	end

	actor._CANWALK = true
end

function Alastor_fire._CustomAiStates.idleAlastor:OnRelease(brain)
	local actor = brain._Objactor
	brain._rotate180AfterEndWalking = nil
	actor._CANWALK = false
end

function Alastor_fire._CustomAiStates.idleAlastor:Evaluate(brain)
	return 0.01
end


------------

Alastor_fire._CustomAiStates.attackFlameAlastor = {		-- dodac spr. czy plajer nie wypadl poza
	name = "attackFlameAlastor",
	active = false,
	posFar = 130,
	posClose = 221 - 36,
	distFly = 120,
	distFly2 = 150,
}

function Alastor_fire._CustomAiStates.attackFlameAlastor:OnInit(brain)
	local dist = Dist3D(Player._groundx, 0, Player._groundz, 0,0,0)
	self.PosClose = 220 + FRand(0.6, 1.2)
	--Game:Print("attackFlame "..dist)
	local actor = brain._Objactor
	brain._submode = nil
	self.mode = -1

	local v = Vector:New(Player._groundx, 0, Player._groundz)

	local distPlayerFromCentre = v:Len()
	if distPlayerFromCentre < 0.01 then
		Game:Print("gracz jest w srodku")
		distPlayerFromCentre = 0
		v = Vector:New(actor._groundx, 0, actor._groundz)
	end
	v:Normalize()

	self.dest = Clone(v)
	local d = self.distFly + self.distFly2

	x = v.X * d
	y = self.posFar
	z = v.Z * d

	self._animSpeed = MDL.GetAnimTimeScale(actor._Entity, actor._CurAnimIndex)
	actor.Pos.X = x
	actor.Pos.Y = y
	actor.Pos.Z = z
	ENTITY.SetPosition(actor._Entity, x,y,z)
	--
	self.active = true
end

function Alastor_fire._CustomAiStates.attackFlameAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	if self.mode == -1 then
		actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
		actor:RotateToVector(Player._groundx, self.posClose, Player._groundz)
		self.mode = 0
		return
	end

	if self.mode == 0 and not actor._isRotating then
		actor:FlyForward(self.distFly2, nil)
		self.mode = 1
	end
	if self.mode == 1 and not actor._isWalking then
		--Game.freezeUpdate = true
		self.delay = 100
		actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
		local x,y,z = Player._groundx, self.posClose, Player._groundz
		x = 0
		z = 0
		local v = Clone(self.dest)
		v:MulByFloat(65,66)
		actor:FlyTo(v.X,y,v.Z,false,"fly_up")		-- cel zawsze na ts wysokosci
		self._targetX = x
		self._targetY = y
		self._targetZ = z
		self.mode = 2
        self.speed = self._animSpeed
        self._actorSpeed = actor._Speed
        --MDL.SetAnimTimeScale(actor._Entity, actor._CurAnimIndex, self.speed * 1.6)
		return
	end

	if self.mode == 2 then
		if not actor._isWalking then
			if self.delay then
				if not actor._flameFX then
					actor:PlaySound({"alastor_attack2-attack"},40,200,"k_szczeka")
					actor:StartFlame()
				else
					if math.random(100) < 15 then		
						--actor:CheckDamageFromFlame()
						actor:RotateToVector(Player._groundx,Player._groundy,Player._groundz)
					end
				end
				
				-- fade anim to 1.0
				--MDL.SetAnimTimeScale(actor._Entity, actor._CurAnimIndex, self.speed )
				
				self.delay = self.delay - 1
				if self.delay < 0 then
					self.delay = nil
				end
				if self.delay == 10 then
					PARTICLE.Die(actor._flameFX)
				end
			else
				actor._flameFX = nil
				self.delay = math.random(50,90)
				self.mode = 3
				local v = Clone(self.dest)
				v:MulByFloat(self.distFly)
				actor:FlyTo(v.X,self.posFar,v.Z,false,"fly_up")
				--MDL.SetAnimTimeScale(actor._Entity, actor._CurAnimIndex, self.speed * 0.6)
			end
		end		
	end

	if self.mode == 3 then
		if not actor._isWalking then
			--Game.freezeUpdate = true
			actor:FlyForward(self.distFly2, nil)
			self.mode = 4
			actor:PlayRandomSound2D({"alastor_ambient-stereo1","alastor_ambient-stereo2","alastor_ambient-stereo3",})
		end
		return
	end
		
	if self.mode == 4 then
		if not actor._isWalking then
			if self.delay then
				self.delay = self.delay - 1
				if self.delay < 0 then
					self.delay = nil
				end
			else
				self.active = false
				self.mode = 0
			end
		end
		return
	end
end

function Alastor_fire._CustomAiStates.attackFlameAlastor:OnRelease(brain)
	self.active = nil
end

function Alastor_fire._CustomAiStates.attackFlameAlastor:Evaluate(brain)
	if self.active or brain._submode == "attackFlame" then
		return 0.3
	end
	return 0
end

--------------

function Alastor_fire:OnTick(delta)

--- cheat ---
    if not IsFinalBuild() then
        if INP.Key(Keys.PgUp) == 1 then 
            self:OnDamage(1500, Player,nil,nil,nil,nil,AttackTypes.Rocket,nil,nil,0)
            Game:Print("DAMAGE alastor")
        end
	end
-------------

	if self._flameFX then
		local idx  = MDL.GetJointIndex(self._Entity,"k_szyja")
		local idx2  = MDL.GetJointIndex(self._Entity,"k_glowa")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx2)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)

		--q.W, q.X, q.Y, q.Z = LookAtToQuat(x2,y2,z2, x3,y3,z3, 0,0,1)

		q:ToEntity(self._flameFX)
		ENTITY.SetPosition(self._flameFX,x3,y3,z3) 
	end
	
	if self._isWalking or self._moveWithAnimation then	
		self._delayExplTime = self._delayExplTime - 1
		if self._delayExplTime < 0 then
			if self._flying then
				self._delayExplTime = 4
			else
				self._delayExplTime = 12
			end
			local v = Vector:New(math.sin(self.angle), 0, math.cos(self.angle))
			v:Normalize()
			v:MulByFloat(7.0)
			local x,y,z = self._groundx,self._groundy,self._groundz
			if self._flying then
				y = y + 2
			else
				y = y + 6
			end

			self.DEBUGl1 = x + v.X
			self.DEBUGl2 = y
			self.DEBUGl3 = z + v.Z
--			WORLD.Explosion2(x+v.X, y, z+v.Z, 5000, --[[range--]]8,nil,AttackTypes.Rocket,self.AiParams.walkDamage)
			if math.random(100) < 15 then
				PlayLogicSound("EXPLOSION",x+v.X, y, z+v.Z,16,32)
			end
		end
	end
	
	if self._selfrotate then
		self.angle = self.angle + self.fallingRotateSpeed * delta
		self._angleDest = self.angle
		ENTITY.SetOrientation(self._Entity,self.angle)
	end
end

function Alastor_fire:Throw()
	local aiParams = self.AiParams
    local brain = self._AIBrain

	local Joint = MDL.GetJointIndex(self._Entity, "d_l_5_3")
	local x,y,z = MDL.TransformPointByJoint(self._Entity,Joint,0,0,0)
	local v2 = Vector:New(math.sin(self.angle), 0, math.cos(self.angle))
	v2:Normalize()
	x = x + v2.X * 3.0
	z = z + v2.Z * 3.0
	local e, obj = AddItem("FireBallAlastor.CItem",nil,Vector:New(x,y,z),true)
	obj.ObjOwner = self
	obj.Pos.X = x
	obj.Pos.Y = y
	obj.Pos.Z = z
	obj:Apply()
	obj:Synchronize()
	self._objTakenToThrow = obj
	brain._enemyLastSeenPoint.X = Player._groundx
	brain._enemyLastSeenPoint.Y = Player._groundy
	brain._enemyLastSeenPoint.Z = Player._groundz
	self:ThrowTaken(nil, true)
end

function Alastor_fire:StrikeGround()
	local x,y,z = self:GetJointPos("d_p_5_3")
	WORLD.Explosion2(x, self._groundy + 1.0, z, 5000, --[[range--]]7,nil,AttackTypes.Rocket,self.AiParams.strikeDamage)
	if debugMarek then
		Game:Print("strike ground")
		self._debugdx3 = x
		self._debugdy3 = self._groundy + 1.0
		self._debugdz3 = z
		self.d1 = x
		self.d2 = y
		self.d3 = z
		self.d4 = x
		self.d5 = y - 3.0
		self.d6 = z
	end
	
	if self.FXwhenHit then
		AddObject(self.FXwhenHit,1.0, Vector:New(x,y,z), nil, true)
	end
	
	if self.HitDecal then
		local b,d,x,y,z,nx,ny,nz,he,e = WORLD.LineTraceFixedGeom(x,y,z,x,y - 3.0,z)
		if e then
			--Game:Print("spawn decal")
			ENTITY.SpawnDecal(e,self.HitDecal,x,y,z,0,1,0, 10)
		end
	end

end

function Alastor_fire:StartFlame()
	if not self._flameFX then
		local idx  = MDL.GetJointIndex(self._Entity,"k_szyja")
		local idx2  = MDL.GetJointIndex(self._Entity,"k_glowa")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx2)
		
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)

		if debugMarek then
			self.yaadebug1 = x2
			self.yaadebug2 = y2
			self.yaadebug3 = z2
			self.yaadebug4 = x3
			self.yaadebug5 = y3
			self.yaadebug6 = z3
		end
		
		
		local size = 1  --2.3
		
		Game:Print("PARTICLE size "..size)
		
		self._flameFX = AddPFX(self.flamerFX, size, Vector:New(x3,y3,z3), q)
	end
end

function Alastor_fire:Stomp(joint, modif)
	self:FootFX(joint)
end

function Alastor_fire:FootFX(joint)
    local j = MDL.GetJointIndex(self._Entity, joint)
    local x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
    AddPFX('but',0.2,Vector:New(x,y,z))
end

function Alastor_fire:EndFlame()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

function Alastor_fire:EnableRotate()		-- zeby w powietrzu mogl sie obracac
	self._canRotate = true
end

function Alastor_fire:DisableRotate()
	self._canRotate = false
end




------------
Alastor_fire._CustomAiStates.groundAttackAlastor = {
	name = "groundAttackAlastor",
	active = false,
	
	-- atak1 - 27 <- przebyty dystans
	-- atak2 - 30
	-- atak3 - 27
	
	--atak1minDistance = 54.0,	-- fireball
	atak3minDistance = 35.0,	-- atak lapami
	minAttackDistance = 20.0,
}

function Alastor_fire._CustomAiStates.groundAttackAlastor:OnInit(brain)
	Game:Print("gr attack "..brain._distToNearestEnemy)
	local actor = brain._Objactor
	self.atak1minDistance = actor.AiParams.breathAttackDistMin
	brain._submode = nil
	--self.mode = 0
	self.active = true
	actor:SetAnim("idle1",false)
	actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
	--actor:RotateToVector(Player._groundx,Player._groundy,Player._groundz)
	self.attackMode = false
	self.breathPoints = rawget(getfenv(),"alastorBreath")
	self.breathPointsWrong = rawget(getfenv(),"alastorBreathWrong")
end

function Alastor_fire._CustomAiStates.groundAttackAlastor:OnUpdate(brain)
	local actor = brain._Objactor
    local aiParams = actor.AiParams
	
	if not self.attackMode then
		if actor._ABdo then
			self.active = false
			actor:Stop()
			return
		end
		--if true then return end

		if not actor._isRotating and not actor._isWalking then
			if debugMarek then Game:Print("GRACZ DYSTANS: "..brain._distToNearestEnemy) end
			if brain._distToNearestEnemy < self.minAttackDistance then
					local v = Vector:New(Player._groundx - actor._groundx, 0, Player._groundz - actor._groundz)
					v:Normalize()
					local angleToPlayer = math.atan2(v.X, v.Z)
					local aDist = AngDist(actor.angle, angleToPlayer)
					if debugMarek then Game:Print("GRACZ ANGLE: "..(aDist*180/math.pi)) end

					if math.random(100) < 30 then
						if math.abs(aDist) > 60.0 * math.pi/180 and brain._distToNearestEnemy > 8 then
							actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
							if debugMarek then Game:Print("zly kat zeby ziac!!!!!!!!!!!!!!!!!") end
							--Game.freezeUpdate = true
							return
						end
					
						actor:SetAnim("zieje01",false)
						self.attackMode = "zieje01"
						Game:Print("zieje01 close")
						return
					end
					
					if math.abs(aDist) > 90.0 * math.pi/180 and brain._distToNearestEnemy > 10 then
						actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
						return
					end
			else
				local v = Vector:New(Player._groundx - actor._groundx, 0, Player._groundz - actor._groundz)
				v:Normalize()
				local angleToPlayer = math.atan2(v.X, v.Z)
				local aDist = AngDist(actor.angle, angleToPlayer)

				if math.abs(aDist) > 30.1 * math.pi/180 then
					actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
					return
				end

				local dist = Dist2D(Player._groundx, Player._groundz, 0,0)
				local distSelf = Dist2D(actor._groundx, actor._groundz, 0,0)
				if debugMarek then
					self.a = actor._groundx
					self.c = actor._groundz
					Game:Print("player at "..dist.." dy = "..(actor._groundx - Player._groundx))
				end
				actor._canRotate = false
				actor._moveWithAnimationDoNotUpdateAngle = false

				-- sprawdzanie czy nie spadnie w ataku
				local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
				v:Normalize()
				v:MulByFloat(self.minAttackDistance + 4.0)		-- narazie tyle dla wszystkich animacji
				local distAtEnd = math.sqrt((actor._groundx + v.X)*(actor._groundx + v.X) + (actor._groundz + v.Z)*(actor._groundz + v.Z))

--[[	attack3			if brain._distToNearestEnemy < self.atak3minDistance then
--					actor:SetAnim("atak3", false)
--					self.attackMode = "atak3"
--					return
--				else
					if brain._distToNearestEnemy < self.atak1minDistance then		-- przedzial miedzy 35 i 40 jest niejsany
						actor:SetAnim("atak2", false)
						self.attackMode = "atak2"
						--Game:Print("atak2")
						return
					else
						if (math.random(100) < 25 and dist < 40) or (distSelf > 33 and actor._floorNo < 4) then		-- dist - odl. gracza od srodka
							actor:WalkTo(Player._groundx, Player._groundy, Player._groundz, false, FRand(20, 40))
							--Game:Print("walkTo PLAYER")
						else
							actor:SetAnim("atak1", false)
							self.attackMode = "atak1"
							--Game:Print("atak1")
							return
						end
					end
]]-- attack3			end
						if (math.random(100) < 25 and dist < 40) or (distSelf > actor.walkdist) then		-- dist - odl. gracza od srodka
							
							actor:WalkTo(Player._groundx, Player._groundy, Player._groundz, false, 5)
							Game:Print("walkTo PLAYER")
						end
			end
		end
	else
		if self.attackMode == "WALKAWAY" then
			if self.mode == 0 and not actor._isRotating then
				actor:WalkTo(0,actor._groundy,0, false, FRand(26,42))
				self.mode = 1
			end
			if self.mode == 1 and not actor._isWalking then
				--Game:Print("koniec walkaway")
				self.attackMode = false
			end
			return
		end
		if not actor._isAnimating then
			if self.attackMode == "atak2" then
				if actor._flameFX then
					PARTICLE.Die(actor._flameFX)
					actor._flameFX = nil
				end
			end
			if debugMarek and self.c and self.attackMode and self.a then
				local dist2 = Dist3D(actor._groundx, 0, actor._groundz, self.a,0,self.c)
				--Game:Print("kniec atakmode "..self.attackMode.." przebyty dystans = "..dist2)
			end
			self.attackMode = false
			actor._moveWithAnimationDoNotUpdateAngle = true
		else
			if actor._canRotate then
				actor:RotateToVector(Player._groundx,Player._groundy,Player._groundz)
			else
				if actor._isRotating then
					actor:FullStop()
				end
			end
			--if self.attackMode == "atak2" then
				--if actor._flameFX and  math.random(100) < 15 then		
				--	actor:CheckDamageFromFlame()
				--end
			--end
		end
	end
end

function Alastor_fire._CustomAiStates.groundAttackAlastor:OnRelease(brain)
	self.active = nil
	local actor = brain._Objactor
	actor:EndFlame()
end

function Alastor_fire._CustomAiStates.groundAttackAlastor:Evaluate(brain)
	if self.active then
		return 0.3
	end
	return 0.1
end




------------

function Alastor_fire:CustomOnDeath()
	PlaySound2D("actor/deaths/alastor_small")
   if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
	self:AddPFX("explode")
	self:Delete()
end

function Alastor_fire:Teleportme()
		local x,y,z = ENTITY.GetPosition(self._Entity)
		local ax,ay,az = ENTITY.GetPosition(Player._Entity)
		AddPFX("spike_demon_endteleport",2.5,Vector:New(x,y,z))
		-- spawn somewhere on the ground
		local finding = true
		while finding do
			px= ax + math.random(10,20)
	 		py = ay 
			pz= az + math.random(10,20)
			local zn,idx = WPT.GetClosest(px,py,pz)   		
		    	if idx > -1 then
			        local x,y,z = WPT.GetPosition(zn,idx)    
				local dist = Dist3D(ax,ay,az,x,y,z)
				if dist > 10 then
					finding = false
					self.Pos.X = x
					self.Pos.Y = y
					self.Pos.Z = z
					ENTITY.SetPosition(self._Entity, x,y,z)		
					AddPFX("spike_demon_endteleport",2.5,Vector:New(x,y,z))
					self.ported=true
				end
			end
		end
end

Alastor_fire._CustomAiStates.portme = {
	name = "portme",
	active = false,
	lastx=0,
	lasty=0,
	lastz=0,
	checktry=400,
	maxtry=400,
	tolerance=5
}

function Alastor_fire._CustomAiStates.portme:OnRelease(brain)
	self.active=false
end


function Alastor_fire._CustomAiStates.portme:OnInit(brain)
	self.active=true
	local actor = brain._Objactor
	actor:SetAnim("break_flo",false)
	self.timer=140
	
end


function Alastor_fire._CustomAiStates.portme:OnUpdate(brain)
	local actor = brain._Objactor
	self.timer=self.timer - 1
	if actor.ported then
		self.active=false 
		actor.ported=false
	end
	if self.timer < 0 then
		self.active=false
	end
end

function Alastor_fire._CustomAiStates.portme:Evaluate(brain)
	local actor = brain._Objactor
	if self.active then return 0.9 end
	if Player then
		local x,y,z = ENTITY.GetPosition(actor._Entity)
		local dist = Dist3D( x,y,z, self.lastx, self.lasty, self.lastz)
		if dist< self.tolerance then 
			self.checktry=self.checktry -1
		else
			self.checktry=self.maxtry
		end
		self.lastx=x
		self.lasty=y
		self.lastz=z
		if self.checktry<0 then
			self.checktry=self.maxtry
			return 0.9
		end
	end
	return 0.1
end


