function Hang_Body:OnInitTemplate()
    self:ReplaceFunction("Update", nil)
	self:ReplaceFunction("Tick", nil)
    self:ReplaceFunction("_Synchronize","Synchronize")
    self:ReplaceFunction("Synchronize")
end

function Hang_Body:OnApply()
    MDL.SetRagdollLinearDamping(self._Entity,0.5)
    MDL.SetRagdollAngularDamping(self._Entity,0.5)
  MDL.SetRagdollCollisionGroup(self._Entity, ECollisionGroups.HCGNormalNCWithSelf)
      self:EnableRagdoll(true)
    self._enabledRD = true
    self._died = true
    self._deathTimer = 99999
end
