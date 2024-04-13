function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
	Cache:PrecacheParticleFX("Altar_Boy_pochodnia")
	Cache:PrecacheParticleFX("Altar_Boy_blast")
	Cache:PrecacheParticleFX("monsterweap_hitground")

end



function o:OnCreateEntity()
--	self:BindFX("pochodnia",0.2,"CandleStickTip",0,0,0)
	   self._AIBrain._lastThrowTime = FRand(-5, 1) 
	self:BindFX("Altar_Boy_pochodnia",0.2,"Weapon",1.8,0,0)
	self:BindSound("actor/mw_altar_boy/aboy_loop",1,10,true)
end


function o:Blast()
--	self:BindFX("pochodnia",0.2,"CandleStickTip",0,0,0)
	self:BindFX("Altar_Boy_blast",2,"Weapon",0,0,0)
end


function o:IfMissedPlaySound()
	local brain = self._AIBrain
	if brain then
		if brain._lastHitTime < brain._lastMissedTime then
			self:PlaySound("missed")
			if self.s_SubClass.hitGroundJoint then
			
				local j = MDL.GetJointIndex(self._Entity, self.s_SubClass.hitGroundJoint)
				Game:Print(j)
				local x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,-0.75,0)

				DEBUGcx = x
				DEBUGcy = y + 0.3
				DEBUGcz = z
				DEBUGfx = x
				DEBUGfy = y - 0.8
				DEBUGfz = z

				local b,d,x1,y1,z1 = WORLD.LineTraceFixedGeom(x,y+0.2,z,x,y-0.8,z)
				if b then
					local q = Quaternion:New_FromNormal(nx,ny,nz)
					AddPFX("monsterweap_hitground",0.17, Vector:New(x1,y1,z1),q)
				end
			end
		end
	end
end
