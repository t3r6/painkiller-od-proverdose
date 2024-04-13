--============================================================================
function IBonegun:OnPrecache()
    Cache:PrecacheActor("Bonegun.CWeapon")
end
--============================================================================
function IBonegun:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function IBonegun:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
    --MDL.CreateShadowMap(self._Entity,64)

    local param  = "r"
    if self.Ammo.Bonegun > self.Ammo.StoneBullets then param = "k" end
    ENTITY.SetSynchroString(self._Entity,"IBonegun.CItem"..":"..param)            
    
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function IBonegun:Client_OnCreateEntity(entity,param)
	local e = ENTITY.Create(ETypes.Billboard,"Script","IBonegun")    
	local tex = "HUD/Mw_hud/weapon/ikon_bones"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_bones"
	if param == "k" then
		tex = "HUD/Mw_hud/weapon/ikon_petrify"
		tex2 = "../ProOptions/Mw_hud/weapon/ikon_petrify"
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
--function IBonegun:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function IBonegun:OnTake(player)    
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity, self.Ammo.Bonegun, self.Ammo.StoneBullets) 
    end
    
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
end
--============================================================================
function IBonegun:TakeFX(pe,aBonegun,aStoneBullets)
    local player = EntityToObject[pe]    
    local t = Templates["IBonegun.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "Bonegun"
        player.Ammo.Bonegun = player.Ammo.Bonegun + aBonegun 
        player.Ammo.StoneBullets = player.Ammo.StoneBullets + aStoneBullets 
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end

    t:SndEnt("pickup",pe)    
end
Network:RegisterMethod("IBonegun.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
