function Cop_Flamer:OnInitTemplate()
    self:SetAIBrain()
end

function Cop_Flamer:OnCreateEntity()
	if self.flame_FX then
		self._Flame2 = self:BindFX(self.flame_FX,0.05,"weapon_joint",0,0,1.14)
	end
    self._AIBrain._lastThrowTime = self._AIBrain._currentTime + FRand(0,2)
    self._soundSample = SOUND3D.Create("actor/maso/maso_flametrower-loop")
	SOUND3D.SetHearingDistance(self._soundSample,14,42)
    SOUND3D.SetLoopCount(self._soundSample,0) 
    SOUND3D.SetVolume(self._soundSample, 0.0)
			self.lasthitjoint=""
local l
l = self.s_SubClass.BillBoard1
	if l then
		local obj = CloneTemplate(l.template)
		obj.Pos:Set(l.offset.X,l.offset.Y,l.offset.Z)
		obj.Size = obj.Size * l.scale
		obj:Apply()
		ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
		self._bindedBill1 = obj
	end
l = self.s_SubClass.BillBoard2
	if l then
		local obj = CloneTemplate(l.template)
		obj.Pos:Set(l.offset.X,l.offset.Y,l.offset.Z)
		obj.Size = obj.Size * l.scale
		obj:Apply()
		ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
		self._bindedBill1 = obj
	end			
end

function o:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Demon then
        return false
    end
    if he then
	local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
	if jName ~= "bag" and jName ~= "k_szyja" then return true end
			self.lasthitjoint=jName
		    return false, damage
    else
	if type == AttackTypes.Physics then
			return false
		end
	if x and type == AttackTypes.Rocket then
			local x1,y1,z1 = self:GetJointPos("bag")
			local dist = Dist3D(x,y,z,x1,y1,z1)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15
				return false, damage
			end
			local x1,y1,z1 = self:GetJointPos("k_szyja")
			local dist = Dist3D(x,y,z,x1,y1,z1)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15
				return false, damage
			end
	end


    end
return true
end


function Cop_Flamer:CheckDamageFromFlame()
	local idx  = MDL.GetJointIndex(self._Entity,"weapon_joint")
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0.2,0,1.14)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 0.2,0,1.14+self.AiParams.weapon.maxDist)
	if debugMarek then
		self.d1 = x2
		self.d2 = y2
		self.d3 = z2
		self.d4 = x3
		self.d5 = y3
		self.d6 = z3
	end
	local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x3,y3,z3, x2,y2,z2)
	--local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTrace(x3,y3,z3, x2,y2,z2)
	if e then
		--Game:Print("flame col")
		local obj = EntityToObject[e]
		if obj then
			if obj ~= self then
				if obj.Ignite then
					obj:Ignite()
				else
					if obj.OnDamage then
						--if debugMarek then Game:Print("flame col with "..obj._Name) end
						obj:OnDamage(self.flameDamage, self)
						if obj._Class == "CPlayer" then
							self._AIBrain._lastHitTime = self._AIBrain._currentTime
						end
					end
				end
			else
				Game:Print(self._Name.." flame col with self!!!!!!!!!!")
			end
		end
	end
	
	
	
--[[	if math.random(100) < 15 then			-- pozniej moze kilka obiektow "gas" wyrzucac
		local obj = GObjects:Add(TempObjName(),CloneTemplate("GasCop_Flamer.CItem"))
		obj.Pos.X = x2
		obj.Pos.Y = y2
		obj.Pos.Z = z2
		obj.Decal = nil
		obj.whileFlyingSize = 0.1
		obj:Apply()
		local v = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v:Normalize()
		local vel = 8
		ENTITY.SetVelocity(obj._Entity, v.X*vel, v.Y*vel, v.Z*vel)
	end--]]

end

function Cop_Flamer:Flame()
	if not self._flameFX then
		local idx  = MDL.GetJointIndex(self._Entity,"weapon_joint")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,1.14)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,2.4)
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
		self._flameFX = AddPFX(self.flamerFX, 0.4, Vector:New(x2,y2,z2), q)
		if self._flameProc then
			Game.freezeUpdate = true
			if debugMarek then Game:Print("self._flameProc juz istnieje") end
		end
		self._flameProc = true
		self:PlaySound({"maso_flametrower-start"})
		SOUND3D.Play(self._soundSample)
		SOUND3D.SetVolume(self._soundSample, 100.0, 0.3)
		SOUND3D.SetPosition(self._soundSample,self._groundx,self._groundy,self._groundz)
		if self._Flame2 then
			PARTICLE.Die(self._Flame2)
			self._Flame2 = nil
		end
		
		--ENTITY.RegisterChild(self._Entity,self._flameFX)
		--Game:Print("flame start")
	else
		if debugMarek then Game:Print("flame started???") end
	end
end

function Cop_Flamer:FlameEnd()
	--Game:Print("flame end")
	if self._flameFX then
		--ENTITY.Release(self._flameFX)
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end

	self._flameProc = nil

	if not self._Flame2 and self.flame_FX then
		self._Flame2 = self:BindFX(self.flame_FX,0.07,"weapon_joint",0,0,1.14)
	end

end

function Cop_Flamer:CustomUpdate()
	if self.flame_FX and self._flameFX and self.Animation ~= "attack1" then
		self:FlameEnd()
		SOUND3D.SetVolume(self._soundSample, 0.0)
		SOUND3D.Stop(self._soundSample)
		self:PlaySound({"maso_flametrower-stop"})
	end
end





function Cop_Flamer:CustomDelete()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
		Game:Print(self._Name.." !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! maso")
		Game.freezeUpdate = true
	end
	if self._soundSample then
		SOUND3D.Delete(self._soundSample)
		self._soundSample = nil
	end
end


function Cop_Flamer:CustomOnDeathAfterRagdoll()
    local brain = self._AIBrain
	if brain and brain.Objhostage2 then
		brain.Objhostage2._locked = nil
		brain.Objhostage2 = nil
	end
    if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
	self._flameProc = nil

	if self._Flame2 then
		PARTICLE.Die(self._Flame2)
		self._Flame2 = nil
	end
	self:PlaySound({"maso-weapon-explode"})
	if self._soundSample then
		SOUND3D.Delete(self._soundSample)
		self._soundSample = nil
	end
    local x,y,z = self._groundx, self._groundy+0.5, self._groundz--self:GetJointPos(self.AiParams.weaponBindPos)
    if not self._gibbed and self.lasthitjoint=="bag" then
		self:Explosion(x,y,z)
	end
    local tdj = self.s_SubClass.DeathJoints
    if tdj  and self.lasthitjoint=="bag" then
        local size = self.burnPFXSize
        for i=1,table.getn(tdj) do
            self:BindFX(self.burnPFX, size, tdj[i])
        end
    end
end

function Cop_Flamer:GetThrowItemRotation()
	local q = Quaternion:New()
    q:FromEuler(0, math.pi/2-self.angle, math.pi/2)
    return q
end    

function Cop_Flamer:Explosion(x,y,z)
	local aiParams = self.AiParams
	WORLD.Explosion2(x,y,z, aiParams.Explosion.ExplosionStrength,aiParams.Explosion.ExplosionRange,nil,AttackTypes.AIClose,aiParams.Explosion.Damage)
	-- sound
	SOUND.Play3D("weapons/machinegun/rocket_hit",x,y,z,20,150)
	local r = Quaternion:New_FromNormal(0,1,0)
	AddObject("FX_rexplode.CActor",1,Vector:New(x,y,z),r,true) 

	-- light
	AddAction({{"Light:a[1],a[2],a[3],200,200,100, 8, 10 , 1, 0.02,0.1,0.02"}},nil,nil,x,y,z)
	if Game._EarthQuakeProc then
		local g = Templates["Grenade.CItem"]
		Game._EarthQuakeProc:Add(x,y,z, 5, g.ExplosionCamDistance, g.ExplosionCamMove, g.ExplosionCamRotate, false)
	end
	--MDL.SetMeshVisibility(self._Entity,"polySurface1|polySurfaceShape1", false)
end


function Cop_Flamer:OnTick()
	if self._flameFX and self._flameProc then
		local idx  = MDL.GetJointIndex(self._Entity,"weapon_joint")
		--Game:Print("PBindPFXToJoint:itck "..idx)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,1.14)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,2.4)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		q:ToEntity(self._flameFX)
		ENTITY.SetPosition(self._flameFX,x2,y2,z2) 
	end
end

