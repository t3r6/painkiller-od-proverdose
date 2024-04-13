--============================================================================
function ICrossbow:OnPrecache()
    Cache:PrecacheActor("MagicCrossbow.CWeapon")
end
--============================================================================
function ICrossbow:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function ICrossbow:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
    --MDL.CreateShadowMap(self._Entity,64)

    local param  = "r"
    if self.Ammo.Arrows < self.Ammo.Heads then param = "k" end
    ENTITY.SetSynchroString(self._Entity,"ICrossbow.CItem"..":"..param)            
    
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function ICrossbow:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","ICrossbow")    
    local tex = "HUD/Mw_hud/weapon/ikon_arrows"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_arrows"
    if param == "k" then
        tex = "HUD/Mw_hud/weapon/ikon_heads"
		tex2 = "../ProOptions/Mw_hud/weapon/ikon_heads"
    end
	if Cfg.PROD_Weapons_Icons == 1 then
		BILLBOARD.SetupCorona(e,1,0,1,0,0,0.25,0,0,0,tex,Color:New(255,255,255,0):Compose(),4,true)    
		ENTITY.SetPosition(e,0,0.7,0)
		ENTITY.RegisterChild(entity,e,true,0) 
		WORLD.AddEntity(e)
	elseif Cfg.PROD_Weapons_Icons == 2 then
		BILLBOARD.SetupCorona(e,1,0,1,0,0,0.25,0,0,0,tex2,Color:New(255,255,255,0):Compose(),4,true)    
		ENTITY.SetPosition(e,0,0.7,0)
		ENTITY.RegisterChild(entity,e,true,0) 
		WORLD.AddEntity(e)
	else
	
	end
end
--MODIFIED=end#####################################################################################
--============================================================================
--function ICrossbow:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function ICrossbow:OnTake(player)    
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity, self.Ammo.Arrows, self.Ammo.Heads) 
    end
    
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
    if Game.GMode == GModes.SingleGame then
			if Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
				self._ambientdelay=0
				PlaySound2D("belial/Belial_ingame_118",Game.chatvolume,nil,true)	
			    end

    end

end
--============================================================================
function ICrossbow:TakeFX(pe,aArrows,aHeads)
    local player = EntityToObject[pe]    
    local t = Templates["ICrossbow.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "MagicCrossbow"
        player.Ammo.Arrows = player.Ammo.Arrows + aArrows 
        player.Ammo.Heads = player.Ammo.Heads + aHeads 
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end

    t:SndEnt("pickup",pe)    
end
Network:RegisterMethod("ICrossbow.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
