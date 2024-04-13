--o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
self.tanim=240
self.tta=1
MDL.SetAnim(self._Entity,"take1")
self._Flame = self:BindFX(self.flame_FX,self.flame_FXscale,'chase',0,-0.3,0)

self:BindSound("C8L01_riot/subway_loop1",20,200,true,'chase')
self:BindSound("C8L01_riot/subway_loop2",20,200,true,'chase')

end


function o:OnUpdate()
self.tanim = self.tanim-1
if self.tanim < 1 then
	if math.random(10) < 5 or self.tta >0 then
			MDL.SetAnim(self._Entity,"none")
			self.tanim=180
			self.tta=0
	else
		if math.random(10) < 5 then
			MDL.SetAnim(self._Entity,"take1")
			self.tanim=240
			self.tta=1
		else
			MDL.SetAnim(self._Entity,"take2")
			self.tanim=240
			self.tta=2
		end
	end

end


end
