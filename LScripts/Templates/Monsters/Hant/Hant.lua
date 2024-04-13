function o:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
end


function o:OnCreateEntity()
	self:BindFX("cloud")
	--self:BindFX("pochodnia",0.1,"www333",0,0.4,0.7)
end

function o:IfMissedPlaySound()
	local brain = self._AIBrain
	if brain then
		if brain._lastHitTime < brain._lastMissedTime then
			self:PlaySound("missed")
		end
	end
end

function o:BindTrails()
self._tr1= self:BindTrail('trail_zombie','l_middle_1','l_middle_2','l_middle_3')
self._tr2= self:BindTrail('trail_zombie','l_index_1','l_index_2','l_index_3')
self._tr3= self:BindTrail('trail_zombie','l_pinky_1','l_pinky_2','l_pinky_3')
self._tr4= self:BindTrail('trail_zombie','l_ring_1','l_ring_2','l_ring_3')
self._tr5= self:BindTrail('trail_zombie','r_middle_1','r_middle_2','r_middle_3')
self._tr6= self:BindTrail('trail_zombie','r_index_1','r_index_2','r_index_3')
self._tr7= self:BindTrail('trail_zombie','r_pinky_1','r_pinky_2','r_pinky_3')
self._tr8= self:BindTrail('trail_zombie','r_ring_1','r_ring_2','r_ring_3')
end

function o:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
	ENTITY.Release(self._tr3)
	self._tr3 = nil
	ENTITY.Release(self._tr4)
	self._tr4 = nil
	ENTITY.Release(self._tr5)
	self._tr5 = nil
	ENTITY.Release(self._tr6)
	self._tr6 = nil
	ENTITY.Release(self._tr7)
	self._tr7 = nil
	ENTITY.Release(self._tr8)
	self._tr8 = nil
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
		if debugMarek then Game:Print("flame started???") end
	end
end

function o:OnTick()
end


function o:CheckDamageFromFlame()
		for gg=1,3 do
		local hidx  = MDL.GetJointIndex(self._Entity,'head')
		local xa,ya,za = MDL.TransformPointByJoint(self._Entity, hidx, 0,0,0)
		local hydx  = MDL.GetJointIndex(self._Entity,'eyelid')
		local k = (2-gg)*0.1
		local xb,yb,zb = MDL.TransformPointByJoint(self._Entity, hydx, k,0,k)
		local mv = Vector:New(xb-xa,yb-ya,zb-za)
		mv:Normalize()
		mv:MulByFloat(self.AiParams.flameRange)
		local s = self.s_SubClass.ParticlesDefinitions.atak
		local idx  = MDL.GetJointIndex(self._Entity,'neck')
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		y2 = y2 - 0.2
			local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x2,y2,z2, x2+mv.X,y2,z2+mv.Z)
			if e then
				--Game:Print("flame col")
				local obj = EntityToObject[e]
				if obj and obj.OnDamage then
					if obj ~= self then
						obj:OnDamage(self.AiParams.flameDamage*FRand(0.5,1.0), self)
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

function Hant:StartBreath(name)
	local fx = self.s_SubClass.ParticlesDefinitions[name]
	local pfx = self:AddPFX(fx.pfx,fx.scale)
	ENTITY.RegisterChild(self._Entity,pfx)
	PARTICLE.SetParentOffset(pfx,fx.offset.X,fx.offset.Y,fx.offset.Z,fx.joint, nil,nil,nil, fx.rotation.X, fx.rotation.Y, fx.rotation.Z)
	self._fx = pfx
end

function Hant:StopBreath()
	if self._fx then
		PARTICLE.Die(self._fx)
		self._fx = nil
	end
end

function Hant:OnStartAnim()
	self:StopBreath()
end
function Hant:OnFinishAnim()
	self:StopBreath()
end
