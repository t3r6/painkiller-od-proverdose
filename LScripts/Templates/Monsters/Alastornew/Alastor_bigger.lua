function Alastor_bigger:OnPrecache()
	Cache:PrecacheDecal(self.HitDecal)
	Cache:PrecacheParticleFX("AlastorenergyFX")
	Cache:PrecacheParticleFX(self.burnPFX)
	Cache:PrecacheParticleFX(self.flamerFX)
	Cache:PrecacheParticleFX(self.hitgroundFX)
	Cache:PrecacheParticleFX("Snow_Giant_Skycicle_explode")
	Cache:PrecacheParticleFX("Frankenstein_chargebody")
	Cache:PrecacheParticleFX("but")
end


function Alastor_bigger:OnInitTemplate()
    self:SetAIBrain()
end

function Alastor_bigger:CustomDelete()
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

function Alastor_bigger:CustomUpdate()
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



function Alastor_bigger:OnCreateEntity()
	self._disableHits = true
	Game.MegaBossHealthMax = self.Health
	Game.MegaBossHealth = self.Health	
	ENTITY.PO_SetMovedByExplosions(self._Entity, false)
	self._speedDamping = true
	self._phase = 0
	self.AiParams.wingJointsNo = {}
	self._elevated = false
	self.flyuptimer = 80
	self.flyupdamage = self.Health / 4 
	self.flyupcounter = 1
	
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

function Alastor_bigger:OnApply()
	self:PlayRandomSound2D({"alastor_ambient-stereo1","alastor_ambient-stereo2","alastor_ambient-stereo3",})
	self._flySound = self:BindSound("actor/alastor/alastor_fly-loop",16, 60, true)
end

function Alastor_bigger:CheckDamageFromFlame()
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


function Alastor_bigger:CustomOnDamage(he,x,y,z,obj,damage,type,nx,ny,nz)
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
					Game:Print("alastor died")
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
					x = Player._groundx
					y = Player._groundx
					z = Player._groundx
					GObjects:Add(TempObjName(),CloneTemplate("EndLevel.CProcess"))
				--	AddItem("EndOfLevel.CItem",nil,Vector:New(x, y,z), true)
					
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

-------------
function Alastor_bigger:OnTick(delta)

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
function Alastor_bigger:Throw()
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

function Alastor_bigger:StrikeGround()
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

function Alastor_bigger:StartFlame()
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

function Alastor_bigger:Stomp(joint, modif)
	local p = modif
	if not p then
		p = 1.0
	end
	local x,y,z = self:GetJointPos(joint)
	Game._EarthQuakeProc:Add(x,y,z, self.StompTimeOut, self.StompRange * p, self.CameraMov * p, self.CameraRot * p, 1.0)
	--WORLD.Explosion2(x, y + 3, z, 1000, --[[range--]]5,self._Entity,AttackTypes.Rocket,200)
	self:FootFX(joint)
end

function Alastor_bigger:FootFX(joint)
    local j = MDL.GetJointIndex(self._Entity, joint)
    local x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
    AddPFX('but',0.8,Vector:New(x,y,z))
end

function Alastor_bigger:EndFlame()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

function Alastor_bigger:EnableRotate()		-- zeby w powietrzu mogl sie obracac
	self._canRotate = true
end

function Alastor_bigger:DisableRotate()
	self._canRotate = false
end


Alastor_bigger._CustomAiStates = {}
Alastor_bigger._CustomAiStates.flyupAlastor = {		
	name = "flyupAlastor",
	active = false,
	timer = 0,
}

function Alastor_bigger._CustomAiStates.flyupAlastor:OnInit(brain)
	self.active = true
	self.timer = 0
	local actor = brain._Objactor
	actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
	actor:FlyTo(actor._groundx,actor._groundy+80,actor._groundz,false,"fly_up")
	actor.flyupcounter = actor.flyupcounter + 1 
	
end
function Alastor_bigger._CustomAiStates.flyupAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	if self.timer >  actor.flyuptimer then 
		self.active = false 
	else
		self.timer = self.timer + 1
	end	
end
function Alastor_bigger._CustomAiStates.flyupAlastor:OnRelease(brain)
	local actor = brain._Objactor
	actor._elevated = true
	self.active = nil 
end
function Alastor_bigger._CustomAiStates.flyupAlastor:Evaluate(brain)
	local actor = brain._Objactor
--	Game:Print("1")
	if actor._elevated then return 0 end
--	Game:Print("2")
	if self.active then return 1 end
--	Game:Print("3")
	local zdravi = Game.MegaBossHealthMax - actor.flyupdamage * actor.flyupcounter
	actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
	--Game:Print("pos="..actor._groundx..","..actor._groundy..","..actor._groundz)
--	Game:Print("4")
	if actor.Health < zdravi then
		return 1
	end
	
	return 0
end

Alastor_bigger._CustomAiStates.topattackAlastor = {
	name = "topattackAlastor",
	active = false,
	level = 0
}
function Alastor_bigger._CustomAiStates.topattackAlastor:OnInit(brain)
	self.active = true
	local actor = brain._Objactor
	local x,y,z = ENTITY.GetPosition(actor._Entity)
	self.level= y
	self.stonenum = actor.hitgroundcount
end

function Alastor_bigger._CustomAiStates.topattackAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	local x,y,z = ENTITY.GetPosition(actor._Entity)
	local ax,ay,az = ENTITY.GetPosition(Player._Entity)
	actor:FlyTo(ax,self.level,az)
	if math.random(100) < actor.hitgroundrndnumber then
			local rnd = actor.hitgroundscatter
			local scales = {1,0.9,1.1}
			local a = x + FRand(-rnd, rnd)
			local b = z + FRand(-rnd, rnd)
			local c = actor._groundy 
			local obj,e = AddObject("Aloball.CItem",scales[math.random(1,3)],Vector:New(a ,y - 10, b),nil,true) 
			AddPFX(actor.hitgroundFX,actor.hitgroundFXscale,Vector:New(a,ay,b))
			
		 	self.stonenum = self.stonenum - 1	
	end
	if self.stonenum < 0 		then
		AddPFX("Snow_Giant_Skycicle_explode",20,Vector:New(x,y,z))
		AddPFX("Snow_Giant_Skycicle_explode",20,Vector:New(x,y,z))
		AddPFX("Snow_Giant_Skycicle_explode",20,Vector:New(x,y,z))
		AddPFX("Snow_Giant_Skycicle_explode",20,Vector:New(x,y,z))
		self.active = false 
		actor._elevated=false
		-- spawn somewhere on the ground
		local finding = true
		while finding do
			px= ax + math.random(30,35)
	 		py = ay 
			pz= az + math.random(30,35)
			local zn,idx = WPT.GetClosest(px,py,pz)   		
		    	if idx > -1 then
			        local x,y,z = WPT.GetPosition(zn,idx)    
				local dist = Dist3D(ax,ay,az,x,y,z)
				if dist > 20 then
					finding = false
					actor.Pos.X = x
					actor.Pos.Y = y
					actor.Pos.Z = z
					ENTITY.SetPosition(actor._Entity, x,y,z)		
				end
			end
		end
	end
end

function Alastor_bigger._CustomAiStates.topattackAlastor:OnRelease(brain)
	self.active = nil
end

function Alastor_bigger._CustomAiStates.topattackAlastor:Evaluate(brain)
	local actor = brain._Objactor
	if self.active or actor._elevated then
		return 1 
	end
	return 0
end


Alastor_bigger._CustomAiStates.attackFlyAlastor = {
	name = "attackFlyAlastor",
	active = false,
	posVFar = 80,		-- y
	posFar = 230 - 36,		-- y		(bylo: 250, 224, 180)
	posClose = 184 - 36,		-- y
	distFly2 = 50,
	distFly = 50,
}

function Alastor_bigger._CustomAiStates.attackFlyAlastor:OnInit(brain)
	--Game:Print("attack")
	local actor = brain._Objactor
	brain._submode = nil
	self.mode = -1
		self.angle = math.random(0,360)
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
		Game:Print("Setpos2!")
	ENTITY.SetPosition(actor._Entity, x,y,z)
	self.active = true
	self._sound = nil
end

function Alastor_bigger._CustomAiStates.attackFlyAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	if self.mode == -1 then
		actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
		actor:RotateToVector(Player._groundx, self.posClose, Player._groundz)
		self.mode = 0
		return
	end
	if self.mode == 0 and not actor._isRotating then
		if actor._bindedFX then
			PARTICLE.Die(actor._bindedFX)
			actor._bindedFX=nil
		end
		--Game:Print("fly up")
		--Game.freezeUpdate = true
		local x,y,z = Player._groundx, self.posFar, Player._groundz
		actor:FlyForward(self.distFly2, nil, self.posFar - self.posVFar)		-- cel zawsze na ts wysokosci
		self.mode = 1
		return
	end
	
	if self.mode == 1 and not actor._isWalking then
		--Game.freezeUpdate = true
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
		actor:FlyForward(self.distFly + 220, nil, self.posFar - self.posClose)		-- pozniej precyzyjnie - 140 poza srodek
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
		self.active = false
		actor._elevated = false
		self.mode = 0
		actor._bindedFX=actor:BindFX("Frankenstein_chargebody", 7)

		-- spawn somewhere on the ground
		local finding = true
		while finding do
			px= Player._groundx + math.random(30,35)
	 		py = Player._groundy 
			pz= Player._groundz + math.random(30,35)
			local zn,idx = WPT.GetClosest(px,py,pz)   		
		    	if idx > -1 then
			        local x,y,z = WPT.GetPosition(zn,idx)    
				local dist = Dist3D(Player._groundx,Player._groundy,Player._groundz,x,y,z)
				if dist > 20 then
					finding = false
					actor.Pos.X = x
					actor.Pos.Y = y
					actor.Pos.Z = z
					ENTITY.SetPosition(actor._Entity, x,y,z)		
				end
			end
		end
	end
end

function Alastor_bigger._CustomAiStates.attackFlyAlastor:OnRelease(brain)
	self.active = nil
end

function Alastor_bigger._CustomAiStates.attackFlyAlastor:Evaluate(brain)
	local actor = brain._Objactor
	if actor._bindedFX then
		PARTICLE.Die(actor._bindedFX)
		actor._bindedFX=nil
	end

	if self.active or actor._elevated then
		return 1 
	end
	return 0
end


Alastor_bigger._CustomAiStates.idleAlastor = {
	lastTimeAmbientSound = 0,
	lastAmbient = 1.0,
	name = "idleAlastor",
}
function Alastor_bigger._CustomAiStates.idleAlastor:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor:Stop()
	--Game:Print("idle oninit")
end

function Alastor_bigger._CustomAiStates.idleAlastor:OnUpdate(brain)
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

function Alastor_bigger._CustomAiStates.idleAlastor:OnRelease(brain)
	local actor = brain._Objactor
	brain._rotate180AfterEndWalking = nil
	actor._CANWALK = false
end

function Alastor_bigger._CustomAiStates.idleAlastor:Evaluate(brain)
	return 0.01
end


------------
--
Alastor_bigger._CustomAiStates.groundAttackAlastor = {
	name = "groundAttackAlastor",
	active = false,
	
	-- atak1 - 27 <- przebyty dystans
	-- atak2 - 30
	-- atak3 - 27
	
	--atak1minDistance = 54.0,	-- fireball
	atak3minDistance = 35.0,	-- atak lapami
	minAttackDistance = 20.0,
}

function Alastor_bigger._CustomAiStates.groundAttackAlastor:OnInit(brain)
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

function Alastor_bigger._CustomAiStates.groundAttackAlastor:OnUpdate(brain)
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

function Alastor_bigger._CustomAiStates.groundAttackAlastor:OnRelease(brain)
	self.active = nil
	local actor = brain._Objactor
	actor:EndFlame()
end

function Alastor_bigger._CustomAiStates.groundAttackAlastor:Evaluate(brain)
	if self.active then
		return 0.3
	end
	return 0.1
end




------------
