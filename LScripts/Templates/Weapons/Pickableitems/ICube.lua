--============================================================================
function ICube:OnPrecache()
end
--============================================================================
function ICube:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end
--============================================================================
function ICube:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,true)

    ENTITY.SetSynchroString(self._Entity,"ICube.CItem")
    
    self:Client_OnCreateEntity(self._Entity)
end
--============================================================================
function ICube:Client_OnCreateEntity(entity,param)
    local e = ENTITY.Create(ETypes.Billboard,"Script","ICube")    
       tex = "HUD/weapons/ikona_boltymetal"
    BILLBOARD.SetupCorona(e,1,0,0,0,0,0.25,0,0,0,tex,Color:New(255,255,255,0):Compose(),4,true)    
    ENTITY.SetPosition(e,0,0.7,0)
    ENTITY.RegisterChild(entity,e,true,0) 
    WORLD.AddEntity(e)
end
--============================================================================
function ICube:OnTake(player)     
    if Game.GMode == GModes.SingleGame or not (Cfg.WeaponsStay and player.EnabledWeapons[self.SlotIndex]) then 
        self.TakeFX(player._Entity)
    end
    if Game.GMode ~= GModes.SingleGame and Cfg.WeaponsStay then return true end
    if Game.GMode == GModes.SingleGame then
			if Game.lastchat and Game.lastchat + Game.chatdelay < Game.currentTime then
				Game.lastchat=Game.currentTime
				self._ambientdelay=0
				PlaySound2D("belial/Belial_ingame_117",Game.chatvolume,nil,true)	
			    end
   end

end
--============================================================================
--function ICube:OnRespawn()
--    local x,y,z = ENTITY.GetPosition(self._Entity)
--    AddObject("FX_ItemRespawn.CActor",1,Vector:New(x,y,z),nil,true) 
--end
--============================================================================
function ICube:TakeFX(pe)
    local player = EntityToObject[pe]    
    local t = Templates["ICube.CItem"]
    if player then        
        player.EnabledWeapons[t.SlotIndex] = "RazorCube"            
        if player == Player then 
            player:Client_OnTakeWeapon(t.SlotIndex)
            player:PickupFX() 
        end
    end
    
    t:SndEnt("pickup",pe)
end
Network:RegisterMethod("ICube.TakeFX", NCallOn.ServerAndAllClients, NMode.Reliable, "e")
--============================================================================
