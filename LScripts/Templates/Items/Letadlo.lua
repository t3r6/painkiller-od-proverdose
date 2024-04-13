o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
	MDL.SetRagdollCollisionGroup(self._Entity, 	ECollisionGroups.HCGNormalBodyNCWithSelf)
	 ENTITY.PO_SetMovedByExplosions(self._Entity, false)
    
    MDL.SetAnim(self._Entity,"none")
	MDL.SetMeshVisibility(self._Entity,"pomalaShape",false)
	MDL.SetMeshVisibility(self._Entity,"jeblaShape",false)

self:BindSound("c8l02_air_combat/plane4",40,70,true)

end

function o:vrtule1()
	MDL.SetMeshVisibility(self._Entity,"rychla_trans_2sidedShape",false)
	MDL.SetMeshVisibility(self._Entity,"pomalaShape",true)
end

function o:vrtule2()
	MDL.SetMeshVisibility(self._Entity,"pomalaShape",false)
	MDL.SetMeshVisibility(self._Entity,"jeblaShape",true)
end



function o:deadend()
j = MDL.GetJointIndex(self._Entity, "body")
x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
AddPFX("Grenade",3.5,Vector:New(x,y,z))

j = MDL.GetJointIndex(self._Entity, "prop")
x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
AddPFX("Grenade",3.5,Vector:New(x,y,z))

j = MDL.GetJointIndex(self._Entity, "body")
x,y,z = MDL.TransformPointByJoint(self._Entity, j,0,0,0)
AddPFX("Grenade",3.5,Vector:New(x,y,z))

GObjects:ToKill(self)	
end