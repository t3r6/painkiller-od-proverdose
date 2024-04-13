o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
MDL.SetAnim(self._Entity,"idle")
self._Flame = self:BindFX(self.flame_FX,self.flame_FXscale,'body',0,-0.3,0)
MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.flightspeed)
if math.random(4) > 1  then
self:BindSound("c8l02_air_combat/plane4",40,70,true)
elseif math.random(3) > 1 then
self:BindSound("c8l02_air_combat/plane3",40,70,true)
elseif math.random(2) > 1 then
self:BindSound("c8l02_air_combat/plane2",40,70,true)
else
self:BindSound("c8l02_air_combat/plane1",40,70,true)
 end
 
end

