o._stakeTime = 0
o._stakeTime = 0
o._zoom = 0
o._curFOV = Cfg.FOV
o._destFOV = Cfg.FOV
o._zoomdelay = 0
--============================================================================
function MagicCrossbow:OnCreateEntity()
	self:ReloadTextures()
    self._sndZoom = SOUND2D.Create(self:GetSndInfo("zoom_loop",true),false,true)
end
--============================================================================
function MagicCrossbow:OnPrecache()
    CloneTemplate("MagicCrossbow.CWeapon"):LoadHUDData()
	Cache:PrecacheItem("Arrow.CItem")     
	Cache:PrecacheItem("Heads.CItem")             
	Cache:PrecacheItem("Heads2.CItem")             
    Cache:PrecacheTrail("trail_kolek")        
    Cache:PrecacheTrail("trail_kolek_combo")        
end
--============================================================================
function MagicCrossbow:OnChangeWeapon()
    self._stakeTime = 0 
    self._zoom = 0
    self._curFOV = Cfg.FOV
    self._destFOV = Cfg.FOV
    Hud.NoCrosshair = nil
    R3D.SetCameraFOV(Cfg.FOV)
    MOUSE.SetSensitivity(Cfg.MouseSensitivity)
    SOUND2D.Stop(self._sndZoom)
    WORLD.UseSwitchZones(true)
end
--============================================================================
function MagicCrossbow:OnReleaseEntity()
    if self._sndZoom then
        SOUND2D.Delete(self._sndZoom)
    end
    WORLD.UseSwitchZones(true)
end
--============================================================================
function MagicCrossbow:ReloadTextures()
	if not self._Entity then return end
    if Cfg.WeaponNormalMap == true then    
        if Cfg.WeaponSpecular == false then
            MATERIAL.Replace("models/kgr/kgr_pb","models/kgr/kgr_pb_no_specular")
        else
            MATERIAL.Replace("models/kgr/kgr_pb","models/kgr/kgr_pb")
        end
    end
	MDL.EnableNormalMaps(self._Entity,Cfg.WeaponNormalMap)
end
--============================================================================
function MagicCrossbow:LoadHUDData()
	self._matAmmoIcon1 = MATERIAL.Create("HUD/Mw_hud/i_arrows", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matAmmoIcon2 = MATERIAL.Create("HUD/Mw_hud/i_heads", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matZoom = MATERIAL.Create("HUD/zoom", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function MagicCrossbow:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
    
    Hud.NoCrosshair = nil
    if self._zoom > 0 then
		if Cfg.PROD_Zoom_FX == 1 then
			HUD.DrawQuad(self._matZoom,0,0,w,h)
			Hud.NoCrosshair = true
		else
			HUD.DrawQuad(Hud._matZoom1,0,0,w,h)
			Hud.NoCrosshair = false		
		end
    end
    
    if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
		Hud:Quad(self._matAmmoIcon1,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoIcon2,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Arrows)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Heads)
	else
		Hud:Quad(self._matAmmoIcon2,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoIcon1,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Heads),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Heads)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Arrows),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Arrows)
	end    
end
--============================================================================
function MagicCrossbow:StickShot(nr,player,ox,oy,oz)
    local s = self:GetSubClass()
    -- create rocket object
    local obj = GObjects:Add(TempObjName(),CloneTemplate("Arrow.CItem"))        
    local x,y,z = ENTITY.PO_GetPawnHeadPos(player._Entity)                
    local fv = player.ForwardVector
    --y = y - 0.05
    
    local orientation = ENTITY.GetOrientation(player._Entity)
    
    local tv = Vector:New(ox,oy,oz)
    tv:Rotate(-math.atan(fv.Y),orientation,0)    
    obj.Pos:Set(x+fv.X*0.4+tv.X,y+fv.Y*0.4+tv.Y,z+fv.Z*0.4+tv.Z)
    obj.Rot:FromNormalZ(fv.X,fv.Y,fv.Z)         
    
    obj._lastTraceStartPoint =  obj.Pos:Copy()
    obj.ObjOwner = player
    obj:Apply()
    obj.Damage = s.ArrowDamage
    if player.HasQuad then            
        obj.Damage = math.floor(obj.Damage * 4)
    end
    obj.EnemyThrowBack = s.ArrowEnemyThrowBack
    obj.EnemyThrowUp   = s.ArrowEnemyThrowUp

    local speed = s.ArrowSpeed
    if player.HasWeaponModifier then 
        speed = speed * 1.2 
        obj.Damage = obj.Damage * 1.5
    end
    
    ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)
    ENTITY.PO_EnableGravity(obj._Entity,false)
    
    MDL.SetMeshVisibility(self._Entity,"goad"..nr.."_2sidedShape",false)
end
--============================================================================
function MagicCrossbow:Fire(prevstate,combo) -- Stake
    if not combo then combo = 0 end
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.Arrows > 0 then                
        local action = {
            
            {"L:p:StickShot(1,p.ObjOwner,0,0,0)"},
            {"L:p:StickShot(2,p.ObjOwner,-0.25,-0.12,0)"},
            {"L:p:StickShot(3,p.ObjOwner,0.25,-0.12,0)"},
            
        }
        AddAction(action,self)
        self.FireSFX(self.ObjOwner._Entity)
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,1)
        self.ShotTimeOut = s.AltFireTimeout
    end

    PlayLogicSound("FIRE",PX,PY,PZ,12,24,Player)   
end
--============================================================================
function MagicCrossbow:OnFinishFire(oldstate)
end
--============================================================================
function MagicCrossbow:BombShot(nr,player,ox,oy,oz)
    -- create grenade object
    local obj
    if nr < 7 then
	    obj = GObjects:Add(TempObjName(),CloneTemplate("Heads.CItem"))
	   else
	    obj = GObjects:Add(TempObjName(),CloneTemplate("Heads2.CItem"))
	end		  
    obj.ObjOwner = player		
    
    local s = self:GetSubClass()
    local fv = Clone(player.ForwardVector)
    local x,y,z = ENTITY.PO_GetPawnHeadPos(player._Entity)                
	local orientation = ENTITY.GetOrientation(player._Entity)   
	local forward = math.sqrt(fv.X*fv.X + fv.Z*fv.Z)

    if nr < 7 then
	    local tv = Vector:New(ox,oy,oz)
	    tv:Rotate(-math.atan2(fv.Y,forward),orientation,0)
	    obj.Pos:Set(x+tv.X+fv.X*0.3+FRand(-0.2,0.2),y+tv.Y+fv.Y*0.3+FRand(-0.1,0.1),z+tv.Z+fv.Z*0.3+FRand(-0.2,0.2))
    	obj.Rot:FromNormalY(fv.X,fv.Y,fv.Z)     
   else
        y = y - 0.2
        local b = self.ObjOwner:Trace(1.3)
        if not b then 
            x,y,z = x + fv.X*1.3, y + fv.Y*1.3, z + fv.Z*1.3    
        end
        
        obj.Pos:Set(x,y,z)
        obj.Rot:FromNormalY(fv.X,fv.Y,fv.Z)     
   end
    obj:Apply()
    obj.ExplosionStrength = s.HeadsExplosionStrength
    obj.ExplosionRange    = s.HeadsExplosionRange        
    obj.Damage            = s.HeadsDamage       
    if Game.GMode ~= GModes.SingleGame then
	obj.Timeout            = s.HeadsExplosionTimer        
    end
    if player.HasQuad then            
        obj.Damage = math.floor(obj.Damage * 4)
    end
    
    local gvf = s.HeadsSpeed
    local tv = Vector:New(0,0,1)
    tv:Rotate(0,(nr-5.5)*0.02,0)
    tv:Rotate(-math.atan2(fv.Y,forward),orientation,0)    
    tv:Normalize()
    if nr ~= 7 then 
	   if nr ~= 1 then 
		MDL.SetMeshVisibility(self._Entity,"head"..nr.."Shape",false)
	   end
    else
		MDL.SetMeshVisibility(self._Entity,"head2Shape",false)
		MDL.SetMeshVisibility(self._Entity,"head3Shape",false)
		MDL.SetMeshVisibility(self._Entity,"head4Shape",false)
		MDL.SetMeshVisibility(self._Entity,"head5Shape",false)
		MDL.SetMeshVisibility(self._Entity,"head6Shape",false)
    end
	if nr < 7 then
	    ENTITY.SetVelocity(obj._Entity,tv.X*gvf+FRand(-2,2), tv.Y*gvf+FRand(-1,1), tv.Z*gvf+FRand(-2,2))       
	 else
	    ENTITY.SetVelocity(obj._Entity,tv.X*gvf, tv.Y*gvf, tv.Z*gvf)       
	 end
end

function o:OnUpdate()
	self.ObjOwner.State = 4
end
--============================================================================
-- ALT FIRE - GRENADE (Server Side)
--============================================================================
function MagicCrossbow:AltFire() -- bomb
    
    --if Game.GMode ~= GModes.SingleGame then 
    --    self._ActionState = "Idle"
    --    self._altfire = false
    --    return 
    --end
    
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.Heads > 5  then       
        if Player then Player.ExplosiveFired = true end       
        if Game.GMode == GModes.SingleGame then 
            self:BombShot(1,self.ObjOwner,-0.5/2,0,0)       
            self:BombShot(2,self.ObjOwner,-0.4/2,0,0)       
            self:BombShot(3,self.ObjOwner,-0.3/2,0,0)       
            self:BombShot(4,self.ObjOwner,-0.2/2,0,0)       
            self:BombShot(5,self.ObjOwner,-0.1/2,0,0)       
            self:BombShot(6,self.ObjOwner,0.1/2,0,0)       
        else
            self:BombShot(7,self.ObjOwner,0,0,0)       
        end
        -- launch SpecialFX on all clients
        self.AltFireSFX(self.ObjOwner._Entity)
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,2)
        self.ShotTimeOut = s.AltFireTimeout
    end

    PlayLogicSound("FIRE",PX,PY,PZ,26,52,Player)
end
--============================================================================
function MagicCrossbow:OnTick(delta)
    if self._stakeTime > 0 then 
        self._stakeTime = self._stakeTime - delta         
    else
        if self._stakeTime < 0 then
            self._stakeTime = 0
        end
        if self.ObjOwner.Ammo.Arrows > 0  then                     
		MDL.SetMeshVisibility(self._Entity,"goad1_2sidedShape",true)
       		if self.ObjOwner.Ammo.Arrows > 1  then                
			MDL.SetMeshVisibility(self._Entity,"goad2_2sidedShape",true)
			if self.ObjOwner.Ammo.Arrows > 2  then                
					MDL.SetMeshVisibility(self._Entity,"goad3_2sidedShape",true)
			end
		end

        end
        if self.ObjOwner.Ammo.Heads > 0  then                     
		MDL.SetMeshVisibility(self._Entity,"head3Shape",true) 
       		if self.ObjOwner.Ammo.Heads > 2  then                     
			MDL.SetMeshVisibility(self._Entity,"head2Shape",true) 
			MDL.SetMeshVisibility(self._Entity,"head6Shape",true)
			if self.ObjOwner.Ammo.Heads > 4  then                     
				MDL.SetMeshVisibility(self._Entity,"head4Shape",true) 
				MDL.SetMeshVisibility(self._Entity,"head5Shape",true) 

			end
		end
        end
    end
    
    if self._zoomdelay and self._zoomdelay > 0 then
        self._zoomdelay = self._zoomdelay - delta
    end
    
    if INP.UIAction(UIActions.Zoom) and self._zoomdelay <= 0 then
        self._zoomdelay = 0.3
        self._zoom = self._zoom + 1
        if self._zoom > 1 then self._zoom = 0 end
        if self._zoom == 1 then
            self:SndEnt("zoom_in",self.ObjOwner._Entity)
            self._destFOV = 50
            if Cfg.ZoomFOV then
                self._destFOV =Cfg.ZoomFOV
            end            
            SOUND2D.Play(self._sndZoom)            
            SOUND2D.SetLoopCount(self._sndZoom,0)
        end
               
        if self._zoom == 0 then
--            Cfg.ZoomFOV = self._destFOV
            self._destFOV = Cfg.FOV
            --R3D.SetCameraFOV(Cfg.FOV)
            MOUSE.SetSensitivity(Cfg.MouseSensitivity)            
            --SOUND2D.SetLoopCount(self._sndZoom,10)
        end        
    end
    
    if self._zoom == 1 then
        if INP.Key(Keys.MouseWheelBack) == 1 or INP.Action(Actions.PrevWeapon) then
            self._destFOV = self._destFOV + 7
            if self._destFOV > 50 then self._destFOV = 50 end
            --Game:Print("back")
        end  
    
        if INP.Key(Keys.MouseWheelForward) == 1 or INP.Action(Actions.NextWeapon) then
            self._destFOV = self._destFOV - 7
            if self._destFOV < 3 then self._destFOV = 3 end
            --Game:Print("forward")
        end  
    end

    MOUSE.SetSensitivity(Cfg.MouseSensitivity * (self._destFOV/Cfg.FOV))
    --Game:Print(Cfg.MouseSensitivity * (Cfg.FOV/self._destFOV))
    self._curFOV = self._curFOV + (self._destFOV - self._curFOV) * delta * 12        
    R3D.SetCameraFOV(self._curFOV)
    
    if self._curFOV < 50 then
        WORLD.UseSwitchZones(false)
    else
        WORLD.UseSwitchZones(true)
    end
    
    local vol = math.abs(self._destFOV - self._curFOV) * 100
    SOUND2D.SetVolume(self._sndZoom,vol)
    --if math.abs(self._destFOV - self._curFOV) < 0.5 then
    --    SOUND2D.SetVolume(self._sndZoom,0)
    --else
    --    SOUND2D.SetVolume(self._sndZoom,100)
    --end
    
    --Game:Print(vol)
end
--============================================================================
function MagicCrossbow:OnFinishAnim(anim)
    if anim == "arrowshot" then
        self._ActionState = "Idle"
        self:SndEnt("bolt_reload",self.ObjOwner._Entity)
    end
end
--============================================================================
-- NET EVENTS
--============================================================================
function MagicCrossbow:FireSFX(pe)
    local player = EntityToObject[pe]   
    
    local t = Templates["MagicCrossbow.CWeapon"]
    local s = t:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)
    
    if player and player._Class ~= "CPlayer" then MsgBox("Bad player object: "..player._Class) end

    -- update ammo on proper client and server
    if player then
        if not Game.NoAmmoLoss then player.Ammo.Arrows = player.Ammo.Arrows - 3 end
        if player.Ammo.Arrows < 0 then player.Ammo.Arrows = 0 end
        -- set next shot timeout
        local cw = player:GetCurWeapon()
        cw.ShotTimeOut =  s.FireTimeout
        cw._ActionState = "Idle"
        cw:ForceAnim("arrowshot",false)                           
--        cw._stakeTime = 1.1         
        cw._stakeTime = 0.5         
        
        local action = {            
            {"L:p:SndEnt('bolt_shot',"..pe..")"},
            --{"Wait:0.1"},
            --{"L:p:SndEnt('bolt_shot',"..pe..")"},
            --{"Wait:0.1"},
            --{"L:p:SndEnt('bolt_shot',"..pe..")"},
            
        }
        AddAction(action,t)
    end

    QuadSound(pe)                
end
Network:RegisterMethod("MagicCrossbow.FireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
-- potwierdzony poniewaz i tak doklei sie do komunikatu stworzenia nowego entity kolka
--============================================================================
function MagicCrossbow:AltFireSFX(pe)
    local player = EntityToObject[pe]

    local t = Templates["MagicCrossbow.CWeapon"]
    local s = t:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)
    
    -- update ammo on proper client and server
    if player then 
        if not Game.NoAmmoLoss then player.Ammo.Heads = player.Ammo.Heads - 6 end
        -- set next shot timeout
        local cw = player:GetCurWeapon()
        cw.ShotTimeOut   =  s.AltFireTimeout
        cw._ActionState = "Idle" -- bo korzystamy z timeout'a        
        Game._EarthQuakeProc:Add(x,y,z, 2, 4, s.ShotCamMove, s.ShotCamRotate, false)        
        if player == Player then
            cw:ForceAnim("headshot",false)                
        end        
        cw._stakeTime = 0.4
    end
          
    t:SndEnt("heater_shot",pe)
    QuadSound(pe)           
end
Network:RegisterMethod("MagicCrossbow.AltFireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
--============================================================================
function MagicCrossbow:OutOfAmmoFX(entity,fire)
    Templates["MagicCrossbow.CWeapon"]:SndEnt("out_of_ammo",entity)
end
Network:RegisterMethod("MagicCrossbow.OutOfAmmoFX", NCallOn.AllClients, NMode.Reliable, "eb") 
--============================================================================
