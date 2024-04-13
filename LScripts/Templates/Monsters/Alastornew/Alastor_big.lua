function Alastor_big:OnPrecache()
	Cache:PrecacheDecal(self.HitDecal)
	Cache:PrecacheParticleFX("AlastorenergyFX")
	Cache:PrecacheParticleFX(self.flamerFX)
	Cache:PrecacheParticleFX("but")
end


function Alastor_big:OnInitTemplate()
    self:SetAIBrain()
end

function Alastor_big:CustomDelete()
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

function Alastor_big:CustomUpdate()
	if not self._died then
		local brain = self._AIBrain
		Game.MegaBossHealth = self.Health
	end
	if self._flameFX then
		if math.random(100) < 15 then		
			self:CheckDamageFromFlame()
		end
	end
end



function Alastor_big:OnCreateEntity()
	self._disableHits = true
	Game.MegaBossHealthMax = self.Health
	Game.MegaBossHealth = self.Health	
	ENTITY.PO_SetMovedByExplosions(self._Entity, false)
	self._speedDamping = true
	self._phase = 0
	self.AiParams.wingJointsNo = {}

	
	self:BindFX(self.burnPFX, self.burnsize, "o_l_d")
	self:BindFX(self.burnPFX, self.burnsize, "o_p_d")

	
	for i,v in self.AiParams.wingJoints do
		local idx  = MDL.GetJointIndex(self._Entity,v)
		if idx == -1 then
			Game:Print(v.." not found")
		end
		table.insert(self.AiParams.wingJointsNo, idx)
	end
	if not debugMarek then
		Game.showCompassArrow = false
	end
	self._delayExplTime = 3
	
	self._moveWithAnimationDoNotUpdateAngle = true
	DebugSpheres = {}
	self._pissedOffRatio = 0
	PHYSICS.ActiveMeshGroupEnable(1, true)
	ENTITY.EnableDeathZoneTest(self._Entity, false)



end

function Alastor_big:OnApply()
	self:PlayRandomSound2D({"alastor_ambient-stereo1","alastor_ambient-stereo2","alastor_ambient-stereo3",})
	self._flySound = self:BindSound("actor/alastor/alastor_fly-loop",16, 60, true)
end

function Alastor_big:CheckDamageFromFlame()
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
	
	local dist = 60
	local size = 9
	if self.Animation ~= "zieje02" and self.Animation ~= "zieje02a" then
			dist = 48
			size = 7
	else
		--Game:Print("y2 = "..y2.." y3 = "..y3)
		y3 = y3 + 1.0
	end
	--Game:Print("dist = "..dist.." size = "..size)
	
	
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


function Alastor_big:CustomOnDamage(he,x,y,z,obj,damage,type,nx,ny,nz)
	-- tu spr. czy nie od wlasnej eksplozji
	if type == AttackTypes.OutOfLevel then
		self._died = true
		self.Health = 0
		self._disableDemonic = true
		Game.MegaBossHealth = nil
		self._deathTimer = self.DeathTimer
		GObjects:Add(TempObjName(),CloneTemplate("EndLevel.CProcess"))
		Game.MegaBossHealthMax = nil
		Game:Print("ERROR: ALASTOR POZA LEVELEM")
		return true
	end
	if obj == self then
		--Game:Print("self damage "..damage)
		return true
	end
	if not self._ABdo then
		if nz then
			--Game:Print("blood fx")
			self:BloodFX(x,y,z,nx,ny,nz)
		end
		self.Health = self.Health - damage
		if self._AIBrain._lastDamageTime + 1.5 < self._AIBrain._currentTime then
			self:PlaySoundHitBinded("hurt", 50, 200)
			self._AIBrain._lastDamageTime = self._AIBrain._currentTime + FRand(0.0, 0.3)
		end
		if self.Health < 0 then
					self.Health = 0
					if not debugMarek then
						Game.showCompassArrow = true
					end
					self._died = true
					self:Stop()
					ENTITY.PO_Enable(self._Entity,false)
					self:EnableRagdoll(true,true,x,y,z)
					Game.MegaBossHealth = nil
					self._deathTimer = self.DeathTimer
					Game.MegaBossHealthMax = nil
					self:BindRandomSound({"alastor_death"}, 50, 300)
					--Game:Print("alastor died")
					if self._flameFX then
						PARTICLE.Die(self._flameFX)
						self._flameFX = nil
					end
					if self._soundSampleCharge then
						SOUND2D.SetVolume(self._soundSampleCharge, 0, 0.1)
						SOUND2D.Forget(self._soundSampleCharge)
						self._soundSampleCharge = nil
					end
					Game.BodyCountTotal = Game.BodyCountTotal + 1
					--AddItem("EndOfLevel.CItem",nil,Vector:New(0, 36, 0), true)
					
					self._disableDemonic = true
					self._timerToDemon = 4
					self._ABdo = 1
					
					return true
		else
			-- narazie 
			if self.Health * 0.4 < self._HealthMax then
				self._pissedOffRatio = 0.7
			end
		end
		
	end

	return true
end
 


-----------------
Alastor_big._CustomAiStates = {}

Alastor_big._CustomAiStates.idleAlastor = {
	lastTimeAmbientSound = 0,
	lastAmbient = 1.0,
	name = "idleAlastor",
}
function Alastor_big._CustomAiStates.idleAlastor:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor:Stop()
	--Game:Print("idle oninit")
end

function Alastor_big._CustomAiStates.idleAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	
	if self.lastAmbient + 1.0 < brain._currentTime and actor._phase == 0 then
		local tabl = aiParams.actions
		Game:Print("losowanie check "..brain._currentTime)
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
			Game:Print("losowanie "..self._submode)
			brain._submode = self._submode
			return
		end
		actor._damage = false
	end

	actor._CANWALK = true
end

function Alastor_big._CustomAiStates.idleAlastor:OnRelease(brain)
	local actor = brain._Objactor
	brain._rotate180AfterEndWalking = nil
	actor._CANWALK = false
end

function Alastor_big._CustomAiStates.idleAlastor:Evaluate(brain)
	return 0.01
end


-------------
function Alastor_big:OnTick(delta)

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
			WORLD.Explosion2(x+v.X, y, z+v.Z, 5000, --[[range--]]8,nil,AttackTypes.Rocket,self.AiParams.walkDamage)
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



-----------------------------
function Alastor_big:Throw()
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

function Alastor_big:StrikeGround()
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

function Alastor_big:StartFlame()
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
		
		
		local size = 2.3
		if self.Animation ~= "zieje02" and self.Animation ~= "zieje02a" then
				size = 1.8
		end
		
		--Game:Print("PARTICLE size "..size)
		
		self._flameFX = AddPFX(self.flamerFX, size, Vector:New(x3,y3,z3), q)
	end
end

function Alastor_big:Stomp(joint, modif)
	local p = modif
	if not p then
		p = 1.0
	end
	local x,y,z = self:GetJointPos(joint)
	Game._EarthQuakeProc:Add(x,y,z, self.StompTimeOut, self.StompRange * p, self.CameraMov * p, self.CameraRot * p, 1.0)
	--WORLD.Explosion2(x, y + 3, z, 1000, --[[range--]]5,self._Entity,AttackTypes.Rocket,200)
	self:FootFX(joint)
end

function Alastor_big:FootFX(joint)
    local j = MDL.GetJointIndex(self._Entity, joint)
    local x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
    AddPFX('but',0.8,Vector:New(x,y,z))
end

function Alastor_big:EndFlame()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

function Alastor_big:EnableRotate()		-- zeby w powietrzu mogl sie obracac
	self._canRotate = true
end

function Alastor_big:DisableRotate()
	self._canRotate = false
end

------------
Alastor_big._CustomAiStates.groundAttackAlastor = {
	name = "groundAttackAlastor",
	active = false,
	
	-- atak1 - 27 <- przebyty dystans
	-- atak2 - 30
	-- atak3 - 27
	
	--atak1minDistance = 54.0,	-- fireball
	atak3minDistance = 25.0,	-- atak lapami
	minAttackDistance = 20.0,
}

function Alastor_big._CustomAiStates.groundAttackAlastor:OnInit(brain)
--	Game:Print("gr attack "..brain._distToNearestEnemy)
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

function Alastor_big._CustomAiStates.groundAttackAlastor:OnUpdate(brain)
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
				-- gracz jest blisko: obrot o 180, albo idzie na gracza
				if math.random(100) < 70 + actor._pissedOffRatio * 20 then
					--actor:RotateToVector(Player._groundx,Player._groundy,Player._groundz)
					local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
					v:Normalize()
					
					
					-- sprawdzanie, zeby nie spadl 
					local dist = 40
					local ok = false
					while not ok do
						local distTarget = Dist3D(actor._groundx + v.X*dist, 0, actor._groundz + v.Z*dist, 0,0,0)	-- narazie
						if distTarget < aiParams.towerRadius then		-- poza wieza (44min, 47max)
							--Game:Print(aiParams.towerRadius.."OBROT dist = "..dist.." "..distTarget)
							ok = true
						else
							dist = dist - 5
							if dist < 10 then
								--Game:Print("OBROT o 180")
								actor:RotateWithAnim(180)
								return
							end
						end
					end
					--
					actor:WalkTo(actor._groundx + v.X*dist, actor._groundy, actor._groundz + v.Z*dist)
				else
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
						--Game:Print("zieje01 close")
						return
					end
					
					if math.abs(aDist) > 90.0 * math.pi/180 and brain._distToNearestEnemy > 10 then
						actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
						if debugMarek then Game:Print("zly kat zeby idle!!!!!!!!!!!!!!!!!") end
						return
					end

					if math.random(100) < 5 then
						actor:SetAnim("idle1",false)
						self.attackMode = "idle1"
						--Game:Print("idle1 close")
						return
					end
					if math.random(100) < 15 then
						actor:SetAnim("idle2",false)
						self.attackMode = "idle2"
						--Game:Print("idle2 close")
						return
					else
						actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
						--Game:Print("rotate close")
					end
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
					--Game:Print("player at "..dist.." dy = "..(actor._groundx - Player._groundx))
				end
				actor._canRotate = false
				actor._moveWithAnimationDoNotUpdateAngle = false
				if math.random(100) < 4 - (actor._pissedOffRatio * 10) then
					actor:SetAnim("idle2",false)
					self.attackMode = "idle2"
					--Game:Print("idle2")
					return
				end

				-- sprawdzanie czy nie spadnie w ataku
				local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
				v:Normalize()
				v:MulByFloat(self.minAttackDistance + 4.0)		-- narazie tyle dla wszystkich animacji
				local distAtEnd = math.sqrt((actor._groundx + v.X)*(actor._groundx + v.X) + (actor._groundz + v.Z)*(actor._groundz + v.Z))
				if distAtEnd > aiParams.towerRange and dist <= aiParams.towerRange then		-- moze czasmi walk?
					--Game:Print("NIE moze atakowac bo dist po skoku przekroczy zakres")
					-- todo: odchodzi
					actor:RotateToWithAnim(0,actor._groundy,0)
					self.mode = 0
					self.attackMode = "WALKAWAY"
					return
				end
				--


				if brain._distToNearestEnemy < self.atak3minDistance then
				--Game:Print("gr attack "..brain._distToNearestEnemy)
					actor:SetAnim("atak3", false)
					self.attackMode = "atak3"
						--Game:Print("atak3")
					return
				else
					if brain._distToNearestEnemy < self.atak1minDistance then		-- przedzial miedzy 35 i 40 jest niejsany
					--Game:Print("gr attack "..brain._distToNearestEnemy)
						actor:SetAnim("atak2", false)
						self.attackMode = "atak2"
						--Game:Print("atak2")
						return
					else
						if (math.random(100) < 25 and dist < 40) or (distSelf > 33) then		-- dist - odl. gracza od srodka
							actor:WalkTo(Player._groundx, Player._groundy, Player._groundz, false, FRand(20, 40))
							--Game:Print("walkTo PLAYER")
						else
							actor:SetAnim("atak1", false)
							self.attackMode = "atak1"
							--Game:Print("atak1")
							return
						end
					end
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

function Alastor_big._CustomAiStates.groundAttackAlastor:OnRelease(brain)
	self.active = nil
	local actor = brain._Objactor
	actor:EndFlame()
end

function Alastor_big._CustomAiStates.groundAttackAlastor:Evaluate(brain)
	if self.active then
		return 0.3
	end
	return 0
end




------------
Alastor_big._CustomAiStates.breathAlastor = {
	name = "breathAlastor",
	active = false,
}

function Alastor_big._CustomAiStates.breathAlastor:OnInit(brain)
	brain._submode = nil
	self.mode = 0
	self.active = true
	--Game:Print("breath alastor <<<<")
end

function Alastor_big._CustomAiStates.breathAlastor:OnUpdate(brain)
	local actor = brain._Objactor
    local aiParams = actor.AiParams

	if self.mode == 0 and not actor._isRotating then
		local distToPoint = Dist3D(brain._point.X, 0, brain._point.Z, actor._groundx, 0, actor._groundz)
		--Game:Print("distToPoint "..distToPoint)
		if distToPoint > 1.2 then
			actor:WalkTo(brain._point.X, brain._point.Y, brain._point.Z)
		end
		self.mode = 1
		return
	end
	if self.mode == 1 then
		if not actor._isWalking then
			-- dodac sprawdzanie, czy doszedl
			--Game:Print("doszedl")
			self.angleDest = (math.atan2(-brain._point.X, -brain._point.Z) + math.pi) * 180/math.pi
			self.mode = 2
			return
		else
			local dist = Dist3D(Player._groundx, 0, Player._groundz, 0,0,0)
			local distFromPoint = Dist3D(Player._groundx, 0, Player._groundz, brain._point.X,0,brain._point.Z)
			if dist < 70 or distFromPoint > 70 then
				actor:Stop()
				self.active = false
				--Game:Print("gracz wyszedl z zwenetrznej "..dist.." dist from point = "..distFromPoint)
				return
			end
		end
	end
	if self.mode == 2 and not actor._isRotating then
		-- Game.freezeUpdate = true
		--Game:Print("koniec obrotu z animacja")
		actor:RotateTo(self.angleDest)
		if math.random(100) < 50 then
			actor:SetAnim("zieje02", false)
		else
			actor:SetAnim("zieje02a", false)
		end
		self.mode = 3
	end
	if self.mode == 3 and (not actor._isAnimating or not (actor.Animation == "zieje02" or actor.Animation == "zieje02a")) then
		self.active = false
		if actor._flameFX then
			PARTICLE.Die(actor._flameFX)
			actor._flameFX = nil
		end
	end
end

function Alastor_big._CustomAiStates.breathAlastor:OnRelease(brain)
	local actor = brain._Objactor
	brain._point = nil
	actor._moveWithAnimationDoNotUpdateAngle = true
	actor:EndFlame()
end


function Alastor_big._CustomAiStates.breathAlastor:Evaluate(brain)
	if self.active or brain._submode == "breath" then
		return 0.3
	end
	return 0
end



function Alastor_big:CustomOnDeathUpdate()
	if self._timerToDemon then
		self._timerToDemon = self._timerToDemon - 1
		if self._timerToDemon <= 0 then
			self._demonfx = Game:EnableDemon(true, 10, false, 0.25)
			self._timerToDemon = nil
		end
	else
		if self._demonfx and self._demonfx.TickCount > self._demonfx.EffectTime - 1.0 then
			self._demonfx = nil
			GObjects:Add(TempObjName(),CloneTemplate("EndLevel.CProcess"))
		end
	end
end


Alastor_big._CustomAiStates.attackFlyAlastor = {
	name = "attackFlyAlastor",
	active = false,
	posVFar = 150,		-- y
	posFar = 230 - 36,		-- y		(bylo: 250, 224, 180)
	posClose = 224 - 36,		-- y
	distFly2 = 100,
	distFly = 100,
}

function Alastor_big._CustomAiStates.attackFlyAlastor:OnInit(brain)
	--Game:Print("attack")
	local actor = brain._Objactor
	brain._submode = nil
	self.mode = -1
	
	-- random pos
	--if not self.angle then
		self.angle = math.random(0,360)
	--else
	--	self.angle = self.angle + math.random(-60,60) + 180
	--end
	self.angle = self.angle * math.pi/180
	local x = math.sin(self.angle) + math.cos(self.angle)
	local z = math.cos(self.angle) - math.sin(self.angle)
	local d = self.distFly + self.distFly2
	x = x * d
	y = self.posVFar
	z = z * d
	actor.Pos.X = x
	actor.Pos.Y = y
	actor.Pos.Z = z
	ENTITY.SetPosition(actor._Entity, x,y,z)
	--Game.freezeUpdate = true
	--
	self.active = true
	self._sound = nil
end

function Alastor_big._CustomAiStates.attackFlyAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	if self.mode == -1 then
		actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
		actor:RotateToVector(Player._groundx, self.posClose, Player._groundz)
		self.mode = 0
		return
	end
	if self.mode == 0 and not actor._isRotating then
		--Game:Print("fly up")
		--Game.freezeUpdate = true
		local x,y,z = Player._groundx, self.posFar, Player._groundz
		actor:FlyForward(self.distFly2, nil, self.posFar - self.posVFar)		-- cel zawsze na ts wysokosci
		self.mode = 1
		return
	end
	
	if self.mode == 1 and not actor._isWalking then
		--Game.freezeUpdate = true
		self.delay = FRand(actor.delayBetweenFlyAttacks,actor.delayBetweenFlyAttacks*1.5)
		actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
		local x,y,z = Player._groundx, self.posClose, Player._groundz
		actor:FlyTo(x,y,z)		-- cel zawsze na ts wysokosci
		--actor:FlyForward(self.distFly, nil, self.posClose - self.posFar)		-- cel zawsze na ts wysokosci
		self._targetX = x
		self._targetY = y
		self._targetZ = z
		self.mode = 2
		self._animSpeed = MDL.GetAnimTimeScale(actor._Entity, actor._CurAnimIndex)
		--Game:Print("1 "..self._animSpeed)
        self.speed = self._animSpeed
        self._actorSpeed = actor._Speed
		return
	end

	if self.mode == 2 then
		local dist = Dist3D(actor._groundx,actor._groundy,actor._groundz,self._targetX,self._targetY,self._targetZ)
		if dist < 60 then
			self.speed = self.speed + 0.035
			actor._Speed = actor._Speed + 0.035
			if self.speed > 2.5*self._animSpeed then
				self.speed = 2.5*self._animSpeed
			end
			if actor._Speed > 2.5*self._actorSpeed then
				actor._Speed = 2.5*self._actorSpeed
			end
			MDL.SetAnimTimeScale(actor._Entity, actor._CurAnimIndex, self.speed)
		end
		if not actor._isWalking then
			self.mode = 3
			--Game:Print("2 "..self.speed)
		else
			local dist = Dist3D(actor._groundx,0,actor._groundz,0,0,0)
			if dist < 45 and not self._sound then
				self._sound = true
				--if math.random(100) < 60 then
					local j = MDL.GetJointIndex(actor._Entity, "k_szczeka")
					local snd = actor:PlaySoundHitBinded({"alastor_attack1-attackvoice","alastor_onfly1"},40, 200, j)
					SND.SetVelocityScaleFactor(snd, 0,0)
				--end
			end
		end
		return
	end
	if self.mode == 3 then		-- atak
		local b = actor._Speed
		actor:FlyForward(self.distFly + 120, nil, self.posFar - self.posClose)		-- pozniej precyzyjnie - 140 poza srodek
		actor._Speed = b
		MDL.SetAnimTimeScale(actor._Entity, actor._CurAnimIndex, self.speed)
		self.mode = 4
	end
	if self.mode == 4 then		-- odlot
		if not actor._isWalking then
			-- tu spr. czy naprawde odlecial daleko
			--Game.freezeUpdate = true
			--Game:Print("fly down")
			self.mode = 5
			actor:PlayRandomSound2D({"alastor_ambient-stereo1","alastor_ambient-stereo2","alastor_ambient-stereo3",})
			actor:FlyForward(self.distFly2, nil, self.posVFar - self.posFar)
			--
		else
			local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
			v:Normalize()
			v:MulByFloat(8.0)
			local x,y,z = actor._groundx,actor._groundy+2,actor._groundz
			WORLD.Explosion2(x+v.X, y, z+v.Z, 5000, --[[range--]]8,nil,AttackTypes.Rocket,actor.AiParams.flyDamage)
			actor.DEBUGl1 = x + v.X
			actor.DEBUGl2 = y
			actor.DEBUGl3 = z + v.Z

		
			self.speed = self.speed - 0.035
			actor._Speed = actor._Speed - 0.035
			if self.speed < self._animSpeed then
				self.speed = self._animSpeed
			end
			if actor._Speed < self._actorSpeed then
				actor._Speed = self._actorSpeed
			end
			MDL.SetAnimTimeScale(actor._Entity, actor._CurAnimIndex, self.speed)
		end
	end
	if self.mode == 5 and not actor._isWalking then
		self.speed = self._animSpeed
		actor._Speed = self._actorSpeed
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
end

function Alastor_big._CustomAiStates.attackFlyAlastor:OnRelease(brain)
	self.active = nil
end

function Alastor_big._CustomAiStates.attackFlyAlastor:Evaluate(brain)
	if self.active or brain._submode == "attack" then
		return 0.3
	end
	return 0
end



------------
--
Alastor_big._CustomAiStates.attackFlameAlastor = {		-- dodac spr. czy plajer nie wypadl poza
	name = "attackFlameAlastor",
	active = false,
	posFar = 130,
	posClose = 221 - 36,
	distFly = 120,
	distFly2 = 150,
}

function Alastor_big._CustomAiStates.attackFlameAlastor:OnInit(brain)
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

function Alastor_big._CustomAiStates.attackFlameAlastor:OnUpdate(brain)
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

function Alastor_big._CustomAiStates.attackFlameAlastor:OnRelease(brain)
	self.active = nil
end

function Alastor_big._CustomAiStates.attackFlameAlastor:Evaluate(brain)
	if self.active or brain._submode == "attackFlame" then
		return 0.3
	end
	return 0
end

---------------
