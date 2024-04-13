o._animstate = 0

function o:OnCreateEntity()
	self:ReloadTextures()
	self._bombnumber =0
end
--============================================================================
function o:OnPrecache()
    CloneTemplate("EggBomb.CWeapon"):LoadHUDData()
end
--============================================================================
function o:OnChangeWeapon()
end

function o:OnUpdate()
self.ObjOwner.State = 8 
	if self._bombnumber >0 then
		self.ObjOwner.State = 81
	end
end


function o:ReloadTextures()
	if not self._Entity then return end
    if Cfg.WeaponNormalMap == true then    
        if Cfg.WeaponSpecular == false then
--            MATERIAL.Replace("models/kgr/kgr_pb","models/kgr/kgr_pb_no_specular")
        else
  --          MATERIAL.Replace("models/kgr/kgr_pb","models/kgr/kgr_pb")
        end
    end
	MDL.EnableNormalMaps(self._Entity,Cfg.WeaponNormalMap)
end

--============================================================================
function o:LoadHUDData()
	self._matAmmoIcon3 = MATERIAL.Create("HUD/Mw_hud/i_eggbombs", TextureFlags.NoLOD + TextureFlags.NoMipMaps)
end
--=====
--
--============================================================================
function o:DrawHUD(delta)
    local w,h = R3D.ScreenSize()
    local gray = R3D.RGB(120,120,70)
    local sizex, sizey = MATERIAL.Size(Hud._matHUDLeft)
    
    
    if not (INP.IsFireSwitched() or (not Game.SwitchFire[7] and Cfg.SwitchFire[7]) or (not Cfg.SwitchFire[7] and Game.SwitchFire[7])) then
		Hud:Quad(self._matAmmoIcon3,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*11)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*16)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.StickyBombs),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.StickyBombs)
	else
		Hud:Quad(self._matAmmoIcon3,(1024-52*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*49)-Cfg.HUDSize*sizey)*h/768,Cfg.HUDSize,false)
		Hud:DrawDigitsText((1024-118*Cfg.HUDSize)*w/1024,((768+Cfg.HUDSize*50)-Cfg.HUDSize*sizey)*h/768,string.sub(string.format("%04d",Player.Ammo.StickyBombs),-3),0.9*Cfg.HUDSize,Player.s_SubClass.AmmoWarning.StickyBombs)
	end    
end
--============================================================================
function o:OnFinishAnim(anim)
    if anim == "throw" then
		self:ForceAnim("triggerin",false) 
    end
end
--============================================================================

function EggBomb:Fire()
		self.FireSFX(self.ObjOwner._Entity, self.ObjOwner.Ammo.StickyBombs) 
end
--============================================================================


function EggBomb:FireSFX(pe,ammo)
	local player = EntityToObject[pe]
	local t = Templates["EggBomb.CWeapon"]
	local s = t:GetSubClass()
	local x,y,z = ENTITY.GetPosition(pe)
	if player then
		local cw = player:GetCurWeapon()
		cw.ShotTimeOut = s.BombDelay
		if cw._bombnumber >0 then
		PlaySound2D("weapons/EggBomb/exp_trigger")
			cw:ForceAnim("triggerpush",false)
			cw._ActionState = "Idle"
			cw._Expstate = 1
			cw._bombnumber = 0
			player._weaponwalk = false
			 if Game.GMode == GModes.SingleGame and Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
					PlaySound2D("belial/Belial_ingame_"..math.random(137,139),Game.chatvolume,nil,true)
			end
		else
			if ammo > 0 then
			cw:ForceAnim("throw",false)
		     	if not Game.NoAmmoLoss then player.Ammo.StickyBombs = player.Ammo.StickyBombs -1 end            
			if player == Player then
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape4",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape2",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape1",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape3",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape5",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape6",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape7",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape8",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape9",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape10",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape11",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape12",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape13",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape14",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape15",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape16",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape17",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape18",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape19",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape20",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape21",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape22",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape29",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurface2_2sided_Shape",false)
			MDL.SetMeshVisibility(cw._Entity,"pPlaneShape1",false)
			MDL.SetMeshVisibility(cw._Entity,"zmizniShape",false)
			cw.inv = true

				end
				cw:ThrowBomb()
				cw._bombnumber = cw._bombnumber + 1
				cw._ActionState = "Idle"
				player._weaponwalk = true
			else
			cw.OutOfAmmoSFX(pe) 
			end
		end
	end
end
Network:RegisterMethod("EggBomb.FireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "eu")	


function EggBomb:ThrowBomb()
		PlaySound2D("weapons/EggBomb/throw"..math.random(1,2))
	local t = Templates["EggBomb.CWeapon"]
	local s = t:GetSubClass()
		local obj = GObjects:Add(TempObjName(),CloneTemplate("StickyEgg.CItem"))
		obj.ObjOwner = self.ObjOwner
		local x,y,z = ENTITY.PO_GetPawnHeadPos(self.ObjOwner._Entity)                
	        local fv = self.ObjOwner.ForwardVector
	        x,y,z = x + fv.X*1.3, y + fv.Y*1.3, z + fv.Z*1.3    

	        obj.Pos:Set(x,y,z)
	        obj.Rot:FromNormalY(fv.X,fv.Y,fv.Z)     
	        obj:Apply()
        	obj.ExplosionStrength = s.ExplStr         
	        obj.ExplosionRange    = s.ExplRange
		        obj.Damage            = s.BombDamage 
	
		        if self.ObjOwner.HasQuad then            
	            obj.Damage = math.floor(obj.Damage * 4)
        	end
	        local pvx,pvy,pvz = ENTITY.GetVelocity(self.ObjOwner._Entity)       
	        pvx,pvy,pvz = pvx*math.abs(fv.X)*0.7,pvy*math.abs(fv.Y)/2*0.7,pvz*math.abs(fv.Z)*0.7 
	        local gvf = s.BVelocityForward
	        local gvu = s.BVelocityUp
	        ENTITY.SetVelocity(obj._Entity, fv.X*gvf+pvx, fv.Y*gvf+gvu+pvy, fv.Z*gvf+pvz) 
	        local a = FRand(2,3)
	        ENTITY.SetAngularVelocity(obj._Entity, fv.Z*a,0,-fv.X*a)
end

function EggBomb:AltFire() -- throw bomb
    local s = self:GetSubClass()
if self.ObjOwner.Ammo.StickyBombs > 0  then
	self.AltFireSFX(self.ObjOwner._Entity)
else
	self.OutOfAmmoSFX(self.ObjOwner._Entity)
        self.ShotTimeOut = s.BombDelay
end
end

function EggBomb:AltFireSFX(pe)
	local player = EntityToObject[pe]
	local t = Templates["EggBomb.CWeapon"]
	local s = t:GetSubClass()
	local x,y,z = ENTITY.GetPosition(pe)

	if player
		then 
		local cw = player:GetCurWeapon()
		if Game.GMode == GModes.SingleGame or cw._bombnumber < Game.MaxEggs then
		if not Game.NoAmmoLoss then player.Ammo.StickyBombs = player.Ammo.StickyBombs -1 end  
		if player == Player then
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape4",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape2",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape1",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape3",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape5",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape6",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape7",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape8",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape9",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape10",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape11",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape12",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape13",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape14",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape15",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape16",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape17",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape18",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape19",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape20",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape21",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape22",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurfaceShape29",false)
			MDL.SetMeshVisibility(cw._Entity,"polySurface2_2sided_Shape",false)
			MDL.SetMeshVisibility(cw._Entity,"pPlaneShape1",false)
			MDL.SetMeshVisibility(cw._Entity,"zmizniShape",false)
			cw.inv = true

		end
			if player.Ammo.StickyBombs > -1 then
				cw._ActionState = "Idle"
				if cw._bombnumber == 0 then
					cw:ForceAnim("throw",false) 
				else
					cw:ForceAnim("triggerthrow",false) 
				end
				cw:ThrowBomb()
				cw._bombnumber = cw._bombnumber + 1
				cw.ShotTimeOut = s.BombDelay
		end
	end	
	end
end
Network:RegisterMethod("EggBomb.AltFireSFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e")	

function EggBomb:OutOfAmmoSFX(entity)
end

--============================================================================
function o:OnTick(delta)
	if self._bombnumber < 1 then
		self._Expstate = 0
		self._weaponwalk = false
		self._bombnumber =0
	else
		self._weaponwalk = true
	end
	if self.inv and self.ObjOwner.Ammo.StickyBombs>0 and self.ShotTimeOut < 1 then
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape4",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape2",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape3",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape5",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape6",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape7",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape8",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape9",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape10",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape11",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape12",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape13",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape14",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape15",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape16",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape17",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape18",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape19",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape20",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape21",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape22",true)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape29",true)
			MDL.SetMeshVisibility(self._Entity,"polySurface2_2sided_Shape",true)
			MDL.SetMeshVisibility(self._Entity,"pPlaneShape1",true)
			MDL.SetMeshVisibility(self._Entity,"zmizniShape",true)
			self.inv= false
	end
	if not self.inv and self.ObjOwner.Ammo.StickyBombs<1 then
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape4",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape2",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape3",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape5",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape6",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape7",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape8",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape9",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape10",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape11",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape12",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape13",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape14",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape15",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape16",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape17",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape18",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape19",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape20",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape21",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape22",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape29",false)
			MDL.SetMeshVisibility(self._Entity,"polySurface2_2sided_Shape",false)
			MDL.SetMeshVisibility(self._Entity,"pPlaneShape1",false)
			MDL.SetMeshVisibility(self._Entity,"zmizniShape",false)
			self.inv= true
	end
end
--============================================================================
