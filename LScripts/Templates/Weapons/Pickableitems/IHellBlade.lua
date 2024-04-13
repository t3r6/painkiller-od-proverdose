--============================================================================
function IHellBlade:OnPrecache()
    Cache:PrecacheActor("HellBlade.CWeapon")
end
--============================================================================
function IHellBlade:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function IHellBlade:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)

    local param  = "h"
    if self.Ammo.Skulls > self.Ammo.DarkEnergy then param = "b" end
    ENTITY.SetSynchroString(self._Entity,"IHellBlade.CItem"..":"..param)
    
    self:Client_OnCreateEntity(self._Entity,param)
end
--============================================================================
--MODIFIED=#####################################################################################
function IHellBlade:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","IHellBlade")    
    local tex = "HUD/Mw_hud/weapon/ikon_fantom_blades"
	local tex2 = "../ProOptions/Mw_hud/weapon/ikon_fantom_blades"
    if param == "b" then        
        tex = "HUD/Mw_hud/weapon/ikon_dark_energy"
		tex2 = "../ProOptions/Mw_hud/weapon/ikon_dark_energy"
    end
	if Cfg.PROD_Weapons_Icons == 1 then
		BILLBOARD.SetupCorona(e,1,0,1,0,0,0.25,0,0,0,tex,Color:New(255,255,255,0):Compose(),4,true)    
		ENTITY.SetPosition(e,0,-0.7,0)
		ENTITY.RegisterChild(entity,e,true,0) 
		WORLD.AddEntity(e)
	elseif Cfg.PROD_Weapons_Icons == 2 then
		BILLBOARD.SetupCorona(e,1,0,1,0,0,0.25,0,0,0,tex2,Color:New(255,255,255,0):Compose(),4,true)    
		ENTITY.SetPosition(e,0,-0.7,0)
		ENTITY.RegisterChild(entity,e,true,0) 
		WORLD.AddEntity(e)
	else
	end
end
--MODIFIED=end#####################################################################################
--============================================================================
function IHellBlade:OnTake(player)     
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity,self.Ammo.Skulls,self.Ammo.DarkEnergy)
    end
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
    if Game.GMode == GModes.SingleGame then
			if Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
				self._ambientdelay=0
				PlaySound2D("belial/Belial_ingame_"..math.random(113,114),Game.chatvolume,nil,true)	
		    end
    end

end
--============================================================================
--function IHellBlade:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function IHellBlade:TakeFX(pe,aSkulls,aDarkEnergy)
    local player = EntityToObject[pe]    
    local t = Templates["IHellBlade.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "HellBlade"            
        player.Ammo.Skulls = player.Ammo.Skulls + aSkulls
        player.Ammo.DarkEnergy = player.Ammo.DarkEnergy + aDarkEnergy
        player:CheckMaxAmmo()
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end
    
    t:SndEnt("pickup",pe)
end
Network:RegisterMethod("IHellBlade.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "euu")
--============================================================================
