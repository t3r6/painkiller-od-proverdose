-------------------------------------------------------------------------------
function BrokenSoul:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,false,2)
    ENTITY.SetSynchroString(self._Entity,"BrokenSoul.CItem")
    self:PO_Create(BodyTypes.SphereSweep,0.001,ECollisionGroups.Noncolliding)
    ENTITY.EnableDraw(self._Entity,false)
    ENTITY.EnableCollisions(self._Entity)
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)
    self._time = 0
    self._lPos = Vector:New(self.Pos)


	self:Client_OnCreateEntity(self._Entity)
end
--============================================================================
function BrokenSoul:Client_OnCreateEntity(entity)
	if Game.GMode ~= GModes.SingleGame then
    local fx = AddPFX("FX_scream",0.5,Vector:New(0,0,0))
    ENTITY.RegisterChild(entity,fx)
    PARTICLE.SetParentOffset(fx,0,0,0,nil)

    local fx = AddPFX("FX_scream2",0.55,Vector:New(0,0,0))
    ENTITY.RegisterChild(entity,fx)
    PARTICLE.SetParentOffset(fx,0,0,0,nil)


	end

end
--============================================================================
function BrokenSoul:OnApply()
	if Game.GMode == GModes.SingleGame and self.Central==1 then
    local fx = AddPFX("FX_scream",0.5,Vector:New(0,0,0))
    ENTITY.RegisterChild(self._Entity,fx)
    PARTICLE.SetParentOffset(fx,0,0,0,nil)

    local fx = AddPFX("FX_scream2",0.55,Vector:New(0,0,0))
    ENTITY.RegisterChild(self._Entity,fx)
    PARTICLE.SetParentOffset(fx,0,0,0,nil)
	end
end
--============================================================================
function BrokenSoul:OnPrecache()
	Cache:PrecacheParticleFX("FX_scream")
	Cache:PrecacheParticleFX("FX_scream2")
end
-------------------------------------------------------------------------------
function BrokenSoul:Update()
    self.Timeout = self.Timeout - 1
    if self.Timeout <= 0 then   
        self:OnCollision(self.Pos.X,self.Pos.Y,self.Pos.Z,0,0,0)
    end
end
-------------------------------------------------------------------------------
function BrokenSoul:Tick(delta)    
    
    self._time = self._time + delta     
    local x,y,z = ENTITY.GetPosition(self._Entity)
    local vx,vy,vz,vl = ENTITY.GetVelocity(self._Entity)    
    
    ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
    ENTITY.RemoveFromIntersectionSolver(self._Entity)    
    local b,d,lx,ly,lz,nx,ny,nz,he,e = WORLD.LineTrace(self._lPos.X,self._lPos.Y,self._lPos.Z,x,y,z)            
    ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
    ENTITY.AddToIntersectionSolver(self._Entity)
    
    if b then self:OnCollision(lx,ly,lz,nx,ny,nz,e,he) end    
    self._lPos:Set(x,y,z)
	if self._time > self.Timeout then
	    GObjects:ToKill(self)
	end
    
end
-------------------------------------------------------------------------------
function BrokenSoul:OnCollision(x,y,z,nx,ny,nz,e,he)
   local mode = 0
    local obj = EntityToObject[e]
    if obj then
            if obj._Class == "CActor"  or  obj._Class == "CPlayer"   and not obj._died  then
            	mode = 1
            end        
	    d=self.damage
	    if obj.OnDamage then
			if obj.ToughOne or obj.IsBoss then
    				self.CL_OnHit(e,x,y,z,mode)
	    			GObjects:ToKill(self)
				local o
				if not obj.ScreamDamage then  o=100 else  o=obj.ScreamDamage end	
				if math.random(100)>o then 	d=0 end
			end
                	obj:OnDamage(d,self.ObjOwner,AttackTypes.Scream,x,y,z,nx,ny,nz,he)  
            end
    end
    self.CL_OnHit(e,x,y,z,mode)
    if  ENTITY.IsFixedMesh(e) then
    GObjects:ToKill(self)
	end
end
-------------------------------------------------------------------------------
function BrokenSoul:CL_OnHit(e,x,y,z,mode)
    
    
    PlaySound3D("impacts/bullet-glass1",x,y,z,10,25)        
    --AddPFX("RifleHitWall", 0.5 ,Vector:New(x,y,z))       
end
Network:RegisterMethod("BrokenSoul.CL_OnHit", NCallOn.AllClients, NMode.Reliable, "efffb") 
-------------------------------------------------------------------------------
