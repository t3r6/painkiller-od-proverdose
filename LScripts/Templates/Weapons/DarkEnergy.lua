-- =======================================================================================
-- =======================================================================================
function DarkEnergy:OnInitTemplate()
    self:ReplaceFunction("_Synchronize","Synchronize")
    self:ReplaceFunction("Synchronize","nil")
end
-- =======================================================================================
function DarkEnergy:Update()
    if self.TimeToLive then
		if self.TimeToLive > 0 then
			self.TimeToLive = self.TimeToLive - 1
		else
			GObjects:ToKill(self)
		end
	end
end
-- =======================================================================================
function DarkEnergy:OnCreateEntity()    
    
    ENTITY.EnableNetworkSynchronization(self._Entity,true,false,2)
    
    self:PO_Create(BodyTypes.FromMesh,nil,ECollisionGroups.Noncolliding)    
    
    ENTITY.RemoveFromIntersectionSolver(self._Entity)
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)

    local param = ""
    if self.ObjOwner.HasWeaponModifier then param = "w" end
    self:Client_OnCreateEntity(self._Entity,param)
    ENTITY.SetSynchroString(self._Entity,"DarkEnergy.CItem"..":"..param)
    self:BindFX("Blade_Corona.CBillboard")
	self.Gtime = 0				
end
--============================================================================
function DarkEnergy:OnPrecache()
	Cache:PrecacheParticleFX("GrenadeSmoke")
	Cache:PrecacheParticleFX("stakeHitWall")
	Cache:PrecacheParticleFX("stakeflame")        
	Cache:PrecacheItem("Grenade.CItem")     
	Cache:PrecacheItem("stake_imp.CItem")         
	Cache:PrecacheDecal('boltstick')   
    Cache:PrecacheTrail("trail_kolek_combo")
    Cache:PrecacheSounds("weapons/darkenergy/dark_throw")
    Cache:PrecacheSounds("weapons/darkenergy/dark_loop")
    Cache:PrecacheSounds("impacts/barrel-wood-fire-loop")
end
-- =======================================================================================
function DarkEnergy:Client_OnCreateEntity(entity,param)    
    BindSoundToEntity(entity,"weapons/darkenergy/dark_loop",4,50,true,nil,nil,nil,nil,0.1)
    local t = ENTITY.Create(ETypes.Trail,"trail_hellblade","trailName")
    ENTITY.SetPosition(t,0,0,0)
    ENTITY.AttachTrailToBones(entity,t)
    WORLD.AddEntity(t)
    
    if param == "w" then
        local fxFire = AddPFX("stakeflame",0.25)
        ENTITY.RegisterChild(entity,fxFire)
        PARTICLE.SetParentOffset(fxFire,0,0,-1)    
        BindSoundToEntity(entity,"weapons/darkenergy/dark_throw",3,18)    
        BindSoundToEntity(entity,"impacts/barrel-wood-fire-loop",3,18,true,nil,nil,nil,nil,0.1)             
    end
end
-- =======================================================================================
DarkEnergy.vlen = 0.8
DarkEnergy.ftime = 0.3
function DarkEnergy:Trace(ex,ey,ez,sx,sy,sz)
    ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)    
    if self.r_BindedActor then
        ENTITY.RemoveFromIntersectionSolver(self.r_BindedActor._Entity)
    end
    local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(ex,ey,ez,sx,sy,sz)    
    ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)    
    if self.r_BindedActor then
        ENTITY.RemoveFromIntersectionSolver(self.r_BindedActor._Entity)
    end
    return b,d,tx,ty,tz,nx,ny,nz,he,e
end
-- =======================================================================================
function DarkEnergy:Tick(delta)
    
    if not ENTITY.PO_IsEnabled(self._Entity) then return end    

    --====================================================================================    
    -- 1. TRACOWANIE
    --====================================================================================    
    local x,y,z = ENTITY.GetPosition(self._Entity)
    local vx,vy,vz,l  = ENTITY.GetVelocity(self._Entity) -- predkosc kolka
    local dx,dy,dz  = vx/l, vy/l, vz/l -- znormalizowany kierunek                    
    
    -- wyliczam zakres trace'a
    self.Rot:FromEntity(self._Entity) 
    local x1,y1,z1 = self.Rot:TransformVector(0,0,self.vlen)
    
    local sx,sy,sz = x,y,z
    local ex,ey,ez = x+x1,y+y1,z+z1
    
    -- w przypadku duzej predkosci zapewniam ciaglosc sprawdzania
    if self._lastTraceStartPoint then
        if Dist3D(ex,ey,ez,self._lastTraceStartPoint.X,self._lastTraceStartPoint.Y,self._lastTraceStartPoint.Z) > 
           Dist3D(ex,ey,ez,sx,sy,sz)
        then
            sx,sy,sz = self._lastTraceStartPoint.X,self._lastTraceStartPoint.Y,self._lastTraceStartPoint.Z         
        end
    else
        self._lastTraceStartPoint = Vector:New(x,y,z)
    end
    self._lastTraceStartPoint:Set(ex,ey,ez)
    local b,d,tx,ty,tz,nx,ny,nz,he,e = self:Trace(sx,sy,sz,ex,ey,ez)    

    if e then
        if Game.GMode == GModes.SingleGame and ENTITY.IsWater(e) then 
            self:InDeathZone(x,y,z,"wat")
            return
        end
        PlayLogicSound("RICOCHET",tx,ty,tz,8,16,Player)
        local obj = EntityToObject[e]             
        if obj then
            local d = self.Damage
            if obj.OnDamage then
                obj:OnDamage(d,self.ObjOwner,AttackTypes.BoltStick,tx,ty,tz,nx,ny,nz,he)  
            end
			
        end
        
        if obj and (obj._Class == "CActor" or obj._Class == "CPlayer") and not obj._died then
            local ib =  self.EnemyThrowBack
            local iu =  self.EnemyThrowUp
            if (not obj.NeverMove and not obj._disableHits) or obj.Health <= 0 then
	     local fv = self.ObjOwner.ForwardVector
		    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib) 
				if obj._Class == "CPlayer" then
					ENTITY.PO_SetPlayerShocked(e)
				end
			end
            --Game:Print(dx*ib.." "..dz*ib)
            mode = 1
        else
            ENTITY.PO_Remove(self._Entity)
            -- przywiazuje do trafionego obiektu
        end                        
                
        self.OnHitSomething(self._Entity,e,mode)                                        
	if self.lockedobject then self.lockedobject=nil end
        GObjects:ToKill(self,true)     
        ENTITY.SetTimeToDie(self._Entity,0)
        
        return
    else
	    if self.lockedobject then
		    if self.NGTime >0 then 
			    self.NGTime = self.NGTime - 1 
		    else
		     self.Gtime = self.Gtime+1
		     if Game.GMode == GModes.SingleGame or self.Gtime < 30  then 
			     local vx,vy,vz,l  = ENTITY.GetVelocity(self._Entity) 
			     local idx = MDL.GetJointIndex(self.lockedobject._Entity,"root")
			     if idx > -1 then
				    local   ix,iy,iz = MDL.GetJointPos(self.lockedobject._Entity,idx)
				    local mx,my,mz = ENTITY.GetPosition(self._Entity)
				    local difvec = Vector:New(ix-mx,iy-my,iz-mz)
				    difvec:Normalize()
				    ENTITY.SetVelocity(self._Entity,difvec.X*l,difvec.Y*l,difvec.Z*l)
				end
			else
				self.Gtime=0
				self.NGTime = 60
			end
		end
		end
    end
    
end
-- =======================================================================================
function DarkEnergy:OnHitSomething(se,e,mode)
    if not se then return end
        
    --ENTITY.SetPosition(se,x,y,z)                    
    if mode == 1 then
        -- roztrzaskal sie
        RawCallMethod(CItem.DestroyItemFX,se,"DarkEnergy.CItem",0)
    else        
        
        ENTITY.UnregisterAllChildren(se,ETypes.Trail)        
        ENTITY.KillAllChildrenByName(se,"weapons/darkenergy/dark_loop")
        ENTITY.KillAllChildrenByName(se,"impacts/barrel-wood-fire-loop")        
        if ENTITY.KillAllChildrenByName(se,"stakeflame")then -- burning?
            -- add smoke
            local smokefx = AddPFX("GrenadeSmoke",1)
            PARTICLE.SetParentOffset(smokefx,0,0,-1)
            ENTITY.RegisterChild(se,smokefx)       
        end
        
    end

    -- decal on the wall
    if e then
        if ENTITY.IsFixedMesh(e) then
            local x,y,z = ENTITY.GetPosition(se)
            local rot = Quaternion:New_FromEntity(se)
            local x1,y1,z1 = rot:TransformVector(0, 0, -0.4)
            local x2,y2,z2 = rot:TransformVector(0, 0, 0.8)
            
            PlaySound3D('impacts/stake-default'..math.random(1,5),x,y,z,5,25,false)
    
            ENTITY.RemoveFromIntersectionSolver(se)        
            local b,d,tx,ty,tz,nx,ny,nz,he,e = ENTITY.PO_LineTrace(e,x+x1,y+y1,z+z1,x+x2,y+y2,z+z2)
            --local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(x+x1,y+y1,z+z1,x+x2,y+y2,z+z2)
            if b then 
                local px,py,pz = tx+nx*0.3,ty+ny*0.3,tz+nz*0.3
                if e and mode == 0 then ENTITY.SpawnDecal(e,'boltstick',tx,ty,tz,nx,ny,nz) end            
                local r = Quaternion:New_FromNormal(nx,ny,nz)                
                if Game.GMode == GModes.SingleGame then 
                    local sizes = {0.7,1.4}
                    for i=1,3 do
                        local vx,vy,vz  = r:TransformVector(FRand(-12,12),FRand(12,25),FRand(-12,12)) 
                        local ke = AddItem("stake_imp.CItem",sizes[math.random(1,2)],Vector:New(px+FRand(-0.1,0.1),py+FRand(-0.1,0.1),pz+FRand(-0.1,0.1)),false,Quaternion:New_FromNormal(-vx,-vy,-vz))
                        ENTITY.SetVelocity(ke,vx,vy,vz)
                        ENTITY.SetTimeToDie(ke,FRand(1,2))
                    end
                end
                AddPFX("stakeHitWall",0.25,Vector:New(px,py,pz),r)
            end
        else
            local obj = EntityToObject[e]
			--if obj then
			--end
			if obj and obj.Health and (obj.Health > 0 or obj._enabledRD or obj._gibbed)then
				if obj._Class == "CActor" and obj._enabledRD then
					--Game:Print("STAKE ON HIT SOMETHING:body")
					--PlaySound3D('impacts/stake-body'..math.random(1,2),x,y,z,12,36,false)
	
				elseif obj.s_SubClass and obj.s_SubClass.SoundsDefinitions and obj.s_SubClass.SoundsDefinitions.SoundHitByBullet then
					if obj.s_SubClass.SoundsDefinitions.SoundHitByBullet.samples[1] == "bullet-metal" then
						--Game:Print("STAKE ON HIT SOMETHING:metal")
					--	PlaySound3D('impacts/stake-shield'..math.random(1,3),x,y,z,12,36,false)
					else
						if not obj.SoundHitByBulletMiniGunOnly then
							obj:PlaySound("SoundHitByBullet")
						end
					end
				else
					--Game:Print("STAKE ON HIT SOMETHING:rest")
				end
			end
        end
    end
end
Network:RegisterMethod("DarkEnergy.OnHitSomething", NCallOn.AllClients, NMode.Reliable, "eeb") 
-- =======================================================================================
function DarkEnergy:EditRender()
    
    self.Rot:FromEntity(self._Entity) 
    local x,y,z = ENTITY.GetWorldPosition(self._Entity)
    local x1,y1,z1 = self.Rot:TransformVector(0,0,self.vlen)
    
    R3D.RenderBox(x+x1-0.1,y+y1-0.1,z+z1,x+x1+0.1,y+y1+0.1,z+z1+0.1,2222)            
end
