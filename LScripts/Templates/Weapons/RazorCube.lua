o._painHeadEntity = nil
o._ComboDelay = 0
--============================================================================
-- HUD
--============================================================================
function RazorCube:LoadHUDData()
	self._matAmmoOpenIcon = MATERIAL.Create("HUD/kostka_open", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matAmmoCloseIcon = MATERIAL.Create("HUD/kostka_close", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matInfinity = MATERIAL.Create("HUD/infinity", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function RazorCube:OnCreateEntity()
    self._sndRotor = SOUND2D.Create(self:GetSndInfo("rotor_loop",true),false,true)
    self._sndRotor2 = SOUND2D.Create(self:GetSndInfo("rotor_loop2",true),false,true)
    self._sndElectro = SOUND2D.Create(self:GetSndInfo("electro_loop",true),false,true)
    self._sndShock = SOUND2D.Create(self:GetSndInfo("shock_loop",true),false,true)
    self:ReloadTextures()
end

--============================================================================
function RazorCube:OnPrecache()
    CloneTemplate("RazorCube.CWeapon"):LoadHUDData()
	Cache:PrecacheParticleFX("FX_pain_elektro")    
	Cache:PrecacheItem("Cube.CItem")     
    MATERIAL.Create("particles/trailpainkiller")
end
--============================================================================
function RazorCube:ReloadTextures()
	if not self._Entity then return end
    if Cfg.WeaponNormalMap == true then    
        if Cfg.WeaponSpecular == false then
            MATERIAL.Replace("models/pkw/pkw_pb","models/pkw/pkw_pb_no_specular")
        else
            MATERIAL.Replace("models/pkw/pkw_pb","models/pkw/pkw_pb")
        end
    end
	MDL.EnableNormalMaps(self._Entity,Cfg.WeaponNormalMap)
end
--============================================================================
function RazorCube:BindTrail(name,...)
    local e = ENTITY.Create(ETypes.Trail,name,"trailName")
    ENTITY.AttachTrailToBones(self._Entity,e,unpack(arg))
    WORLD.AddEntity(e)
    return e
end


function RazorCube:Bindtrails()
self._tr1=self:BindTrail("trail_razorcube", "joint1")	
self._tr2=self:BindTrail("trail_razorcube", "joint12")	
self._tr3=self:BindTrail("trail_razorcube", "joint26")	
self._tr4=self:BindTrail("trail_razorcube", "joint10")	
self._tr5=self:BindTrail("trail_razorcube", "joint23")	
self._tr6=self:BindTrail("trail_razorcube", "joint10")	
self._tr7=self:BindTrail("trail_razorcube", "joint25")
self._tr8=self:BindTrail("trail_razorcube", "joint13")
self._tr9=self:BindTrail("trail_razorcube", "joint15")
self._tr10=self:BindTrail("trail_razorcube", "joint22")	
self._tr11=self:BindTrail("trail_razorcube", "joint12")
self._tr12=self:BindTrail("trail_razorcube", "joint5")
self._tr13=self:BindTrail("trail_razorcube", "joint8")
end
--============================================================================
function RazorCube:Endtrails()
	if self._tr1 then
		ENTITY.Release(self._tr1)
		self._tr1 = nil
	end
	if self._tr2 then
		ENTITY.Release(self._tr2)
		self._tr2 = nil
	end
	if self._tr3 then
		ENTITY.Release(self._tr3)
		self._tr3 = nil
	end
	if self._tr4 then
		ENTITY.Release(self._tr4)
		self._tr4 = nil
	end
	if self._tr5 then
		ENTITY.Release(self._tr5)
		self._tr5 = nil
	end
	if self._tr6 then
		ENTITY.Release(self._tr6)
		self._tr6 = nil
	end
	if self._tr7 then
		ENTITY.Release(self._tr7)
		self._tr7 = nil
	end
	if self._tr8 then
		ENTITY.Release(self._tr8)
		self._tr8 = nil
	end
	if self._tr9 then
		ENTITY.Release(self._tr9)
		self._tr9 = nil
	end
	if self._tr10 then
		ENTITY.Release(self._tr10)
		self._tr10 = nil
	end
	if self._tr11 then
		ENTITY.Release(self._tr11)
		self._tr11 = nil
	end
	if self._tr12 then
		ENTITY.Release(self._tr12)
		self._tr12 = nil
	end
	if self._tr13 then
		ENTITY.Release(self._tr13)
		self._tr13 = nil
	end
end

--============================================================================
function RazorCube:EnableEnergyFX(enable)
    if enable then
        --Game:Print("true")
        if not self._fx then
            self._fx = AddPFX("Razorcube",0.03,Vector:New(0,0,0))
            ENTITY.RegisterChild(self._Entity,self._fx,true)
            PARTICLE.SetParentOffset(self._fx,0.04,0.04,0.02,MDL.GetJointIndex(self._Entity,"joint5"))
        end
    else
        --Game:Print("false")
        ENTITY.Release(self._fx)
        self._fx = nil        
        SOUND2D.Pause(self._sndElectro)    
    end    
end
--============================================================================
function RazorCube:OnReleaseEntity()
    SOUND2D.Delete(self._sndRotor)
    SOUND2D.Delete(self._sndRotor2)
    SOUND2D.Delete(self._sndElectro)
    SOUND2D.Delete(self._sndShock)
end
--============================================================================
function RazorCube:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
    
    if not (INP.IsFireSwitched() or (not Game.SwitchFire[1] and Cfg.SwitchFire[1]) or (not Cfg.SwitchFire[1] and Game.SwitchFire[1])) then
		Hud:Quad(self._matAmmoOpenIcon,(1024-62*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*12)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoCloseIcon,(1024-62*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
    else
		Hud:Quad(self._matAmmoCloseIcon,(1024-62*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*12)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoOpenIcon,(1024-62*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*44)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
    end
    
    Hud:Quad(self._matInfinity,(1024-121*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*15)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
    Hud:Quad(self._matInfinity,(1024-121*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
end
--============================================================================
-- FIRE - Painkiller closed (Server Side)
--============================================================================
function RazorCube:Fire()
    if self.r_PainHead then 
        self._ActionState = "Idle"
        return 
    end    

    self.StartFireSFX(self.ObjOwner.ClientID,self.ObjOwner._Entity)
end
--============================================================================
function RazorCube:OnFinishFire()
    if self.r_PainHead then return end    
    self.FinishFireSFX(self.ObjOwner.ClientID,self.ObjOwner._Entity)
end
--============================================================================
-- ALT FIRE - RazorCube opened (Server Side)
--============================================================================
function RazorCube:AltFire(first,combo)
--    self._ActionState = "Idle"
    if not first then return end
    
    if not self.r_PainHead and not self.ObjOwner._jammed then       
        self._spinning = combo
        
        -- create rocket object
        local obj = GObjects:Add(TempObjName(),CloneTemplate("Cube.CItem"))
        -- set position
	local j = MDL.GetJointIndex(self._Entity, "cube") 
--        local x,y,z = MDL.TransformPointByJoint(self._Entity,j,0.03,0.04,0)--,0,0,0) 

        local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
        local fv = self.ObjOwner.ForwardVector       
        
        obj._lastTraceStartPoint =  Vector:New(x,y,z)
	obj.Pos:Set(x+fv.X*1.7,y+fv.Y*1.7,z+fv.Z*1.7)
        obj.Rot:FromNormalZ(fv.X,fv.Y,fv.Z)     
        obj.ObjOwner = self.ObjOwner
        obj._spinning = self._spinning
        obj:Apply()
        
        if obj._spinning then
            local ax,ay,az = Quaternion:New_FromEntity(obj._Entity):TransformVector(0,0,30)
            ENTITY.PO_EnableGravity(obj._Entity,false)
--            ENTITY.SetAngularVelocity(obj._Entity,ax,ay,az)            
            MDL.SetAnim(obj._Entity,"combo",true,1,0)
            obj.ObjOwner.State = 13 -- krecacy
        else
            obj.ObjOwner.State = 121 -- promien
            MDL.SetAnim(obj._Entity,"attack2",true,1,0)
        end
        
        local s = self:GetSubClass()
        
        obj.Damage = s.PainHeadDamage
        if obj._spinning then 
            obj.Damage = s.PainHeadSpinningDamage
        end
        if self.ObjOwner.HasQuad then            
            obj.Damage = math.floor(obj.Damage * 4)
        end

        obj.BackSpeed = s.PainHeadBackSpeed                
        obj.BackImpulse = s.PainHeadBackImpulse
        obj.MonstersBackVelocity = s.PainHeadMonstersBackVelocity
        obj.Range = s.PainHeadRange
        self.r_PainHead = obj
        
        local speed = s.PainHeadSpeed
        if obj._spinning then speed =  s.PainHeadSpinningSpeed end 
        ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)
        ENTITY.PO_EnableGravity(obj._Entity,false)

        PlayLogicSound("FIRE",self.ObjOwner.Pos.X,self.ObjOwner.Pos.Y,self.ObjOwner.Pos.Z,12,26,self.ObjOwner)           
            self._fx2 = AddPFX("screamhand",0.05,Vector:New(0,0,0))
            ENTITY.RegisterChild(self._Entity,self._fx2,true)
            PARTICLE.SetParentOffset(self._fx2,0,0.1,0,MDL.GetJointIndex(self._Entity,"cube"))

        local cb = 0
        if combo then cb = 1 end
        self.AltFireSFX(self.ObjOwner._Entity,obj._Entity,cb)    
    else        
        if self.r_PainHead then
            self.r_PainHead._back = true                        
        end
    end
end
RazorCube._points = { {0,0,1.8}, {1,1,1.5}, {1,-1,1.5}, {-1,1,1.5}, {-1,-1,1.5} }
--============================================================================
function RazorCube:OnUpdate()

    if self._ComboDelay > 0 then self._ComboDelay = self._ComboDelay - 1 end
    local s = self:GetSubClass()     
    if self._painHeadEntity and self.r_PainHead and not self.r_PainHead._back and not self._spinning then        
    
        if Game.GMode ~= GModes.MultiplayerClient then 
            local x,y,z = ENTITY.GetPosition(self.r_PainHead._Entity)        
            local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
            local fv = self.ObjOwner.ForwardVector
            
            local d = R3D.DistToLine(x,y,z,cx,cy,cz,cx+fv.X*900,cy+fv.Y*900,cz+fv.Z*900)    
            if self.ObjOwner.HasWeaponModifier or d < s.PainRayTolerance then        
                
                local px,py,pz = cx,cy-0.5,cz
                
                if Game.GMode == GModes.SingleGame then
                    local j = MDL.GetJointIndex(self._Entity, "joint5") 
                    px,py,pz = MDL.TransformPointByJoint(self._Entity,j,0.03,0.04,0)--,0,0,0) 
                end
    
                ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
                local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(px,py,pz,x-fv.X,y-fv.Y,z-fv.Z)
                ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
                
                if b then                            
                    local obj = EntityToObject[e]             
                    if obj then          
                        if math.random(100) < 50 then                            
                            local damage = s.PainRayDamage
                            if self.ObjOwner.HasQuad then            
                                damage = math.floor(damage * 4)
                            end
                            if obj.OnDamage then obj:OnDamage(damage,self.ObjOwner,AttackTypes.Painkiller,tx,ty,tz,nx,ny,nz, he) end
                        end
                    end
                end        
            end        
        end
        
    elseif self.Animation == "attack1start" or self.Animation == "attack1roll" then -- mlocka
        local fv = self.ObjOwner.ForwardVector
        local rot = Quaternion:New_FromNormalZ(fv.X,fv.Y,fv.Z) 
        local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity) 
                        
        local b,d,tx,ty,tz,nx,ny,nz,he,e        
        for i,o in self._points do
            local sx,sy,sz = rot:TransformVector(o[1],o[2],o[3])
            b,d,tx,ty,tz,nx,ny,nz,he,e = self.ObjOwner:TraceToPoint(cx+sx,cy+sy,cz+sz)
            if b then break end
        end
        if b then
            if Game.GMode ~= GModes.MultiplayerClient then 
                local fv = self.ObjOwner.ForwardVector
                local obj = EntityToObject[e]
                if obj and obj.OnDamage then
                    local d = s.PainKnifeDamage
                    if self.ObjOwner.HasWeaponModifier then d = d * 2 end
                    if obj.OnDamage then obj:OnDamage(s.PainKnifeDamage,self.ObjOwner,AttackTypes.PainkillerRotor,tx,ty,tz,nx,ny,nz, he) end
                    if self.ObjOwner == Player and self.ObjOwner == Player and obj._Class == "CActor" then
                        self:Snd2D("rotor_hit_enemy")
			if Game.GMode == GModes.SingleGame and Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
				PlaySound2D("belial/Belial_ingame_"..math.random(137,139),Game.chatvolume,nil,true)
			end
                    end                
                end
    
                local imp = s.PainKnifeImpulse
                WORLD.HitPhysicObject(he,tx,ty,tz,fv.X*imp,fv.Y*imp,fv.Z*imp)
            end
            
            if self.ObjOwner == Player then 
                if ENTITY.GetType(e) ==  ETypes.Model then
                    self:Snd2D("rotor_hit_enemy")
                else
                    self:Snd2D("rotor_hit_wall")
                end
            end            
            
        end        
    end
end
--============================================================================
function RazorCube:OnTick(delta)
    if self.r_PainHead and (not self.r_PainHead._Entity or self._changed)then
        self.BackHeadSFX(self.ObjOwner.ClientID,self.ObjOwner._Entity)    
    end    
end
--============================================================================
function RazorCube:ComboCheck()
    
    if not (self._ActionState == "Fire" and self._ComboDelay <= 0) then return end    
    
    if ENTITY.PO_IsActionState(self.ObjOwner._Entity,Actions.AltFire) then
        self._ActionState = "Idle"
        self._fire = false
        self._altfire = true
        self:AltFire(true,true)
    end

end
--============================================================================
function RazorCube:OnChangeWeapon()
    if self.r_PainHead then
        if self.ObjOwner._died then
            GObjects:ToKill(self.r_PainHead)
        end
        self.r_PainHead._back = true
        self._changed = true
        self:OnTick()
        self._changed = nil
        self.ObjOwner.State = 1
    end
    self:EnableEnergyFX(false)
    self:ForceAnim("idle",true)
    self:Endtrails()
    SOUND2D.Stop(self._sndRotor)
    SOUND2D.Stop(self._sndRotor2)
    SOUND2D.Stop(self._sndElectro)
    SOUND2D.Stop(self._sndShock)
end
--============================================================================
function RazorCube:OnFinishAnim(anim)
    if anim == "attack1stop" or anim == "attack2stop" then
        self._ActionState = "Idle"
        self.ShotTimeOut = -1
        self:SetAnim("idle") 
    else
        if anim == "attack1start" then
            self:SetAnim("attack1roll")
       end
    end
end
--============================================================================
function RazorCube:Render()

    if WORLD.IsGamePaused() or Player ~= self.ObjOwner then return end

    if not self._painHeadEntity or (self.r_PainHead and self.r_PainHead._back) or self._spinning then 
        if self.ObjOwner.HasWeaponModifier and self.Animation == "attack1roll" and not self._combo then
            self:EnableEnergyFX(true)
        else
            self:EnableEnergyFX(false)
        end
        return         
    end
        
    local disableFX = false
    local s = self:GetSubClass()
    
    local x,y,z = ENTITY.GetPosition(self._painHeadEntity)    
    local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity) 
    local fv = self.ObjOwner.ForwardVector

    local d = R3D.DistToLine(x,y,z,cx,cy,cz,cx+fv.X*900,cy+fv.Y*900,cz+fv.Z*900)    
    if self.ObjOwner.HasWeaponModifier or d < s.PainRayTolerance then
        local j = MDL.GetJointIndex(self._Entity, "cube") 
        local yj = MDL.GetJointIndex(self._Entity, "r_index3") 
        local px,py,pz = MDL.TransformPointByJoint(self._Entity,j,0.03,0.1,0)--,0,0,0) 
        
        ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
        local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(px,py,pz,x-fv.X,y-fv.Y,z-fv.Z)
        ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
        
        local isObj = false
        if b and e then
            if Game.GMode == GModes.SingleGame then
                local obj = EntityToObject[e]
                if obj and obj.OnDamage then isObj = true end
            else
                if ENTITY.GetType(e) ==  ETypes.Model or 
                    ( ENTITY.GetType(e) ==  ETypes.Mesh and not ENTITY.IsFixedMesh(e) ) then 
                    isObj = true
                end
            end            
        end
        
        if isObj or not b then 
--[[	local points={}
	   points[1] = Vector:New(px,py,pz)
	   points[2] = Vector:New(x,y,z)
	  local t = Templates["DriverElectro.CWeapon"]
	  t:DrawBezierLine(points,15,11, FRand(0.1, 0.4), R3D.RGB(240,40,40))
	  t:DrawBezierLine(points,15,12, FRand(0.1, 0.4), R3D.RGB(240,44,44))
--]]
           R3D.DrawSprite1DOF(px,py,pz,x,y,z,0.1,R3D.RGB(255,255,255),"particles/trailscreamer") 
            self:EnableEnergyFX(true)            
            if not SOUND2D.IsPlaying(self._sndElectro) then 
                SOUND2D.SetLoopCount(self._sndElectro,0)             
                SOUND2D.Play(self._sndElectro) 
            end             
            if isObj then
                if not SOUND2D.IsPlaying(self._sndShock) then 
                    SOUND2D.SetLoopCount(self._sndShock,0)                                 
                    SOUND2D.Play(self._sndShock) 
                end
            else
                SOUND2D.Pause(self._sndShock)                                
            end
        else
            disableFX = true
        end
    else
        disableFX = true
    end
    
    if disableFX then
        self:EnableEnergyFX(false)
        SOUND2D.Pause(self._sndElectro)
        SOUND2D.Pause(self._sndShock)
    end

end
--============================================================================
function RazorCube:StartFireSFX(pe)    
    local player = EntityToObject[pe]       
    local t = Templates["RazorCube.CWeapon"]
    local x,y,z = ENTITY.GetPosition(pe)

    if player then
        local w = player:GetCurWeapon()
	w:Bindtrails()
        w._ComboDelay = 15
        w:SetAnim("attack1start",false)
        player.State = 11
        w._ActionState = "Fire" -- to musimy recznie ustawic na kliencie
        if player == Player then
            SOUND2D.SetLoopCount(w._sndRotor,0)        
            SOUND2D.SetLoopCount(w._sndRotor2,0)        
            SOUND2D.Play(w._sndRotor)    
            SOUND2D.Play(w._sndRotor2)    
        end
    end    
    t:SndEnt("rotor_start",pe)
    QuadSound(pe)    
end
Network:RegisterMethod("RazorCube.StartFireSFX", NCallOn.ServerAndAllClients, NMode.ReliableForSingle, "e") 
--============================================================================
function RazorCube:AltFireSFX(pe,he,combo)    
    local player = EntityToObject[pe]       
    local t = Templates["RazorCube.CWeapon"]
    
    if player then        
        local cw = player:GetCurWeapon()
	if combo == 1 then
        cw:ForceAnim("combostart",false)                   
	cw:Endtrails()
	else
        cw:ForceAnim("attack2start",false)                   
	end
	cw._weaponwalk = true
 	cw.weaponwalk = "attack2roll"
	cw.weaponidle = "attack2roll"

        cw._stakeTime = 0.75       
        cw._painHeadEntity = he
        if combo == 1 then
            cw._spinning = true
        end        
        if player == Player then
            cw._ActionState = "Shot"
	MDL.SetMeshVisibility(cw._Entity,"pCylinderShape1",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape2",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape3",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape4",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape5",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape6",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape7",false)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape8",false)
		MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape1",false)
		MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape2",false)
		MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape2",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape3",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape4",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape5",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape6",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape8",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape7",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape9",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape10",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape13",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape16",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape19",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape22",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape25",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape28",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape31",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape34",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape40",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape43",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape49",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape46",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape37",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape11",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape12",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape14",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape15",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape17",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape18",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape20",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape21",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape23",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape24",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape26",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape27",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape29",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape30",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape32",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape33",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape35",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape36",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape38",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape39",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape41",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape42",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape44",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape45",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape47",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape48",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape50",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape51",false)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape52",false)

            SOUND2D.Stop(cw._sndRotor)    
            SOUND2D.Stop(cw._sndRotor2)    
            cw:EnableEnergyFX(false)
        end
    end    
    ENTITY.RegisterChild(pe,he,false,-1,false)
    t:SndEnt("head_shot",pe)
    QuadSound(pe)    
end
Network:RegisterMethod("RazorCube.AltFireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "eeb") 
--============================================================================
function RazorCube:BackHeadSFX(pe)    
    local player = EntityToObject[pe] 
    local t = Templates["RazorCube.CWeapon"]
    if player then        
        local cw = player.Weapons[1]
        if player == Player then
		MDL.SetMeshVisibility(cw._Entity,"pCylinderShape1",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape2",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape3",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape4",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape5",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape6",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape7",true)
            MDL.SetMeshVisibility(cw._Entity,"pCylinderShape8",true)
		MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape1",true)
		MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape2",true)
		MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape2",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape3",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape4",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape5",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape6",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape8",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape7",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape9",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape10",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape13",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape16",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape19",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape22",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape25",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape28",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape31",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape34",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape40",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape43",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape49",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape46",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape37",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape11",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape12",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape14",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape15",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape17",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape18",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape20",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape21",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape23",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape24",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape26",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape27",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape29",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape30",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape32",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape33",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape35",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape36",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape38",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape39",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape41",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape42",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape44",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape45",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape47",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape48",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape50",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape51",true)
            MDL.SetMeshVisibility(cw._Entity,"cube_polySurfaceShape52",true)
            
            SOUND2D.Pause(cw._sndElectro)    
            SOUND2D.Pause(cw._sndShock)    
            cw._ActionState = "End"
        end
        ENTITY.Release(cw._fx2)
        cw._fx2 = nil        
        cw:ForceAnim("attack2stop",false)
   	cw._weaponwalk = false
        cw.r_PainHead = nil
        cw._spinning = nil        
        cw._painHeadEntity = nil        
        player.State = 1
    end
    t:SndEnt("head_reload",pe)
end
Network:RegisterMethod("RazorCube.BackHeadSFX", NCallOn.ServerAndAllClients, NMode.ReliableForSingle, "e") 
--============================================================================
function RazorCube:FinishFireSFX(pe)    
    local player = EntityToObject[pe]       
    local t = Templates["RazorCube.CWeapon"]
    local x,y,z = ENTITY.GetPosition(pe)

    if player then
        local w = player:GetCurWeapon()
        w:SetAnim("attack1stop",false)
	w:Endtrails()
        player.State = 1
        if player == Player then
            w._ActionState = "End" -- to musimy recznie ustawic na kliencie
            SOUND2D.Stop(w._sndRotor)    
            SOUND2D.Stop(w._sndRotor2)    
            w:EnableEnergyFX(false)
        end
    end
    t:SndEnt("rotor_stop",pe)    
end
Network:RegisterMethod("RazorCube.FinishFireSFX", NCallOn.ServerAndAllClients, NMode.ReliableForSingle, "e") 
--============================================================================
