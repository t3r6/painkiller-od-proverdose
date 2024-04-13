
-------------------------------------------------------------------------------
function Heads:OnCreateEntity()
    ENTITY.EnableNetworkSynchronization(self._Entity,true,false,2)
    self:PO_Create(BodyTypes.Sphere,0.15,ECollisionGroups.Missile)    

    ENTITY.PO_SetMovedByExplosions(self._Entity, false)    
    ENTITY.RemoveFromIntersectionSolver(self._Entity) 

    self._collisionNr = 0
    local param = "0"
    if self.ObjOwner.HasWeaponModifier then 
        self._collisionNr = 2 
        param = "9"
    end
    self:Client_OnCreateEntity(self._Entity,param)
    ENTITY.SetSynchroString(self._Entity,"Heads.CItem"..":"..param)

    if Game.GMode == GModes.SingleGame then
        ENTITY.EnableCollisions(self._Entity,true,0,0)
    else
        ENTITY.EnableCollisions(self._Entity,true,0,0.1)
    end
    ENTITY.PO_SetMissile(self._Entity, MPProjectileTypes.HeaterBomb ) 

end
--============================================================================
function Heads:Client_OnCreateEntity(entity,param)
    RawCallMethod(self.SetSFX,entity,tonumber(param))    
end
--============================================================================
function Heads:Client_OnCreatePO(entity,po)
    ENTITY.EnableCollisions(entity,true,0.3,0.3)
    ENTITY.PO_SetGrenade(entity)
    ENTITY.PO_SetCollisionGroup(entity, ECollisionGroups.ClientGrenade)
end
--============================================================================
function Heads:OnPrecache()
	Cache:PrecacheParticleFX("Grenade")
	Cache:PrecacheParticleFX("GrenadeSmoke")
	Cache:PrecacheParticleFX("explo_ammobox")
	Cache:PrecacheItem("KamykWybuch.CItem")     
    Cache:PrecacheTrail("trail_grenade")  
 Cache:PrecacheParticleFX("bomb_glow")
end
--============================================================================
function Heads:Client_OnCollision(x,y,z)
    Templates["MagicCrossbow.CWeapon"]:SndEnt("heater_bounce",self._Entity)   
end             
--============================================================================
function Heads:Update()
    self.Timeout = self.Timeout - 1
    if self.Timeout <= 0 then self:Explode() end
end

--============================================================================
function Heads:SetSFX(hbe,nr)
    if nr == 0 or nr == 9 then
        local e = ENTITY.Create(ETypes.Trail,"player_eye","trailName")
        ENTITY.AttachTrailToBones(hbe,e)
        WORLD.AddEntity(e)
    end
    if nr == 1 or nr == 9 then 
        local glow = AddPFX("bomb_glow",0.2)
        ENTITY.RegisterChild(hbe,glow)        
        PARTICLE.SetParentOffset(glow,0,0,0,nil,0.2,0.2,0.2)    
    end    
    if nr == 2 or nr == 9 then 
        local smoke = AddPFX("GrenadeSmoke",1)
        ENTITY.RegisterChild(hbe,smoke)
    end
end
Network:RegisterMethod("Heads.SetSFX", NCallOn.AllClients, NMode.Unreliable, "eb")
--============================================================================
function Heads:OnCollision(x,y,z,nx,ny,nz,e)
        
    if Game.GMode == GModes.MultiplayerClient then return end
    
    if Game.GMode == GModes.SingleGame then
	if  ENTITY.IsWater(e) then 
		self:InDeathZone(x,y,z,"wat")
		return
	end	
	self._collisionNr = self._collisionNr + 1
	local obj = EntityToObject[e]
	if self._collisionNr > 1 and obj then
		if obj and not obj._ToKill and obj.OnDamage then 
	        	obj:OnDamage(self.Damage,self.ObjOwner,AttackTypes.Heads)
	        	obj._GotInstantExplosion = Game.Counter
	        end
	        self:Explode()    
	        return
	else
	    if self._collisionNr < 3 then 
	            self:Client_OnCollision(x,y,z)
	    else    
	        self:Explode()
	    end
	end    
	    
    else
	self._collisionNr = self._collisionNr + 1
	local obj = EntityToObject[e]
	if  obj then
       		if obj and not obj._ToKill and obj.OnDamage then 
	            obj:OnDamage(self.Damage,self.ObjOwner,AttackTypes.Heads)
	            obj._GotInstantExplosion = Game.Counter
	        end
	        self:Explode()    
	        return
	else
	           self:Client_OnCollision(x,y,z)
	           self.SetSFX(self._Entity,self._collisionNr)
	end    
   end
end
--============================================================================
function Heads:Explode()    
    local x,y,z = ENTITY.GetPosition(self._Entity)   
    ENTITY.EnableCollisions(self._Entity,false) -- disable next callbacks        
    ENTITY.RemoveFromIntersectionSolver(self._Entity)
    ENTITY.PO_Enable(self._Entity, false)	-- bo inaczej by zglaszal msg 'explosion' z soba samym
    Explosion(x,y,z,self.ExplosionStrength,self.ExplosionRange,self.ObjOwner.ClientID,AttackTypes.Heads,self.Damage)
    self.Client_Explosion(self._Entity,x,y,z)    
    GObjects:ToKill(self)    
end
-------------------------------------------------------------------------------
function Heads:Client_Explosion(entity,x,y,z)

    ENTITY.EnableDraw(entity,false)    
    ENTITY.PO_Enable(entity,false)
    
    Templates["MagicCrossbow.CWeapon"]:SndEnt("heater_explosion",entity)
    local pfx = AddPFX("explo_ammobox",0.1,Vector:New(x,y,z))
end
-------------------------------------------------------------------------------
Network:RegisterMethod("Heads.Client_Explosion", NCallOn.AllClients, NMode.Reliable, "efff")
-------------------------------------------------------------------------------
