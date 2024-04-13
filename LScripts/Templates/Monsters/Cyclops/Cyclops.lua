function o:OnInitTemplate()
    self:SetAIBrain()
    self._disableHits = true
    self._hitsCounter = 0
    self._AIBrain._lastThrowTime = FRand(-4, -1)

end
function o:OnFinishAnim(anim)
	if anim == "attack1" then
		MDL.SetMeshVisibility(self._Entity, "Stone2Shape", true)
		if not self._Flame then 
			self._Flame = self:BindFX(self.fxx,0.06,"Stone")
		end
	end
end

function o:OnPrecache()
MATERIAL.Create("particles/trailscreamer")
end

function o:CustomOnDamage(he,x,y,z,obj,damage,type,nx,ny,nz)
	if type == AttackTypes.OutOfLevel or type == AttackTypes.Demon then
        	return false
	end
	if self._hiddenstone then 
		return true
	end
	return false
end

function o:Setydest(wh)
	self._ydest=wh
end

function o:Hidestone()
	MDL.SetMeshVisibility(self._Entity, "Stone2Shape", false)
	PARTICLE.Die(self._Flame)
	self._Flame=nil
	self._hiddenstone = true
end

function o:Showstone()
	MDL.SetMeshVisibility(self._Entity, "Stone2Shape", true)
	if not self._Flame then 
		self._Flame = self:BindFX(self.fxx,0.06,"Stone")
	end
	self._hiddenstone = false
end

function o:Render()
		if not self._died then
		local brain = self._AIBrain
		if self.Animation == self.AiParams.laserAnimation and self._AIBrain.r_closestEnemy  then
		local Joint = MDL.GetJointIndex(self._Entity, self.AiParams.laserjoint)
		local ax,ay,az = self.AiParams.lasershift.X, self.AiParams.lasershift.Y, self.AiParams.lasershift.Z
		local srcx,srcy,srcz = MDL.TransformPointByJoint(self._Entity, Joint, ax,ay,az)
		local destx, desty, destz
		if brain._enemyLastSeenPoint and brain._enemyLastSeenPoint.X then
			destx, desty, destz = brain._enemyLastSeenPoint.X,brain._enemyLastSeenPoint.Y,brain._enemyLastSeenPoint.Z
		else
			destx, desty, destz = brain.r_closestEnemy.Pos.X,brain.r_closestEnemy.Pos.Y,brain.r_closestEnemy.Pos.Z
		end
	local yDest= self._ydest
	if yDest then
		desty = desty + yDest
	end
--        ENTITY.RemoveFromIntersectionSolver(self._Entity)
     local b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(srcx,srcy,srcz,destx,desty,destz)
--        ENTITY.AddToIntersectionSolver(self._Entity)
             
                if b then                            
                    local obj = EntityToObject[e]             
                    if obj  and e ~= self._Entity then          
                        if math.random(100) < 20 then                            
                            if obj.OnDamage then obj:OnDamage(self.AiParams.laserdamage,self,AttackTypes.Painkiller,tx,ty,tz,nx,ny,nz) end
                        end
		    end
		end
		if b and e then
              	ENTITY.SpawnDecal(e,'electro',tx,ty,tz,nx,ny,nz)
		AddPFX("FX_rexplode1", 0.1,Vector:New(tx,ty,tz))
        	end
	 R3D.DrawSprite1DOF(srcx,srcy,srcz,destx,desty,destz,0.1,R3D.RGB(255,255,255),"particles/trailscreamer") 

	else
		self._ydest=-4
	end
	end
end

function o:SetnextThrow()

	if math.random(100) < 50 then
	self.AiParams.throwAnim = "attack1"	
	else
	self.AiParams.throwAnim = "attack2"	
	end

end


function o:OnCreateEntity()
	 self._Flame = self:BindFX(self.fxx,0.06,"Stone")
	self._hiddenstone = false
end
