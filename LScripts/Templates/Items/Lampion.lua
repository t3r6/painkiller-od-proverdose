--o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
self:PO_Create(BodyTypes.FromMesh)
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)
   
--    MDL.SetAnim(self._Entity,"none")
end

function o:Update()
	if self._gibbed then
		if self.LifeG > 0 then 
			self.LifeG = self.LifeG -1
		else
			GObjects:ToKill(self)
		end
	end
end
