o._stakeTime = 0
o._drain = 0
o._zoom = 0
o._curFOV = Cfg.FOV
o._destFOV = Cfg.FOV
o._zoomdelay = 0
--============================================================================
function HellBlade:OnCreateEntity()
	MDL.SetMeshVisibility(self._Entity,"pPlainShape1",false)
	self:ReloadTextures()
    self._sndZoom = SOUND2D.Create(self:GetSndInfo("zoom_loop",true),false,true)
end
--============================================================================
function HellBlade:OnPrecache()
    CloneTemplate("HellBlade.CWeapon"):LoadHUDData()
 	Cache:PrecacheParticleFX("infernalbul")
	Cache:PrecacheItem("DarkEnergy.CItem")     
	Cache:PrecacheItem("Flying_blade.CItem")     
    Cache:PrecacheTrail("trail_kolek")        
    Cache:PrecacheTrail("trail_kolek_combo")        
end
--============================================================================
function HellBlade:OnChangeWeapon()
    self._stakeTime = 0 
    self._zoom = 0
    self._curFOV = Cfg.FOV
    self._destFOV = Cfg.FOV
    Hud.NoCrosshair = nil
    R3D.SetCameraFOV(Cfg.FOV)
    MOUSE.SetSensitivity(Cfg.MouseSensitivity)
    SOUND2D.Stop(self._sndZoom)
    WORLD.UseSwitchZones(true)
	if self.r_PainHead then
        if self.ObjOwner._died then
            GObjects:ToKill(self.r_PainHead)
        end
        self.r_PainHead._back = true
        self._changed = true
        self:OnTick()
        self._changed = nil
	self.ObjOwner.State = 6
    end
end

--============================================================================
function HellBlade:BindTrailSword2(name, joint1, joint2, joint3)
	if self._trailSword2 then
		ENTITY.Release(self._trailSword2)
	end
	self._trailSword2 = self:BindTrail(name, joint1, joint2, joint3)
end

function HellBlade:EndTrailSword2()
	if self._trailSword2 then
		ENTITY.Release(self._trailSword2)
		self._trailSword2 = nil
	end
end


--============================================================================
function HellBlade:OnReleaseEntity()
    if self._sndZoom then
        SOUND2D.Delete(self._sndZoom)
    end
    WORLD.UseSwitchZones(true)
end
--============================================================================
function HellBlade:ReloadTextures()
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
function HellBlade:LoadHUDData()
	self._matAmmoIcon3 = MATERIAL.Create("HUD/Mw_hud/i_skulls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matAmmoIcon4 = MATERIAL.Create("HUD/Mw_hud/i_Dark_energy", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function HellBlade:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
    
    Hud.NoCrosshair = nil
    
    if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
		Hud:Quad(self._matAmmoIcon3,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoIcon4,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Skulls)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.DarkEnergy)
	else
		Hud:Quad(self._matAmmoIcon4,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoIcon3,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.DarkEnergy),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.DarkEnergy)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Skulls),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Skulls)
	end    
end
--============================================================================
function HellBlade:StickShot(nr,player,ox,oy,oz,chdir,side,what)
    local s = self:GetSubClass()
    local speed=0
    local obj = nil
	local lockobj = nil
	-- try to lock target
	    local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity) 
	    local fv = self.ObjOwner.ForwardVector                       
	    local rot = Quaternion:New_FromNormalZ(fv.X,fv.Y,fv.Z) 
	    local  sx,sy,sz = rot:TransformVector(0,0,s.LockingDistance) 
	    local xmod, ymod
	    for gg = 1,15 do
		if gg == 1 then
			xmod=1
			ymod=1
		elseif gg == 2 then
			xmod = -1
			ymod = 1
		elseif gg == 3 then
			xmod = 1
			ymod = -1
		elseif gg == 4 then
			xmod = -1
			ymod = -1
		elseif gg == 5 then
			xmod = 0
			ymod = 0
		elseif gg == 6 then
			xmod = 1
			ymod = 2
		elseif gg == 7 then
			xmod = 2
			ymod = 1
		elseif gg == 8 then
			xmod = 2
			ymod = -1
		elseif gg == 9 then
			xmod = -2
			ymod = 1
		elseif gg == 10 then
			xmod = 1
			ymod = -2
		elseif gg == 11 then
			xmod = -1
			ymod = 2
		elseif gg == 12 then
			xmod = 2
			ymod = 2
		elseif gg == 13 then
			xmod = -2
			ymod = 2
		elseif gg == 14 then
			xmod = 2
			ymod = -2
		elseif gg == 15 then
			xmod = -2
			ymod = -2
		end
    		local b,d,x,y,z,nx,ny,nz,he,e = self.ObjOwner:TraceToPoint(cx+sx+xmod,cy+sy+ymod,cz+sz)
                local monster = false
                lockobj = EntityToObject[e] -- LUA gameobject
		if lockobj and (lockobj._Class == "CActor" or lockobj._Class =="CPlayer") then 
			if Dist3D(x,y,z,cx,cy,cz) > s.LockingDistance then
					lockobj = nil
			else
				break
			end
			
		else
					lockobj = nil
		end
	   end
    -- create rocket object
   	  obj = GObjects:Add(TempObjName(),CloneTemplate("DarkEnergy.CItem"))        
    local x,y,z = ENTITY.PO_GetPawnHeadPos(player._Entity)                
    local fv = player.ForwardVector
    --y = y - 0.05
    local orientation = ENTITY.GetOrientation(player._Entity)
   
    local xmod=0
    local ymod=0
    local zmod=0
-- get change of direction
	if  chdir then
		player._koliks[side]=obj
		xmod = side * 0.1
		zmod = 0.9
	else
		if player._koliks[-1] then
			obj.lkolik=player._koliks[-1]
			player._koliks[-1]=nil
		end
		if player._koliks[1] then
			obj.rkolik=player._koliks[1]
			player._koliks[1]=nil
		end

	end
    local tv = Vector:New(ox,oy,oz)
    tv:Rotate(-math.atan(fv.Y),orientation,0)    
    obj.Pos:Set(x+fv.X*0.4+tv.X,y+fv.Y*0.4+tv.Y,z+fv.Z*0.4+tv.Z)
    obj.Rot:FromNormalZ(fv.X,fv.Y,fv.Z)         
	if lockobj then 
		obj.lockedobject = lockobj
		obj.lockedjoint = joint
	end
    obj._lastTraceStartPoint =  obj.Pos:Copy()
    obj.ObjOwner = player
    obj:Apply()
    obj.Damage = s.DarkEnergyDamage
 	    if player.HasQuad then            
	        obj.Damage = math.floor(obj.Damage * 4)
	    end
    obj.EnemyThrowBack = s.EnergyThrowBack
    obj.EnemyThrowUp   = s.EnergyThrowUp
    local speed = s.EnergySpeed
    if player.HasWeaponModifier then 
        speed = speed * 1.2 
        obj.Damage = obj.Damage * 1.5
    end
	if  chdir then
	   local rot = Quaternion:New_FromNormalZ(xmod,ymod,zmod) 
	   obj.Rot:FromNormalZ(xmod,ymod,zmod) 
	   sx,sy,sz = rot:TransformVector(fv.X,fv.Y,fv.Z)    
           ENTITY.SetVelocity(obj._Entity,sx*speed,sy*speed,sz*speed)
        else
	 ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)			   
	end
  
    ENTITY.PO_EnableGravity(obj._Entity,false)
    
--    MDL.SetMeshVisibility(self._Entity,"bones03_polySurfaceShape1869",false)
end

--============================================================================
function HellBlade:Fire() -- Stake
	if not self._swordaway then
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.Skulls > s.Ammolimit then                
	    local action={}
	if Game.GMode == GModes.SingleGame then
        action = {
            {"L:p:StickShot(1,p.ObjOwner,0,0,0,false,0,0)"},
            {"Wait:0.1"},
            {"L:p:StickShot(2,p.ObjOwner,-1,-0.12,0,true,-1,0)"},
            {"L:p:StickShot(4,p.ObjOwner,1,-0.12,0,true,1,0)"},           
        }
	else
	action = {
            {"L:p:StickShot(2,p.ObjOwner,-1,-0.12,0,true,-1,0)"},
            {"L:p:StickShot(4,p.ObjOwner,1,-0.12,0,true,1,0)"},           
        }
	end
        AddAction(action,self)
        self.FireSFX(self.ObjOwner._Entity)
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,1)
        self.ShotTimeOut = s.FireTimeout
    end

    PlayLogicSound("FIRE",PX,PY,PZ,12,24,Player)   
	end
end
--============================================================================
function HellBlade:AltFire() 
	if not self._swordaway and not self.ObjOwner._jammed and ( self.ObjOwner.Ammo.DarkEnergy > 10 or Game.NoAmmoLoss ) then       
		self._swordaway=true
        -- create rocket object
        local obj = GObjects:Add(TempObjName(),CloneTemplate("Flying_blade.CItem"))
        -- set position
        local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
        local fv = self.ObjOwner.ForwardVector       
        
        obj._lastTraceStartPoint =  Vector:New(x,y,z)
        obj.Pos:Set(x+fv.X*1.7,y+fv.Y*1.7,z+fv.Z*1.7)
        obj.ObjOwner = self.ObjOwner
        obj._OE = self.ObjOwner._Entity
        obj._spinning = true
        obj:Apply()
        ENTITY.PO_EnableGravity(obj._Entity,false)
--        MDL.SetAnim(obj._Entity,"opened",false,1,0)
        
        local s = self:GetSubClass()
        
        obj.Damage = s.PainHeadSpinningDamage
        if self.ObjOwner.HasQuad then            
            obj.Damage = math.floor(obj.Damage * 4)
        end

        obj.BackSpeed = s.PainHeadBackSpeed                
        obj.Range = s.PainHeadRange
        self.r_PainHead = obj
	self._weaponwalk = true
        
        local speed =  s.PainHeadSpinningSpeed 
	obj.speed = speed
	obj.sidespeed = s.Sidespeed
	obj.fv=Vector:New(fv.X,fv.Y,fv.Z)
        ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)
        ENTITY.PO_EnableGravity(obj._Entity,false)
        self.AltFireSFX(self.ObjOwner._Entity)
	else
	 if self.r_PainHead then
            self.r_PainHead._back = true                        
        	self.ShotTimeOut   =  10
        end
    end
end
--============================================================================
function HellBlade:OnTick(delta)
    if self._stakeTime > 0 then 
        self._stakeTime = self._stakeTime - delta         
    else
            self._stakeTime = 0
    end
	if self.r_PainHead and (not self.r_PainHead._Entity or self._changed)then
	        self.BackHeadSFX(self.ObjOwner.ClientID,self.ObjOwner._Entity)    
	end
	if  self.r_PainHead and self.r_PainHead._Entity then
		self.Drain(self.ObjOwner._Entity)
    end    
end


function HellBlade:Drain(pe)
    local player = EntityToObject[pe]  
    if player then
    local cw = player.Weapons[6]
		if cw._drain < 1 then
				cw._drain=30
        		if not Game.NoAmmoLoss then player.Ammo.DarkEnergy = player.Ammo.DarkEnergy - 1 end
		        if player.Ammo.DarkEnergy < 0 then
			player.Ammo.DarkEnergy = 0 
        		if cw.r_PainHead then cw.r_PainHead._back = true end
			end
			else
				cw._drain= cw._drain-1
		end
	end
end
Network:RegisterMethod("HellBlade.Drain", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
--============================================================================
function HellBlade:OnFinishAnim(anim)
    if anim == "throw" then
        self:SetAnim("control",true) 
    end
end

--============================================================================
-- NET EVENTS
--============================================================================
function HellBlade:FireSFX(pe)
    local player = EntityToObject[pe]   
    
    local t = Templates["HellBlade.CWeapon"]
    local s = t:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)
    
    if player and player._Class ~= "CPlayer" then MsgBox("Bad player object: "..player._Class) end

    -- update ammo on proper client and server
    if player then
	if Game.GMode == GModes.SingleGame then
        	if not Game.NoAmmoLoss then player.Ammo.Skulls = player.Ammo.Skulls - 3 end
	else
        	if not Game.NoAmmoLoss then player.Ammo.Skulls = player.Ammo.Skulls - 2 end
	end

        if player.Ammo.Skulls < 0 then player.Ammo.Skulls = 0 end
        -- set next shot timeout
        local cw = player:GetCurWeapon()
        cw.ShotTimeOut =  s.FireTimeout
        cw._ActionState = "Idle"
        cw:ForceAnim("attack1",false)                           
        cw._stakeTime = 1.1         
	
        local action = {            
	{"L:p:SndEnt('dark_swish',"..pe..")"},
            {"Wait:0.1"},
            {"L:p:SndEnt('dark_swish',"..pe..")"},
            {"Wait:0.1"},
            {"L:p:SndEnt('dark_swish',"..pe..")"},
            
        }
        AddAction(action,t)
	cw._fxflash = BindFX(cw._Entity,"HellBlade_red_flash",0.4,"RightHand",0,0.5,2)
    end

    QuadSound(pe)                
end
Network:RegisterMethod("HellBlade.FireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
-- potwierdzony poniewaz i tak doklei sie do komunikatu stworzenia nowego entity kolka
--============================================================================
function HellBlade:AltFireSFX(pe)
    local player = EntityToObject[pe]

    local t = Templates["HellBlade.CWeapon"]
    local s = t:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)
    
    -- update ammo on proper client and server
    if player then 
    player.State=61
        if not Game.NoAmmoLoss then player.Ammo.DarkEnergy = player.Ammo.DarkEnergy - 10 end
        if player.Ammo.DarkEnergy < 0 then player.Ammo.DarkEnergy = 0 end
        -- set next shot timeout
 		t:SndEnt("throw_swish",pe)        

        local cw = player:GetCurWeapon()
        cw.ShotTimeOut   =  s.AltFireTimeout
        cw._ActionState = "Idle" -- bo korzystamy z timeout'a        
        if player == Player then
            cw:ForceAnim("throw",false)               
	MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape1",false)
        end        
        cw._stakeTime = 0.4
	cw._drain = 30
    end
    QuadSound(pe)           
end
Network:RegisterMethod("HellBlade.AltFireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
--============================================================================
function HellBlade:OutOfAmmoFX(entity,fire)
    Templates["HellBlade.CWeapon"]:SndEnt("out_of_ammo",entity)
end
Network:RegisterMethod("HellBlade.OutOfAmmoFX", NCallOn.AllClients, NMode.Reliable, "eb") 
--============================================================================
--
function HellBlade:BackHeadSFX(pe)    
    local player = EntityToObject[pe] 
    local t = Templates["RazorCube.CWeapon"]
    if player then        
        local cw = player.Weapons[6]
        cw._ActionState = "End"
	MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape1",true)
        cw:ForceAnim("catch",false)
        cw.r_PainHead = nil
	Game:Print("BACKHEAD")
        cw._spinning = nil        
	cw._swordaway = false
	cw._weaponwalk = false
        cw._painHeadEntity = nil        
        player.State = 6
        cw._ActionState = "Idle"
    end
    t:SndEnt("head_reload",pe)
end
Network:RegisterMethod("HellBlade.BackHeadSFX", NCallOn.ServerAndAllClients, NMode.ReliableForSingle, "e") 
