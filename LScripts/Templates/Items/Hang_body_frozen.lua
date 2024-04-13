o.OnInitTemplate = CItem.StdOnInitTemplate

function Hang_body_frozen:OnCreateEntity()
    MDL.SetRagdollLinearDamping(self._Entity,0.5)
    MDL.SetRagdollAngularDamping(self._Entity,0.5)
    MDL.EnableRagdoll(self._Entity,true,ECollisionGroups.RagdollNonColliding)
    MDL.SetRagdollHardDeactivator(self._Entity)
    MDL.SetMaterial(self._Entity, "palskinned_freeze")
end
