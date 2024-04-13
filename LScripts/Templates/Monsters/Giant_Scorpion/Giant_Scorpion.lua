function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
	Cache:PrecacheParticleFX(self.eyeFX)
	Cache:PrecacheParticleFX(self.transformIntoBigVampFX)
	Cache:PrecacheActor("Scarabeus.CActor")
end

function o:OnCreateEntity()
--	self._AIBrain._lastThrowTime = FRand(-2, 2)
--	self:BindFX("pochodnia",0.1,self.AiParams.weaponBindPos,self.AiParams.weaponBindPosShift.X,self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
	self:BindFX(self.eyeFX,0.03,"TailF",0.1,0.2,0)
	self:BindFX(self.eyeFX,0.03,"TailF",-0.1,0.2,0)
	self._lastTimeJump = 0
end

function o:CustomOnDamage(he,x,y,z,obj)
	if obj == self then
		return true
	end
end

function o:OnThrow(x,y,z)
	local aiParams = self.AiParams
	local gun = aiParams.weapon
	local v2 = Vector:New(x,y,z)
	v2:Normalize()
	local q = Quaternion:New_FromNormal(v2.X, v2.Y, v2.Z)

    local idx
    
	--[[if self._useSecondWeapon then
		idx = MDL.GetJointIndex(self._Entity, aiParams.secondWeaponBindPos)
	else
        idx = MDL.GetJointIndex(self._Entity, aiParams.weaponBindPos)
    end
	local srcx,srcy,srcz = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)--]]
	
	local srcx,srcy,srcz = self._objTakenToThrow.Pos.X,self._objTakenToThrow.Pos.Y,self._objTakenToThrow.Pos.Z
	if gun.fireParticle then
		AddPFX(gun.fireParticle, gun.fireParticleSize, Vector:New(srcx,srcy,srcz), q)
	end
end

function o:CustomOnDeath()
	if self.enableTransformHP and self.enableTransformHP <= self.Health then
		if self._AIBrain._onFloor then
			self:PlaySound("transform")
			self:SetAnim("idle", nil, nil, 0)
			self.throwHeart = false
			ENTITY.PO_Enable(self._Entity, false)
			Game:Print("transform")

			local obj = GObjects:Add(TempObjName(),CloneTemplate("Scarabeus.CActor"))
			obj.Pos.X = self.Pos.X
			obj.Pos.Y = self.Pos.Y+1
			obj.Pos.Z = self.Pos.Z
			obj.angle = self.angle
			obj._angleDest = self._angleDest
			obj:Apply()
			obj:Synchronize()
			Game:Print("transforme")
			--local tdj = obj.s_SubClass.DeathJoints
			--if tdj then
			--	local size = obj._SphereSize * 0.4
			--	for i=1,table.getn(tdj) do
			--		--local x,y,z = obj:GetJointPos(tdj[i])
			--		--AddPFX(self.transformIntoBigVampFX, size ,Vector:New(x,y,z))
			--		obj:BindFX(self.transformIntoBigVampFX, size, tdj[i])
			--	end
			--end
			Game.BodyCountTotal = Game.BodyCountTotal - 1
			Game:Print("transformr")
			if self.s_SubClass.GibEmitters then
				for i,v in self.s_SubClass.GibEmitters do
					local gibFX = v[2]
					self:BindFX(gibFX,0.3,v[1], nil,nil,nil, v[3])
				end
			end
			
			GObjects:ToKill(self)
			
			--Game:Print("transform")

		end		
	end
end
