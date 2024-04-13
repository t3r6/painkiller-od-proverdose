o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
MDL.SetAnim(self._Entity,"attack1roll")
	MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.FanRotateSpeed)
self:BindFX("blueburn",0.1,"joint1")
self:BindFX("blueburn",0.1,"joint21")
self:BindFX("blueburn",0.1,"joint2")
self:BindFX("blueburn",0.1,"joint12")
end
