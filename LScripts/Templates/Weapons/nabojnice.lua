function nabojnice:OnInitTemplate()
    self:ReplaceFunction("_OnTake","OnTake")
    self:ReplaceFunction("OnTake","nil")
end


--============================================================================
function nabojnice:OnCreateEntity()
	local angle = math.random(0,360)
	local x = math.sin(angle) + math.cos(angle)
	local z = math.cos(angle) - math.sin(angle)
	local y = FRand(1.5, 2.0)
	x = x * self.force[1]
	y = y * self.force[2]
	z = z * self.force[3]
	self:PO_Create(BodyTypes.FromMesh,nil,ECollisionGroups.InsideItems)
	ENTITY.SetAngularVelocity(self._Entity, self.rotate[1], self.rotate[2]*FRand(0.7,1.2), self.rotate[3])
	ENTITY.PO_SetAngularDamping(self._Entity, self.angularDamping)
	ENTITY.PO_SetMovedByExplosions(self._Entity, false)
    ENTITY.RemoveFromIntersectionSolver(self._Entity) 
	ENTITY.PO_Hit(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z,x,y,z)
	self.TimeToLive = self.TimeToLive * FRand(0.8, 1.1)
    self.OnDamage = nil
end
--============================================================================
