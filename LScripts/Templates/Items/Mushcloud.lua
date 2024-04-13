function Mushcloud:OnPrecache()
    Cache:PrecacheParticleFX(self.burninFX)
    Cache:PrecacheDecal(self.Decal)    
end

function Mushcloud:OnCreateEntity()
	self:PO_Create(BodyTypes.Simple,0.2,ECollisionGroups.FromMesh)
	ENTITY.EnableCollisions(self._Entity, false)
    ENTITY.RemoveFromIntersectionSolver(self._Entity)
	 ENTITY.PO_EnableGravity(self._Entity, false)
	 ENTITY.EnableDraw(self._Entity, false)
    self.OnDamage = nil
	local smokefx = AddPFX("mushroom_expl",0.7)
    ENTITY.RegisterChild(self._Entity,smokefx)
end

function Mushcloud:OnUpdate()
	if math.random(100) < 30 then
		for i,o in Game.Players do
                    if not o._died and o.Health > 0 then
                        local x,y,z = ENTITY.GetPosition(o._Entity)
                        local dist = Dist3D(x,y,z,self.Pos.X, self.Pos.Y, self.Pos.Z)
                        if dist < self.Range then
   		            o:OnDamage(self.damage, nil, AttackTypes.Fire) 
                        end
                    end
                end
		for i,o in Actors do
                if not o._died and o.Health > 0 and not o._burning and not o.NotCountable then
                    local x,y,z = ENTITY.GetWorldPosition(o._Entity)
                    local dist = Dist3D(x,y,z,self.Pos.X, self.Pos.Y, self.Pos.Z)
                    if dist < self.Range then
   		            o:OnDamage(self.damage, nil, AttackTypes.Fire) 
                    end
                end
            end
		
	end
end



function Mushcloud:OnRelease()
	if self._soundSample then
		SOUND3D.Stop(self._soundSample)
	end
end
