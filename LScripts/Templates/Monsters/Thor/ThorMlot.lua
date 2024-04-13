function o:OnInitTemplate()
end



function ThorMlot:OnCreateEntity()
	--self:PO_Create(BodyTypes.Simple)--FromMesh)	-- "mlot", "mlot1"
	--self:PO_Create(BodyTypes.Simple,0.01, ECollisionGroups.Noncolliding)
	--ENTITY.PO_Enable(self._Entity, false)
end

function o:OnDamage(damage, owner, attacktype)
end

function o:OnRelease()
	if debugMarek then Game:Print("mlot on release") end
end

