function DemonHand:OnInitTemplate()
    self:SetAIBrain()
end

function DemonHand:OnCreateEntity()
    self._AIBrain._lastThrowTime = self._AIBrain._currentTime + FRand(0,2)
    
end

function o:Gloweye()
local l = self.s_SubClass.BillBoard
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,0.0,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill = obj
		end
end

function o:Glowend()
if self._bindedBill then
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
	end
end

function DemonHand:CustomDelete()
if self._bindedBill then
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
	end
end





