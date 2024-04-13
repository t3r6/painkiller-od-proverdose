o._shotNr = 0
o._stakeTime = 0
o._fxMode = 1
--============================================================================
function Ectoplasmer:OnReleaseEntity()
    self:OnChangeWeapon()
    if self._sndLoop then
        SOUND2D.Delete(self._sndLoop)
    end
    if self._sndLoop2 then
        SOUND2D.Delete(self._sndLoop2)
    end
    self._sndLoop = nil
    self._sndLoop2 = nil
    --self._fireFX:Delete()
end
--============================================================================
function Ectoplasmer:OnCreateEntity(entity)
    self._sndLoop = SOUND2D.Create(self:GetSndInfo("flame_loop",true))
    self._sndLoop2 = SOUND2D.Create(self:GetSndInfo("servo_loop",true))
    self:ReloadTextures()
--    self._part1x=BindFX(self._Entity,"Ectoplasmer_UglyGreen",0.65,"ep_forcer_joint",0.55,0.15,0)
--    self._part2x=BindFX(self._Entity,"Ectoplasmer_UglyGreen",0.65,"ep_forcer_joint",0.35,0.18,0)
end
--============================================================================
function Ectoplasmer:OnPrecache()
    CloneTemplate("Ectoplasmer.CWeapon"):LoadHUDData()
	Cache:PrecacheParticleFX("Ectoplasmer_flame")
	Cache:PrecacheParticleFX("Ectoplasmer_plop")
	Cache:PrecacheParticleFX("RFT_flame")
    Cache:PrecacheParticleFX("Ectoplasmer_Warp")
    Cache:PrecacheParticleFX("RifleHitWall")
	Cache:PrecacheItem("Kamyk.CItem")
    Cache:PrecacheDecal("bullethole")
    Cache:PrecacheItem("GreenGoo.CItem")     
    Cache:PrecacheItem("Ectoplasm.CItem")     
    Cache:PrecacheSounds("impacts/barrel-wood-fire-loop")
end
--============================================================================
function Ectoplasmer:MuzzleFlashFX()
    -- protection for multiply lights simultaneously
    if not self._LightName or getfenv()[self._LightName] == nil then
        local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
        local fv = self.ObjOwner.ForwardVector
        local a = AddAction({{"Light:a[1],a[2],a[3],200,200,150, 5, 8 , 1, 0,0.05,0.05"}},nil,nil,x+fv.X*1.5,y+1.5,z+fv.Z*1.5)
        self._LightName = a._Name
        self:MuzzleFlash("ep_root_joint",0,0,0,0.5,"particles/rm",FRand(0,6.28))
    end        
end
--============================================================================
function Ectoplasmer:EnableFX(mode)
    if self._oldmode == mode then return end

    --ENTITY.Release(self._light)
--    ENTITY.Release(self._fxStart)
    PARTICLE.Die(self._fxEnd2)
    PARTICLE.Die(self._fxEnd)
    PARTICLE.Die(self._fxEnd3)
    PARTICLE.Die(self._part1x)
    PARTICLE.Die(self._part2x)
    self._part2x = nil
    self._part1x = nil
    self._fxEnd2 = nil
    self._fxEnd3 = nil
    self._fxEnd = nil

    if mode == 1 then -- normal
    self._part1x=BindFX(self._Entity,"Ectoplasmer_UglyGreen",0.35,"ep_forcer_joint",0.55,0.15,0)
    self._part2x=BindFX(self._Entity,"Ectoplasmer_UglyGreen",0.35,"ep_forcer_joint",0.35,0.18,0)

        ENTITY.EnableGunPass(self._fxStart,true)
    end

    if mode == 2 then -- attack
     self._light = CreateLight(0,0,0,255,255,255,2,5,1)
        local scale = 1
        if self.ObjOwner.HasWeaponModifier then scale = 1.25 end
        self._fxEnd = BindFX(self._Entity,"Ectoplasmer_flame",0.4*scale,"ep_forcer_joint",0.65,0.15,-0.5,nil,nil,nil,0,1.57,0)        
        self._fxEnd2 = BindFX(self._Entity,"Ectoplasmer_Warp",0.25*scale,"ep_root_joint",0,-4,1,nil,nil,nil,0,1.57,0)        
        self._fxEnd3 = BindFX(self._Entity,"Ectoplasmer_plop",1.5*scale,"ep_root_joint",0,0.1,1,nil,nil,nil,0,1.57,0)        
    end

    self._oldmode = mode
    self._fxMode = mode
end
--============================================================================
function Ectoplasmer:OnChangeWeapon()
    self._stakeTime = 0
    SOUND2D.Stop(self._sndLoop)
    SOUND2D.Stop(self._sndLoop2)
    self:EnableFX(0)
    --ENTITY.EnableDraw(self._fireFX._Entity,false)    
    self._fxMode = 1
end
--============================================================================
function Ectoplasmer:ReloadTextures()
	if not self._Entity then return end
    if Cfg.WeaponNormalMap == true then
        if Cfg.WeaponSpecular == false then
            MATERIAL.Replace("models/esl/esl_tex2pb","models/esl/esl_tex2pb_no_specular")
        else
            MATERIAL.Replace("models/esl/esl_tex2pb","models/esl/esl_tex2pb")
        end
    end
	MDL.EnableNormalMaps(self._Entity,Cfg.WeaponNormalMap)
end
--=============================================================================
function o:Sparks()
	BindFX(self._Entity,"ecto_sparks",0.5,"ep_forcer_joint",-0.5,-0.05,-0.1)
end

--============================================================================


--============================================================================
function Ectoplasmer:LoadHUDData()
	self._matAmmoIcon = MATERIAL.Create("HUD/Mw_hud/i_GreenGoo", TextureFlags.NoLOD)
	self._matAmmoElectroIcon = MATERIAL.Create("HUD/Mw_hud/i_Ectoplasm", TextureFlags.NoLOD)
end
--============================================================================
function Ectoplasmer:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)

    if not (INP.IsFireSwitched() or (not Game.SwitchFire[6] and Cfg.SwitchFire[6]) or (not Cfg.SwitchFire[6] and Game.SwitchFire[6])) then
		Hud:Quad(self._matAmmoElectroIcon,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*13)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoIcon,(1024-56*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.GreenGoo)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Ectoplasm)
	else
		Hud:Quad(self._matAmmoIcon,(1024-56*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*12)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matAmmoElectroIcon,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.Ectoplasm),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.Ectoplasm)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.GreenGoo),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.GreenGoo)
	end
end
--============================================================================
function Ectoplasmer:Fire()
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.Ectoplasm > 0 then

        -- create rocket object
        local obj = GObjects:Add(TempObjName(),CloneTemplate("Ectoplasm.CItem"))        
        local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)                
        local fv = self.ObjOwner.ForwardVector
        y = y - 0.2
        
        obj._lastTraceStartPoint =  Vector:New(x,y,z)
        obj.Pos:Set(x+fv.X*1,y+fv.Y*1,z+fv.Z*1)
        obj.Rot:FromNormalZ(fv.X,fv.Y,fv.Z)     
        obj.ObjOwner = self.ObjOwner
        obj:Apply()
        obj.Damage = s.BallDamage
        if self.ObjOwner.HasQuad then            
            obj.Damage = math.floor(obj.Damage * 4)
        end
        local speed = s.BallSpeed
        if self.ObjOwner.HasWeaponModifier then speed = speed * 1.6 end
        ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)
        ENTITY.PO_EnableGravity(obj._Entity,false)
        
        PlayLogicSound("FIRE",self.ObjOwner.Pos.X,self.ObjOwner.Pos.Y,self.ObjOwner.Pos.Z,12,24,self.ObjOwner)   
        BindFX(self._Entity,"Ectoplasmer_cloud", 1, "ep_forcer_joint",0.45,0.15,0)
	self:Sparks()
        self.StartFireFX(self.ObjOwner._Entity, self.ObjOwner.Ammo.Ectoplasm)
   	self.FireSFX(self.ObjOwner._Entity)
        return obj
    else    
        self.OutOfAmmoFX(self.ObjOwner._Entity,1)
        self.ShotTimeOut = s.FireTimeout * 5
        self._ActionState = "Idle"
        self._fire = false
    end
end
--============================================================================
function Ectoplasmer:OnFinishFire(oldstate)
    self.OnReloadFX(self.ObjOwner.ClientID,self.ObjOwner._Entity, self.ObjOwner.Ammo.Ectoplasm)
end
--============================================================================
function Ectoplasmer:StartFireFX(pe,ammo)
    local player = EntityToObject[pe]
    local t = Templates["Ectoplasmer.CWeapon"]
    local s = t:GetSubClass()

    if player then
        player.Ammo.Ectoplasm = ammo
        local cw = player:GetCurWeapon()
        cw._ShotInterval = s.FireTimeout
      cw._ActionState = "Fire"
    end
    QuadSound(pe)
end
Network:RegisterMethod("Ectoplasmer.StartFireFX", NCallOn.ServerAndAllClients, NMode.Reliable, "eu")
--============================================================================
--============================================================================
function Ectoplasmer:OnReloadFX(pe,ammo)
    local t = Templates["Ectoplasmer.CWeapon"]
    local s = t:GetSubClass()
    local player = EntityToObject[pe]    
    if player then
        player.Ammo.Ectoplasm = ammo
        local cw = player:GetCurWeapon()
        cw.ShotTimeOut = s.ReloadTimeout
        cw._ActionState = "Idle"
        cw._fire = false
        cw._shotNr = 0
        if player == Player then
        --    cw:SetAnim("attack2",false)            
        end
        --t:SndEnt("rifle_reload",pe)
    end
end
Network:RegisterMethod("Ectoplasmer.OnReloadFX", NCallOn.ServerAndSingleClient, NMode.Reliable, "eu")
--============================================================================
-- ALT FIRE -
--============================================================================
function Ectoplasmer:AltFire()

    if Game.GMode ~= GModes.SingleGame then 
        self._ActionState = "Idle"
        self._altfire = false
        return 
    end

    if self.ObjOwner.Ammo.GreenGoo > 0 then
        self.StartAltFireFX(self.ObjOwner._Entity, self.ObjOwner.Ammo.GreenGoo)
    else
        local s = self:GetSubClass()
        self.OutOfAmmoFX(self.ObjOwner._Entity,2)
        self.ShotTimeOut = s.AltFireTimeout * 4
        self._ShotInterval = 0
        -- to jakos inaczej rozwiazac, zeby outofammo od razu ustawialo idle'a
        self._ActionState = "Idle"
        self._altfire = false
    end
end
--============================================================================
function Ectoplasmer:OnFinishAltFire()
    self.FinishAltFireFX(self.ObjOwner.ClientID, self.ObjOwner._Entity,self.ObjOwner.Ammo.GreenGoo)
end
--============================================================================
function Ectoplasmer:StartAltFireFX(pe,ammo)
    local player = EntityToObject[pe]
    local t = Templates["Ectoplasmer.CWeapon"]
    local s = t:GetSubClass()

    if player then
        local cw = player:GetCurWeapon()
        cw._lastLockedEntity = nil
        cw._lockedEntity = nil
        local x,y,z = ENTITY.PO_GetPawnHeadPos(player._Entity)
        local fv = player.ForwardVector
        player.Ammo.GreenGoo = ammo
        cw.ShotTimeOut = s.AltFireTimeout

        if player == Player then
            SOUND2D.SetLoopCount(cw._sndLoop,0)
            SOUND2D.Play(cw._sndLoop)
            SOUND2D.SetLoopCount(cw._sndLoop2,0)
            SOUND2D.Play(cw._sndLoop2)
            cw:ForceAnim("attack2_start",false)
            cw._ActionState = "AltFire"            
        cw:EnableFX(2)
        end
    end
    QuadSound(pe)
    t:SndEnt("flame_start",pe)
end
Network:RegisterMethod("Ectoplasmer.StartAltFireFX", NCallOn.ServerAndAllClients, NMode.Reliable, "eu")
--============================================================================
function Ectoplasmer:FinishAltFireFX(pe,ammo)
    local player = EntityToObject[pe]
    if not player then return end

    player.Ammo.GreenGoo = ammo
    local cw = player:GetCurWeapon()
    cw._lockedEntity = nil
    cw._ActionState = "FinishFire"
    cw._altfire = false
    if player == Player then
        cw:EnableFX(1)
        cw:SetAnim("attack2_stop",false)
        cw:Snd2D("flame_stop",pe)
        SOUND2D.Stop(cw._sndLoop)
        SOUND2D.Stop(cw._sndLoop2)
    end
end
Network:RegisterMethod("Ectoplasmer.FinishAltFireFX", NCallOn.ServerAndSingleClient, NMode.Reliable, "eu")
Ectoplasmer.time = 0

--============================================================================
function Ectoplasmer:OnFinishAnim(anim)
	if anim == "attack2_stop" then
		    self._ActionState = "Idle"
	end
	if anim == "attack2_start" then
		    self:SetAnim("attack2_prostredek",true)
	end
end

--============================================================================
function Ectoplasmer:OnTick(delta)
    if self._stakeTime > 0 then 
        self._stakeTime = self._stakeTime - delta         
    else
        if self._stakeTime < 0 then
            self._stakeTime = 0
        end
    end
    if self.ObjOwner ~= Player then return end
end
--============================================================================
function Ectoplasmer:OnUpdate() -- COMMON: CLIENT & SERVER
    local s = Templates["Ectoplasmer.CWeapon"]:GetSubClass()
    self.ObjOwner.State = 7    
        
    if self._ActionState == "Fire" then
        if self.ObjOwner.Ammo.Ectoplasm > 0 then            
            self._ShotInterval = self._ShotInterval - 1
            if self._ShotInterval <= 0 then
                PlayLogicSound("FIRE",self.ObjOwner.Pos.X,self.ObjOwner.Pos.Y,self.ObjOwner.Pos.Z,12,26,self.ObjOwner)            
--                self:FireSFX(self.ObjOwner._Entity)
                if Game.GMode ~= GModes.MultiplayerClient then
                  --  self:HitTest()            
                    self._shotNr = self._shotNr + 1
                    if self._shotNr >= s.RifleBurst then
                        if self.ObjOwner.HasWeaponModifier then
                            self._shotNr = 0
                        else
                            self.OnReloadFX(self.ObjOwner.ClientID,self.ObjOwner._Entity,self.ObjOwner.Ammo.Ectoplasm)
                        end
                    end
                    if self.ObjOwner.Ammo.Ectoplasm <= 0 then
                        self.OnReloadFX(self.ObjOwner.ClientID,self.ObjOwner._Entity,self.ObjOwner.Ammo.Ectoplasm)
                    end
                end
            end
        end
                
        self.ObjOwner.State = 71
        return
    end

    if self._ActionState == "AltFire" and self.ObjOwner.Ammo.GreenGoo > 0 then
            if not Game.NoAmmoLoss then self.ObjOwner.Ammo.GreenGoo = self.ObjOwner.Ammo.GreenGoo - 1 end
            self._ShotInterval = s.AltFireTimeout
                if self.ObjOwner.Ammo.GreenGoo <= 0 then
                    self.ObjOwner.Ammo.GreenGoo = 0
                    self:OnFinishAltFire()
                else
			if self.Animation ~= "attack2_start" then
		          	self:SetAnim("attack2_prostredek",true)
			end
                    self:FlameThrowerTest()
                end
    else
        self:EnableFX(1)
    end
end

--============================================================================
function Ectoplasmer:FlameThrowerSP()
    
    local fv = self.ObjOwner.ForwardVector
    local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
    
    for i = 1, 1 do
        local ke = AddItem("FlamePart.CItem",1,Vector:New(cx+fv.X*0.7,cy-0.1+fv.Y*0.7,cz+fv.Z*1.2),true)
        local mx = 1 --FRand(0.9,1.1)
        local mz = 1 --FRand(0.9,1.1)
        ENTITY.SetVelocity(ke,fv.X*125,fv.Y*125,fv.Z*125)
    end
end
--============================================================================
function Ectoplasmer:FlameThrowerTest()
	local SlowMod = 0.33
    local s = Templates["Ectoplasmer.CWeapon"]:GetSubClass()
    -- havok's trace from player

    local fv = self.ObjOwner.ForwardVector
    local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
    local rot = Quaternion:New_FromNormalZ(fv.X,fv.Y,fv.Z) 
    local b,d,tx,ty,tz,nx,ny,nz,he,e
    local scale = 1
    if self.ObjOwner.HasWeaponModifier then scale = 1.25 end
    for i,o in s.FlameRangePoints do
        local sx,sy,sz = rot:TransformVector(o[1]*scale,o[2]*scale,o[3]*scale)
        b,d,tx,ty,tz,nx,ny,nz,he,e = self.ObjOwner:TraceToPoint(cx+sx,cy+sy,cz+sz)
        if b then break end
    end
    if b and e then
        local damage = s.FlameDamage        
        local obj = EntityToObject[e] -- LUA gameobject
        if obj then
            if obj.OnDamage then obj:OnDamage(damage,self.ObjOwner,AttackTypes.Lava,tx,ty,tz,nx,ny,nz,he) end
	 if obj._Class == "CActor"  and not obj.IsBoss then    
                obj:SlowObject(obj,SlowMod)
		local tdj = obj.s_SubClass.DeathJoints
		if tdj then
			for i=1,table.getn(tdj) do
--                	obj:BindFX("Ectoplasmer_acidsmoke", 0.3, tdj[i])
			end
		else
 --      	    obj:BindFX("Ectoplasmer_acidsmoke", 0.2, "root")
        	end
          end
	end
    end
end
--============================================================================
function Ectoplasmer:HitTest()
    local s = Templates["Ectoplasmer.CWeapon"]:GetSubClass()
    -- havok's trace from player
    local b,d,x,y,z,nx,ny,nz,he,e = self.ObjOwner:Trace(s.RifleRange)
    if b and e then
        local fv = self.ObjOwner.ForwardVector
        if Game.GMode == GModes.SingleGame and ENTITY.IsWater(e) then
            Templates["MiniGunRL.CWeapon"]:HitWaterSFX(x,y,z,nx,ny,nz,fv.X,fv.Y,fv.Z,e)
        else
            local damage = s.RifleDamage
            if self.ObjOwner.HasWeaponModifier then
                damage = math.floor(damage * 1.5)
            end
            if self.ObjOwner.HasQuad then            
                damage = math.floor(damage * 4)
            end
            local obj = EntityToObject[e] -- LUA gameobject
            if obj and damage > 0 and obj.OnDamage then
                obj:OnDamage(damage,self.ObjOwner,AttackTypes.Rifle,x,y,z,nx,ny,nz,he)
            end
    
            if obj and (obj._Class == "CActor" or obj._Class == "CPlayer" )then
                local ib =  s.EnemyThrowBack
                local iu =  s.EnemyThrowUp
                if self.ObjOwner.HasWeaponModifier then
                    ib = ib * 1.5
                end
                -- hit spherical body
                if (not obj.NeverMove and not obj._disableHits) or obj.Health <= damage then
                    ENTITY.PO_Hit(e,x,y,z,fv.X*ib,fv.Y*ib+iu,fv.Z*ib)
                end
                -- hit ragdoll body
                WORLD.HitPhysicObject(he,x,y,z,fv.X*150,fv.Y*150,fv.Z*150)
                if not CanBurning(obj) then 
                    self:HitWallSFX(e,x,y,z,nx,ny,nz)
                end
            else
                -- hit havok body
                WORLD.HitPhysicObject(he,x,y,z,fv.X*150,fv.Y*150,fv.Z*150)
                if Game.GMode == GModes.SingleGame then
                    self:HitWallSFX(e,x,y,z,nx,ny,nz)
                end
            end
            CheckStartGlass(he,x,y,z,0.1,fv.X*50,fv.Y*50,fv.Z*50)
        end
        PlayLogicSound("freezer_shot",x,y,z,8,16,nil)
    end
end
--============================================================================
function Ectoplasmer:HitWallSFX(entity,x,y,z,nx,ny,nz)

    local t = Templates["Ectoplasmer.CWeapon"]

    if entity then ENTITY.SpawnDecal(entity,'bullethole',x,y,z,nx,ny,nz) end
    -- launch sparks and decals
    local r = Quaternion:New(1,0,0,0)
    local ay = math.atan2(nx,-nz) + 1.57
    r:FromEuler(0,ay,-1.57 + ny*1.57)    
	AddPFX("RifleHitWall",0.2,Vector:New(x,y,z),r)    
    if nx>=ny and nx>=nz then nx=nx+0.5; ny=ny+0.5*math.random(-1,1); nz=nz+0.5*math.random(-1,1) end
    if ny>=nx and ny>=nz then ny=ny+0.5; nx=nx+0.5*math.random(-1,1); nz=nz+0.5*math.random(-1,1) end
    if nz>=nx and nz>=ny then nz=nz+0.5; nx=nx+0.5*math.random(-1,1); ny=ny+0.5*math.random(-1,1) end
    local n = math.random(1,1)
    for i = 1, n do
        local sizes = {0.3,0.5,0.8}
        local ke = AddItem("Kamyk.CItem",sizes[math.random(1,3)],Vector:New(x+FRand(-0.2,0.2),y+FRand(-0.2,0.2),z+FRand(-0.2,0.2)))
        local vx = nx*FRand(10,15)
        local vy = ny*FRand(10,15)
        local vz = nz*FRand(10,15)
        ENTITY.SetVelocity(ke,vx,vy,vz)
        ENTITY.SetTimeToDie(ke,FRand(1,2))
    end
    
    local obj = EntityToObject[entity]
    if obj and obj.s_SubClass and obj.s_SubClass.SoundsDefinitions and obj.s_SubClass.SoundsDefinitions.SoundHitByBullet and math.random(100) < 50 then
        obj:PlaySound("SoundHitByBullet",nil,nil,nil,nil,tx,ty,tz)
    else
        if math.random(100) < 50 then  t:Snd3D("bullet_hit_wall",x,y,z) end
    end

end
--============================================================================
-- NET EVENTS
--============================================================================
--============================================================================
-- COMMON: CLIENT & SERVER
function Ectoplasmer:FireSFX(pe)
    local player = EntityToObject[pe]

    local t = Templates["Ectoplasmer.CWeapon"]
    local s = t:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)
Game:Print("POS")
    -- update ammo on proper client and server
    if player then
Game:Print("PLAy")
        if not Game.NoAmmoLoss then player.Ammo.Ectoplasm = player.Ammo.Ectoplasm - 1 end
        if player.Ammo.Ectoplasm < 0 then player.Ammo.Ectoplasm = 0 end        
Game:Print("AMMO")
        local cw = player:GetCurWeapon()
--        cw._ShotInterval = cw.FireTimeout        
Game:Print("ANIM")
            cw:ForceAnim("attack1",false)            
Game:Print("MUZZLE")
            cw:MuzzleFlashFX()
            Game._EarthQuakeProc:Add(x,y,z, 2, 4, 0.1, 0.1, false)
    end

    t:SndEnt("rifle_shot",pe)
    t:SndEnt("rifle_shot2",pe)
    t:SndEnt("rifle_shell",pe)
end
Network:RegisterMethod("Ectoplasmer.FireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e")
--============================================================================
function Ectoplasmer:OutOfAmmoFX(entity,fire)
    Templates["Ectoplasmer.CWeapon"]:SndEnt("out_of_ammo",entity)
end
Network:RegisterMethod("Ectoplasmer.OutOfAmmoFX", NCallOn.AllClients, NMode.Reliable, "eb")
--============================================================================
function Ectoplasmer:Render(delta)

    if Player ~= self.ObjOwner then return end
    if Game.TPP then return end

    if not (self._ActionState == "AltFire" and self.ObjOwner.Ammo.GreenGoo > 0) then
        return
    end

    self:EnableFX(2)
end
--============================================================================
function Ectoplasmer:ClientTick(delta)
    if self._fxMode == 1 then
        --ENTITY.EnableDraw(self._fireFX._Entity,false)
    else
        --ENTITY.EnableDraw(self._fireFX._Entity,false) -- aby widziec efekt to trzeba zakomentowac
        --ENTITY.EnableDraw(self._fireFX._Entity,true)  -- a to odkomentowac
    end
end
