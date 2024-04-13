--============================================================================
function IEctoplasmer:OnPrecache()
    Cache:PrecacheActor("Ectoplasmer.CWeapon")
end
--============================================================================
function IEctoplasmer:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function IEctoplasmer:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
    --MDL.CreateShadowMap(self._Entity,64)

    local param  = "r"
    if self.Ammo.Ectoplasm > self.Ammo.GreenGoo then param = "k" end
    ENTITY.SetSynchroString(self._Entity,"IEctoplasmer.CItem"..":"..param)            
    
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function IEctoplasmer:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","IEctoplasmer")    
    local tex = "HUD/Mw_hud/weapon/ikon_ectoplasm"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_ectoplasm"
    if param == "k" then
        tex = "HUD/Mw_hud/weapon/ikon_green_goo"
		tex2 = "../ProOptions/Mw_hud/weapon/ikon_green_goo"
    end
	if Cfg.PROD_Weapons_Icons == 1 then
		BILLBOARD.SetupCorona(e,1,0,0,0,0,0.25,0,0,0,tex,Color:New(255,255,255,0):Compose(),4,true)    
		ENTITY.SetPosition(e,0,-0.7,0)
		ENTITY.RegisterChild(entity,e,true,0) 
		WORLD.AddEntity(e)
	elseif Cfg.PROD_Weapons_Icons == 2 then
		BILLBOARD.SetupCorona(e,1,0,0,0,0,0.25,0,0,0,tex2,Color:New(255,255,255,0):Compose(),4,true)    
		ENTITY.SetPosition(e,0,-0.7,0)
		ENTITY.RegisterChild(entity,e,true,0) 
		WORLD.AddEntity(e)
	else
	
	end
end
--MODIFIED=end#####################################################################################
--============================================================================
--function IEctoplasmer:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function IEctoplasmer:OnTake(player)    
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity, self.Ammo.Ectoplasm, self.Ammo.GreenGoo) 
    end
    
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
    if Game.GMode == GModes.SingleGame then
	if Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
				self._ambientdelay=0
				PlaySound2D("belial/Belial_ingame_115",Game.chatvolume,nil,true)	
			    end
    end

end
--============================================================================
function IEctoplasmer:TakeFX(pe,aEctoplasm,aGreenGoo)
    local player = EntityToObject[pe]    
    local t = Templates["IEctoplasmer.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "Ectoplasmer"
        player.Ammo.Ectoplasm = player.Ammo.Ectoplasm + aEctoplasm 
        player.Ammo.GreenGoo = player.Ammo.GreenGoo + aGreenGoo 
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end

    t:SndEnt("pickup",pe)    
end
Network:RegisterMethod("IEctoplasmer.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
