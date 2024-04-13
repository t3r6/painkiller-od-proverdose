function Spike_Demon_Blue:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
	Cache:PrecacheParticleFX("spike_demon_shot")
	Cache:PrecacheParticleFX("spike_demon_breath")
	Cache:PrecacheParticleFX("spike_demon_cloud")
	Cache:PrecacheParticleFX("spike_demon_runcloud")
	Cache:PrecacheParticleFX("spike_demon_red")
	Cache:PrecacheParticleFX("spike_demon_startteleport")
	Cache:PrecacheParticleFX("spike_demon_endteleport")
	Cache:PrecacheParticleFX(self.AiParams.teleportPFX)

end

function Spike_Demon_Blue:OnCreateEntity()
    self._AIBrain._lastThrowTime = FRand(-5, 1) 
     self.Visible=false
end

function Spike_Demon_Blue:BindTrails()
self._tr1= self:BindTrail('trail_zombie','RightForeArm','RightHand')
self._tr2= self:BindTrail('trail_zombie','LeftForeArm','LeftHand')
end

function Spike_Demon_Blue:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end

function Spike_Demon_Blue:Shotflash()
self._ap=self:BindFX('shotfx')
end

function Spike_Demon_Blue:StartWalk()
if not self._brt then
	self._brt=self:BindFX('runcloud')
end
end

function Spike_Demon_Blue:EndWalk()
if self._brt then
	PARTICLE.Die(self._brt)
	self._brt=nil
end
end


----------------------------
o._CustomAiStates = {}
o._CustomAiStates.DemonTeleport = {
	name = "DemonTeleport",
	_lastTimeTeleport = 0,
}

function o._CustomAiStates.DemonTeleport:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	self.state = 0
	MDL.SetMeshVisibility(actor._Entity,"Object02Shape", false)
	ENTITY.EnableCollisions(actor._Entity,false)
	AddPFX("spike_demon_startteleport", 1.5 , actor.Pos)
	self._oldspeed = actor._randomizedParams.RotateSpeed
	actor.onlyWPmove = true
	actor._randomizedParams.RotateSpeed = actor._randomizedParams.RotateSpeed * 6
	self.destx = nil
	self.destx2 = nil
	self.destx3 = nil
	-- losowanie punktu z boku gracza
	if debugMarek then
		Game:Print(actor._Name.." teleport INIT")
		--Game.freezeUpdate = true
	end
	local enemy = brain.r_closestEnemy
    if enemy then
		self._lastTimeTeleport = brain._currentTime
		actor._overrideMovingCurve = aiParams.teleportSpeed

        -- TODO:obliczanie najktr. sciezki
		-- TODO:sciezki i widocznosci...
		local sign = 1
		if math.random(100) < 50 then
			sign = -1
		end

		local done = false
		local maxCount = 8
        if debugMarek then
            actor.DDEB = {}
        end
		while not done do
			local angle = FRand(75 * math.pi/180, 100 * math.pi/180) * sign
			local v = Vector:New(math.sin(enemy.angle - angle), 0, math.cos(enemy.angle - angle))		-- pozniej troche random
			v:Normalize()

   			local d = FRand(4.5,5.6)
			self.destx = enemy._groundx + v.X * d
			self.desty = enemy._groundy
			self.destz = enemy._groundz + v.Z * d
			local v2 = Vector:New(math.sin(enemy.angle - angle), 0, math.cos(enemy.angle - angle))		-- pozniej troche random
			v2:Normalize()
	       
			d = FRand(3.5,4.5)
			self.destx2 = enemy._groundx + v2.X * d
			self.desty2 = enemy._groundy
			self.destz2 = enemy._groundz + v2.Z * d
            if debugMarek then
                table.insert(actor.DDEB, {self.destx2,self.desty2+1,self.destz2,enemy._groundx,enemy._groundy+1,enemy._groundz})
            end
			
			local b,d = WORLD.LineTraceFixedGeom(self.destx2, self.desty2+1, self.destz2, enemy._groundx, enemy._groundy+1, enemy._groundz)
			if not d then
				done = true
			--	Game:Print("ok.")
			else
				sign = -sign
				maxCount = maxCount - 1
				if maxCount < 0 then
					done = true
--					Game:Print("failed..")
				end
			end
		end
		
		if maxCount >= 0 then
			local b,d,x,y,z,nx,ny,nz,he,e = WORLD.LineTrace(self.destx, self.desty+2.8, self.destz, actor._groundx,actor._groundy+2.8,actor._groundz)
			Game:Print("!!!!!!!!! teleport")
			if b then
				if debugMarek then 
					local obj = EntityToObject[e]
					Game:Print(actor._Name.." col1")
					if obj then
						Game:Print(actor._Name.." col1 "..obj._Name)
					end
				end
--				return
			end
		
			actor:WalkTo(self.destx, self.desty, self.destz, true)
			actor:PlaySound("sprint")
			actor:PlaySound("shuri")
			Game:Print(actor._Name.." teleport")
			self.active = true
			local v = Vector:New(self.destx2 - enemy._groundx, self.desty2 - enemy._groundy, self.destz2 - enemy._groundz)
			v:Normalize()
			v.X = v.X * 3
			v.Y = v.Y * 3
			v.Z = v.Z * 3
			self.destx3 = enemy._groundx + v.X
			self.desty3 = enemy._groundy + v.Y
			self.destz3 = enemy._groundz + v.Z
			local tdj = actor.s_SubClass.DeathJoints
			if tdj then
				local size = actor._SphereSize * 0.3
				for i=1,table.getn(tdj) do
					actor:BindFX(aiParams.teleportPFX, 0.1, tdj[i])
				end
			end
		end
    end
end

function o._CustomAiStates.DemonTeleport:OnUpdate(brain)
    local actor = brain._Objactor
	local aiParams = actor.AiParams
	self._lastTimeTeleport = brain._currentTime
	if self.state < 3 then
		actor:RotateToVector(Player._groundx, Player._groundy, Player._groundz)
	end
    if self.state == 0 then
		if not actor._isWalking then
			-- TODO:obliczanie najktr. sciezki
			if debugMarek then
				actor.DEBUGl4 = self.destx2
				actor.DEBUGl5 = self.desty2
				actor.DEBUGl6 = self.destz2
			end

			local b,d,x,y,z,nx,ny,nz,he,e = WORLD.LineTrace(self.destx2, self.desty2+2.8, self.destz2, actor._groundx,actor._groundy+2.8,actor._groundz)
			if not b then
				actor:WalkTo(self.destx2, self.desty2, self.destz2, true)	
			else
				if debugMarek then 
					local obj = EntityToObject[e]
					Game:Print(actor._Name.." col2")
					if obj then
						Game:Print(actor._Name.." col2 "..obj._Name)
					end
					--Game.freezeUpdate = true
				end
			end
			
			self.state = 1
			--Game.freezeUpdate = true
		end
	end

    if self.state == 1 then
		if not actor._isWalking then
			if self.destx3 then
				actor:WalkTo(self.destx3, self.desty3, self.destz3, true)
			end
			self.state = 2
		else
			if brain.r_closestEnemy then
				local dist = Dist3D(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz, actor._groundx, actor._groundy, actor._groundz)
				if dist < aiParams.attackRange * 0.6 then
					--Game:Print(actor._Name.." walk2: za blisko playera")
					--Game.freezeUpdate = true
					self.state = 2
				end	
			end
		end
    end
    
    if self.state == 2 then
        if brain.r_closestEnemy then
			local dist = Dist3D(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz, actor._groundx, actor._groundy, actor._groundz)
			if dist < aiParams.attackRange * 0.6  then
				ENTITY.SetVelocity(actor._Entity, 0,0,0)
				ENTITY.UnregisterAllChildren(actor._Entity, ETypes.ParticleFX)
				actor:Stop()
				actor:RotateToVector(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz)
				
				--Game:Print(actor._Name.." teleport anim "..(Dist3D(Player._groundx,Player._groundy,Player._groundz,actor._groundx,actor._groundy,actor._groundz)))
				self.state = 3
				return
			end
		end
        if not actor._isWalking then
            if brain.r_closestEnemy then
                local dist = Dist3D(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz, actor._groundx, actor._groundy, actor._groundz)
                if dist < aiParams.attackRange then
                    ENTITY.SetVelocity(actor._Entity, 0,0,0)
                    ENTITY.UnregisterAllChildren(actor._Entity, ETypes.ParticleFX)
                    actor:Stop()
                    actor:RotateToVector(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz)
                    --Game:Print(actor._Name.." teleport anim "..(Dist3D(Player._groundx,Player._groundy,Player._groundz,actor._groundx,actor._groundy,actor._groundz)))
                    self.state = 3
                    return
                end
            end
            self.active = false
            --Game:Print(actor._Name.." teleport FAILED "..(Dist3D(Player._groundx,Player._groundy,Player._groundz,actor._groundx,actor._groundy,actor._groundz)))
            return
        end
	end
    if self.state == 3 then
		if not actor._isRotating then
            if brain.r_closestEnemy and brain._distToNearestEnemy < aiParams.attackRange * 1.3 then
                actor:RotateToVector(brain.r_closestEnemy._groundx, brain.r_closestEnemy._groundy, brain.r_closestEnemy._groundz)
            else
                --Game:Print(actor._Name.." teleport FAILED2 nie widzi wroga ")
                self.active = false
                return
            end
            actor:SetAnim("idle1",false)
			self.state = 4
    	end
    end
    if self.state == 4 then
        if not actor._isAnimating or actor.Animation ~= "idle1" then
            self.active = false
            --Game:Print(actor._Name.." teleport end")
		end
    end
end

function o._CustomAiStates.DemonTeleport:OnRelease(brain)
    local actor = brain._Objactor
	actor._overrideMovingCurve = nil
	ENTITY.UnregisterAllChildren(actor._Entity, ETypes.ParticleFX)
	actor.onlyWPmove = false
	actor._randomizedParams.RotateSpeed = self._oldspeed
	MDL.SetMeshVisibility(actor._Entity,"Object02Shape", true)
	ENTITY.EnableCollisions(actor._Entity,true)
	AddPFX("spike_demon_endteleport", 1.5 , actor.Pos)
	
end

function o._CustomAiStates.DemonTeleport:Evaluate(brain)
	if self.active then
		return 0.8
	end
	if brain.r_closestEnemy then
        local actor = brain._Objactor
        local aiParams = actor.AiParams
            if self._lastTimeTeleport + aiParams.minimumTimeBetweenTeleport < brain._currentTime and actor._state ~= "ATTACKING" and Player._velocity < 1 then		-- dodac random do czasu
        		local enemy = brain.r_closestEnemy
				local v2 = Vector:New(math.sin(enemy.angle), 0, math.cos(enemy.angle))
       			v2:Normalize()

				self.destx = enemy._groundx - v2.X * actor._SphereSize * 2
				self.desty = enemy._groundy + 1
				self.destz = enemy._groundz - v2.Z * actor._SphereSize * 2
				local b,d = WORLD.LineTraceFixedGeom(enemy._groundx, enemy._groundy + 1, enemy._groundz, self.destx, self.desty, self.destz)
				if not d then	
					-- czy jest miejsce za celem?
					local b,d = WORLD.LineTraceFixedGeom(self.destx, self.desty + actor._SphereSize * 3, self.destz, self.destx, self.desty - actor._SphereSize * 3, self.destz)
					if d and d > actor._SphereSize*1.5 and d < actor._SphereSize * 4.5 then
						return 0.8
					end
				end
				return 0.8
			end
	end
	return 0.0
end

