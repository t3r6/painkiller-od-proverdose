--o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
	self:PO_Create(BodyTypes.FromMesh)
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)
   
--    MDL.SetAnim(self._Entity,"none")
end

function o:CustomOnDamage(damage, owner, attacktype, x, y, z, nx, ny, nz, he)
	 if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "gong"  then
	PlaySound2D("actor/maso/maso_grenade-explosion")
	end
	end
end
