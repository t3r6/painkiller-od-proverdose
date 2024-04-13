function o:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
end

function o:OnPrecache()
	Cache:PrecacheParticleFX("BodyBlood")
	Cache:PrecacheParticleFX("Walking_Tree_dymm")
	Cache:PrecacheParticleFX("Walking_Tree_redeyes")
	Cache:PrecacheParticleFX("Walking_Tree_redattack")
end

function o:OnCreateEntity()
self._s1=self:BindFX("smoke")
self._p1=self:BindFX("eye1")
self._p3=self:BindFX("eye2")
	self:BindSound("actor/mw_walking_tree/tree_loop",5,30,true)
end

function o:IfMissedPlaySound()
	local brain = self._AIBrain
	if brain then
		if brain._lastHitTime < brain._lastMissedTime then
			self:PlaySound("missed")
		end
	end
end

------------------

function o:Flame()
	if not self._flameFX then
		local s = self.s_SubClass.ParticlesDefinitions.atak
		
        local idx  = MDL.GetJointIndex(self._Entity,s.joint)
        local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2,0)

	    self._flameFX = AddPFX(s.pfx, s.scale, Vector:New(x2,y2,z2), q)
	else
		Game:Print("flame started???") 
	end
end

function o:CheckDamageFromFlame()
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
		
		local idx  = MDL.GetJointIndex(self._Entity,'root')
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x2,y2,z2, x2+v.X,y2,z2+v.Z)
		if e then
			--Game:Print("flame col")
			local obj = EntityToObject[e]
			if obj and obj.OnDamage then
				if obj ~= self then
					obj:OnDamage(self.AiParams.flameDamage*FRand(0.5,1.0), self)
					break
				end
			end
		end
	end
end    

function o:OnTick()
	if self._flameFX then
		--local idx  = MDL.GetJointIndex(self._Entity,"joint22")
		--Game:Print("PBindPFXToJoint:itck "..idx)
		local s = self.s_SubClass.ParticlesDefinitions.atak
	
		local idx  = MDL.GetJointIndex(self._Entity,s.joint)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2+FRand(-0.04,0.04),0)
		q:ToEntity(self._flameFX)
		ENTITY.SetPosition(self._flameFX,x2,y2,z2) 
	end
end



function o:EndFlame()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

function o:CustomOnDeath()
	self:EndFlame()
	
end
