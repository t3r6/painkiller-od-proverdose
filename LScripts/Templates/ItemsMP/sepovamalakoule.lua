o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnInitTemplate()
 self._Synchronize = self.Synchronize
    self.Synchronize = nil
end

function o:OnCreateEntity()
ENTITY.EnableNetworkSynchronization(self._Entity,true,true)

    MDL.SetRagdollLinearDamping(self._Entity,0.5)
    MDL.SetRagdollAngularDamping(self._Entity,0.9)
    MDL.EnableRagdoll(self._Entity,true,ECollisionGroups.RagdollNonColliding)    
    MDL.SetRagdollHardDeactivator(self._Entity)
  MDL.SetAnim(self._Entity,"idle")
 MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.AnimSpeed)
end





