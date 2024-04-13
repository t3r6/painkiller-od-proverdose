function o:CustomOnDamage(he,x,y,z,obj, damage, type)
if type == AttackTypes.Demon then
       return true
end
if not self._vulnerable  then
   	self._hitmesh1 = true 
	 MDL.SetMeshVisibility(self._Entity,"soutaneSShape_add",true)
	    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape16_add",true)
	    MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape4_add",true)
	    MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape5_add",true)
	    MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape6_add",true)
	    MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape4_add",true)
	    MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape5_add",true)
	    MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape6_add",true)
	    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape21_add",true)
	    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape23_add",true)
	    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape31_add",true)
	    MDL.SetMeshVisibility(self._Entity,"polySurfaceShape25_add",true)
	self._hitmeshtime = self._AIBrain._currentTime
    return true
else
    if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "l_wing1" or jName == "r_wing1" or jName == "k_szyja" then
			if damage > self.Health then
				self._toexplode={}
				self._toexplodetime={}
				self._nextexplode=1
				Game.MegaBossHealth = nil
				Game.MegaBossHealthMax = nil
				Game.Samael= false
			end
			return false
		end
    end
end
return true
end


function o:OnThrow(aX, aY,aZ, angle, pitch)

	if math.random(100) < 50 then
	self.AiParams.throwAnim = "fireball"	
	self.AiParams.throwRangeMin = 1
	self.AiParams.throwRangeMax = 300
	self.AiParams.ThrowableItem = "Sammael_Fireball2.CItem"
	self.AiParams.throwVelOnly = true
	self.AiParams.throwDistMinus = 0
	self.AiParams.ThrowSpeed = 10
	self.AiParams.throwVelocity = 40
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	else
	self.AiParams.throwAnim = "swarm"	
	self.AiParams.throwRangeMin = 1
	self.AiParams.throwRangeMax = 400
	self.AiParams.ThrowableItem = "Sammael_Swarm2.CActor"
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	end

end

function o:CustomUpdate(delta)
	if not self._died then
		local brain = self._AIBrain
		Game.MegaBossHealth = self.Health
	end
	if self._hitmesh1 then
		if self._hitmeshtime + self.hitmeshdelay < self._AIBrain._currentTime then
			self._hitmesh1 = nil
			MDL.SetMeshVisibility(self._Entity,"soutaneSShape_add",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape16_add",false)
			MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape4_add",false)
			MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape5_add",false)
			MDL.SetMeshVisibility(self._Entity,"r_polySurfaceShape6_add",false)
			MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape4_add",false)
			MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape5_add",false)
			MDL.SetMeshVisibility(self._Entity,"l_polySurfaceShape6_add",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape21_add",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape23_add",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape31_add",false)
			MDL.SetMeshVisibility(self._Entity,"polySurfaceShape25_add",false)
		end
	end
	if self._vulnerable then
		for i,v in self._toexplodetime do
			if v < self._AIBrain._currentTime then
				self._toexplodetime[i] = nil
				WORLD.Explosion2(self._toexplode[i].X,self._toexplode[i].Y,self._toexplode[i].Z, self.groundexpstr,self.groundexpran,nil,AttackTypes.Rocket,self.groundexpdam)
			        AddPFX(self.Exploparticle,self.Exploparticlescale, self._toexplode[i])
				self._toexplode[i]=nil
			end
		end
		if self._AIBrain._lastExplode + self._earthexplodetime < self._AIBrain._currentTime then 
			--check if some are waiting to be exploded
			if table.getn(self._toexplodetime) < 1 then
				self._vulnerable = false
				self:BindSwordFlames()
				self._toexplode={}
				self._toexplodetime={}
				self._nextexplode=1
			end
		else
 			local ax,ay,az = ENTITY.GetPosition(Player._Entity)
			local rnd = self.hitgroundscatter
			while math.random(100) < self.exphits do
				local a = ax + FRand(-rnd, rnd)
				local b = az + FRand(-rnd, rnd)
				local zn,idx = WPT.GetClosest(a,ay,b)
				if idx > -1 then
					local xx,xy,xz = WPT.GetPosition(zn,idx)  
					AddPFX(self.hitgroundFX,self.hitgroundFXscale,Vector:New(xx,xy,xz))
					self._toexplode[self._nextexplode] = Vector:New(xx,xy,xz)
					self._toexplodetime[self._nextexplode] = self._AIBrain._currentTime + self._singleexpdelay
					self._nextexplode=self._nextexplode+1
				end
			end
		end
	end
end

function o:BindSwordFlames()
  self._swfl1=self:BindFX("Bswflames1")
  self._swfl2=self:BindFX("Bswflames2")
  self._swfl3=self:BindFX("Bswflames3")
  self._swfl4=self:BindFX("rootflame")
end

