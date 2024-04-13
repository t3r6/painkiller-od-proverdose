
function o:TD()
GObjects:ToKill(self)
end


function o:OnCreateEntity()
if self.Model == "ge_bones" then
	MDL.SetMeshVisibility(self._Entity, "pCubeShape1", false)
end

	if self.customgibexpsound then
			self:PlaySound(self.customgibexpsound)
	else
	self:PlaySound({"impacts/gib_big","impacts/gib_big2","impacts/gib_big3","impacts/gib_medium","impacts/gib_small"})
	end
	if (math.random(1,2) < 2) then
		self:ForceAnim("exp1", false)
		self._CurAnimLength = MDL.GetAnimLength(self._Entity, self._CurAnimIndex)
		self:ForceAnim("idle", false)
		local a=self._CurAnimLength * 9 / 11
		self.s_SubClass.Animations.exp1   = {self.exp1speed,false,{{a,'TD'},}}
		self:ForceAnim("exp1", false)
	else
	self:ForceAnim("exp2", false)
		self._CurAnimLength = MDL.GetAnimLength(self._Entity, self._CurAnimIndex)
		self:ForceAnim("idle", false)
		local a=self._CurAnimLength * 9 / 11
		self.s_SubClass.Animations.exp2   = {self.exp2speed,false,{{a,'TD'},}}
		self:ForceAnim("exp2", false)
		

	end
	self._timer=0
	self.TimeToLive=90
end

function o:CustomUpdate()
		self.TimeToLive = self.TimeToLive - 1
		if self.TimeToLive < 0 then
			self.TimeToLive = nil
			GObjects:ToKill(self)
		end
end


function o:CustomOnDeath()
end
