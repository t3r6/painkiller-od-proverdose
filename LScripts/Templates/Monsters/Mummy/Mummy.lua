function Mummy:OnInitTemplate()
    self:SetAIBrain()
end

function Mummy:OnPrecache()
Cache:PrecacheParticleFX("torch_hitground") 
Cache:PrecacheParticleFX("Mummy_flame") 
    Cache:PrecacheItem("Tang.")
end


function Mummy:OnCreateEntity()
	 self:BindSound("actor/mw_mummy/mummy_loop",1,15,true)
    self._AIBrain._lastThrowTime = FRand(-5, 1) 
    if debugMarek then
		self._AIBrain._lastThrowTime = -100
    end
	if self.flame_FX then
		self:Flame2()
	end

    self._soundSample = SOUND3D.Create("actor/mw_mummy/mummy_blowfire-loop")
	SOUND3D.SetHearingDistance(self._soundSample,14,42)
    SOUND3D.SetLoopCount(self._soundSample,0) 
    SOUND3D.SetVolume(self._soundSample, 0.0)

	
	local l = self.s_SubClass.Light
	if l then
		if Game._numberOfDynLigths < 3 then
			Game._numberOfDynLigths = Game._numberOfDynLigths + 1
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,0,0.6)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedLight = obj
		end
	end
	l = self.s_SubClass.BillBoard
	if l then
		local obj = CloneTemplate(l.template)
		obj.Pos:Set(0,0,0.6)
		obj:Apply()
		ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
		self._bindedBill = obj
	end

end

function Mummy:Flame2()
	if not self._Flame2 then
		self._Flame2 = self:BindFX(self.flame_FX,0.22,"weapon",0,0,0.6)	--1.05,-0.6,0.0)
	end
end

function Mummy:CustomUpdate()
--	if self.flame_FX and self._flameFX and self.Animation ~= "atak1" then
--		self:FlameEnd()
		--Game:Print("flame end, bo end anim")
--	end
end

function Mummy:IgniteBomb()
	if self._objTakenToThrow then
		self._objTakenToThrow._snd  = self._objTakenToThrow:BindSound("actor/Mummy/fuse_burning-loop",5,26,true)
        self._objTakenToThrow:BindFX("EM_lont", 0.1)
	end
end

function Mummy:CheckDamageFromFlame()
	local angle = self.angle - 0.08
	
	for gg=1,3 do
		local v = Vector:New(math.sin(angle), 0, math.cos(angle))
		angle = angle + 0.08
		v:Normalize()
		if gg == 2 then
			v:MulByFloat(self.AiParams.flameRange)
		else
			v:MulByFloat(self.AiParams.flameRange*0.9)
		end
		
		local s = self.s_SubClass.ParticlesDefinitions.atak
		
		local idx  = MDL.GetJointIndex(self._Entity,s.joint)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		y2 = y2 - 0.2
		local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x2,y2,z2, x2+v.X,y2,z2+v.Z)
		if e then
			--Game:Print("flame col")
			local obj = EntityToObject[e]
			if obj and obj.OnDamage and  obj._Class == "CPlayer"   then
				if obj ~= self then
					obj:OnDamage(self.AiParams.flameDamage*FRand(0.5,1.0), self)
					break
				end
			end
		end
	end
end

function Mummy:Flame()
	if not self._flameFX then
		local s = self.s_SubClass.ParticlesDefinitions.atak
		
        local idx  = MDL.GetJointIndex(self._Entity,s.joint)
        local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2,0)

	    self._flameFX = AddPFX(s.pfx, s.scale, Vector:New(x2,y2,z2), q)
	else
		if debugMarek then Game:Print("flame started???") end
	end
end

function Mummy:EndFlame()
	Game:Print("flame end")
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

--[[function Mummy:CustomUpdate()
	if self.flame_FX and self._flameFX and self.Animation ~= "atak1" then
		self:FlameEnd()
	end
end
--]]

function Mummy:CustomDelete()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
	if self._soundSample then
		SOUND3D.Delete(self._soundSample)
		self._soundSample = nil
	end
	Game._numberOfDynLigths = Game._numberOfDynLigths - 1
end


function Mummy:CustomOnDeath()
    if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
	self._flameProc = nil

	--if self._Flame2 then
	--	PARTICLE.Die(self._Flame2)
	--	self._Flame2 = nil
	--end
	
	self:Flame2()
	
	--self:PlaySound({"$/actor/maso/maso-weapon-explode"})
	if self._soundSample then
		SOUND3D.Delete(self._soundSample)
		self._soundSample = nil
	end
end

function Mummy:CustomOnRagdollCollision(x,y,z,nx,ny,nz,j)
	if j == 21 then			-- gaszenie pochodni
		if self._bindedLight then
			--ENTITY.UnregisterAllChildren(self._Entity)		-- dodac typ
			GObjects:ToKill(self._bindedLight)
			self._bindedLight = nil
			local q = Quaternion:New_FromNormal(nx,ny,nz)
			AddPFX("torch_hitground", 0.2, Vector:New(x,y,z),q)
		end
		if self._bindedBill then
			--ENTITY.UnregisterAllChildren(self._Entity)
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
		end
		if self._Flame2 then
			PARTICLE.Die(self._Flame2)
			self._Flame2 = nil
		end

	end
end

function Mummy:OnTick()
	if self._flameFX and self._flameProc then
		local idx  = MDL.GetJointIndex(self._Entity,"weapon")
		local idx2  = MDL.GetJointIndex(self._Entity,"head")

		--Game:Print("PBindPFXToJoint:itck "..idx)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx2, 0.0,0.0,0.0)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 0.8,-0.8,0.0)
		local v2 = Vector:New(x3 - x2, 0, z3 - z2)
		v2:Normalize()
		
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		q:ToEntity(self._flameFX)
		ENTITY.SetPosition(self._flameFX,x3,y2,z3) 
	end

	if self._bindedLight then
		local l = Templates[self.s_SubClass.Light.template]
		local rnd = FRand(0.85, 1.0)
		local i = l.Intensity
		LIGHT.SetIntensity(self._bindedLight._Entity, i * rnd)
		local f = l.StartFalloff * rnd
		local radius = l.Range * rnd
		LIGHT.SetFalloff(self._bindedLight._Entity,f,radius)
	end

end
