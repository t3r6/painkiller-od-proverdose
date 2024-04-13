function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
    Cache:PrecacheParticleFX("monsterweap_hitground")
    Cache:PrecacheParticleFX("priestcloud")
end

function o:OnCreateEntity()
	self:BindFX("priestcloud",0.9,'l_toe',0,-0.3,0)
	 self._AIBrain._lastTimeSpecial = -100
	 self.revstage = 0
 end
function o:OnTick(delta)
	local brain = self._AIBrain
	if not brain.Objhostage2 then
		if self.Immortal==true then self.Immortal = false end
		if self._blur1 then
			PARTICLE.Die(self._blur1)
			self._blur1=nil
			PARTICLE.Die(self._blur2)
			self._blur2=nil
		end
	end
end
function o:Revstage(what)
	if  what > 0 and not self._blur1 then
		self._blur1=self:BindFX("priestwarp",0.5,'l_toe',0,0,0)
		self._blur2=self:BindFX("priestwarp",0.5,'root',0,0,0)
	end
	self.revstage=what
	if what == 4 then
		self.toppart = 	self:BindFX("resur",1,'r_weapon_3',0,0,0)
		self.lpart = 	self:BindFX("resur",1,'joint2',0,0,0)
		self.ppart = 	self:BindFX("resur",1,'joint1',0,0,0)
	end
end

function o:Render(delta)
	if not self.died then
	local t = Templates["DriverElectro.CWeapon"]
				local j = MDL.GetJointIndex(self._Entity, 'r_weapon_3')
				local x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
				local j = MDL.GetJointIndex(self._Entity, 'r_weapon_2')
				local kx,ky,kz = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
				local j = MDL.GetJointIndex(self._Entity, 'joint1')
				local mx,my,mz = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
				local j = MDL.GetJointIndex(self._Entity, 'joint2')
				local nx,ny,nz = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
	self._points1 = {}
	self._points1[2]= Vector:New(kx,ky,kz)
	self._points1[1]= Vector:New(kx-(kx-x)/6,ky-(ky-y)/6,kz-(kz-z)/6)
	
	if self.revstage > 0 then
	self._points2 = {}
	self._points2[2]= Vector:New(kx,ky,kz)
	self._points2[1]= Vector:New(nx,ny,nz)
	self._points3 = {}
	self._points3[2]= Vector:New(kx,ky,kz)
	self._points3[1]= Vector:New(mx,my,mz)
	t:DrawBezierLine(self._points3,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points2,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
--[[	j = MDL.GetJointIndex(self._Entity, 'l_forearm')
	local k1,l1,m1 = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
	j = MDL.GetJointIndex(self._Entity, 'l_cloak_3')
	local k2,l2,m2 = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
	j = MDL.GetJointIndex(self._Entity, 'r_cloak_2')
	local k3,l3,m3 = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
	j = MDL.GetJointIndex(self._Entity, 'l_cloak_2')
	local k4,l4,m4 = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
	j = MDL.GetJointIndex(self._Entity, 'r_forearm')
	local k5,l5,m5 = MDL.TransformPointByJoint(self._Entity, j,0,0,0)

	self._points7 = {}
	self._points7[2]= Vector:New(k1,l1,m1)
	self._points7[2]= Vector:New(k2,l2,m2)
	self._points8 = {}
	self._points8[2]= Vector:New(k3,l3,m3)
	self._points8[1]= Vector:New(k2,l2,m2)
	self._points10 = {}
	self._points10[2]= Vector:New(k3,l3,m3)
	self._points10[1]= Vector:New(k4,l4,m3)
	self._points11 = {}
	self._points11[2]= Vector:New(k1,l1,m1)
	self._points11[1]= Vector:New(k5,l5,m5)
	t:DrawBezierLine(self._points7,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points8,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points10,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points11,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))

--]]	
	end
	if self.revstage > 2 then
	self._points4 = {}
	self._points4[2]= Vector:New(x,y,z)
	self._points4[1]= Vector:New(nx,ny,nz)
	self._points5 = {}
	self._points5[2]= Vector:New(x,y,z)
	self._points5[1]= Vector:New(mx,my,mz)
	t:DrawBezierLine(self._points4,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points5,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	end
	if self.revstage > 1 then
	self._points6 = {}
	self._points6[2]= Vector:New(x,y,z)
	self._points6[1]= Vector:New(kx,ky,kz)
	t:DrawBezierLine(self._points6,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points1,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	end
	local brain = self._AIBrain
	if self.revstage > 3  and brain and brain.Objhostage2 and brain.Objhostage2._Entity then
		brain._JointH,x2,y2,z2 = self:GetClosestJoint(x,y,z, brain.Objhostage2._Entity)
		self._points9 = {}
		self._points9[2]= Vector:New(kx,ky,kz)
		self._points9[1]= Vector:New(x2,y2,z2)
	t:DrawBezierLine(self._points9,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points9,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	t:DrawBezierLine(self._points9,10,2, FRand(0.05, 0.1),R3D.RGB(FRand(240,255),FRand(25,45),FRand(20,35)))
	end
		end
end

function o:IfMissedPlaySound()
	local brain = self._AIBrain
	if brain then
		if brain._lastHitTime < brain._lastMissedTime then
			self:PlaySound("missed")
			if self.s_SubClass.hitGroundJoint then
			
				local j = MDL.GetJointIndex(self._Entity, self.s_SubClass.hitGroundJoint)
				Game:Print(j)
				local x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,-0.75,0)

				DEBUGcx = x
				DEBUGcy = y + 0.3
				DEBUGcz = z
				DEBUGfx = x
				DEBUGfy = y - 0.8
				DEBUGfz = z

				local b,d,x1,y1,z1 = WORLD.LineTraceFixedGeom(x,y+0.2,z,x,y-0.8,z)
				if b then
					local q = Quaternion:New_FromNormal(nx,ny,nz)
					AddPFX("monsterweap_hitground",0.17, Vector:New(x1,y1,z1),q)
				end
			end
		end
	end
end



--------------------------
AiStates.Ressurect = {
	name = "Ressurect",
}

function AiStates.Ressurect:OnInit(brain)
	local actor = brain._Objactor
	actor.Immortal=true
	actor:Revstage(1)
	actor._oldSpeed=actor._randomizedParams.RunSpeed
	actor._randomizedParams.RunSpeed = actor._randomizedParams.RunSpeed * 2
	actor:WalkTo(self.vecx, self.vecy, self.vecz, true)
	--self.initialDistance = Dist3D(actor._groundx,actor._groundy,actor._groundz, self.vecx, self.vecy, self.vecz)
	self.active = true
	self.state = 0

	actor._oldColGr = MDL.GetRagdollCollisionGroup(brain.Objhostage2._Entity)
	
	if debugMarek then Game:Print(brain.Objhostage2._Name.." RCG = "..actor._oldColGr) end
	
    MDL.SetRagdollCollisionGroup(brain.Objhostage2._Entity, ECollisionGroups.RagdollSpecial)
	if brain.Objhostage2._deathTimer < 600 then
		brain.Objhostage2._deathTimer = brain.Objhostage2._deathTimer + 60		-- +2 sec. bonusu
	end
	self.maxRetries = 5
	brain._JointH = nil
end

function AiStates.Ressurect:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	brain._lastTimeSpecial = brain._currentTime
	if brain.Objhostage2 then
		if brain.Objhostage2._deathTimer then
			brain.Objhostage2._deathTimer = brain.Objhostage2._deathTimer + 1
		end
	else
		self.active = false
		return
	end
	if actor._isWalking --[[and not actor._proc--]] then
		--local x,y,z = brain.Objhostage2:GetJointPos(brain.Objhostage2.s_SubClass.ragdollJoint)
		
		local j,x,y,z = actor:GetClosestJoint(actor._groundx,actor._groundy,actor._groundz, brain.Objhostage2._Entity)
		
		local diff = Dist3D(x,y,z, self.vecx, self.vecy, self.vecz)
		if debugMarek then
			actor.DEBUG_P1 = self.vecx
			actor.DEBUG_P2 = self.vecy
			actor.DEBUG_P3 = self.vecz
			-- if pos changed:
			actor.DEBUG_P4 = actor._groundx
			actor.DEBUG_P5 = actor._groundy
			actor.DEBUG_P6 = actor._groundz
		end
		
		local dist = Dist3D(x,y,z, actor._groundx,actor._groundy,actor._groundz)

--		if dist > self.initialDistance then
--			self.active = false
--			Game:Print("za daleko, ignore")
--			return
--		end
		
		if (diff > 0.5 and math.random(100) < 20) then
			actor:WalkTo(x,y,z, true)
			self.vecx = x
			self.vecy = y
			self.vecz = z
			if debugMarek then Game:Print("diff > 0.5 "..diff) end
		end
		
		if dist < 1.0 and diff <= 0.5 then
			actor:Stop()
			--WORLD.SetWorldSpeed(0.1)
			actor:SetAnim('attack3', false)
			self.state = 1
			--self.OLDminimumTimeBetweenHitAnimation = actor.minimumTimeBetweenHitAnimation
			--actor.minimumTimeBetweenHitAnimation = -1
		end
		
		if brain._distToNearestEnemy < aiParams.attackRange then
			if debugMarek then Game:Print("przerwal dochodzenie do ragdolla, zeby mnie zdzielic w rylo") end
			self.active = false
			actor:Stop()
		end
	else
		-- jesli obstacle, to walk again
		--
		if self.state == 0 then
		
			self.maxRetries = self.maxRetries - 1
			if self.maxRetries < 0 then
				self.active = false
				if debugMarek then Game:Print("behead - max retries reached") end
				return
			end

			if debugMarek then Game:Print("retry - narazie") end
			local x,y,z = brain.Objhostage2:GetJointPos(brain.Objhostage2.s_SubClass.ragdollJoint)
			actor:WalkTo(x,y,z, true)
		end
	end

	if self.state == 1 then
		--Game:Print("actor.Animation = "..actor.Animation.." "..brain._lastDamageTime.." "..brain._currentTime)
		if (not actor._isAnimating or actor.Animation ~= "attack3") then
			if debugMarek then Game:Print("inna animacja") end
			if self._fx then
				ENTITY.Release(self._fx)
				self._fx = nil
			end

			if brain.Objhostage2 then
				--[[if actor._proc then
					actor._proc._ToKill = true
					if debugMarek then Game:Print(">ktos przerwal mu ozywianie") end
				end
				if brain._JointH then
					--Game:Print(">odpinowanie")
					MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, false)	
					brain._JointH = nil
				end--]]
				if debugMarek then Game:Print(">NILowanie") end

				if actor._oldColGr then
					actor._oldColGr = nil
					MDL.SetRagdollCollisionGroup(brain.Objhostage2._Entity, actor._oldColGr)
				end
				brain.Objhostage2._locked = nil
				brain.Objhostage2 = nil
			else
				if debugMarek then Game:Print(">NO Hostage") end
			end
			self.active = false
		end
	end
end


function AiStates.Ressurect:OnRelease(brain)
	local actor = brain._Objactor
	actor._randomizedParams.RunSpeed = actor._oldSpeed
	self.active = false
	--if not actor._proc or actor._proc._ToKill
	--actor._proc = nil
	if debugMarek then Game:Print("Ressurect:OnRelease(brain)") end
	if brain.Objhostage2 then
		--[[if brain._JointH then
			MDL.SetPinnedJoint(brain.Objhostage2._Entity, brain._JointH, false)
			brain._JointH = nil
		end--]]
		if actor._oldColGr then
			MDL.SetRagdollCollisionGroup(brain.Objhostage2._Entity, actor._oldColGr)
			actor._oldColGr = nil
		end
		brain.Objhostage2._locked = nil
		brain.Objhostage2 = nil
	end
	if self._fx then
		ENTITY.Release(self._fx)
		self._fx = nil
	end
end


function AiStates.Ressurect:Evaluate(brain)
	if self.active and brain.Objhostage2 then
		return 0.7
	else
		local actor = brain._Objactor
		local aiParams = actor.AiParams
		actor:Revstage(0)
		if brain._distToNearestEnemy > aiParams.attackRange and math.random(100) < 30 and not actor._proc and not brain.Objhostage2 then		-- ### czy potrzebne _proc i _proc jest killowany
			--local x,y,z = actor:GetJointPos(aiParams.holdJoint)			-- sprawdzanie odl od j do j
			if brain._lastTimeSpecial + aiParams.minDelayBetweenBehead < brain._currentTime then
				local maxDist = 9999
				for i,v in Actors do
					if v.Health <= 0 then
						if v.s_SubClass.ragdollJoint and v._enabledRD and not v._locked and not v._gibbed and not v.Pinned then
							self.vecx, self.vecy, self.vecz = v:GetJointPos(v.s_SubClass.ragdollJoint)
							local dist = Dist3D(self.vecx, self.vecy, self.vecz, actor._groundx,actor._groundy,actor._groundz)
							-- get velocity of joint
							--local _velocityx,_velocityy,_velocityz,_velocity = ENTITY.GetVelocity(v._Entity)
							--Game:Print("dist to enemy = "..(brain._distToNearestEnemy*0.9).." dist to rd = "..dist)
							--
							if dist < maxDist and dist < aiParams.viewDistance and dist < brain._distToNearestEnemy * 0.9 then
								if ENTITY.SeesEntity(actor._Entity, v._Entity) then
									maxDist = dist
									brain.Objhostage2 = v
								end
							end
						end
					end
				end
				if brain.Objhostage2 then
					brain.Objhostage2._locked = true
					return 0.65
				end
			end
		end
	end
	return 0.0
end


function Priest:Take()
	self.Immortal=false
			if self.toppart then
			PARTICLE.Die(self.lpart)
			PARTICLE.Die(self.ppart)
			PARTICLE.Die(self.toppart)
		end

    local brain = self._AIBrain
    if brain.Objhostage2 then
        local aiParams = self.AiParams
        
        local j = MDL.GetJointIndex(self._Entity,aiParams.holdJoint)
        local x,y,z = MDL.TransformPointByJoint(self._Entity, j, 0,0,0)
        local x2,y2,z2
        brain._JointH,x2,y2,z2 = self:GetClosestJoint(x,y,z, brain.Objhostage2._Entity)
        if Dist3D(x,y,z,x2,y2,z2) < 1.5 then
			local a,b = WPT.GetClosest(x2,y2,z2)
			local xx,xy,xz = WPT.GetPosition(a,b)
			Game.BodyCountTotal = Game.BodyCountTotal - 1
			if Lev and not Lev._revieved then
				PlaySound2D("belial/Belial_ingame_52",nil,nil,true)
				Lev._revieved = true
			end
			local obj = GObjects:Add(TempObjName(),CloneTemplate(brain.Objhostage2.BaseObj))
			
			local v = Vector:New(Player._groundx - self._groundx, Player._groundy - self._groundy, Player._groundz - self._groundz)
		    v:Normalize()


				if self.reviveFXsrc then
					AddPFX(self.reviveFXsrc,0.2,Vector:New(x,y,z))
				end	
				obj.Pos.X = xx
				obj.Pos.Y = xy + 1.5
				obj.Pos.Z = xz
				obj.angle = self.angle
				obj._angleDest = self._angleDest
				obj:Apply()
				obj._AIBrain._enemyLastSeenPoint.X = Player._groundx				-- hunt PLAYER
				obj._AIBrain._enemyLastSeenPoint.Y = Player._groundy
				obj._AIBrain._enemyLastSeenPoint.Z = Player._groundz
				obj._AIBrain._enemyLastSeenTime = obj._AIBrain._currentTime
				obj:Synchronize()
				if brain.Objhostage2._deathTimer then
					brain.Objhostage2._deathTimer = -1
			else
				GObjects:ToKill(brain.Objhostage2)
			end
			if debugMarek then Game:Print("brain.Objhostage2 NIL, bo koniec ozywiania") end
			brain.Objhostage2 = nil
        else
            brain.Objhostage2._locked = false
            brain.Objhostage2 = nil
        end
        brain._JointH = nil
    end
end

