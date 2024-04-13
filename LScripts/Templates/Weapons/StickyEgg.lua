function o:OnCreateEntity()
	ENTITY.EnableNetworkSynchronization(self._Entity,true,false,2)
	ENTITY.SetSynchroString(self._Entity,"StickyEgg.CItem")
	
	if Game.GMode == GModes.SingleGame then 
        	self:PO_Create(BodyTypes.FromMesh,nil,ECollisionGroups.Noncolliding)    
	    else
	        self:PO_Create(BodyTypes.Sphere,0.001,ECollisionGroups.Noncolliding)
	end
	ENTITY.PO_SetMovedByExplosions(self._Entity, false)
	ENTITY.PO_EnableGravity(self._Entity, true)
	self:Client_OnCreateEntity(self._Entity)
	self._time = 0
	self._dieaftertime = false
	self._lPos = Vector:New(self.Pos)    
end

-------------------------------------------------------------------------------
function o:Client_OnCreateEntity(entity)
    BindSoundToEntity(entity,"weapons/EggBomb/eggloop"..math.random(1,5),3,30,true,nil,nil,nil,nil,0.1)   
    BindSoundToEntity(entity,"weapons/EggBomb/eggvloop"..math.random(1,3),3,30,true,nil,nil,nil,nil,0.1)   
--    BindSoundToEntity(entity,"weapons/EggBomb/beeploop"..math.random(1,3),3,30,true,nil,nil,nil,nil,0.1)   
end

-------------------------------------------------------------------------------
function o:OnInitTemplate()
    self:ReplaceFunction("_Synchronize","Synchronize")
    self:ReplaceFunction("Synchronize","nil")
end

function o:OnPrecache()
end


function o:Tick(delta)    
	self._time = self._time + delta    
	local x,y,z = ENTITY.GetWorldPosition(self._Entity)
	if not self._binded then
		local vx,vy,vz,vl = ENTITY.GetVelocity(self._Entity)    
                ENTITY.RemoveFromIntersectionSolver(self.ObjOwner._Entity)
        	ENTITY.RemoveFromIntersectionSolver(self._Entity)    
	        local b,d,lx,ly,lz,nx,ny,nz,he,e = WORLD.LineTrace(self._lPos.X,self._lPos.Y,self._lPos.Z,x,y,z)            
        	ENTITY.AddToIntersectionSolver(self.ObjOwner._Entity)
	        ENTITY.AddToIntersectionSolver(self._Entity)
        	self._lPos:Set(x,y,z)
		if b then 
	            if Game.GMode == GModes.SingleGame and ENTITY.IsWater(e) then 
	                self:InDeathZone(lx,ly,lz,"wat")
	            else
	                local cg = ENTITY.PO_GetCollisionGroup(e)
	                if not CheckStartGlass(he,lx,ly,lz,0.3,vx,vy,vz) and cg~=7 and cg~=8 then
	                    self:OnCollision(lx,ly,lz,nx,ny,nz,e,he)
	                end
	            end
	        end
	end
	if self.ObjOwner._died or self.ObjOwner._ToKill then
		GObjects:ToKill(self)
	end
	local player = EntityToObject[self.ObjOwner._Entity]
	if player then
		local cw = player.Weapons[8]
		if cw then 
		if cw._Expstate == 1 then
			if (self._time > 1 or self._binded) then
			Explosion(x,y,z,self.ExplosionStrength,self.ExplosionRange,self.ObjOwner.ClientID,AttackTypes.Rocket,self.Damage)
			self.ExplosionFX(self._Entity,x,y,z)
			cw._bombnumber = cw._bombnumber - 1 
			GObjects:ToKill(self)
			else
				self._dieaftertime = true
			end
		end
		end
	end
	if self._dieaftertime and self._time > 1 then
		Explosion(x,y,z,self.ExplosionStrength,self.ExplosionRange,self.ObjOwner.ClientID,AttackTypes.Rocket,self.Damage)
		self.ExplosionFX(self._Entity,x,y,z)
		GObjects:ToKill(self)
	end
end

function o:OnCollision(x,y,z,nx,ny,nz,e,he)
	ENTITY.SetPosition(self._Entity,x,y,z)
	self._binded = true
	ENTITY.PO_Remove(self._Entity)
	local joint = MDL.GetJointFromHavokBody(e,he)    	
	ENTITY.EnableCollisions(self._Entity, false)
        ENTITY.ComputeChildMatrix(self._Entity,e,joint)
        ENTITY.RegisterChild(e,self._Entity,true,joint) 
	self.HitFX(self._Entity,etype)
end

function o:HitFX(se,etype)
end

function o:ExplosionFX(entity,x,y,z)
    ENTITY.EnableDraw(entity,false) 
    local vx,vy,vz = ENTITY.GetVelocity(entity)    
    SOUND.Play3D("weapons/EggBomb/egg_expl"..math.random(1,3),x,y,z,30,200)
    local r = Quaternion:New_FromNormal(x,-y,z)
    if MPCfg.GameMode == "People Can Fly" then
        AddObject("FX_rexplodePCF.CActor",1,Vector:New(x,y,z),r,true) 
    else    
        AddObject("FX_eggbomb.CActor",1,Vector:New(x,y,z),r,true) 
    end
    if Game.GMode == GModes.SingleGame then 
        local n = math.random(4,6) -- how many (min,max)
        for i = 1, n do
            local ke = AddItem("KamykWybuchRakieta.CItem",0.6,Vector:New(x+FRand(-0.2,0.2),y+FRand(-0.2,0.2),z+FRand(-0.2,0.2)),
                false,Quaternion:New_FromEuler(FRand(0,3.14), FRand(0,3.14), FRand(0,3.14)))
            vx,vy,vz  = r:TransformVector(FRand(-30,30),FRand(22,34),FRand(-30,30))
            ENTITY.SetVelocity(ke,vx,vy,vz)
            ENTITY.SetTimeToDie(ke,FRand(1,2)) -- lifetime (min,max)
        end
    end
    if Game._EarthQuakeProc then
        local g = Templates["Grenade.CItem"]
        Game._EarthQuakeProc:Add(x,y,z, 5, g.ExplosionCamDistance, g.ExplosionCamMove, g.ExplosionCamRotate, false)
    end
end
Network:RegisterMethod("StickyEgg.ExplosionFX", NCallOn.AllClients, NMode.Reliable, "effffff")
