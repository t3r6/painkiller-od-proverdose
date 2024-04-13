function o:Flame()
	if not self._flameFX1 then
		local idx  = MDL.GetJointIndex(self._Entity,"weapon_joint")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,3.14)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 4,-6,3.14)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		self._flameFX1 = AddPFX(self.flamerFX, 0.4, Vector:New(x2,y2,z2), q)
		if self._flameProc then
			Game.freezeUpdate = true
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
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,3.14)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 0,-6,3.14+self.AiParams.weapon.maxDist)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		self._flameFX2 = AddPFX(self.flamerFX, 0.4, Vector:New(x2,y2,z2), q)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,3.14)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 8,-6,3.14+self.AiParams.weapon.maxDist)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		self._flameFX3 = AddPFX(self.flamerFX, 0.4, Vector:New(x2,y2,z2), q)
	end
end

function o:FlameEnd()
	if self._flameFX1 then
		PARTICLE.Die(self._flameFX1)
		self._flameFX1 = nil
		PARTICLE.Die(self._flameFX2)
		self._flameFX2 = nil
		PARTICLE.Die(self._flameFX3)
		self._flameFX3 = nil
	end
	self._flameProc = nil
	if not self._Flame2 and self.flame_FX then
		self._Flame2 = self:BindFX(self.flame_FX,0.07,"weapon_joint",0,0,3.14)
	end

end

function o:CheckDamageFromFlame()
	local idx  = MDL.GetJointIndex(self._Entity,"weapon_joint")

	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,-0.9,3.14)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 4,-8,3.14+self.AiParams.weapon.maxDist)
	local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x3,y3,z3, x2,y2,z2)
	if e then
		local obj = EntityToObject[e]
		if obj then
			if obj ~= self then
				Game:Print("flame col obj.."..obj._Class)
				if obj.Ignite then
					obj:Ignite()
				else
					if obj.OnDamage then
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
		if Player and Dist3D(xcol,ycol,zcol,Player.Pos.X,Player.Pos.Y-1,Player.Pos.Z)<1.5 then
						Player:OnDamage(self.flameDamage, self)
						self._AIBrain._lastHitTime = self._AIBrain._currentTime
		end
	end
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,-0.9,3.14)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 0,-7,3.14+self.AiParams.weapon.maxDist)
	local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x3,y3,z3, x2,y2,z2)
	if e then
		local obj = EntityToObject[e]
		if obj then
			if obj ~= self then
				if obj.Ignite then
					obj:Ignite()
				else
					if obj.OnDamage then
						obj:OnDamage(self.flameDamage, self)
						if obj._Class == "CPlayer" then
							self._AIBrain._lastHitTime = self._AIBrain._currentTime
						end
					end
				end
			end
		end
		if Player and Dist3D(xcol,ycol,zcol,Player.Pos.X,Player.Pos.Y-1,Player.Pos.Z)<1.5 then
						Player:OnDamage(self.flameDamage, self)
						self._AIBrain._lastHitTime = self._AIBrain._currentTime
		end
	end	
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,-0.9,3.14)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 8,-7,3.14+self.AiParams.weapon.maxDist)
	local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x3,y3,z3, x2,y2,z2)
	if e then
		local obj = EntityToObject[e]
		if obj then
			if obj ~= self then
				if obj.Ignite then
					obj:Ignite()
				else
					if obj.OnDamage then
						obj:OnDamage(self.flameDamage, self)
						if obj._Class == "CPlayer" then
							self._AIBrain._lastHitTime = self._AIBrain._currentTime
						end
					end
				end
			end
		end
		if Player and Dist3D(xcol,ycol,zcol,Player.Pos.X,Player.Pos.Y-1,Player.Pos.Z)<1.5 then
						Player:OnDamage(self.flameDamage, self)
						self._AIBrain._lastHitTime = self._AIBrain._currentTime
		end
	end		
	
end

function o:OnTick()
	if self._flameFX1 and self._flameProc then
		local idx  = MDL.GetJointIndex(self._Entity,"weapon_joint")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0.3,-0.3,3.02)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 6,-6,3.14+self.AiParams.weapon.maxDist)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		q:ToEntity(self._flameFX1)
		ENTITY.SetPosition(self._flameFX1,x2,y2,z2) 
		
		x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 10,-6,3.14+self.AiParams.weapon.maxDist)
		v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		q:ToEntity(self._flameFX2)
		ENTITY.SetPosition(self._flameFX2,x2,y2,z2) 

		x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 2,-6,3.14+self.AiParams.weapon.maxDist)
		v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		q:ToEntity(self._flameFX3)
		ENTITY.SetPosition(self._flameFX3,x2,y2,z2) 
	end
end

function o:CustomUpdate()
	if self.flame_FX and self._flameFX1 and self.Animation ~= "attack1" then
		self:FlameEnd()
		SOUND3D.SetVolume(self._soundSample, 0.0)
		SOUND3D.Stop(self._soundSample)
		self:PlaySound({"maso_flametrower-stop"})
	end
end

function o:CustomDelete()
	if self._flameFXI1 then
		PARTICLE.Die(self._flameFX1)
		self._flameFX1 = nil
		PARTICLE.Die(self._flameFX2)
		self._flameFX2 = nil
		PARTICLE.Die(self._flameFX3)
		self._flameFX3 = nil
		Game.freezeUpdate = true
	end
	if self._soundSample then
		SOUND3D.Delete(self._soundSample)
		self._soundSample = nil
	end
end


function o:CustomOnDeathAfterRagdoll()
    local brain = self._AIBrain
	if brain and brain.Objhostage2 then
		brain.Objhostage2._locked = nil
		brain.Objhostage2 = nil
	end
    if self._flameFX1 then
		PARTICLE.Die(self._flameFX1)
		self._flameFX1 = nil
		PARTICLE.Die(self._flameFX2)
		self._flameFX2 = nil
		PARTICLE.Die(self._flameFX3)
		self._flameFX3 = nil
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
