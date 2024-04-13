function o:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
end


function o:OnCreateEntity()
MDL.SetMeshVisibility(self._Entity, "sprayer_weapon_part2Shape", false)
MDL.SetMeshVisibility(self._Entity, "sprayer_weapon_part1Shape", false)
MDL.SetMeshVisibility(self._Entity, "sprayer_zapalovacShape", false)
if math.random(100)<30 then
		self._spart = self.s_SubClass.ParticlesDefinitions.sprejflame2
		else
			if math.random(100)<50 then
				self._spart = self.s_SubClass.ParticlesDefinitions.sprejflame3
			else

				self._spart = self.s_SubClass.ParticlesDefinitions.sprejflame1
			end
		end


end


function o:Flame()
	if not self._flameFX then
		local s=self._spart
		
        local idx  = MDL.GetJointIndex(self._Entity,s.joint)
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, self.AiParams.weaponBindPosShift.X, self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2,0)

	    self._flameFX = AddPFX(s.pfx, s.scale, Vector:New(x2,y2,z2), q)
	else
		if debugMarek then Game:Print("flame started???") end
	end
end


function o:EndFlame()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

function o:CustomOnDeath()
if self._bindedBill then
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
	end
	self:EndFlame()
	self:EndFlame1()
end



function o:Flame1()
	if not self._flameFX1 then
		local s
		if math.random(100)<30 then
		s = self.s_SubClass.ParticlesDefinitions.sprejflame2
		else
			if math.random(100)<50 then
				s = self.s_SubClass.ParticlesDefinitions.sprejflame3
			else

				s = self.s_SubClass.ParticlesDefinitions.sprejflame1
			end
		end

	
        local idx  = MDL.GetJointIndex(self._Entity,s.joint)
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, self.AiParams.weaponBindPosShift.X, self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2,0)

	    self._flameFX1 = AddPFX(s.pfx, s.scale, Vector:New(x2,y2,z2), q)
	else
		if debugMarek then Game:Print("flame started???") end
	end
end

function o:EndFlame1()
	if self._flameFX1 then
		PARTICLE.Die(self._flameFX1)
		self._flameFX1 = nil
	end
end
