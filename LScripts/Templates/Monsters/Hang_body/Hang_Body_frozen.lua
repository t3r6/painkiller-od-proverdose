function Hang_Body_frozen:OnCreateEntity()
   local shader = "palskinned_freeze"
    MDL.SetMaterial(self._Entity, shader)

end