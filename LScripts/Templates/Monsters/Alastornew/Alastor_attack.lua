function Alastor_attack._CustomAiStates.groundAttackAlastor:OnUpdate(brain)
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
--			Game:Print("GRACZ DYSTANS: "..brain._distToNearestEnemy) 
		--[[	if brain._distToNearestEnemy < self.minAttackDistance then
					local v = Vector:New(Player._groundx - actor._groundx, 0, Player._groundz - actor._groundz)
					v:Normalize()
					local angleToPlayer = math.atan2(v.X, v.Z)
					local aDist = AngDist(actor.angle, angleToPlayer)
--					Game:Print("GRACZ ANGLE: "..(aDist*180/math.pi)) 

					if math.abs(aDist) > 90.0 * math.pi/180 and brain._distToNearestEnemy > 10 then
						actor:RotateToVectorWithAnim(Player._groundx,Player._groundy,Player._groundz)
						return
					end
			else--]]
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
				--	self.a = actor._groundx
				--	self.c = actor._groundz
				--	Game:Print("player at "..dist.." dy = "..(actor._groundx - Player._groundx))
				actor._canRotate = false
				actor._moveWithAnimationDoNotUpdateAngle = false

				-- sprawdzanie czy nie spadnie w ataku
				local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
				v:Normalize()
				v:MulByFloat(self.minAttackDistance + 4.0)		-- narazie tyle dla wszystkich animacji
				local distAtEnd = math.sqrt((actor._groundx + v.X)*(actor._groundx + v.X) + (actor._groundz + v.Z)*(actor._groundz + v.Z))

				Game:Print("brain._distToNearestEnemy "..brain._distToNearestEnemy)

					if brain._distToNearestEnemy < self.atak1minDistance then		-- przedzial miedzy 35 i 40 jest niejsany
						actor:SetAnim("atak2", false)
						self.attackMode = "atak2"
				--		Game:Print("!!!!!!!!!atak2")
						return
					end
				if (math.random(100) < 25 and dist < 40) or (distSelf > actor.walkdist) then		-- dist - odl. gracza od srodka
					actor:WalkTo(Player._groundx, Player._groundy, Player._groundz, false, 5)
					--Game:Print("walkTo PLAYER")
				end
--			end
		end
	else
		if self.attackMode == "WALKAWAY" then
			if self.mode == 0 and not actor._isRotating then
				actor:WalkTo(0,actor._groundy,0, false, FRand(26,42))
				self.mode = 1
			end
			if self.mode == 1 and not actor._isWalking then
				Game:Print("koniec walkaway")
				self.attackMode = false
			end
			return
		end
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

function Alastor_attack:Stomp(joint, modif)
	self:FootFX(joint)
	Player:OnDamage(self.attackDamage, self)
	
end
