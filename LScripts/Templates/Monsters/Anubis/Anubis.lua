function Anubis:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
end



function Anubis:OnCreateEntity()
	self._AIBrain._lastThrowTime = FRand(-2, 2)
	self:BindFX('koule')
	self:BindFX('prach')
	local l = self.s_SubClass.Light
	if l then
		if Game._numberOfDynLigths < 3 then
			Game._numberOfDynLigths = Game._numberOfDynLigths + 1
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(1,0,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedLight = obj
		end
	end
	
	l = self.s_SubClass.BillBoard
	if l then
		local obj = CloneTemplate(l.template)
		obj.Pos:Set(1,0,0)
		obj:Apply()
		ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
		self._bindedBill = obj
	end
	
	
end

function Anubis:Burntip()
self._tiplight=self:BindFX('tip')
end

function Anubis:Tipend()
	if self._tiplight then
		PARTICLE.Die(self._tiplight)
		self._tiplight = nil
	end
end

--[[function Templar:GetThrowItemRotation()
	local q = Quaternion:New()
	q:FromEuler( 0, -self.angle, 0)
	return q
end--]]

function Anubis:OnThrow(x,y,z)
	--local q = Quaternion:New()
    --Game:Print("yaw "..(yaw*180/math.pi).." pitch "..(pitch*180/math.pi))
    local v = Vector:New(x,y,z)
    v:Normalize()
	local q = Quaternion:New_FromNormalX(v.X, v.Y, v.Z)
	--Game:Print(v.X.." "..v.Y.." "..v.Z)
	--Game:Print(q.X.." "..q.Y.." "..q.Z)
    q:ToEntity(self._objTakenToThrow._Entity)
end


function o:CustomOnDeath()
	MDL.SetMeshVisibility(self._Entity,"CarpetM1Shape",false)
if self._bindedBill then
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
	end
end
