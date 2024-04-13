o.OnInitTemplate = CItem.StdOnInitTemplate

function Vrtulka:OnCreateEntity()
	MDL.SetAnim(self._Entity,"idle")
	MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.FanRotateSpeed)
end
