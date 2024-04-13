--============================================================================
function Bonegun:OnReleaseEntity()
end
--============================================================================
function Bonegun:OnCreateEntity()
	self:ReloadTextures()
end
--============================================================================
function Bonegun:OnPrecache()
    CloneTemplate("Bonegun.CWeapon"):LoadHUDData()
	Cache:PrecacheParticleFX("SG_fx")
	Cache:PrecacheParticleFX("FX_shotgunmp")    
	Cache:PrecacheParticleFX("shotgunHitWater") 
	Cache:PrecacheParticleFX("shotgunHitWall") 
	Cache:PrecacheItem("sgKamyk.CItem")     
    Cache:PrecacheItem("StoneBullet.CItem")    
--    Cache:PrecacheDecal("splash")        
    Cache:PrecacheDecal("bullethole")            
end
--============================================================================
function Bonegun:ReloadTextures()
	if not self._Entity then return end
    if Cfg.WeaponNormalMap == true then
        if Cfg.WeaponSpecular == false then
            MATERIAL.Replace("models/asg/asg_pb","models/asg/asg_pb_no_specular")
        else
            MATERIAL.Replace("models/asg/asg_pb","models/asg/asg_pb")
        end
    end
	MDL.EnableNormalMaps(self._Entity,Cfg.WeaponNormalMap)
end
--============================================================================
function Bonegun:LoadHUDData()
	self._matAmmoIcon = MATERIAL.Create("HUD/Mw_hud/i_bones", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matFreezerIcon = MATERIAL.Create("HUD/Mw_hud/i_petrify", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function Bonegun:MuzzleFlashFX()
    -- protection for multiply lights simultaneously
    if not self._LightName or getfenv()[self._LightName] == nil then
        local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
        local fv = self.ObjOwner.ForwardVector
        local a = AddAction({{"Light:a[1],a[2],a[3],200,200,150, 5, 8 , 1, 0,0.1,0.05"}},nil,nil,x+fv.X*2.5,y+1,z+fv.Z*2.5)
        self._LightName = a._Name
        --self:MuzzleFlash("l_hlaven",0,0,0)
        --self:MuzzleFlash("r_hlaven",0,0,0)
        --self:MuzzleFlash("joint2",-5.5,-1.9,-1.4)
        --self:MuzzleFlash("joint2",-5.5,-1.9,-2.0)
    end    
end
--============================================================================
function Bonegun:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
    if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
		Hud:Quad(self._matAmmoIcon,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matFreezerIcon,(1024-55*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*46)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Bonegun)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.StoneBullets)

	else
		Hud:Quad(self._matAmmoIcon,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matFreezerIcon,(1024-55*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*12)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.StoneBullets),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.StoneBullets)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.Bonegun),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Bonegun)
    end
end
--============================================================================
-- FIRE - BULLET (Server Side)
--============================================================================
function Bonegun:Fire()
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.Bonegun > 0 then           
        PlayLogicSound("FIRE",self.ObjOwner.Pos.X,self.ObjOwner.Pos.Y,self.ObjOwner.Pos.Z,15,35,self.ObjOwner)               
        
        local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)                
        local fv = self.ObjOwner.ForwardVector                       
        local rot = Quaternion:New_FromNormalZ(fv.X,fv.Y,fv.Z) 
        local hobj = {} 
        
        for i=1, s.HowManyPellets do 
            local r = s.FireRadius
            if self.ObjOwner.HasWeaponModifier then r = s.FireRadius / 4 end            
            local sx,sy = RadiusRandom2D(r)
            local sz = s.FireRange
            if self.ObjOwner.HasWeaponModifier then sz = sz * 1.5 end            
            sx,sy,sz = rot:TransformVector(sx,sy,sz)        
            
            local b,d,x,y,z,nx,ny,nz,he,e = self.ObjOwner:TraceToPoint(cx+sx,cy+sy,cz+sz)
            if b then
                local monster = false
                local obj = EntityToObject[e] -- LUA gameobject            
                local a = 1 - (Dist3D(x,y,z,cx,cy,cz)/s.FireRange)                
                local damage = s.PelletDamage
                if self.ObjOwner.HasQuad then            
                    damage = math.floor(damage * 4)
                end

                --Game:Print(damage)
                if obj then                
                    if obj.BonegunCheckAllPellets then
                        obj:OnDamage(damage,self.ObjOwner,attack,x,y,z,nx,ny,nz,he) 
                    else
                        if not hobj[obj._Name] then hobj[obj._Name] = {obj=obj,damage=0,x=x,y=y,z=z,nx=nx,ny=ny,nz=nz,he=he} end
                        hobj[obj._Name].damage =  hobj[obj._Name].damage + damage
                    end
                    --Game:Print(hobj[obj._Name].damage)
                    
                    if (obj._Class == "CActor" or obj._Class == "CPlayer") then 
                        local ib =  s.EnemyThrowBack
                        local iu =  s.EnemyThrowUp                               
                        -- hit spherical body
                        ENTITY.PO_AccumulateRotation(e,x,y,z,fv.X*ib*a,(fv.Y*ib+iu)*a,fv.Z*ib*a)
                        --Game:Print(obj.Health.." "..hobj[obj._Name].damage)
                        if (not obj.NeverMove and not obj._disableHits) or obj.Health <= damage then
							ENTITY.PO_Hit(e,x,y,z,fv.X*ib*a,(fv.Y*ib+iu)*a,fv.Z*ib*a)
							if obj._Class == "CPlayer" then
								ENTITY.PO_SetPlayerShocked(e)
							end
						end
                        
                        if CanBurning(obj) then 
                            monster = true
                        end
                    end
                end
                if not monster then
                    if Game.GMode == GModes.SingleGame then
                        self:HitWallSFX(e,x,y,z,nx,ny,nz,fv.X,fv.Y,fv.Z)
                    end
                    CheckStartGlass(he,x,y,z,0.2,fv.X*50,fv.Y*50,fv.Z*50)
                else
                    if obj.CustomBonegunHit then
                    end
                end
                if not obj or (obj and not obj.demonHitDisable) then
	                WORLD.HitPhysicObject(he,x,y,z,fv.X*s.PhysicsImpulse*a,fv.Y*s.PhysicsImpulse*a,fv.Z*s.PhysicsImpulse*a)
	            end   
            end            
        end
                
        for i,o in hobj do
            if o.obj.OnDamage then
                local attack = AttackTypes.Bonegun
                --Game:Print("bum: "..o.damage)                
                o.obj:OnDamage(o.damage,self.ObjOwner,attack,o.x,o.y,o.z,o.nx,o.ny,o.nz,o.he) 
            end
        end
                        
        self.FireSFX(self.ObjOwner._Entity)                 
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,1)
        self.ShotTimeOut = s.FireTimeout
    end
end
--============================================================================
function Bonegun:OnFinishFire()
end
--============================================================================
function Bonegun:OnFinishAnim(anim)
    --if anim == "iceshot" then
    --    self._NoWaitForIdle = true
    --end
end
--============================================================================
function Bonegun:OnUpdate()    
	self.ObjOwner.State = 2
end
--============================================================================
-- ALT FIRE
--============================================================================
function Bonegun:AltFire() 
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.StoneBullets and self.ObjOwner.Ammo.StoneBullets > 0 and not self.ObjOwner._jammed then
       
        for i=1,2 do
            -- create ice object
            local obj = GObjects:Add(TempObjName(),CloneTemplate("StoneBullet.CItem"))
            -- set position
            local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
            local fv = self.ObjOwner.ForwardVector       
            local rv = self.ObjOwner.RightVector       
            local zz = 0.15
            if i==2 then zz = -zz end
            
            x = x + rv.X * zz
            z = z + rv.Z * zz
                            
            local b = self.ObjOwner:Trace(1)        
            if not b then 
                x,y,z = x + fv.X*1, y + fv.Y*1, z + fv.Z*1    
            end
            
            obj.Pos:Set(x,y,z)        
            local orientation = ENTITY.GetOrientation(self.ObjOwner._Entity)
            obj.Rot:FromEulerZYX(-fv.Y,-orientation+1.57,0)  
            obj:Apply()
            obj.ObjOwner = self.ObjOwner        
    
            ENTITY.SetVelocity(obj._Entity,fv.X*s.StoneBulletSpeed,fv.Y*s.StoneBulletSpeed,fv.Z*s.StoneBulletSpeed)        
            local ax,ay,az = obj.Rot:TransformVector(0,120,0)
            ENTITY.SetAngularVelocity(obj._Entity,ax,ay,az)
            ENTITY.PO_EnableGravity(obj._Entity,false)
        end
        
        
        PlayLogicSound("FIRE",self.ObjOwner.Pos.X,self.ObjOwner.Pos.Y,self.ObjOwner.Pos.Z,12,26,self.ObjOwner)           
        self.AltFireSFX(self.ObjOwner._Entity)                
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,2)
        self.ShotTimeOut = s.AltFireTimeout
    end
end
--============================================================================
--function Bonegun:OnClientTick(delta)
--end
--============================================================================
-- NET EVENTS
--============================================================================
function Bonegun:FireSFX(pe,range)
    local player = EntityToObject[pe]       
    
    local t = Templates["Bonegun.CWeapon"]
    local s = t:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)
    local myplayer = false
    if player then
        -- update ammo on proper client
        local w = player:GetCurWeapon()
        if not Game.NoAmmoLoss then player.Ammo.Bonegun = player.Ammo.Bonegun - 1 end
        w.ShotTimeOut =  s.FireTimeout
        w._ActionState = "Idle"
        w:ForceAnim("shot",false)

        if player == Player then        
            myplayer = true
            -- dym z lufy            
            if Cfg.ViewWeaponModel then
                local pfx1 = AddPFX("bonegun_shot",0.6)            
                local pfx2 = AddPFX("bonegun_shot",0.6)            
                ENTITY.RegisterChild(w._Entity,pfx1)
                ENTITY.RegisterChild(w._Entity,pfx2)            
                local joint1 = MDL.GetJointIndex(w._Entity,"l_hlaven") 
                local joint2 = MDL.GetJointIndex(w._Entity,"r_hlaven") 
                PARTICLE.SetParentOffset(pfx1, 0, 0, 0, joint1, nil,nil,nil, 0, 0, -math.pi/2) 
                PARTICLE.SetParentOffset(pfx2, 0, 0, -1, joint1, nil,nil,nil, 0, 0, -math.pi/2) 
--                PARTICLE.SetParentOffset(pfx2, 0, 0, 0, joint2, nil,nil,nil, 0, 0, math.pi/2) 
            end
            w:MuzzleFlashFX()     
        end        
    end
    
    -- other player FX
    if not myplayer then
        -- light
        local px,py,pz = BindPoint(pe,0,2.3,1) 
        AddAction({{"Light:a[1],a[2],a[3],255,255,185, 3, 4 , 2, 0, 0, 0.1"}},nil,nil,px,py,pz)
        -- pfx
        local pfx1 = AddPFX("bonegun_shot",0.2)            
        local pfx2 = AddPFX("bonegun_shot",0.2)            
        ENTITY.RegisterChild(pe,pfx1)
        ENTITY.RegisterChild(pe,pfx2)            
        local j = MDL.GetJointIndex(pe,"joint1")
        PARTICLE.SetParentOffset(pfx1, 0,0,0, j, nil,nil,nil, -1.57, 0, 0)
        PARTICLE.SetParentOffset(pfx2, 0,0,0, j, nil,nil,nil, -1.57, 0, 0)
    end
    
    -- pellets fx
    if Game.GMode == GModes.MultiplayerClient or Game.GMode == GModes.MultiplayerServer then
        if player then
            local fv = player.ForwardVector
            t:FirePelletsFX(pe,fv.X,fv.Y,fv.Z,player.HasWeaponModifier)
        else
            local ps = Game:FindPlayerStatsByEntity(pe)
            if ps and ps._animproc then 
                local q = Quaternion:New_FromEuler(ps._animproc.Yaw,ENTITY.GetOrientation(pe),0)
                fx,fy,fz = q:InverseTransformVector(0,0,1)                                
                t:FirePelletsFX(pe,fx,fy,fz,0)
            end
        end
    end
    
    Game._EarthQuakeProc:Add(x,y,z, 4.5, 3, s.ShotCamMove, s.ShotCamRotate, false)
    
    t:SndEnt("shot",pe)
    t:SndEnt("shell",pe)
    QuadSound(pe)        
end
Network:RegisterMethod("Bonegun.FireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "eb")
--============================================================================
function Bonegun:AltFireSFX(pe)
    local player = EntityToObject[pe]    
    local t = Templates["Bonegun.CWeapon"]
    local s = Templates["Bonegun.CWeapon"]:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)

    -- update ammo on proper client and server
    if player then
        if not Game.NoAmmoLoss then player.Ammo.StoneBullets = player.Ammo.StoneBullets - 1 end
        if player.Ammo.StoneBullets < 0 then player.Ammo.StoneBullets = 0 end
        -- set next shot timeout
        local cw = player:GetCurWeapon()
        cw.ShotTimeOut =  s.AltFireTimeout
        cw._ActionState = "Idle"
        cw:ForceAnim("iceshot",false)
        if Cfg.ViewWeaponModel then
                local pfx1 = AddPFX("stonebullet_shot",0.6)            
                local pfx2 = AddPFX("stonebullet_shot",0.05)   
                local pfx3 = AddPFX("stonebullet_shot2",0.05)             
                ENTITY.RegisterChild(cw._Entity,pfx1)
                ENTITY.RegisterChild(cw._Entity,pfx2)    
                ENTITY.RegisterChild(cw._Entity,pfx3)          
                local joint1 = MDL.GetJointIndex(cw._Entity,"l_hlaven") 
                local joint2 = MDL.GetJointIndex(cw._Entity,"r_hlaven") 
                local joint3 = MDL.GetJointIndex(cw._Entity,"lebka_head") 
                PARTICLE.SetParentOffset(pfx1, 0,0, 0, joint1, nil,nil,nil, 0, 0, -math.pi/8) 
                PARTICLE.SetParentOffset(pfx2, 0, 0, 0, joint2, nil,nil,nil, 0, 0, -math.pi) 
                PARTICLE.SetParentOffset(pfx3, -0.05, 0.1, 0, joint3, nil,nil,nil, 0, 0, -math.pi) 
        end
    end

    t:SndEnt("freezer_shot",pe)    
    QuadSound(pe)                
end
Network:RegisterMethod("Bonegun.AltFireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
--============================================================================
function Bonegun:HitWallSFX(entity,x,y,z,nx,ny,nz,fx,fy,fz)

    --Game:Print("HitWallSFX:"..x..", "..y..", "..z..", "..nx..", "..ny..", "..nz..", "..fx..", "..fy..", "..fz)
    local px,py,pz = x-fx,y-fy,z-fz

    local t = Templates["Bonegun.CWeapon"]
    if ENTITY.IsWater(entity) then
        if math.random(1,5) == 1 then             
--            ENTITY.SpawnDecal(entity,'splash',x,y,z,nx,ny,nz)
            AddPFX("shotgunHitWater",0.3,Vector:New(px,py,pz),Quaternion:New_FromNormal(nx,ny,nz))        
            t:Snd3D("hit_water",x,y,z)
        end
        return
    end

    if entity then ENTITY.SpawnDecal(entity,'bullethole',x,y,z,nx,ny,nz) end    
    local t = Templates["Bonegun.CWeapon"]
    local r = Quaternion:New_FromNormal(nx,ny,nz)
    
    AddPFX("shotgunHitWall",0.25,Vector:New(px,py,pz),r)        
    
    if Game.GMode == GModes.SingleGame then 
        if math.random(0,1) == 0 then
            local vx,vy,vz  = r:TransformVector(FRand(-12,12),FRand(12,25),FRand(-12,12)) 
            local sizes = {0.3,0.5,0.8}
            local ke = AddItem("sgKamyk.CItem",sizes[math.random(1,3)],Vector:New(px+FRand(-0.1,0.1),py+FRand(-0.1,0.1),pz+FRand(-0.1,0.1)),false,Quaternion:New_FromNormal(-vx,-vy,-vz))
            ENTITY.SetVelocity(ke,vx,vy,vz)
            ENTITY.SetTimeToDie(ke,FRand(1,2))
        end
    end
end
--============================================================================
function Bonegun:FirePelletsFX(pe,fx,fy,fz,modified)
    local t = Templates["Bonegun.CWeapon"]
    local s = t:GetSubClass()
    local rot = Quaternion:New_FromNormalZ(fx,fy,fz)         

    local hw = s.HowManyPellets
    
    if Cfg.LowQualityMultiplayerSFX then hw = math.floor(hw/3) end
    
    for i=1, hw do 
        local r = s.FireRadius
        if modified == true or modified == 1 then r = s.FireRadius / 4 end            
        local sx,sy = RadiusRandom2D(r)
        local sz = s.FireRange
        sx,sy,sz = rot:TransformVector(sx,sy,sz)
        local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(pe)
        local b,d,x,y,z,nx,ny,nz,he,e = TraceFromPlayerToPoint(pe,cx+sx,cy+sy,cz+sz)
        if ENTITY.IsFixedMesh(e) then
            t:HitWallSFX(e,x,y,z,nx,ny,nz,fx,fy,fz)
        end            
    end
end
--============================================================================
function Bonegun:OutOfAmmoFX(entity,fire)
    Templates["Bonegun.CWeapon"]:SndEnt("out_of_ammo",entity)
end
Network:RegisterMethod("Bonegun.OutOfAmmoFX", NCallOn.AllClients, NMode.Reliable, "eb") 
--============================================================================
