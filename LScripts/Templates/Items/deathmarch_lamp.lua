o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
	MDL.SetRagdollCollisionGroup(self._Entity, ECollisionGroups.HCGNormalBodyNCWithSelf)
	--ENTITY.PO_SetCollisionGroup(self._Entity, ECollisionGroups.HCGNormalBodyNCWithSelf)
	
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)
	MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.speed)
    
    local j = MDL.GetJointIndex(self._Entity, "joint3")
    ENTITY.EnableCollisionsToRagdoll(self._Entity, j, 0.1, 0)

	self:BindFX('e1')
	self:BindFX('e2')
	self:BindFX('e3')
		local l = self.s_SubClass.Light
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,0.0,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedLight = obj
		end
		l = self.BillBoard
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,0.0,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill = obj
		end

self:BindSound("C8L04_Dead_march/ball_loop1",5,30,true)
self:BindSound("C8L04_Dead_march/ball_loop2",2,20,true)

end

function o:OnCollision(x,y,z,nx,ny,nz,e,he_me,he_other)
	if e then
		local obj = EntityToObject[e]
		if obj and obj.OnDamage then
            obj:OnDamage(15, nil, AttackTypes.Shuriken,x,y,z,nx,ny,nz)
            ENTITY.PO_Hit(e,x,y,z,nx*1200,ny*1200,nz*1200)
            if obj._Class == "CPlayer" then
                ENTITY.PO_SetPlayerShocked(e)
			end
            self:SndEnt("Hit",obj._Entity)
		end
	end
end


function o:Tick()
	if self._bindedLight then
		local l = Templates[self.s_SubClass.Light.template]
		local rnd = 1
		local i = l.Intensity
		LIGHT.SetIntensity(self._bindedLight._Entity, i * rnd)
		local f = l.StartFalloff * rnd
		local radius = l.Range * rnd
		LIGHT.SetFalloff(self._bindedLight._Entity,f,radius)
	end
end

