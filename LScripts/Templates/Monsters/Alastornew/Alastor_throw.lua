function Alastor_throw._CustomAiStates.groundAttackAlastor:OnUpdate(brain)
	local actor = brain._Objactor
    local aiParams = actor.AiParams
	
	if not self.attackMode then
		if actor._ABdo then
			self.active = false
			actor:Stop()
			return
		end
		--if true then return end

		if not actor._isRotating and not actor._isWalking then
			if debugMarek then Game:Print("GRACZ DYSTANS: "..brain._distToNearestEnemy) end
				local v = Vector:New(Player._groundx - actor._groundx, 0, Player._groundz - actor._groundz)
				v:Normalize()
				local angleToPlayer = math.atan2(v.X, v.Z)
				local aDist = AngDist(actor.angle, angleToPlayer)

				if math.abs(aDist) > 30.1 * math.pi/180 then
					actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
					return
				end

				local dist = Dist2D(Player._groundx, Player._groundz, 0,0)
				local distSelf = Dist2D(actor._groundx, actor._groundz, 0,0)
				if debugMarek then
					self.a = actor._groundx
					self.c = actor._groundz
					Game:Print("player at "..dist.." dy = "..(actor._groundx - Player._groundx))
				end
				actor._canRotate = false
				actor._moveWithAnimationDoNotUpdateAngle = false

				-- sprawdzanie czy nie spadnie w ataku
				local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
				v:Normalize()
				v:MulByFloat(self.minAttackDistance + 4.0)		-- narazie tyle dla wszystkich animacji
				local distAtEnd = math.sqrt((actor._groundx + v.X)*(actor._groundx + v.X) + (actor._groundz + v.Z)*(actor._groundz + v.Z))

				if brain._distToNearestEnemy > self.atak1minDistance then
						if ((math.random(100) < 6 and brain._distToNearestEnemy < 40) or (brain._distToNearestEnemy > 23)) and (brain._distToNearestEnemy > 6) then
							actor:WalkTo(Player._groundx, Player._groundy, Player._groundz, false,5)
							--Game:Print("walkTo PLAYER")
						else
							actor:SetAnim("atak1", false)
							self.attackMode = "atak1"
							--Game:Print("atak1")
							return
						end
				end
						if (math.random(100) < 25 and dist < 40) or (distSelf > actor.walkdist)  and (brain._distToNearestEnemy > 6)
							then		-- dist - odl. gracza od srodka
							actor:WalkTo(Player._groundx, Player._groundy, Player._groundz, false, 5)
							Game:Print("walkTo PLAYER")
						end
			end
	else
		if not actor._isAnimating then
			self.attackMode = false
			actor._moveWithAnimationDoNotUpdateAngle = true
		else
			if actor._canRotate then
				actor:RotateToVector(Player._groundx,Player._groundy,Player._groundz)
			else
				if actor._isRotating then
					actor:FullStop()
				end
			end
		end
	end
end
