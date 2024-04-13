--============================================================================
function ICannongun:OnPrecache()
    Cache:PrecacheActor("CannonGun.CWeapon")
end
--============================================================================
function ICannongun:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function ICannongun:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
    --MDL.CreateShadowMap(self._Entity,64)

    local param  = "r"
    if self.Ammo.Minigun > self.Ammo.Cannonball then param = "k" end
    ENTITY.SetSynchroString(self._Entity,"ICannongun.CItem"..":"..param)            
    
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function ICannongun:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","ICannongun")    
    local tex = "HUD/Mw_hud/weapon/ikon_cannonball"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_cannonball"
    if param == "k" then
        tex = "HUD/weapons/ikona_chaingun"
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
--function ICannongun:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function ICannongun:OnTake(player)    
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity, self.Ammo.Minigun, self.Ammo.Cannonball) 
    end
    
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
end
--============================================================================
function ICannongun:TakeFX(pe,aMinigun,aCannonball)
    local player = EntityToObject[pe]    
    local t = Templates["ICannongun.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "CannonGun"
        player.Ammo.MiniGun = player.Ammo.MiniGun + aMinigun 
        player.Ammo.Cannonball = player.Ammo.Cannonball + aCannonball 
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end

    t:SndEnt("pickup",pe)    
end
Network:RegisterMethod("ICannongun.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
