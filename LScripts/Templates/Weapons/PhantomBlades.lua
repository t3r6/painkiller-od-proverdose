-- =======================================================================================
-- =======================================================================================
function PhantomBlades:OnInitTemplate()
    self:ReplaceFunction("_Synchronize","Synchronize")
    self:ReplaceFunction("Synchronize","nil")
end
-- =======================================================================================
function PhantomBlades:Update()
    if self.TimeToLive then
		if self.TimeToLive > 0 then
			self.TimeToLive = self.TimeToLive - 1
		else
			GObjects:ToKill(self)
		end
	end
end
function PhantomBlades:DrawBezierLine(points,parts,mode,size,color,rnd)
    local va = VARRAY.Create()
    for i,o in points do
        VARRAY.AddPoint(va,o.X,o.Y,o.Z)
    end
    local spr = R3D.Spr_Create(size,color,"particles/spaw_01",mode)
    if not rnd then rnd = 0.1 end
    local px,py,pz
    for i=0,parts do
        px,py,pz = VARRAY.GetBezierPoint(va,i/(parts-1))
        if i ~= 0 then
            px = FRand(px-rnd, px+rnd)
            py = FRand(py-rnd, py+rnd)
            pz = FRand(pz-rnd, pz+rnd)
        end
        R3D.Spr_AddPoint(spr,px,py,pz)
    end
    R3D.Spr_Render(spr)
    VARRAY.Delete(va)
end

function PhantomBlades:Render()
local rx,ry,rz = ENTITY.GetPosition(self._Entity)
   if self.lkolik and not self.lkolik.hito and not self.lkolik._died then
	local points1={}
	local kx,ky,kz = ENTITY.GetPosition(self.lkolik._Entity)	
	points1[1]= Vector:New(kx,ky,kz)
	points1[2]= Vector:New(rx,ry,rz)
	self:DrawBezierLine(points1,15,12, FRand(0.1, 0.2), R3D.RGB(255,10,10))
	self:DrawBezierLine(points1,15,11, FRand(0.1, 0.2), R3D.RGB(255,10,10))
   end
      if self.rkolik and not self.rkolik.hito and not self.rkolik._died then
	local points2={}
	local x,y,z = ENTITY.GetPosition(self.rkolik._Entity)	
	points2[1]= Vector:New(x,y,z)
	points2[2]= Vector:New(rx,ry,rz)
	self:DrawBezierLine(points2,15,12, FRand(0.1, 0.2), R3D.RGB(255,10,10))
	self:DrawBezierLine(points2,15,11, FRand(0.1, 0.2), R3D.RGB(255,10,10))
   end
end
-- =======================================================================================
function PhantomBlades:OnCreateEntity()    
    
    ENTITY.EnableNetworkSynchronization(self._Entity,true,false,2)
    
    self:PO_Create(BodyTypes.FromMesh,nil,ECollisionGroups.Noncolliding)    
    
    ENTITY.RemoveFromIntersectionSolver(self._Entity)
    ENTITY.PO_SetMovedByExplosions(self._Entity, false)

    local param = ""
    if self.ObjOwner.HasWeaponModifier then param = "w" end
    self:Client_OnCreateEntity(self._Entity,param)
    ENTITY.SetSynchroString(self._Entity,"PhantomBlades.CItem"..":"..param)
    	if self.BillBoard then
		local a
		a, self._fx = AddObject(self.BillBoard[1],self.BillBoard[2],Vector:New(self.BillBoard[4],self.BillBoard[5],self.BillBoard[6]))
		local j = MDL.GetJointIndex(self._Entity,self.BillBoard[3])
		ENTITY.RegisterChild(self._Entity, self._fx, true, j)
	end
    self.hito=false		
end
--============================================================================
function PhantomBlades:OnPrecache()
	Cache:PrecacheParticleFX("GrenadeSmoke")
	Cache:PrecacheParticleFX("stakeHitWall")
	Cache:PrecacheParticleFX("stakeflame")        
	Cache:PrecacheItem("Grenade.CItem")     
	Cache:PrecacheParticleFX("phantom_bladeFX")       
	Cache:PrecacheItem("stake_imp.CItem")         
	Cache:PrecacheDecal('boltstick')   
    Cache:PrecacheParticleFX("bomb_glow")
    Cache:PrecacheTrail("trail_ghost")
    Cache:PrecacheSounds("weapons/darkenergy/dark_throw")
    Cache:PrecacheSounds("weapons/hellblade/phantomblades")
    Cache:PrecacheSounds("impacts/barrel-wood-fire-loop")
end
-- =======================================================================================
function PhantomBlades:Client_OnCreateEntity(entity,param)    
    BindSoundToEntity(entity,"weapons/hellblade/phantomblades",5,40,true,nil,nil,nil,nil,0.1)
    local t = ENTITY.Create(ETypes.Trail,"trail_kolek_combo","trailName")
    ENTITY.SetPosition(t,0,0,0)
    ENTITY.AttachTrailToBones(entity,t)
    WORLD.AddEntity(t)
    local smokefx = AddPFX("phantom_bladeFX",0.5)
    ENTITY.RegisterChild(entity,smokefx)
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
PhantomBlades.vlen = 0.8
PhantomBlades.ftime = 0.3
function PhantomBlades:Trace(ex,ey,ez,sx,sy,sz)
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
function PhantomBlades:Tick(delta)
   
    if not ENTITY.PO_IsEnabled(self._Entity) then return end    
    --====================================================================================    
    -- 0. sidekicks
    --====================================================================================    
local rx,ry,rz = ENTITY.GetPosition(self._Entity)
   if self.lkolik and not self.lkolik.hito and not self.lkolik._died then
	local kx,ky,kz = ENTITY.GetPosition(self.lkolik._Entity)	
                ENTITY.RemoveFromIntersectionSolver(self.lkolik._Entity)
                ENTITY.RemoveFromIntersectionSolver(self._Entity)
                local tb,td,ttx1,tty1,ttz1,tnx,tny,tnz,het,et = WORLD.LineTrace(rx,ry,rz,kx,ky,kz)
                ENTITY.AddToIntersectionSolver(self.lkolik._Entity)
                ENTITY.AddToIntersectionSolver(self._Entity)
	if et then
                    obj = EntityToObject[et]
		    if obj and not obj._died and obj._Class == "CActor" and obj.OnDamage then
			    local dam = self.wiredamage
	                obj:OnDamage(dam,self.ObjOwner,AttackTypes.Electro)  
		    end
	end
   end
      if self.rkolik and not self.rkolik.hito and not self.rkolik._died then
	local kx,ky,kz = ENTITY.GetPosition(self.rkolik._Entity)	
	                ENTITY.RemoveFromIntersectionSolver(self.rkolik._Entity)
                ENTITY.RemoveFromIntersectionSolver(self._Entity)
                local tb,td,ttx1,tty1,ttz1,tnx,tny,tnz,het,et = WORLD.LineTrace(rx,ry,rz,kx,ky,kz)
                ENTITY.AddToIntersectionSolver(self.rkolik._Entity)
                ENTITY.AddToIntersectionSolver(self._Entity)
	if et then
                    obj = EntityToObject[et]
		    if obj and not obj._died and obj._Class == "CActor" and obj.OnDamage then
			    local dam = self.wiredamage
	                obj:OnDamage(dam,self.ObjOwner,AttackTypes.Electro)  
		    end
	end
   end
	
		

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
    
    -- czy w cos sie wbil?    
    local b,d,tx,ty,tz,nx,ny,nz,he,e = self:Trace(sx,sy,sz,ex,ey,ez)    
    --Game:Print("sx: "..sx..", sy: "..sy..", sz: "..sz)
--    Game:Print("ex: "..ex..", ey: "..ey..", ez: "..ez)

    --====================================================================================    
    -- 2. PRZELATUJE PRZEZ SZKLO ROZWALAJAC JE
    --====================================================================================    

    local cg = ENTITY.PO_GetCollisionGroup(e)
    if CheckStartGlass(he,tx,ty,tz,0.3,vx,vy,vz) or cg==7 or cg==8 then
        return
    end

    -- tak, w cos uderzyl
    if e then
        if Game.GMode == GModes.SingleGame and ENTITY.IsWater(e) then 
            self:InDeathZone(x,y,z,"wat")
            return
        end
        
            
        PlayLogicSound("RICOCHET",tx,ty,tz,8,16,Player)
        -- sprawdzam czy to entity posiada obiekt logiczny                
        local obj = EntityToObject[e]             
        if obj and not self.r_BindedActor then
            --MsgBox(obj._Name)
        
            -- sprawdzam czy trafilem w cialo czy w jakis odpadajacy element, np kosa czy naramiennik                
            if  (obj._Class == "CActor" or obj._Class == "CPlayer") and not obj.stakeCanHitNotLinkedJoint then
                local joint = MDL.GetJointFromHavokBody(e,he)                
                local cb = MDL.JointsLinked(e,joint,MDL.GetJointIndex(e, "root"))
                if not cb then cb = MDL.JointsLinked(e,joint,MDL.GetJointIndex(e, "k_sub_root")) end -- stare modele
                if not cb and not obj.DontTestRootLink then 
                    -- wyjmuje ten obiekt z havoka i ponawiam trace'a
                    local ohe = he
                    PHYSICS.RemoveHavokBodyFromIS(ohe,true)
                    b,d,tx,ty,tz,nx,ny,nz,he,e = self:Trace(ex,ey,ez,sx,sy,sz)
                    PHYSICS.RemoveHavokBodyFromIS(ohe,false)                         
                    --Game:Print("przelatuje: "..joint.." "..MDL.GetJointName(e,joint)) 
                    if not b or not (e and EntityToObject[e]) then return end -- przelatuje  
                    obj = EntityToObject[e]
                    --MsgBox(obj._Class)
                end
            end
            
            local d = self.Damage
            -- zadaje obrazenia
            if obj.OnDamage then
                obj:OnDamage(d,self.ObjOwner,AttackTypes.BoltStick,tx,ty,tz,nx,ny,nz,he)  
            end
			
			if obj.bulletsFliesThru then
				--Game:Print("kolek przelatuje")
				return
			end
            -- jezeli zabilem Actora
            if (obj._Class == "CActor" or obj._Class == "CPlayer") and obj._died then
       
                --Game:Print(obj._Name)
                if self.r_BindedActor then Game:Print(self.r_BindedActor._Name) end
                if obj._gibbed then -- przy gibie nic nie robie
                    GObjects:ToKill(self)
                    return
                end
                if obj._dontPinStake then
--					RawCallMethod(CItem.DestroyItemFX,self._Entity,"PhantomBlades.CItem",0)
                    GObjects:ToKill(self)
                    return
				end

                local range = 8
                -- przesuwam srodek kolka w punkt, w ktory sie wbil
                if not obj.Pinned and not obj._pinnedByAI then
                    --Game:Print("przesuwam")
					PlaySound3D('impacts/stake-body'..math.random(1,2),tx,ty,tz,9,33)
                    --Game:Print(dx..", "..dy..", "..dz)
                    x,y,z = tx-dx*0.35,ty-dy*0.35,tz-dz*0.35
                    ENTITY.SetPosition(self._Entity,x,y,z)                    
                else
                    range = 1.5 -- jezeli jest juz przybity to skracam zakres szukania sciany
                end
                
                local hx,hy,hz = PHYSICS.GetHavokBodyPosition(he)
                self.ox,self.oy,self.oz = x-hx,y-hy,z-hz
                --Game:Print(self.ox..", "..self.oy..", "..self.oz)
                
                -- sprawdzam czy za nim jest sciana
                ENTITY.RemoveFromIntersectionSolver(e)
                local b,d,tx1,ty1,tz1,nx,ny,nz,he1,e1 = WORLD.LineTrace(tx,ty,tz,tx+dx*range,ty+dy*range,tz+dz*range)
                ENTITY.AddToIntersectionSolver(e)
                                                                
                -- bede przybijal obiekt do sciany    
                if b and ENTITY.IsFixedMesh(e1) then                
                    --MDL.SetRagdollLinearDamping(obj._Entity,0.1)
                    --MDL.SetRagdollAngularDamping(obj._Entity,0.1)
                    --Game:Print("do przybicia "..self._Name)
                    self.r_BindedActor = obj
                    self.he = he
                    if not self.r_BindedActor.Pinned and not obj[he] then 
                        obj[he] = true                        
                        self._moveActor = true
                    else
                        --Game:Print("juz jest tam wbity")
                    end
                    
                    -- jezeli juz wisi na scianie to nadaje lekki impulse bo nie bede ciagnal
                    if obj.Pinned then
                        --Game:Print("przybicie juz pinned")
                        WORLD.HitPhysicObject(he,tx,ty,tz,dx*500,dy*500,dz*500)
                    end                    
                    return 
                end                 
            end
        end
        
        local mode = 0

        -- wylaczam fizyke
        ENTITY.PO_Enable(self._Entity,false)            

        -- przesuwam srodek kolka w punkt, w ktory sie wbil
        if obj and (obj._Class == "CActor" or obj._Class == "CPlayer") then -- aktora przebija
            ENTITY.SetPosition(self._Entity,tx,ty,tz)
        else
             -- przesuwam czubek kolka w punkt, w ktory sie wbil
            ENTITY.SetPosition(self._Entity,tx,ty,tz)                
        end
        
        -- jezeli ciagnal za soba actora to go pinujemy
        if self.r_BindedActor and ENTITY.IsFixedMesh(e) then
            if self._moveActor then
                local x,y,z = ENTITY.GetPosition(self._Entity)
                PHYSICS.SetHavokBodyPosition(self.he,x+self.ox,y+self.oy,z+self.oz)
                --PHYSICS.PinHavokBody(self.he) 
                --Game:Print("przybijam "..self._Name)
            end
            PHYSICS.PinHavokBody(self.he) 
            --Game:Print(self.ox..", "..self.oy..", "..self.oz)			
			self.r_BindedActor.Pinned = true
			PlaySound3D('weapons/stake/stake_hit'..math.random(1,2),tx,ty,tz,12)                        
        end
                
        -- przy trafieniu w actora lub playera rozwalam kolek i odpycham pawn'a
        if obj and (obj._Class == "CActor" or obj._Class == "CPlayer") and not obj._died then
            local ib =  self.EnemyThrowBack
            local iu =  self.EnemyThrowUp
            if (not obj.NeverMove and not obj._disableHits) or obj.Health <= 0 then
	     local fv = self.ObjOwner.ForwardVector
		    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib) 
		    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib) 
		    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib) 
		    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib) 
		    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib) 
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
            local joint = MDL.GetJointFromHavokBody(e,he)
            ENTITY.ComputeChildMatrix(self._Entity,e,joint)
            ENTITY.RegisterChild(e,self._Entity,true,joint)                            
        end                        
                
       self.hito = true
        self.OnHitSomething(self._Entity,e,mode)                                        

        -- kasuje obiekt logiczny kolka
        GObjects:ToKill(self,true)     

        if mode == 1 then
            ENTITY.Release(self._Entity)            
        else
            -- wlaczam autodestrukcje entity kolka za 10 sec
            if Game.GMode == GModes.SingleGame then
                ENTITY.SetTimeToDie(self._Entity,8)
            else
                ENTITY.SetTimeToDie(self._Entity,3)
            end
        end
        
        if not obj or not self._moveActor then
            -- nadaje impuls trafionemu entity
            WORLD.HitPhysicObject(he,tx,ty,tz,dx*200,FRand(1,200),dz*200)
        end
        return
    end
    
    -- jezeli ciagnie za soba actora to nadajemy mu predkosc (o ile nie zginal w miedzyczasie)
    if self.r_BindedActor then
        local entity = ENTITY.GetPtrByIndex(self.r_BindedActor._Entity)
        if not entity then 
            GObjects:ToKill(self)
            return
        else
            --Game:Print(self._Name.."ciagnie")
            if not self.r_BindedActor.Pinned and self._moveActor then
                -- ustawiamy pozycje temu kawalkowi ragdolla 
                --local obj = EntityToObject[entity]
                --if obj and (obj.Pinned or obj._pinnedByAI) then
				--else
					--Game:Print(self._Name.."ciagnie i set pos")
					MDL.ApplyVelocitiesToAllJoints(entity,vx*0.8,vy*0.8,vz*0.8,0,0,0)
                    PHYSICS.SetHavokBodyPosition(self.he,x+self.ox,y+self.oy,z+self.oz)    
                --end                
            end
        end
    end

end
-- =======================================================================================
function PhantomBlades:OnHitSomething(se,e,mode)
    if not se then return end
    --ENTITY.SetPosition(se,x,y,z)                    
    if mode == 1 then
        -- roztrzaskal sie
		local x,y,z = ENTITY.GetWorldPosition(se)
		AddPFX("explo_shuriken", 0.2 ,Vector:New(x,y,z))
		GObjects:ToKill(self)
    else        
        
        ENTITY.UnregisterAllChildren(se,ETypes.Trail)        
        ENTITY.KillAllChildrenByName(se,"weapons/hellblade/phantomblades")
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
            
            PlaySound3D('impacts/stake-default'..math.random(1,5),x,y,z,12,36,false)
    
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
				--Game:Print("STAKE ON HIT SOMETHING?")
			--end
			if obj and obj.Health and (obj.Health > 0 or obj._enabledRD or obj._gibbed)then
				if obj._Class == "CActor" and obj._enabledRD then
					--Game:Print("STAKE ON HIT SOMETHING:body")
					PlaySound3D('impacts/stake-body'..math.random(1,2),x,y,z,12,36,false)
	
				elseif obj.s_SubClass and obj.s_SubClass.SoundsDefinitions and obj.s_SubClass.SoundsDefinitions.SoundHitByBullet then
					if obj.s_SubClass.SoundsDefinitions.SoundHitByBullet.samples[1] == "bullet-metal" then
						--Game:Print("STAKE ON HIT SOMETHING:metal")
						PlaySound3D('impacts/stake-shield'..math.random(1,3),x,y,z,12,36,false)
					else
						if not obj.SoundHitByBulletMiniGunOnly then
							obj:PlaySound("SoundHitByBullet")
						end
					end
				else
					--Game:Print("STAKE ON HIT SOMETHING:rest")
					PlaySound3D('impacts/stake-default'..math.random(1,5),x,y,z,12,36,false)
				end
			end
        end
    end
    
end
Network:RegisterMethod("PhantomBlades.OnHitSomething", NCallOn.AllClients, NMode.Reliable, "eeb") 
-- =======================================================================================
function PhantomBlades:EditRender()
    
    self.Rot:FromEntity(self._Entity) 
    local x,y,z = ENTITY.GetWorldPosition(self._Entity)
    local x1,y1,z1 = self.Rot:TransformVector(0,0,self.vlen)
    
    R3D.RenderBox(x+x1-0.1,y+y1-0.1,z+z1,x+x1+0.1,y+y1+0.1,z+z1+0.1,2222)            
end
