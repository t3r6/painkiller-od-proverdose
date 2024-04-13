o.OnInitTemplate = CItem.StdOnInitTemplate

function Flying_blade:OnCreateEntity()

    ENTITY.EnableNetworkSynchronization(self._Entity,true,true,2)       
    local param = "s"
        
    ENTITY.SetSynchroString(self._Entity,"Flying_blade.CItem"..":"..param)
    
--    self:PO_Create(BodyTypes.Simple,2,ECollisionGroups.Normal)
   self:PO_Create(BodyTypes.Simple,self.Scale,ECollisionGroups.Noncolliding)
    ENTITY.RemoveFromIntersectionSolver(self._Entity)
    self.StartPos = Clone(self.Pos)        
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)    
    
    self:Client_OnCreateEntity(self._Entity,param)
    ENTITY.PO_SetMissile(self._Entity, MPProjectileTypes.PainHead )
	 BindFX(self._Entity,"blueburn",0.15,"root",0,0,0)
    BindSoundToEntity(self._Entity,"weapons/Flyingblade/flyingblade_loop",3,30,true,nil,nil,nil,nil,0.1)   
end

--============================================================================
function Flying_blade:Client_OnCreateEntity(entity,param)
	MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, 2)
end
--============================================================================
function Flying_blade:OnPrecache()
end

function Flying_blade:Trace(ex,ey,ez,sx,sy,sz)
    ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)    
    local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(ex,ey,ez,sx,sy,sz)    
    ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)    
    return b,d,tx,ty,tz,nx,ny,nz,he,e
end
function Flying_blade:Tick(delta)

    if self.ObjOwner._died or self.ObjOwner._ToKill then
        GObjects:ToKill(self)
        return
    end
    
    if self._back then -- powrot
        GObjects:ToKill(self)
	return
    end
        
    if not ENTITY.PO_IsEnabled(self._Entity) then return end    
    
    local x,y,z = ENTITY.GetPosition(self._Entity)
    local vx,vy,vz,l  = ENTITY.GetVelocity(self._Entity)
    local dx,dy,dz  = vx/l, vy/l, vz/l -- znormalizowany kierunek         

    --collision test
    --
    	local vectorz={}
	vectorz[1]={}
	vectorz[2]={}
	vectorz[3]={}
	vectorz[4]={}
	vectorz[5]={}
	vectorz[6]={}
	local j = MDL.GetJointIndex(self._Entity,"e1")
        vectorz[1].x,vectorz[1].y,vectorz[1].z = MDL.TransformPointByJoint(self._Entity,j,0,0,0)
	local j = MDL.GetJointIndex(self._Entity,"e2")
        vectorz[2].x,vectorz[2].y,vectorz[2].z = MDL.TransformPointByJoint(self._Entity,j,0,0,0)
	local j = MDL.GetJointIndex(self._Entity,"e3")
        vectorz[3].x,vectorz[3].y,vectorz[3].z = MDL.TransformPointByJoint(self._Entity,j,0,0,0)
	local j = MDL.GetJointIndex(self._Entity,"e4")
        vectorz[4].x,vectorz[4].y,vectorz[4].z = MDL.TransformPointByJoint(self._Entity,j,0,0,0)
	local j = MDL.GetJointIndex(self._Entity,"e5")
        vectorz[5].x,vectorz[5].y,vectorz[5].z = MDL.TransformPointByJoint(self._Entity,j,0,0,0)
	local j = MDL.GetJointIndex(self._Entity,"e6")
        vectorz[6].x,vectorz[6].y,vectorz[6].z = MDL.TransformPointByJoint(self._Entity,j,0,0,0)
    
    self.Rot:FromEntity(self._Entity) 
    local x1,y1,z1 = self.Rot:TransformVector(0,0,-0.5)
    local sx,sy,sz = x+x1,y+y1,z+z1    
    if self._lastTraceStartPoint then
        ex,ey,ez = self._lastTraceStartPoint.X,self._lastTraceStartPoint.Y,self._lastTraceStartPoint.Z 
    else
        self._lastTraceStartPoint = Vector:New(sx,sy,sz)
    end    
    self._lastTraceStartPoint:Set(sx,sy,sz)
	local b,d,tx,ty,tz,nx,ny,nz,he,e = self:Trace(ex,ey,ez,sx,sy,sz)    
	local cg = ENTITY.PO_GetCollisionGroup(e)
	if CheckStartGlass(he,tx,ty,tz,0.3,vx,vy,vz) or cg==7 or cg==8 then
	        return
	end
	if not e then

    for k=1,6 do
	if not e then b,d,tx,ty,tz,nx,ny,nz,he,e = self:Trace(vectorz[k].x,vectorz[k].y,vectorz[k].z,sx+vectorz[k].x-ex,sy+vectorz[k].y-ey,sz+vectorz[k].z-ez)    end
    end
	end
    if e then 
        if ENTITY.IsWater(e) then 
--            ENTITY.SpawnDecal(e,'splash',tx,ty,tz,nx,ny,nz)
            Templates["Flying_blade.CItem"]:Snd3D("head_hit_water",tx,ty,tz)
            self._back = true
            return
        end
        
        if ENTITY.IsFixedMesh(e) then 
            self._back = true
            return
        end
        
        -- sprawdzam czy to entity posiada obiekt logiczny                
        local obj = EntityToObject[e]             

        if obj then                                
            -- zadaje obrazenia
            if obj.OnDamage then
                obj:OnDamage(self.Damage,self.ObjOwner,AttackTypes.Painkiller,tx,ty,tz,nx,ny,nz,he)  
		if obj.IsBoss or obj.ToughOne then
			self._back = true
		end
            end
   			if not PHYSICS.IsHavokBodyInWorld(he) then
				he = nil		-- jak sie np. zgibuje to jest robione ragdoll.remove i he moze byc zle
			end
        end                
        
            if e and not (obj and (obj._Class == "CActor" or obj.DestroyPack)) then
                WORLD.HitPhysicObject(he,tx,ty,tz,dx*250,dy*250,dz*250)
--                ENTITY.PO_Remove(self._Entity)
--                self._back = true
--                MDL.SetAnim(self._Entity,"close",false,1,0.2)
            end        
        end
-- NAVIGACE
	self.Moveme(self.ObjOwner._Entity,self._Entity,self.sidespeed)
-- LEVITACE

end

function Flying_blade:Moveme(pe,le,speed)
	local player = EntityToObject[pe] 
	local blade = EntityToObject[le] 
	if player then
		local fv = player.ForwardVector
		local px,py,pz = ENTITY.PO_GetPawnHeadPos(pe)
	ENTITY.RemoveFromIntersectionSolver(pe)
		local b,d,ttx,tty,ttz,nx,ny,nz,he,e2 = WORLD.LineTrace(px+fv.X*1.7,py+fv.Y*1.7,pz+fv.Z*1.7,px+fv.X*20000,px+fv.Y*20000,px+fv.Z*20000)
	ENTITY.AddToIntersectionSolver(pe)

	if e2 then
		local j = MDL.GetJointIndex(le,"root")
	       local pox,poy,poz = MDL.TransformPointByJoint(le,j,0,0,0)
		local pfx = AddPFX("hellblade_target",0.6,Vector:New(ttx,tty,ttz))
		local kv = Vector:New(ttx-pox,tty-poy,ttz-poz) 
		kv:Normalize()
		ENTITY.SetVelocity(le,kv.X*speed,kv.Y*speed,kv.Z*speed)	
	else
		ENTITY.SetVelocity(le,0,0,0)	
	end
	end
end
Network:RegisterMethod("Flying_blade.Moveme", NCallOn.ServerAndAllClients, NMode.Reliable, "eeu") 

function Flying_blade:CL_HitWallSFX(e)
    Templates["Flying_blade.CWeapon"]:SndEnt("head_hit_wall",e)
end
Network:RegisterMethod("Flying_blade.CL_HitWallSFX", NCallOn.AllClients, NMode.Unreliable, "e") 

