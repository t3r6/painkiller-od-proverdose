function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
	Cache:PrecacheParticleFX(self.transformIntoBigVampFX)
	Cache:PrecacheActor("BrainEater_young.CActor")
end

function o:OnCreateEntity()
	self._lastTimeBurrow = 0
		self._komkour1	= self:BindFX("permgas")
end

function o:CustomOnDamage(he,x,y,z,obj)
	if obj == self then
		return true
	end
end

function o:gas()
	self:BindFX('poisongas')
end

function o:leavemud()
	self:BindFX('leave_effect')
end

function o:startg()
		if not self._komkour1 then
			self._komkour1	= self:BindFX("permgas")
		end

end

function o:endg()
	PARTICLE.Die(self._komkour1)
end

function o:visme()
	ENTITY.EnableDemonic(self._Entity,false,true)
	self.NeverMove=true
end

function o:CustomOnDeath()
	if self.enableTransformHP and self.enableTransformHP <= self.Health then
		if self._AIBrain._onFloor then
			self:PlaySound("transform")
			self:SetAnim("idle", nil, nil, 0)
			self.throwHeart = false
			ENTITY.PO_Enable(self._Entity, false)
			Game:Print("transform")

			local obj = GObjects:Add(TempObjName(),CloneTemplate("BrainEater_young.CActor"))
			obj.Pos.X = self.Pos.X
			obj.Pos.Y = self.Pos.Y
			obj.Pos.Z = self.Pos.Z
			obj.angle = self.angle
			obj._angleDest = self._angleDest
			obj:Apply()
			obj:Synchronize()
 local action = {
    {'AI:p,false'},
    {"PSnd:'misc/spawn_ground',20,30"},
    {'EnablePO:p,false'},    
    {'Anim:p,"enter1",false,0'},
    {'EnableDraw:p,true'},    
    {"Wait:2"},
--    {"WaitForAnim:p"},
    {'AI:p,true'},
    {'EnablePO:p,true'},
}
                        AddAction(action,obj)
			
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
			if self.s_SubClass.GibEmitters then
				for i,v in self.s_SubClass.GibEmitters do
					local gibFX = v[2]
					self:BindFX(gibFX,0.3,v[1], nil,nil,nil, v[3])
				end
			end
			
			--GObjects:ToKill(self)
		end		
	end
end
