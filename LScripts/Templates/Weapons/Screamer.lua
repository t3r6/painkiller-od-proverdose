o.TipPoint = Vector:New(0,0,0)
o._ShotInterval = 0
--============================================================================
function Screamer:OnReleaseEntity()
	PARTICLE.Die(self._fxblood)
	PARTICLE.Die(self._fxsaliva)
	
   if self._sndLoop then
   	SOUND2D.Delete(self._sndLoop)
	end 
   if self._electroLoop then
   	SOUND2D.Delete(self._electroLoop)
	end 
   if self._laserfinishSnd then
   	SOUND2D.Delete(self._laserfinishSnd)
	end 

end
--============================================================================
function Screamer:OnCreateEntity()
--	self._fxblood = BindFX(self._Entity,"Screamer_blood_leak",0.15,"bk_bone1",-0.07,0.07,0.3)  -- levoprava/hornodolni/predozadni
	self._fxsaliva = BindFX(self._Entity,"Screamer_green_saliva",0.5,"tongue_tip",-0.1,0.02,0)

   self._sndLoop = SOUND2D.Create(self:GetSndInfo("laser_loop",true),false,true)
   self._electroLoop = SOUND2D.Create(self:GetSndInfo("laser_electro_loop",true),false,true)
	self._laserfinishSnd = SOUND2D.Create(self:GetSndInfo("laser_end",true),false,true)


	self:ReloadTextures()
end
--============================================================================
function o:OnChangeWeapon()
	self.ObjOwner.State = 5
	SOUND2D.Stop(self._sndLoop)
	SOUND2D.Stop(self._electroLoop)
end

--============================================================================
function Screamer:OnPrecache()
    CloneTemplate("Screamer.CWeapon"):LoadHUDData()
	Cache:PrecacheParticleFX("SG_fx")
	Cache:PrecacheParticleFX("FX_shotgunmp")    
	Cache:PrecacheParticleFX("shotgunHitWater") 
	Cache:PrecacheParticleFX("Screamer_blood_leak") 
	Cache:PrecacheParticleFX("shotgunHitWall") 
	Cache:PrecacheItem("sgKamyk.CItem")     
    Cache:PrecacheItem("BrokenSoul.CItem")    
	MATERIAL.Create("particles/trailscreamer")
    
--    Cache:PrecacheDecal("splash")        
    Cache:PrecacheDecal("bullethole")            
end
--============================================================================
function Screamer:ReloadTextures()
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
function Screamer:LoadHUDData()
	self._matAmmoIcon = MATERIAL.Create("HUD/Mw_hud/i_Brain_worms", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
	self._matFreezerIcon = MATERIAL.Create("HUD/Mw_hud/i_broken_souls", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--============================================================================
function Screamer:MuzzleFlashFX()
    -- protection for multiply lights simultaneously
    if not self._LightName or getfenv()[self._LightName] == nil then
        local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
        local fv = self.ObjOwner.ForwardVector
        local a = AddAction({{"Light:a[1],a[2],a[3],200,200,150, 5, 8 , 1, 0,0.1,0.05"}},nil,nil,x+fv.X*2.5,y+1,z+fv.Z*2.5)
        self._LightName = a._Name
        self:MuzzleFlash("joint2",-4,-1.3,-1.4)
        self:MuzzleFlash("joint2",-4,-1.3,-2.0)
        --self:MuzzleFlash("joint2",-5.5,-1.9,-1.4)
        --self:MuzzleFlash("joint2",-5.5,-1.9,-2.0)
    end    
end
--============================================================================
function Screamer:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
    
    if not (INP.IsFireSwitched() or (not Game.SwitchFire[2] and Cfg.SwitchFire[2]) or (not Cfg.SwitchFire[2] and Game.SwitchFire[2])) then
		Hud:Quad(self._matAmmoIcon,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matFreezerIcon,(1024-55*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*46)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.BrainWorms)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.BrokenSouls)
	else
		Hud:Quad(self._matAmmoIcon,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*47)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:Quad(self._matFreezerIcon,(1024-55*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*12)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrokenSouls),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.BrokenSouls)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%03d",Player.Ammo.BrainWorms),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.BrainWorms)
    end
end
--============================================================================
-- FIRE - BULLET (Server Side)
--============================================================================
function Screamer:Fire()
    local s = self:GetSubClass()
    if self.ObjOwner.Ammo.BrainWorms > 0 then           
    --    PlayLogicSound("FIRE",self.ObjOwner.Pos.X,self.ObjOwner.Pos.Y,self.ObjOwner.Pos.Z,15,35,self.ObjOwner)               
        
	self.StartFireFX(self.ObjOwner.ClientID, self.ObjOwner._Entity, self.ObjOwner.Ammo.BrainWorms)
           
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,1)
        self.ShotTimeOut = s.FireTimeout
    end
end

--============================================================================
function Screamer:StartFireFX(pe,ammo)
    local player = EntityToObject[pe]
    if not player then return end

    local w = player:GetCurWeapon()
        if not Game.NoAmmoLoss then player.Ammo.BrainWorms = player.Ammo.BrainWorms - 1 end
        w.ShotTimeOut =  0 --s.FireTimeout
        w:ForceAnim("attack1",true)
    w:SndEnt("laser_start",pe)
    w:SndEnt("laser_start_voice",pe)
    QuadSound(pe)
	 player.State = 51
    if player == Player then
          SOUND2D.SetLoopCount(w._sndLoop,0)
          SOUND2D.Play(w._sndLoop)
          SOUND2D.SetLoopCount(w._electroLoop,0)
          SOUND2D.Play(w._electroLoop)
        w._ActionState = "Fire"
    end
end
Network:RegisterMethod("Screamer.StartFireFX", NCallOn.ServerAndSingleClient, NMode.Reliable, "eu")



--============================================================================
function Screamer:OnFinishFire()
--    self.FinishAltFireFX(self.ObjOwner._Entity,self.ObjOwner.Ammo.BrainWorms)
    SOUND2D.Stop(self._sndLoop)
    SOUND2D.Stop(self._electroLoop)
    SOUND2D.Play(self._laserfinishSnd)
self.ObjOwner.State = 5
end

function Screamer:FinishAltFireFX(entity, ammo)
local player = EntityToObject[entity]
if not player then return end
Game:Print("UA="..ammo)
if ammo < 1 then
	Game:Print("UB")
    local w = player:GetCurWeapon()
    w:ForceAnim("idle",true)
end
end
Network:RegisterMethod("Screamer.FinishAltFireFX", NCallOn.ServerAndSingleClient, NMode.Reliable, "eu")
--============================================================================
function Screamer:OnFinishAnim(anim)
    --if anim == "iceshot" then
    --    self._NoWaitForIdle = true
    --end
end
--============================================================================
function Screamer:Render()
    if WORLD.IsGamePaused() or Player ~= self.ObjOwner then return end

    local disableFX = false
    local s = self:GetSubClass()
    local fv = self.ObjOwner.ForwardVector

      if self._ActionState == "Fire" and self.ObjOwner.Ammo.BrainWorms > 0 then
        local j = MDL.GetJointIndex(self._Entity, "head_bone") 
        local px,py,pz = MDL.TransformPointByJoint(self._Entity,j,self.lefteye.X,self.lefteye.Y,self.lefteye.Z)--,0,0,0) 
        local pzx,pzy,pzz = MDL.TransformPointByJoint(self._Entity,j,self.righteye.X,self.righteye.Y,self.righteye.Z)--,0,0,0) 
--MODIFIED=#############################################################################################      
		if not Cfg.PROD_ThinShaft then
			R3D.DrawSprite1DOF(px,py,pz,fv.X*20000,fv.Y*20000,fv.Z*20000,0.1,R3D.RGB(255,255,255),"particles/trailscreamer") 
            R3D.DrawSprite1DOF(pzx,pzy,pzz,fv.X*20000,fv.Y*20000,fv.Z*20000,0.1,R3D.RGB(255,255,255),"particles/trailscreamer") 
		else
			--R3D.DrawSprite1DOF(px,py,pz,fv.X*20000,fv.Y*20000,fv.Z*20000,0.1,R3D.RGB(255,255,255),"particles/trailscreamer") 
            --R3D.DrawSprite1DOF(pzx,pzy,pzz,fv.X*20000,fv.Y*20000,fv.Z*20000,0.1,R3D.RGB(255,255,255),"particles/trailscreamer") 
		end

	  local points={}
	  points[1] = Vector:New(px,py,pz)
	  points[2] = Vector:New(fv.X*20000,fv.Y*20000,fv.Z*20000)
	  local t = Templates["DriverElectro.CWeapon"]
	  if not Cfg.PROD_ThinShaft then
		FRandxxx = FRand(0.1, 0.4)
		colorxxx = {240, 44, 40}
	  else
		FRandxxx = FRand(0.0, 0.05)
		colorxxx = {255, 255, 255}
	  end
	  t:DrawBezierLine(points,15,11, FRandxxx, R3D.RGB(colorxxx[1],colorxxx[2],colorxxx[3]))
	  t:DrawBezierLine(points,15,12, FRandxxx, R3D.RGB(colorxxx[1],colorxxx[2],colorxxx[3]))
	  local points2={}
	  points2[1] = Vector:New(pzx,pzy,pzz)
	  points2[2] = Vector:New(fv.X*20000,fv.Y*20000,fv.Z*20000)
	  t:DrawBezierLine(points2,15,11, FRandxxx, R3D.RGB(colorxxx[1],colorxxx[2],colorxxx[3]))
	  t:DrawBezierLine(points2,15,12, FRandxxx, R3D.RGB(colorxxx[1],colorxxx[2],colorxxx[3]))
--MODIFIED=end#############################################################################################  
	local fv = self.ObjOwner.ForwardVector
        ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
     	local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(px,py,pz,fv.X*20000,fv.Y*20000,fv.Z*20000)
     	local b1,d1,tx1,ty1,tz1,nx1,ny1,nz1,he1,e1 = WORLD.LineTrace(pzx,pzy,pzz,fv.X*20000,fv.Y*20000,fv.Z*20000)
        ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
	local ertt = Templates["Screamer.CWeapon"]
	if b and e then
			if not SOUND2D.IsPlaying(self._sndGeoFry) then
             			SOUND2D.SetLoopCount(self._sndGeoFry,0)
	              	 	 SOUND2D.Play(self._sndGeoFry)
		       	end
	 	if ENTITY.IsWater(e) then
	        if math.random(1,5) == 1 then             
	            	ENTITY.SpawnDecal(e,'splash',tx,ty,tz,nx,ny,nz)
		        AddPFX("shotgunHitWater",0.3,Vector:New(tx,ty,tz),Quaternion:New_FromNormal(nx,ny,nz))        
		        ertt:Snd3D("screamer_hitwall",tx,ty,tz)
		        end
		else
	     	ENTITY.SpawnDecal(e,'electro',tx,ty,tz,nx,ny,nz)
	      	local r = Quaternion:New_FromNormal(nx,ny,nz)
	       	AddPFX("Screamer_beam_hit",0.42,Vector:New(tx,ty,tz),r)
		end
	end
	if b1 and e1 then
			if not SOUND2D.IsPlaying(self._sndGeoFry) then
             			SOUND2D.SetLoopCount(self._sndGeoFry,0)
	              	 	 SOUND2D.Play(self._sndGeoFry)
		       	end
	 	if ENTITY.IsWater(e1) then
	        if math.random(1,5) == 1 then             
	            	ENTITY.SpawnDecal(e1,'splash',tx1,ty1,tz1,nx1,ny1,nz1)
		        AddPFX("shotgunHitWater",0.3,Vector:New(nx1,ny1,nz1),Quaternion:New_FromNormal(nx1,ny1,nz1))        
		        ertt:Snd3D("screamer_hitwall",tx1,ty1,tz1)
		        end
		else
		     	ENTITY.SpawnDecal(e1,'electro',tx1,ty1,tz1,nx1,ny1,nz1)
		      	local r = Quaternion:New_FromNormal(nx1,ny1,nz1)
		       	AddPFX("Screamer_beam_hit",0.42,Vector:New(tx1,ty1,tz1),r)
		end
	end

    else
        disableFX = true
    end
end

--============================================================================
function Screamer:OnUpdate()    
   local s = Templates["Screamer.CWeapon"]:GetSubClass()
   if self._ActionState == "Fire" and self.ObjOwner.Ammo.BrainWorms > 0 then
	 self._ShotInterval = self._ShotInterval - 1
	if self._ShotInterval <= 0  then
            if not Game.NoAmmoLoss and math.random(100) < 60 then self.ObjOwner.Ammo.BrainWorms = self.ObjOwner.Ammo.BrainWorms - 1 end
            self._ShotInterval = s.FireTimeout

            if Game.GMode ~= GModes.MultiplayerClient then
                if self.ObjOwner.Ammo.BrainWorms <= 0 then
                    self.ObjOwner.Ammo.BrainWorms = 0
		 self._ActionState = "Idle"
		self:OnFinishFire()
	 	end
            end
	end
	  

        if Game.GMode ~= GModes.MultiplayerClient then
		local fv = self.ObjOwner.ForwardVector
		local fx,fy,fz =fv.X,fv.Y,fv.Z
    		if Game.GMode == GModes.SingleGame then 
			local j = MDL.GetJointIndex(self._Entity, "head_bone") 
			local px,py,pz = MDL.TransformPointByJoint(self._Entity,j,self.lefteye.X,self.lefteye.Y,self.lefteye.Z)--,0,0,0) 
		        local pzx,pzy,pzz = MDL.TransformPointByJoint(self._Entity,j,self.righteye.X,self.righteye.Y,self.righteye.Z)--,0,0,0) 
	        	ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
		        local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(pzx,pzy,pzz,fx*20000,fy*20000,fz*20000)
		        local b1,d1,tx1,ty1,tz1,nx1,ny1,nz1,he1,e1 = WORLD.LineTrace(px,py,pz,fx*20000,fy*20000,fz*20000)
	                ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
			if b and e then
		                	local obj = EntityToObject[e]             
		                	if obj then          
		                        	if math.random(100) < 50 then                            
			                            local damage = s.BeamDamage
			                            if self.ObjOwner.HasQuad then            
			                                damage = math.floor(damage * 4)
			                            end
			                            if obj.OnDamage then 
							    obj:OnDamage(damage,self.ObjOwner,AttackTypes.Painkiller,tx,ty,tz,nx,ny,nz, he)
						    end
			                        end
					end
			end
			if b1 and e1 then
		                	local obj = EntityToObject[e1]             
		                	if obj then          
		                        	if math.random(100) < 50 then                            
			                            local damage = s.BeamDamage
			                            if self.ObjOwner.HasQuad then            
			                                damage = math.floor(damage * 4)
			                            end
			                            if obj.OnDamage then 
							    obj:OnDamage(damage,self.ObjOwner,AttackTypes.Painkiller,tx1,ty1,tz1,nx1,ny1,nz1, he1)
						    end
			                        end
					end
			end

		else
			local cx,cy,cz = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)
		        ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
		     	local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(cx,cy,cz,fx*20000,fy*20000,fz*20000)
		        ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
			if b then                       
				if e then
		                	ENTITY.SpawnDecal(e,'electro',tx,ty,tz,nx,ny,nz)
		                	local r = Quaternion:New_FromNormal(nx,ny,nz)
		                	AddPFX("Screamer_beam_hit",0.42,Vector:New(tx,ty,tz),r)
	                    		local obj = EntityToObject[e]             
		      		        if obj then          
		                	        if math.random(100) < 50 then                            
			                            local damage = s.BeamDamage
			                            if self.ObjOwner.HasQuad then            
		                              	       damage = math.floor(damage * 4)
			                            end
			                            if obj.OnDamage then 
							    obj:OnDamage(damage,self.ObjOwner,AttackTypes.Painkiller,tx,ty,tz,nx,ny,nz, he)
						    end
		                        	end
				    	end
				end
			end
			
		end
       end
end

end


--============================================================================
-- ALT FIRE
--============================================================================
function Screamer:AltFire() 
   local s = self:GetSubClass()
    if self.ObjOwner.Ammo.BrokenSouls > 0  then       

	local v=2*math.pi
	local c = v / (s.ScreamDiv)
	local i,st=0,0
	while i < v do 
		local range,step = 1,s.StepScream
		local dist = 1/step
		while dist < range do
			
	    	local obj = GObjects:Add(TempObjName(),CloneTemplate("BrokenSoul.CItem"))        
		local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)                
		local fv = self.ObjOwner.ForwardVector
		    --y = y - 0.05
		    local orientation = ENTITY.GetOrientation(self.ObjOwner._Entity)

		--krouzek
		    local xmod = math.cos(i+dist)*dist
		    local ymod= math.sin(i+dist)*dist
		    if dist == 4/step then
			if st==0 or st ==3 or st ==6 or st ==8  then
				obj.Central = true	
			end
		    end
		    local tv = Vector:New(xmod,ymod,0)
		    tv:Rotate(-math.atan(fv.Y),orientation,0)    
		    obj.Pos:Set(x+fv.X*0.4+tv.X,y+fv.Y*0.4+tv.Y,z+fv.Z*0.4+tv.Z)
    
		    obj._lastTraceStartPoint =  obj.Pos:Copy()
		    obj.ObjOwner = self.ObjOwner
		    obj:Apply()
		    obj.Damage = s.ScreamDamage
		    if self.ObjOwner.HasQuad then            
		        obj.Damage = math.floor(obj.Damage * 4)
		    end
		    obj.EnemyThrowBack = s.ScreamEnemyThrowBack
		    obj.EnemyThrowUp   = s.ScreamEnemyThrowUp

		    local speed = s.ScreamSpeed
		    if self.ObjOwner.HasWeaponModifier then 
		        speed = speed * 1.2 
		        obj.Damage = obj.Damage * 1.5
		    end
	        ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)
  		ENTITY.PO_EnableGravity(obj._Entity,false)
		--MDL.SetMeshVisibility(self._Entity,"bones03_polySurfaceShape1869",false)
		dist = dist + 1/step
		end
		st = st + 1
		i = i + c
	  end
	--central projectile
	local obj = GObjects:Add(TempObjName(),CloneTemplate("BrokenSoul.CItem"))        
	local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)                
	local fv = self.ObjOwner.ForwardVector
	local orientation = ENTITY.GetOrientation(self.ObjOwner._Entity)
	obj.Pos:Set(x+fv.X*0.4,y+fv.Y*0.4,z+fv.Z*0.4)
	obj.Central = 1
	obj._lastTraceStartPoint =  obj.Pos:Copy()
	obj.ObjOwner = self.ObjOwner
	obj:Apply()
	obj.Damage = s.ScreamDamage
	if self.ObjOwner.HasQuad then            
	        obj.Damage = math.floor(obj.Damage * 4)
	end
	obj.EnemyThrowBack = s.ScreamEnemyThrowBack
	obj.EnemyThrowUp   = s.ScreamEnemyThrowUp
	local speed = s.ScreamSpeed
	if self.ObjOwner.HasWeaponModifier then 
	       speed = speed * 1.2 
	        obj.Damage = obj.Damage * 1.5
	end
	ENTITY.SetVelocity(obj._Entity,fv.X*speed,fv.Y*speed,fv.Z*speed)
  	ENTITY.PO_EnableGravity(obj._Entity,false)
	MDL.SetMeshVisibility(self._Entity,"bones03_polySurfaceShape1869",false)
	
	-- launch SpecialFX on all clients
     self.AltFireSFX(self.ObjOwner._Entity)
    else
        self.OutOfAmmoFX(self.ObjOwner._Entity,2)
        self.ShotTimeOut = s.AltFireTimeout
    end

end
--============================================================================
function Screamer:MuzzleFlashFX()
end
--============================================================================
-- NET EVENTS
--============================================================================

function Screamer:AltFireSFX(pe)
    local player = EntityToObject[pe]    
    local t = Templates["Screamer.CWeapon"]
    local s = Templates["Screamer.CWeapon"]:GetSubClass()
    local x,y,z = ENTITY.GetPosition(pe)

    -- update ammo on proper client and server
    if player then
        if not Game.NoAmmoLoss then player.Ammo.BrokenSouls = player.Ammo.BrokenSouls - 5 end
        if player.Ammo.BrokenSouls < 0 then player.Ammo.BrokenSouls = 0 end
        -- set next shot timeout
        local cw = player:GetCurWeapon()
        cw.ShotTimeOut =  s.AltFireTimeout
        cw._ActionState = "Idle"
        cw:ForceAnim("attack2",false)
	cw._fxflash = BindFX(cw._Entity,"Screamer_green_flash",0.25,"tongue_base",0.1,0,0)
    end
     if Game._EarthQuakeProc then
        local g = Templates["Grenade.CItem"]
        Game._EarthQuakeProc:Add(x,y,z, 5, g.ExplosionCamDistance, g.ExplosionCamMove, g.ExplosionCamRotate, false)
    end
    t:SndEnt("scream1",pe)    
    t:SndEnt("screamer_shoot",pe)    
    QuadSound(pe)                
end
Network:RegisterMethod("Screamer.AltFireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e") 
--============================================================================

function Screamer:OutOfAmmoFX(entity,fire)
    Templates["Screamer.CWeapon"]:SndEnt("out_of_ammo",entity)
end
Network:RegisterMethod("Screamer.OutOfAmmoFX", NCallOn.AllClients, NMode.Reliable, "eb") 
--============================================================================
