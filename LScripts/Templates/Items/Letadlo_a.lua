o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
MDL.SetAnim(self._Entity,"idle")
self._Flame = self:BindFX(self.flame_FX,self.flame_FXscale,'body',0,-0.3,0)
MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.flightspeed)

self:BindSound("c8l02_air_combat/plane4",40,70,true)

 
end

