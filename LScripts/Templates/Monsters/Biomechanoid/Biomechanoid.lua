function Biomechanoid:OnPrecache()
	Cache:PrecacheParticleFX(self.flamerFX)
	Cache:PrecacheParticleFX(self.flame_FX)
end



function Biomechanoid:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
end

function Biomechanoid:OnCreateEntity()
	l = self.s_SubClass.BillBoard
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,-0.4,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill = obj
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,0.4,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill2 = obj
		end
	self:BindFX('ambient1')
	self:BindFX('ambient3')
	self._Flame2=self:BindFX('ambient2')
	self:BindSound("actor/mw_biomechanoid/biomech_idle",8,30,true)
--	self:BindSound("actor/mw_biomechanoid/biomech_fireloop",8,30,true)
	self:BindSound("actor/mw_biomechanoid/biomech_loop",4,20,true)
end

function Biomechanoid:Flame()
	if not self._flameFX then
		local idx  = MDL.GetJointIndex(self._Entity,"l_finger")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 1,0,0)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		self._flameFX = AddPFX(self.flamerFX, 0.4, Vector:New(x2,y2,z2),q )
		if self._flameProc then
			Game.freezeUpdate = true
			if debugMarek then Game:Print("self._flameProc juz istnieje") end
		end
		self._flameProc = true
		SOUND3D.Play(self._soundSample)
		SOUND3D.SetVolume(self._soundSample, 100.0, 0.3)
		SOUND3D.SetPosition(self._soundSample,self._groundx,self._groundy,self._groundz)
		if self._Flame2 then
			PARTICLE.Die(self._Flame2)
			self._Flame2 = nil
		end
	end
end

function Biomechanoid:FlameEnd()
	--Game:Print("flame end")
	if self._flameFX then
		--ENTITY.Release(self._flameFX)
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end

	self._flameProc = nil

	if not self._Flame2 and self.flame_FX then
		self._Flame2 = self:BindFX(self.flame_FX,0.1,"l_finger",0,0,0.2)
	end

end


function Biomechanoid:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Demon then
        return false
    end

    if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "shield" then
            if type == AttackTypes.Shotgun or type == AttackTypes.MiniGun or type == AttackTypes.Painkiller then
				self:PlaySound({"$/actor/maso/maso_hit_impact1","$/actor/maso/maso_hit_impact2"},22,52)
            end
			return true
		end
	else
		if type == AttackTypes.Physics then
			return false
		end
		if x and type == AttackTypes.Rocket then
			local x1,y1,z1 = self:GetJointPos("root")
			local dist = Dist3D(x,y,z,x1,y1,z1)
			Game:Print("odleglosc wybuchu od jointa : "..dist.." "..damage)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15
				return false, damage
			end
		end
	end
	return false
end

function Biomechanoid:CheckDamageFromFlame()
	local idx  = MDL.GetJointIndex(self._Entity,"l_finger")
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 1,0,1)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 1+self.AiParams.attackRange2,0,1)
	local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x3,y3,z3, x2,y2,z2)
	--local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTrace(x3,y3,z3, x2,y2,z2)
	if e then
		local obj = EntityToObject[e]
		if obj then
			if obj ~= self then
				if obj.Ignite then
					obj:Ignite()
				else
					if obj.OnDamage then
						--if debugMarek then Game:Print("flame col with "..obj._Name) end
						obj:OnDamage(self.flameDamage, self)
						Game:Print("loc "..obj._Class)
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
	
end




function Biomechanoid:CustomUpdate()
	if self.flame_FX and self._flameFX and self.Animation ~= "attack3" then
		self:FlameEnd()
		SOUND3D.SetVolume(self._soundSample, 0.0)
		SOUND3D.Stop(self._soundSample)
		self:PlaySound({"maso_flametrower-stop"})
	end
end
--[[function Biomechanoid:GetThrowItemRotation()
	local q = Quaternion:New()
	q:FromEuler( 0, -self.angle, 0)
	return q
end--]]

function Biomechanoid:OnThrow(x,y,z)
	--local q = Quaternion:New()
    --Game:Print("yaw "..(yaw*180/math.pi).." pitch "..(pitch*180/math.pi))
    local v = Vector:New(x,y,z)
    v:Normalize()
	local q = Quaternion:New_FromNormalX(v.X, v.Y, v.Z)
	--Game:Print(v.X.." "..v.Y.." "..v.Z)
	--Game:Print(q.X.." "..q.Y.." "..q.Z)
    q:ToEntity(self._objTakenToThrow._Entity)
end


function Biomechanoid:OnTick()
	if self._flameFX and self._flameProc then
		local idx  = MDL.GetJointIndex(self._Entity,"l_finger")
		--Game:Print("PBindPFXToJoint:itck "..idx)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx, 1,0,0)
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)
		q:ToEntity(self._flameFX)
		ENTITY.SetPosition(self._flameFX,x2,y2,z2) 
	end
end

function Biomechanoid:CustomOnDeath()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
		if self._Flame2 then
		PARTICLE.Die(self._Flame2)
		self._Flame2 = nil
	end
	if self._bindedBill then
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
			GObjects:ToKill(self._bindedBill2)
			self._bindedBill2 = nil
		
	end
	
end
