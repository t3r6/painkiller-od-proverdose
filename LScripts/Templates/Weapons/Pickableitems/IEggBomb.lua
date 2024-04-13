--============================================================================
function IEggBomb:OnPrecache()
    Cache:PrecacheActor("EggBomb.CWeapon")
end
--============================================================================
function IEggBomb:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function IEggBomb:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
    --MDL.CreateShadowMap(self._Entity,64)

    local param  = "r"
    ENTITY.SetSynchroString(self._Entity,"IEggBomb.CItem"..":"..param)            
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function IEggBomb:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","IEggBomb")    
    local tex = "HUD/Mw_hud/weapon/ikon_eggbombs"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_eggbombs"
    if param == "k" then
        tex = "HUD/Mw_hud/weapon/ikon_eggbombs"
		tex2 = "../ProOptions/Mw_hud/weapon/ikon_eggbombs"
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
--function IEggBomb:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function IEggBomb:OnTake(player)    
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity, self.Ammo.StickyBombs) 
    end
    
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
    if Game.GMode == GModes.SingleGame then
			if Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
				self._ambientdelay=0
				PlaySound2D("belial/Belial_ingame_116",Game.chatvolume,nil,true)	
			    end
    end

end
--============================================================================
function IEggBomb:TakeFX(pe,aStickyBombs)
    local player = EntityToObject[pe]    
    local t = Templates["IEggBomb.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "EggBomb"
        player.Ammo.StickyBombs = player.Ammo.StickyBombs + aStickyBombs 
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end

    t:SndEnt("pickup",pe)    
end
Network:RegisterMethod("IEggBomb.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
