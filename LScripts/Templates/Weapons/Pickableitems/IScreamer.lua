--============================================================================
function IScreamer:OnPrecache()
    Cache:PrecacheActor("Screamer.CWeapon")
end
--============================================================================
function IScreamer:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function IScreamer:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
    --MDL.CreateShadowMap(self._Entity,64)

    local param  = "r"
    if self.Ammo.BrainWorms > self.Ammo.BrokenSouls then param = "k" end
    ENTITY.SetSynchroString(self._Entity,"IScreamer.CItem"..":"..param)            
    
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function IScreamer:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","IScreamer")    
    local tex = "HUD/Mw_hud/weapon/ikon_brain_worms"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_brain_worms"
    if param == "k" then
        tex = "HUD/Mw_hud/weapon/ikon_broken_souls"
		tex2 = "../ProOptions/Mw_hud/weapon/ikon_broken_souls"
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
--function IScreamer:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function IScreamer:OnTake(player)    
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity, self.Ammo.BrainWorms, self.Ammo.BrokenSouls) 
    end
    
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
end
--============================================================================
function IScreamer:TakeFX(pe,aBrainWorms,aBrokenSouls)
    local player = EntityToObject[pe]    
    local t = Templates["IScreamer.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "Screamer"
        player.Ammo.BrainWorms = player.Ammo.BrainWorms + aBrainWorms 
        player.Ammo.BrokenSouls = player.Ammo.BrokenSouls + aBrokenSouls 
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end

    t:SndEnt("pickup",pe)    
end
Network:RegisterMethod("IScreamer.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
