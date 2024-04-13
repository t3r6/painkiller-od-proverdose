--==============================================================================
-- Define the bot states
--==============================================================================

BotStates = {
	SearchingForWaypoint = 0,
	HeadingToWaypoint = 1,
	AttackingEnemy = 2,
	WaitingToAttack = 3,
	FollowingTeammate = 4,
	ChangingWeapon = 5,
	Idle = 6,
	Talking = 7,
	Dancing = 8,
	AttackingAdvance = 9,
	AttackingRetreat = 10,
	AttackingStrafeLeft = 11,
	AttackingStrafeRight = 12,
	Typing = 13,
	WaitingForItem = 14,
	GuardingLocation = 15,
	HeadingToItem = 16
}

--==============================================================================

function Game:BotAttackTick(botclientid)

	-- ATTACK
	-- This is the main code for handling when the bot is attacking.

	local botx,boty,botz = self:GetClientPosition(botclientid)
	if(Cfg.BotAttack)then
		if(self.bot[botclientid].state ~= BotStates.ChangingWeapon)then
			if(self.bot[botclientid].state ~= BotStates.AttackingEnemy)then
				local testx,testy,testz,targetsuccess = self:GetAttackTarget(botclientid)
				if(targetsuccess)then
					self.bot[botclientid].state = BotStates.AttackingEnemy
					self.bot[botclientid].statetime = INP.GetTime() + 0.25 -- WAS 0.5
					self.bot[botclientid].targetx,self.bot[botclientid].targety,self.bot[botclientid].targetz = self:GetAttackTarget(botclientid)
					local angle = math.atan2(botx-self.bot[botclientid].targetx,botz-self.bot[botclientid].targetz)
					self.bot[botclientid].angle = angle
				end
			else
				local testx,testy,testz,targetsuccess = self:GetAttackTarget(botclientid)
				if(targetsuccess)then
					self.bot[botclientid].state = BotStates.AttackingEnemy
					self.bot[botclientid].targetx,self.bot[botclientid].targety,self.bot[botclientid].targetz = self:GetAttackTarget(botclientid)
					local angle = math.atan2(botx-self.bot[botclientid].targetx,botz-self.bot[botclientid].targetz)
					if(Cfg.BotSkill > 3) then
						self.bot[botclientid].angle = angle
					else
						-- This makes things a lot worse
						self.bot[botclientid].angle = self.bot[botclientid].angle - (self.bot[botclientid].angle - angle) * 0.6
					end
				end
			end
		end
	end
end

--==============================================================================

function Game:BotWaypointTick(botclientid)

	-- WAYPOINT CODE
	-- This is the main code for bot handling of waypoints.

	local botx,boty,botz = self:GetClientPosition(botclientid)
	if(self.bot[botclientid].state == BotStates.SearchingForWaypoint)then
		-- LOST, LOOKING FOR SOMEWHERE
		local currentwp = self:GetCurrentWaypoint(botclientid)
		local testx,testy,testz,tid,success = self:GetNextWaypoint(botclientid,currentwp)
		if(success)then
			self.bot[botclientid].state = BotStates.HeadingToWaypoint
			self.bot[botclientid].statetime = INP.GetTime() + 3
			self.bot[botclientid].targetx,self.bot[botclientid].targety,self.bot[botclientid].targetz,tid,blah = self:GetNextWaypoint(botclientid,currentwp)
			for i=1,32 do
				self.bot[botclientid].TargetID[32+1-i] = self.bot[botclientid].TargetID[32-i]
			end
			self.bot[botclientid].TargetID[1] = tid
		else
			if(Cfg.BotChat and math.floor(math.random(5000)) == 1 or Cfg.BotChat and Cfg.BotEliza and Game.PlayerStats[botclientid].LastThingHeard~=nil)then
				self.bot[botclientid].state = BotStates.Typing
				self.bot[botclientid].statetime = INP.GetTime() + 2
			else
				self.bot[botclientid].angle = self.bot[botclientid].angle
				self.bot[botclientid].state = BotStates.SearchingForWaypoint
			end
		end
	elseif(self.bot[botclientid].state == BotStates.HeadingToWaypoint or self.bot[botclientid].state == HeadingToItem)then
		-- HEADING SOMEWHERE
		local angle = math.atan2(botx-self.bot[botclientid].targetx,botz-self.bot[botclientid].targetz)
		if(angle <= -math.pi)then
			angle = angle + math.pi*2.0
		end
		if(angle > math.pi)then
			angle = angle - math.pi*2.0
		end
		self.bot[botclientid].angle = angle
		-- STOP MEGA SPIN
		if(self.bot[botclientid].angle <= -math.pi)then
			self.bot[botclientid].angle = self.bot[botclientid].angle + math.pi*2.0
		end
		if(self.bot[botclientid].angle > math.pi)then
			self.bot[botclientid].angle = self.bot[botclientid].angle - math.pi*2.0
		end
		self.bot[botclientid].rotation = 1
		if(math.random(2) > 1)then self.bot[botclientid].rotation = -1 end
		local ignore = false
		if (math.random(2) < 1) then ignore = true end
		if(Cfg.BotChat and math.floor(math.random(5000))==1 or Cfg.BotChat and Cfg.BotEliza and Game.PlayerStats[botclientid].LastThingHeard~=nil and not ignore)then
			self.bot[botclientid].state = BotStates.Typing
			self.bot[botclientid].statetime = INP.GetTime() + 2
			-- ITEM HANDLING
		elseif(self:GetCurrentWaypoint(botclientid) == self.bot[botclientid].TargetID[1])then
			self.bot[botclientid].state = BotStates.SearchingForWaypoint
			self.bot[botclientid].statetime = INP.GetTime() + 0.1

			-- ITEM HANDLING
			if(not isuc or not Cfg.BotFindItems)then
				-- REACHED TARGET
				--RawCallMethod(Game.ConsoleClientMessage,botclientid,"Reached target .."..class,0)--.." "..self:GetCurrentWaypoint(botclientid).." next target iss "..self.bot[botclientid].TargetID[1].." last target was "..self.bot[botclientid].TargetID[2].." last target was "..self.bot[botclientid].TargetID[3].." last target was "..self.bot[botclientid].TargetID[4].." last target was "..self.bot[botclientid].TargetID[5],0)
				--Game.PlayerStats[botclientid].LastThingHeard = nil
				--self.bot[botclientid].state = BotStates.WaitingForItem
				--self.bot[botclientid].statetime = INP.GetTime() + 1
			end
		end
		if ignore then Game.PlayerStats[botclientid].LastThingHeard = nil end
	end
end

--==============================================================================

function Game:BotStateTimeoutTick(botclientid)

	-- STATE TIMEOUT
	-- This function is called when a bot state expires. This can occur when a bot
	-- is unable to complete a task, or when reassessment is required.

	if(self.bot[botclientid].statetime < INP.GetTime())then
		if(self.bot[botclientid].state == BotStates.Typing)then

			-- Time to finish typing and say

			self.bot[botclientid].state = BotStates.Talking

		elseif(self.bot[botclientid].state == BotStates.WaitingToAttack)then

			-- Time to attack

			self.bot[botclientid].state = BotStates.AttackingEnemy
			self.bot[botclientid].statetime = INP.GetTime() + 1

		elseif(self.bot[botclientid].state == BotStates.AttackingEnemy)then

			-- Time to try to change weapon

			self.bot[botclientid].state = BotStates.ChangingWeapon
			self.bot[botclientid].statetime = INP.GetTime() + 1

		elseif(self.bot[botclientid].state == BotStates.HeadingToWaypoint)then

			-- Here we are trying to head to a waypoint, but didn't get there. We now ignore that
			-- waypoint in future, and look for another.

			for i=1,32 do
				self.bot[botclientid].TargetID[32+1-i] = self.bot[botclientid].TargetID[32-i]
			end
			local testx,testy,testz,tid = Game:GetNextWaypoint(botclientid, self:GetCurrentWaypoint(botclientid))
			self.bot[botclientid].TargetID[1] = tid
			self.bot[botclientid].state = BotStates.SearchingForWaypoint
			self.bot[botclientid].statetime = INP.GetTime() + 0.1
		else

			-- Default, we probably have been trying to search for a waypoint and found nothing
			-- time to forget the past a little.

			self.bot[botclientid].state = BotStates.SearchingForWaypoint
			self.bot[botclientid].statetime = INP.GetTime() + 0.1
			self:BotResetWaypoints(botclientid)
		end
	end
end

--==============================================================================

function Game:BotTick(delta)

	-- This is the main bot thinking code. It handles both heading to waypoints,
	-- and attack code and weapon selection. It also handles bot chatter.

	for j,pks in Game.PlayerStats do
		if pks and pks.Bot and pks._Entity ~= nil then -- For each bot
			local botclientid = pks.ClientID  --
			if(Game.PlayerStats[botclientid]~=nil)then
				local botx,boty,botz = self:GetClientPosition(botclientid)
				NET.ClientPingReset(botclientid)
				if not self.bot[botclientid].targetx then self.bot[botclientid].targetx = botx end
				if not self.bot[botclientid].targety then self.bot[botclientid].targety = boty end
				if not self.bot[botclientid].targetz then self.bot[botclientid].targetz = botz end
				if not botx then botx = 0 end
				if not boty then boty = 0 end
				if not botz then botz = 0 end

				self:BotStateTimeoutTick(botclientid)
				self:BotWaypointTick(botclientid)
				self:BotAttackTick(botclientid)

				for i,o in Game.Players do
					if o.ClientID == botclientid then
						local yaw = self.bot[botclientid].angle
						local arm = Dist2D(botx,botz,self.bot[botclientid].targetx,self.bot[botclientid].targetz)
						local pitch = math.atan2(arm,boty-self.bot[botclientid].targety)-math.pi/2
						if(self.bot[botclientid].state == BotStates.HeadingToWaypoint or self.bot[botclientid].state == BotStates.SearchingForWaypoint)then pitch = 0 end
						ENTITY.SetOrientation(Game.PlayerStats[botclientid]._Entity, self.bot[botclientid].angle + math.pi)

						-- STUBNOSE and blocked view
						-- Stub nose is to ensure the bot isn't trying to run into a wall. If it is it
						-- ignores the current waypoint target, and doesn't try a re-approach by
						-- remembering that waypoint.

						if(Cfg.BotCheckStubNose and self.bot[botclientid].state ~= BotStates.SearchingForWaypoint)then

							-- Construct a nose, then perform an intersection test between client head and nose tip.

							local Nose = Vector:New(0,0,0)
							Nose:Set(self.bot[botclientid].targetx-botx,self.bot[botclientid].targety-boty,self.bot[botclientid].targetz-botz)
							Nose:Normalize()
							Nose.X = Nose.X * 2.0
							Nose.Y = 0
							Nose.Z = Nose.Z * 2.0
							ENTITY.RemoveFromIntersectionSolver(self.bot[botclientid]._Entity)
							local notseenose,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx,boty,botz,botx+Nose.X,boty+Nose.Y,botz+Nose.Z)

							-- Construct an antenna from the tip of the extended nose downward a sufficient amount to see if
							-- there is a drop ahead.

							local vx,vy,vz,l  = ENTITY.GetVelocity(Game.PlayerStats[botclientid]._Entity)
							Nose:Normalize()
							local extension = (3.0+(vx*vx+vz*vz)/60)
							Nose.X = Nose.X * extension
							Nose.Y = 0
							Nose.Z = Nose.Z * extension
							local notseelongnose,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx,boty,botz,botx+Nose.X,boty,botz+Nose.Z)
							local cannotseedrop,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx+Nose.X,boty-10,botz+Nose.Z,botx+Nose.X,boty,botz+Nose.Z)
							local cannotseedrop2,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx+Nose.X*1.1,boty-10,botz+Nose.Z*1.1,botx+Nose.X*1.1,boty,botz+Nose.Z*1.1)
							local onground,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx,boty-3,botz,botx,boty,botz)
							ENTITY.AddToIntersectionSolver(self.bot[botclientid]._Entity)

							-- If we cannot see the end of our 'nose' we are facing a wall, therefore should ignore
							-- where we are trying to go.

							if notseenose or onground and not notseelongnose and not cannotseedrop and not cannotseedrop2 then
								for i=1,32 do
									self.bot[botclientid].TargetID[32+1-i] = self.bot[botclientid].TargetID[32-i]
								end
								local testx,testy,testz,tid = Game:GetNextWaypoint(botclientid, self:GetCurrentWaypoint(botclientid))
								self.bot[botclientid].targetx = botx + Nose.X
								self.bot[botclientid].targety = boty - 5
								self.bot[botclientid].targetz = botz + Nose.Z
								self.bot[botclientid].TargetID[1] = tid
								self.bot[botclientid].state = BotStates.SearchingForWaypoint
								self.bot[botclientid].statetime = INP.GetTime() + 0.1
								if onground and not notseelongnose and not cannotseedrop then self.bot[botclientid].angle = self.bot[botclientid].angle + 3.14159 end
							end
						end
						if(self.bot[botclientid].state == BotStates.HeadingToWaypoint or self.bot[botclientid].state == BotStates.AttackingEnemy and arm > 80 or self.bot[botclientid].state == BotStates.AttackingEnemy and self.bot[botclientid].weapon == 1)then
							--==============================================================================
							-- Movement details
							--==============================================================================
							if(o:IsOnGround())then
								local vx,vy,vz,l  = ENTITY.GetVelocity(Game.PlayerStats[botclientid]._Entity)
								local randomjump = false
								if math.floor(math.random(20))==1 then randomjump = true end
								if((vx*vx+vz*vz)>=118 or randomjump)then
									--==============================================================================
									-- BUNNY
									--==============================================================================
									if(Cfg.BotSkill>5 or randomjump and Cfg.BotSkill>1)then
										self:DoBotAction(o,botclientid,Actions.Jump + Actions.Forward,botx,boty,botz,yaw,pitch,delta)
									else
										self:DoBotAction(o,botclientid,Actions.Forward,botx,boty,botz,yaw,pitch,delta)
									end
								else
									--==============================================================================
									-- RUN
									--==============================================================================
									if(arm < 8 and arm>=0 and self.bot[botclientid].state == BotStates.AttackingEnemy and self.bot[botclientid].weapon ~= 1)then
										self:DoBotAction(o,botclientid,Actions.Jump + Actions.Fire,botx,boty,botz,yaw,pitch,delta)
									elseif(self.bot[botclientid].state == BotStates.AttackingEnemy and self.bot[botclientid].weapon == 1)then
										--==============================================================================
										-- ADJUST FOR SKILL
										--==============================================================================
										if(Cfg.BotSkill<10)then
											local WiggleRange = (10-Cfg.BotSkill)*0.5
											self.bot[botclientid].targetx = self.bot[botclientid].targetx + math.random(-WiggleRange,WiggleRange)
											self.bot[botclientid].targetz = self.bot[botclientid].targetz + math.random(-WiggleRange,WiggleRange)
										end
										self:DoBotAction(o,botclientid,Actions.Fire + Actions.Forward,botx,boty,botz,yaw,pitch,delta)
									elseif(arm < 3 and arm>=0 and self.bot[botclientid].state == BotStates.AttackingEnemy and self.bot[botclientid].weapon ~= 1)then
										self:DoBotAction(o,botclientid,Actions.Backward,botx,boty,botz,yaw,pitch,delta)
									else
										self:DoBotAction(o,botclientid,Actions.Forward,botx,boty,botz,yaw,pitch,delta)
									end
								end
							else
								--==============================================================================
								-- FORWARD IN THE AIR
								--==============================================================================
								if(self.bot[botclientid].state == BotStates.AttackingEnemy)then
									self:DoBotAction(o,botclientid,Actions.Fire + Actions.Forward,botx,boty,botz,yaw,pitch,delta)
								else
									self:DoBotAction(o,botclientid,Actions.Forward,botx,boty,botz,yaw,pitch,delta)
								end
							end
						elseif(self.bot[botclientid].state == BotStates.AttackingEnemy)then
							-- ATTACK
							-- ADJUST FOR SKILL
							if(Cfg.BotSkill<10)then
								local WiggleRange = (10-Cfg.BotSkill)*0.5
								self.bot[botclientid].targetx = self.bot[botclientid].targetx + math.random(-WiggleRange,WiggleRange)
								self.bot[botclientid].targetz = self.bot[botclientid].targetz + math.random(-WiggleRange,WiggleRange)
							end
							if(self.bot[botclientid].altfire)then
								if(self.bot[botclientid].straferight == false)then
									self:DoBotAction(o,botclientid,Actions.AltFire + Actions.Left,botx,boty,botz,yaw,pitch,delta)
								else
									self:DoBotAction(o,botclientid,Actions.AltFire + Actions.Right,botx,boty,botz,yaw,pitch,delta)
								end
							else
								if(self.bot[botclientid].straferight == false)then
									self:DoBotAction(o,botclientid,Actions.Fire + Actions.Left,botx,boty,botz,yaw,pitch,delta)
								else
									self:DoBotAction(o,botclientid,Actions.Fire + Actions.Right,botx,boty,botz,yaw,pitch,delta)
								end
							end
						elseif(self.bot[botclientid].state == BotStates.ChangingWeapon)then
							-- DEFAULTS, MEDIUM RANGE
							-- ADJUST FOR SKILL
							if(Cfg.BotSkill<10)then
								local WiggleRange = (10-Cfg.BotSkill)*0.5
								self.bot[botclientid].targetx = self.bot[botclientid].targetx + math.random(-WiggleRange,WiggleRange)
								self.bot[botclientid].targetz = self.bot[botclientid].targetz + math.random(-WiggleRange,WiggleRange)
							end
							if(o.EnabledWeapons[3]~=nil and o.Ammo[Weapon2Ammo[31]] > 0)then
								self.bot[botclientid].weapon = 3
								self.bot[botclientid].altfire = false
							elseif(o.EnabledWeapons[3]~=nil and o.Ammo[Weapon2Ammo[32]] > 0)then
								self.bot[botclientid].weapon = 3
								self.bot[botclientid].altfire = true
							elseif(o.EnabledWeapons[5]~=nil and o.Ammo[Weapon2Ammo[52]] > 0)then
								self.bot[botclientid].weapon = 5
								self.bot[botclientid].altfire = true
							elseif(o.EnabledWeapons[5]~=nil and o.Ammo[Weapon2Ammo[51]] > 0)then
								self.bot[botclientid].weapon = 5
								self.bot[botclientid].altfire = false
							elseif(o.EnabledWeapons[6]~=nil and o.Ammo[Weapon2Ammo[62]] > 0)then
								self.bot[botclientid].weapon = 6
								self.bot[botclientid].altfire = true
							elseif(o.EnabledWeapons[6]~=nil and o.Ammo[Weapon2Ammo[61]] > 2)then
								self.bot[botclientid].weapon = 6
								self.bot[botclientid].altfire = false
							elseif(o.EnabledWeapons[7]~=nil and o.Ammo[Weapon2Ammo[71]] > 0)then
								self.bot[botclientid].weapon = 7
								self.bot[botclientid].altfire = false
							elseif(o.EnabledWeapons[7]~=nil and o.Ammo[Weapon2Ammo[72]] > 0)then
								self.bot[botclientid].weapon = 7
								self.bot[botclientid].altfire = true
							elseif(o.EnabledWeapons[2]~=nil and o.Ammo[Weapon2Ammo[21]] > 0)then
								self.bot[botclientid].weapon = 2
								self.bot[botclientid].altfire = false
							elseif(o.EnabledWeapons[4]~=nil and o.Ammo[Weapon2Ammo[41]] > 0)then
								self.bot[botclientid].weapon = 4
								self.bot[botclientid].altfire = false
							elseif(o.EnabledWeapons[4]~=nil and o.Ammo[Weapon2Ammo[42]] > 0)then
								self.bot[botclientid].weapon = 4
								self.bot[botclientid].altfire = true
							else
								self.bot[botclientid].weapon = 1
								self.bot[botclientid].altfire = false
							end
							if(arm>20)then
								if(o.EnabledWeapons[3]~=nil and o.Ammo[Weapon2Ammo[32]] >0)then
									self.bot[botclientid].weapon = 3
									self.bot[botclientid].altfire = true
								elseif(o.EnabledWeapons[3]~=nil and o.Ammo[Weapon2Ammo[31]] > 0)then
									self.bot[botclientid].weapon = 3
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[5]~=nil and o.Ammo[Weapon2Ammo[52]] > 0)then
									self.bot[botclientid].weapon = 5
									self.bot[botclientid].altfire = true
								elseif(o.EnabledWeapons[5]~=nil and o.Ammo[Weapon2Ammo[51]] > 0)then
									self.bot[botclientid].weapon = 5
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[6]~=nil and o.Ammo[Weapon2Ammo[62]] > 9)then
									self.bot[botclientid].weapon = 6
									self.bot[botclientid].altfire = true
								elseif(o.EnabledWeapons[6]~=nil and o.Ammo[Weapon2Ammo[61]] > 2)then
									self.bot[botclientid].weapon = 6
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[7]~=nil and o.Ammo[Weapon2Ammo[71]] > 0)then
									self.bot[botclientid].weapon = 7
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[7]~=nil and o.Ammo[Weapon2Ammo[72]] > 0)then
									self.bot[botclientid].weapon = 7
									self.bot[botclientid].altfire = true
								elseif(o.EnabledWeapons[2]~=nil and o.Ammo[Weapon2Ammo[21]] > 0)then
									self.bot[botclientid].weapon = 2
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[4]~=nil and o.Ammo[Weapon2Ammo[41]] > 0)then
									self.bot[botclientid].weapon = 4
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[4]~=nil and o.Ammo[Weapon2Ammo[42]] > 0)then
									self.bot[botclientid].weapon = 4
									self.bot[botclientid].altfire = true
								else
									self.bot[botclientid].weapon = 1
									self.bot[botclientid].altfire = false
								end
								--SHORT RANGE
							elseif(arm<=6 and arm>1.5)then
								if(o.EnabledWeapons[3]~=nil and o.Ammo[Weapon2Ammo[31]] > 0)then
									self.bot[botclientid].weapon = 3
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[3]~=nil and o.Ammo[Weapon2Ammo[32]] > 0)then
									self.bot[botclientid].weapon = 3
									self.bot[botclientid].altfire = true
								elseif(o.EnabledWeapons[8]~=nil and o.Ammo[Weapon2Ammo[81]] > 0)then
									self.bot[botclientid].weapon = 8
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[5]~=nil and o.Ammo[Weapon2Ammo[51]] > 2)then
									self.bot[botclientid].weapon = 5
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[4]~=nil and o.Ammo[Weapon2Ammo[41]] > 0)then
									self.bot[botclientid].weapon = 4
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[6]~=nil and o.Ammo[Weapon2Ammo[61]] > 2)then
									self.bot[botclientid].weapon = 6
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[7]~=nil and o.Ammo[Weapon2Ammo[71]] > 0)then
									self.bot[botclientid].weapon = 7
									self.bot[botclientid].altfire = false
								elseif(o.EnabledWeapons[7]~=nil and o.Ammo[Weapon2Ammo[72]] > 0)then
									self.bot[botclientid].weapon = 7
									self.bot[botclientid].altfire = true
								elseif(o.EnabledWeapons[2]~=nil and o.Ammo[Weapon2Ammo[21]] > 0)then
									self.bot[botclientid].weapon = 2
									self.bot[botclientid].altfire = false
								else
									self.bot[botclientid].weapon = 1
									self.bot[botclientid].altfire = false
								end
								--POINT BLANK
							elseif(arm<=1.5)then
								self.bot[botclientid].weapon = 1
								self.bot[botclientid].altfire = false
								if(math.random(2)>1)then self.bot[botclientid].altfire = true end
							end
							self:DoBotAction(o,botclientid,Actions.None,botx,boty,botz,yaw,pitch,delta)
							-- RANDOM WEAPON USE
							o:TryToChangeWeapon( self.bot[botclientid].weapon )
							--if MPCfg.GameMode ~= "Voosh" then o._CurWeaponIndex = self.bot[botclientid].weapon end

							self.bot[botclientid].state = BotStates.HeadingToWaypoint
							self.bot[botclientid].statetime = INP.GetTime() + 2

							self.bot[botclientid].straferight = true
							if(math.random(2)>1)then self.bot[botclientid].straferight = false end

						elseif(self.bot[botclientid].state == BotStates.Talking)then
							-- STAND
							local tauntcount = 0
							for i,taunt in Cfg.BotTaunts do
								tauntcount = tauntcount + 1
							end
							local txt = Cfg.BotTaunts[math.floor(math.random(1,tauntcount-1))]
							if(Cfg.BotEliza and not Game.PlayerStats[botclientid].LastThingHeard)then
							end
							if(Cfg.BotEliza and Game.PlayerStats[botclientid].LastThingHeard)then
								local reply = Eliza(Game.PlayerStats[botclientid].LastThingHeard)
								txt = string.lower(reply)
								Game.PlayerStats[botclientid].LastThingHeard = nil
							end
							if(math.random(6)>1 and false)then
								Game.PlayerStats[botclientid].LastThingHeard = nil
								self:DoBotAction(o,botclientid,Actions.SelectBestWeapon1,botx,boty,botz,yaw,pitch,delta)
								return
							end
							for i,y in Game.PlayerStats do
								if y.ClientID == ServerID then
									RawCallMethod(Game.ConsoleClientMessage,botclientid,txt,0)
								else
									SendNetMethod(Game.ConsoleClientMessage, y.ClientID, true, true, botclientid ,txt,0)
								end
							end
							self:DoBotAction(o,botclientid,Actions.SelectBestWeapon1,botx,boty,botz,yaw,pitch,delta)
							self.bot[botclientid].state = BotStates.Idle
							self.bot[botclientid].statetime = INP.GetTime() + 3
						else
							self:DoBotAction(o,botclientid,Actions.None,botx,boty,botz,yaw,pitch,delta)
							--self:DoBotAction(o,botclientid,Actions.SelectBestWeapon1,botx,boty,botz,yaw,pitch,delta)
						end
					end
				end
			end
		end
	end
end

--==============================================================================

function Game:GetAttackTarget(botclientid)

	-- This function handles the bot attacking and mainly deals with the aiming code
	-- Targeting is based on time-to-target, and is approximated. Targeting requires
	-- knowledge about the weapon hitscan or projectile behaviour. Where not defined
	-- it assumes hitscan.

	local nearestx = 0
	local nearesty = 0
	local nearestz = 0
	local min = 1000000
	local botx,boty,botz = ENTITY.PO_GetPawnHeadPos(self.PlayerStats[botclientid]._Entity)
	local targetsuccess = false
	for i, ps in Game.PlayerStats do
		if(ps and ps~=nil and ps._Entity~=nil)then
			if(ps.ClientID ~= botclientid)then
				if(ps.Spectator == 0)then
					if(Game.PlayerStats[botclientid].Team ~= ps.Team and MPGameRules[MPCfg.GameMode] and MPGameRules[MPCfg.GameMode].Teams or not (MPGameRules[MPCfg.GameMode] and MPGameRules[MPCfg.GameMode].Teams)) then
						local mex,mey,mez = ENTITY.PO_GetPawnHeadPos(ps._Entity)
						local distance = Dist3D(botx,boty,botz,mex,mey,mez)
						if(distance<min and distance<80)then
							local angle = math.atan2(botx-mex,botz-mez)
							ENTITY.RemoveFromIntersectionSolver(self.bot[botclientid]._Entity)
							local b,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx,boty,botz,mex,mey,mez)
							ENTITY.AddToIntersectionSolver(self.bot[botclientid]._Entity)
							if(not b)then
								local weaponclass =0 -- 0 = hitscan, 1 = aimatfeet, 2 = gravityaffected
								local time = distance / 40.0 -- weapon speed
								local vx,vy,vz,l = ENTITY.GetVelocity(ps._Entity)
								local wep = self.bot[botclientid].weapon
								local alt = self.bot[botclientid].altfire
								local weaponspeed = 40.0

								-- MISSILES - ROCKETS, SHURIKENS, FREEZE, PAINKILLER2
								if(wep==3 and alt==false)then
									weaponspeed = 40.0
								elseif(wep==5 and alt==false)then
									weaponspeed = 50.0
								elseif(wep==1 and alt==true)then
									weaponspeed = 30.0
								elseif(wep==2 and alt==true)then
									weaponspeed = 50.0

									-- GRAVITY AFFECTED - STAKE, BOLT, GRENADES
								elseif(wep==4 and alt==false)then
									weaponspeed = 100.0 --70.0
								elseif(wep==7 and alt==false)then
									weaponspeed = 70.0
								elseif(wep==4 and alt==false)then
									weaponspeed = 190.0
								elseif(wep==4 and alt==true)then
									weaponspeed = 28.0 -- also has 8 up
								end

								local k = (mex-botx)
								local l = (mey-boty)
								local m = (mez-botz)
								local A = vx*vx + vy*vy + vz*vz - weaponspeed*weaponspeed
								local B = 2.0*(k*vx + l*vy + m*vz)
								local C = k*k + l*l + m*m
								if(A~=0 and B*B > 4*A*C)then
									time = (-B + math.sqrt(B*B-4.0*A*C))/(2.0*A)
									if(time<0)then time = (-B - math.sqrt(B*B-4.0*A*C))/(2.0*A) end
								end

								ENTITY.RemoveFromIntersectionSolver(ps._Entity)
								local isFloor,d,wx,wy,wz = WORLD.LineTraceFixedGeom(mex,mey,mez,mex,mey-2,mez) --2.21
								ENTITY.AddToIntersectionSolver(ps._Entity)

								if(isFloor)then
									-- MISSILES - ROCKETS, SHURIKENS, FREEZE, PAINKILLER2
									if(wep==3 and alt==false or wep==7 and alt==false or wep==1 and alt==true or wep==2 and alt==true)then
										nearestx = mex + vx*time
										nearestz = mez + vz*time
										if(wep==3 and alt==false)then
											nearesty = mey - 2.15 --+ vy*time
											if(nearesty>boty)then
												nearesty = mey
											end

											-- We now test to see if we can actually see the target point. If we can't, we
											-- are probably trying to fire through a wall, in which case the best option
											-- is to fire at where we can see the other player.

											ENTITY.RemoveFromIntersectionSolver(ps._Entity)
											ENTITY.RemoveFromIntersectionSolver(self.PlayerStats[botclientid]._Entity)
											local blockedview,d,wx,wy,wz = WORLD.LineTraceFixedGeom(nearestx,nearesty,nearestz,botx,boty,botz)
											ENTITY.AddToIntersectionSolver(ps._Entity)
											ENTITY.AddToIntersectionSolver(self.PlayerStats[botclientid]._Entity)

											if(blockedview) then
												nearestx = mex
												nearestz = mez
											end

										else
											nearesty = mey - 0.8
										end

										-- GRAVITY AFFECTED - STAKE, BOLT, GRENADES
									elseif(wep==4 and alt==true or wep==7 and alt==false or wep==4 and alt==false)then
										nearestx = mex + vx*time
										nearestz = mez + vz*time
										nearesty = mey - 1.1 + 0.5*Tweak.GlobalData.MPGravity*time*time
									else

										-- HITSCAN - CHAINGUN, MACHINEGUN, SHOTGUN, ELECTRO, PAINKILLER1
										nearestx = mex
										nearesty = mey
										nearestz = mez
									end
								else
									-- MISSILES - SHURIKENS, ROCKETS, FREEZE, PAINKILLER2
									if(wep==3 and alt==false or wep==1 and alt==true or wep==2 and alt==true)then --or wep==5 and alt==false
										nearestx = mex + vx*time
										nearestz = mez + vz*time
										if(wep==3 and alt==false)then
											nearesty = mey - 0.65 + vy*time - 0.5*Tweak.GlobalData.MPGravity*time*time
											if(nearesty < boty - 2.15 )then
												nearesty = mey - 2.15
											end
										else
											nearesty = mey - 0.8 + vy*time - 0.5*Tweak.GlobalData.MPGravity*time*time
											if(nearesty < boty - 0.8 )then
												nearesty = boty - 0.8
											end
										end

										-- GRAVITY AFFECTED - STAKE, BOLT, GRENADES
									elseif(wep==4 and alt==true or wep==7 and alt==false or wep==4 and alt==false)then
										nearestx = mex + vx*time
										nearestz = mez + vz*time
										nearesty = mey - 0.3 -- TARGET FALLING VELOCITY CANCELS
										if(nearesty < boty - 2.2 )then
											nearesty = mey - 0.3 + 0.5*Tweak.GlobalData.MPGravity*time*time
										end
									else

										-- HITSCAN - CHAINGUN, MACHINEGUN, SHOTGUN, ELECTRO, PAINKILLER1
										nearestx = mex
										nearesty = mey
										nearestz = mez
									end
								end

								targetsuccess  = true
								min = distance
							end
						end
					end
				end
			end
		end
	end
	return nearestx,nearesty,nearestz,targetsuccess
end

--==============================================================================

function Game:DoBotAction(o,botclientid,action,botx,boty,botz,yaw,pitch,delta)

	-- This function does the required bot action (normally movement or firing)

	o:SetupAction(botclientid,action,pitch,yaw)
	o.ForwardVector:Set(self.bot[botclientid].targetx-botx,self.bot[botclientid].targety-boty,self.bot[botclientid].targetz-botz)
	o.ForwardVector:Normalize()
	PLAYER.BotAction(Game.PlayerStats[botclientid]._Entity,action,yaw,pitch,delta)

end

--==============================================================================

function Game:GetClientPosition(botclientid)

	-- This function returns the position of the bot's head

	local x = 0
	local y = 0
	local z = 0
	if Game.PlayerStats[botclientid]~=nil and Game.PlayerStats[botclientid]._Entity~=nil then
		x,y,z = ENTITY.PO_GetPawnHeadPos(Game.PlayerStats[botclientid]._Entity)
	end
	return x,y,z
end

--==============================================================================
if not Cfg.BotWaypointRange then Cfg.BotWaypointRange = 0.6 end
--==============================================================================

function Game:GetCurrentWaypoint(botclientid)

	-- This function returns the index of the waypoint closest to the bot which it is
	-- currently targeting.

	local x,y,z = self:GetClientPosition(botclientid)
	for i,locitem in Waypoint.Position do
		if(Game.bot[botclientid].targetx==locitem.x and Game.bot[botclientid].targety==locitem.y and Game.bot[botclientid].targetz==locitem.z) then
			if(Dist2D(Game.bot[botclientid].targetx,Game.bot[botclientid].targetz,x,z)<=Cfg.BotWaypointRange)then     -- Dist3D(x,y,z,locitem.x,locitem.y,locitem.z)<1 or WAS 0.6
				return i
			end
		end
	end

	-- NON WAYPOINT DETECTION
	-- Should the bot be targeting a point rather than a waypoint, this resets the bot
	-- state to search mode.

	if(Dist2D(x,z,Game.bot[botclientid].targetx,Game.bot[botclientid].targetz)<1)then
		self.bot[botclientid].state = BotStates.SearchingForWaypoint
		self.bot[botclientid].statetime = INP.GetTime()
		return (300+math.floor(math.random(1000)))
	end
	return -1
end

--============================================================================

function Game:GetNextWaypoint(botclientid, currentwp)
	local areaname = "Unknown"
	local min = 1000000
	local botx,boty,botz = ENTITY.PO_GetPawnHeadPos(Game.PlayerStats[botclientid]._Entity)
	local nearestx = 0
	local nearesty = 0
	local nearestz = 0
	local success = false
	local wpokay = true

	-- Look through entire waypoint list
	-- In checking which waypoints we can consider, we firstly check through the bot's
	-- list of recently visited waypoints. If it cannot remember the point, we proceed.

	local wayangle = 0

	for i,locitem in Waypoint.Position do
		if(i ~= currentwp)then
			wpokay = true
			for j=1,32 do
				if(wpokay == true)then
					if(i==self.bot[botclientid].TargetID[j])then
						wpokay = false
					end
				end
			end
			if(wpokay)then

				-- Calculate the waydistanceangle
				-- To ensure that the bot picks sensible waypoints to avoid sharp turns
				-- or picking waypoints too far away, or too high above or below it,
				-- a combined value system is used to weight each waypoint.

				local distance = Dist3D(botx,boty,botz,locitem.x,locitem.y,locitem.z)
				wayangle = math.atan2(botx-locitem.x,botz-locitem.z)-self.bot[botclientid].angle
				if(wayangle < -math.pi)then
					wayangle = wayangle + math.pi*2.0
				end
				if(wayangle >= math.pi)then
					wayangle = wayangle - math.pi*2.0
				end
				distance = (math.sqrt(wayangle*wayangle)+1) * distance * (math.abs(boty-locitem.y)+1)
				if(distance < min and math.abs(boty-locitem.y)<7)then
					local b,d,wx,wy,wz = WORLD.LineTraceFixedGeom(locitem.x,locitem.y,locitem.z,botx,boty,botz,yaw,pitch,delta)
					if(not b)then
						areaname = locitem.location
						nearestx = locitem.x
						nearesty = locitem.y
						nearestz = locitem.z
						success = true
						targetid = i
						min = distance

					end
				end
			end
		end
	end
	return nearestx,nearesty,nearestz,targetid,success
end

--=======================================================================

function Console:Cmd_KICKBOT()

	-- This function removes a bot from the game

	if Game.GMode == GModes.SingleGame then return end
	if Game:IsServer() then
		local botcount = 0
		local bluecount = 0
		local redcount = 0
		for i,ps in Game.PlayerStats do
			if ps.Bot then
				botcount = botcount + 1
			end
		end
		if(botcount>0)then
			local base = 150
			local BotID = base + botcount
			Game.OnPlayerLeaveGame(BotID-1)
			Game.PlayerStats[BotID-1]=nil
		end
	end
end

--=======================================================================

function Console:Cmd_KICKALLBOTS()

	-- This function removes all bots

	local botcount = 0
	for i,ps in Game.PlayerStats do
		if ps.Bot then
			botcount = botcount + 1
		end
	end
	for i=0,botcount+1 do
		Console:Cmd_KICKBOT()
	end
end

--=======================================================================

function Console:Cmd_BOTMINPLAYERS(number)

	-- Sets the minimum number of players including bots expected on the server.

	if Game.GMode == GModes.SingleGame then return end
	if Game:IsServer() then
		if(number==nil)then
			CONSOLE.AddMessage("Syntax: botminplayers <number>")
			CONSOLE.AddMessage("Help: Sets the minimum number of players to appear on the server, before which bots are added. If set equal to Cfg.MaxPlayers, the bots will always leave one space for new players. If set greater than Cfg.MaxPlayers, bots will leave a space only if there are spectators present.")
			CONSOLE.AddMessage("State: Cfg.BotMinPlayers is currently ".. tonumber(Cfg.BotMinPlayers))
		else
			Cfg.BotMinPlayers = tonumber(number)
			CONSOLE.AddMessage("Cfg.BotMinPlayers is now ".. tonumber(number))
		end
	end
end

--=======================================================================

function Console:Cmd_BOTSKILL(number)

	-- Sets the skill level of the code affecting movement and aim

	if Game.GMode == GModes.SingleGame then return end
	if Game:IsServer() then
		if(number==nil)then
			CONSOLE.AddMessage("Cfg.BotSkill is "..Cfg.BotSkill)
		else
			Cfg.BotSkill = tonumber(number)
			CONSOLE.AddMessage("Cfg.BotSkill is now ".. tonumber(Cfg.BotSkill))
		end
	end
end

--=======================================================================

function Console:Cmd_ADDBOT()

	-- This function adds a bot to the game

	if Game.GMode == GModes.SingleGame then return end
	if Game:IsServer() and not (MPCfg.GameState == GameStates.Playing and MPCfg.ForceSpec == true) then
		local botcount = 0
		local bluecount = 0
		local redcount = 0
		for i,ps in Game.PlayerStats do
			if ps.Team == 0 and ps.Spectator == 0 then
				bluecount = bluecount + 1
			end
			if ps.Team == 1 and ps.Spectator == 0 then
				redcount = redcount + 1
			end
			if ps.Bot then
				botcount = botcount + 1
			end
		end
		local team = math.floor(math.random(0,1))
		if(redcount < bluecount) then team = 1 end
		if(redcount > bluecount) then team = 0 end

		-- TOO MANY PLAYERS
		if(redcount + bluecount >= Cfg.MaxPlayers)then CONSOLE.AddMessage("Too many players. Increase Cfg.MaxPlayers") return end
		if Cfg.GameMode == "Duel" and redcount + bluecount >= 2 then CONSOLE.AddMessage("Too many players.")return end

		local base = 150
		local BotID = base + botcount
		name = "Bot-"..BotID
		local namecount = 1
		for nnn in Cfg.BotNames do
			if(nnn~=nil)then namecount = namecount + 1 end
		end

		local name = Cfg.BotNames[math.floor(math.random(namecount-1))]

		if(name==nil)then name = "Bot-"..BotID end
		if(Game.bot[BotID] and Game.bot[BotID].Name~=nil)then
			name = Game.bot[BotID].Name
		end

		Game.bot[BotID]={angle=0,speed=0,rotation=1,state=0,mex=0,mey=0,mez=0,statetime=INP.GetTime(),TargetID={}, altfire=false, weapon = 3, straferight=false}
		Game.bot[BotID].Name = name

		Game.NewPlayerRequest(BotID,name,math.floor(math.random(1,4)),team,0,0)
		Game.PlayerRespawnRequest(BotID)

		for j=1,32 do
			Game.bot[BotID].TargetID[j]= -2
		end
		if(Game.PlayerStats[BotID]~=nil)then
			Game.PlayerStats[BotID].Bot = true
			Game.SetStateRequest(BotID,1)
		end
	end
end

--=======================================================================

function Game:CheckBotCount()

	-- This function is called to check there are the correct number of bots
	-- on the server against botminplayers. It will always leave space for
	-- new players to join, either from spectator mode or from network.
	-- The only way to override this is to set botminplayers higher than
	-- maxplayers.

	if Game:IsServer() then
		local botcount = 0
		local bluecount = 0
		local redcount = 0
		local speccount = 0
		local playercount = 0

		for i,ps in Game.PlayerStats do
			if ps.Team == 0 and ps.Spectator == 0 then
				bluecount = bluecount + 1
			end
			if ps.Team == 1 and ps.Spectator == 0 then
				redcount = redcount + 1
			end
			if ps.Bot and ps.Spectator == 0 then
				botcount = botcount + 1
			end
			if ps.Spectator == 1 then
				speccount = speccount + 1
			end
		end
		local playercount = bluecount + redcount

		-- AUTO ADDBOT/KICKBOT LOGIC

		local maxplayers = Cfg.MaxPlayers
		if Cfg.GameMode == "Duel" then maxplayers = 2 end

		if( Cfg.BotMinPlayers < maxplayers and playercount < maxplayers-1 and playercount < Cfg.BotMinPlayers ) then Console:Cmd_ADDBOT() return end
		if( Cfg.BotMinPlayers < maxplayers and (playercount > maxplayers-1 or playercount > Cfg.BotMinPlayers) ) and botcount > 0 then Console:Cmd_KICKBOT() return end

		if( Cfg.BotMinPlayers == maxplayers and playercount < maxplayers-1 and playercount < Cfg.BotMinPlayers) then Console:Cmd_ADDBOT() return end
		if( Cfg.BotMinPlayers == maxplayers and playercount > maxplayers or playercount > Cfg.BotMinPlayers) and botcount > 0 then Console:Cmd_KICKBOT() return end

		if( Cfg.BotMinPlayers == maxplayers+1 and playercount < maxplayers-1 and playercount < Cfg.BotMinPlayers) then Console:Cmd_ADDBOT() return end
		if( Cfg.BotMinPlayers == maxplayers+1 and playercount < maxplayers and playercount < Cfg.BotMinPlayers and speccount==0 ) then Console:Cmd_ADDBOT() return end
		if( Cfg.BotMinPlayers == maxplayers+1 and playercount > maxplayers-1 and speccount > 0) and botcount > 0 then Console:Cmd_KICKBOT() return end

		if( Cfg.BotMinPlayers > maxplayers+1 and playercount < maxplayers and playercount < Cfg.BotMinPlayers) then Console:Cmd_ADDBOT() return end
		if( Cfg.BotMinPlayers > maxplayers+1 and playercount > maxplayers ) and botcount > 0 then Console:Cmd_KICKBOT() return end
	end

	for j,pks in Game.PlayerStats do
		if pks and pks.Bot then
			local botclientid = pks.ClientID
			Game.PlayerRespawnRequest(botclientid)
		end
	end
end

--============================================================================

function Game:GetNearestItem(botclientid)

	-- Finds the nearest desired item.

	if true then return 0,0,0,false end
	local nearestx = 0
	local nearesty = 0
	local nearestz = 0
	local min = 1000000
	local botx,boty,botz = ENTITY.PO_GetPawnHeadPos(self.PlayerStats[botclientid]._Entity)
	local targetsuccess = false
	local items = GObjects:GetAllObjectsByClass("CItem")
	local waittime = 0
	for i,o in items do
		local mex = o.Pos.X
		local mey = o.Pos.Y
		local mez = o.Pos.Z
		local distance = Dist3D(botx,boty,botz,mex,mey,mez)
		if(distance<min and distance<10 and math.abs(mey-boty)<4 and o._Rst <= 0)then
			-- HERE WE NEED ITEM VALUING!

			-- IS AMMO AND I HAVE NO AMMO
			-- IS HEALTH AND I HAVE NO HEALTH
			-- IS ARMOUR AND I HAVE NO ARMOUR
			-- IS POWERUP OR FLAG

			--  EACH SHOULD HAVE A PRIORITY

			-- CAN BOT REACH ITEM?

			-- SHOULD BOT WAIT FOR ITEM?
			ENTITY.RemoveFromIntersectionSolver(self.bot[botclientid]._Entity)
			local b,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx,boty,botz,mex,mey,mez)
			ENTITY.AddToIntersectionSolver(self.bot[botclientid]._Entity)
			if(not b)then
				nearestx = mex
				nearesty = mey
				nearestz = mez
				targetsuccess  = true
				min = distance
				class = o._Name
			end
		end
	end
	return nearestx,nearesty,nearestz,targetsuccess,class,waittime
end

--============================================================================

function Game:BotResetWaypoints(botclientid)

	-- This function is called if the waypoint memory is full and we want to forget
	-- the oldest waypoint. Typically if a bot can only see remembered waypoints
	-- then it has either run a complete loop, or come into a dead end.
	-- We favour that it has made a complete loop, rather than to assume to
	-- immediately backtrack. Ultimately once it forgets all waypoints it will
	-- backtrack from a dead end anyway.

	self.bot[botclientid].rotation = 1
	if(math.random(2) > 1)then self.bot[botclientid].rotation = -1 end
	self.bot[botclientid].state = BotStates.SearchingForWaypoint
	local changedone = false
	for i=1,32 do
		if(not changedone)then
			if(self.bot[botclientid].TargetID[32+1-i]~=-2)then
				self.bot[botclientid].TargetID[32+1-i] = -2
				changedone = true
			end
		end
	end

	-- ROAM MODE - get us out of trouble when we cannot see any waypoints!
	-- If we have reset all waypoints, and we still cannot see any, we roam
	-- For this we create a scatter of random points in a 20x20 square around the bot
	-- We then give the ones we can see from the bot's viewpoint a view angle rating
	-- We head towards the one with the smallest viewangle (so smallest change of course)
	-- More points means we are more likely to head in straight lines, which usually means
	-- we track around the outside of rooms.

	if(Cfg.BotRoam and not changedone)then
		local min = 100000
		for i=1,10 do
			local botx,boty,botz = ENTITY.PO_GetPawnHeadPos(self.PlayerStats[botclientid]._Entity)
			local testx = botx + math.random(-10000,10000)/1000
			local testy = boty
			local testz = botz + math.random(-10000,10000)/1000
			local wayangle = math.atan2(botx-testx,botz-testz)-self.bot[botclientid].angle
			if(wayangle < -math.pi)then
				wayangle = wayangle + math.pi*2.0
			end
			if(wayangle >= math.pi)then
				wayangle = wayangle - math.pi*2.0
			end
			ENTITY.RemoveFromIntersectionSolver(self.bot[botclientid]._Entity)
			local b,d,wx,wy,wz = WORLD.LineTraceFixedGeom(botx,boty,botz,testx,testy,testz)
			ENTITY.AddToIntersectionSolver(self.bot[botclientid]._Entity)
			if(not b and wayangle*wayangle < min)then
				self.bot[botclientid].targetx = testx
				self.bot[botclientid].targety = testy
				self.bot[botclientid].targetz = testz
				min = wayangle*wayangle
			end
		end
		self.bot[botclientid].state = BotStates.HeadingToWaypoint
		self.bot[botclientid].statetime = INP.GetTime()	+ 2
	end
end

--============================================================================

function Console:Cmd_ADDWAYPOINT(location,l1,l2,l3,l4,l5)

	-- Adds a waypoint

	if(location==nil)then location = "Waypoint" end

	if(l1~=nil)then location = location .." ".. l1 end
	if(l2~=nil)then location = location .." ".. l2 end
	if(l3~=nil)then location = location .." ".. l3 end
	if(l4~=nil)then location = location .." ".. l4 end
	if(l5~=nil)then location = location .." ".. l5 end

	local me = -99
	for i,ps in Game.PlayerStats do
		if(Player == Game:FindPlayerByClientID(ps.ClientID))then
			me = ps.ClientID
		end
	end
	if(me==-99)then return end
	local x = 0
	local y = 0
	local z = 0
	if Game.PlayerStats[me] and Game.PlayerStats[me]._Entity and Game.PlayerStats[me]._Entity ~=0 then
		x,y,z = ENTITY.PO_GetPawnHeadPos(Game.PlayerStats[me]._Entity)
	end
	local Waypointfile = "../Data/Waypoints/"
	local mapname = Lev.Map
	if(mapname==nil)then return end
	Waypointfile = Waypointfile .. string.gsub (mapname,"(%a+).mpk", "%1")  .. ".bwp"
	local file = io.open(Waypointfile,"a")
	if not file then return end
	local txt = location..","..x..","..y..","..z..'\n'
	file:write(txt)
	CONSOLE.AddMessage("Added Location.")
	io.close(file)
	Waypoint.Position = {}
	Waypoint:Load(mapname)
end

--============================================================================

function Console:Cmd_BOTCHAT(enable)

	-- Toggles bot chatting

	if(enable=="1")then Cfg.BotChat = true CONSOLE.AddMessage("BotChat is now enabled.")  return end
	if(enable=="0")then Cfg.BotChat = false CONSOLE.AddMessage("BotChat is now disabled.") return end
	CONSOLE.AddMessage("Syntax: BotNoBotChatChat [1/0]")
	CONSOLE.AddMessage("Help: Toggles bot talking.")
	if Cfg.BotChat then CONSOLE.AddMessage("State: BotChat is currently on.")
	else CONSOLE.AddMessage("State: BotChat is currently off.")
	end
end

--============================================================================

function Console:Cmd_BOTATTACK(enable)

	-- Toggles bot attacking

	if(enable=="1")then Cfg.BotAttack = true CONSOLE.AddMessage("BotAttack is now enabled.")  return end
	if(enable=="0")then Cfg.BotAttack = false CONSOLE.AddMessage("BotAttack is now disabled.") return end
	CONSOLE.AddMessage("Syntax: BotAttack [1/0]")
	CONSOLE.AddMessage("Help: Toggles bots attack.")
	if Cfg.BotAttack then CONSOLE.AddMessage("State: BotAttack is currently on.")
	else CONSOLE.AddMessage("State: BotAttack is currently off.")
	end
end

--============================================================================

function Console:Cmd_BOTROAM(enable)

	-- Toggles bot roaming

	if(enable=="1")then Cfg.BotRoam = true CONSOLE.AddMessage("BotRoam is now enabled.")  return end
	if(enable=="0")then Cfg.BotRoam = false CONSOLE.AddMessage("BotRoam is now disabled.") return end
	CONSOLE.AddMessage("Syntax: BotRoam [1/0]")
	CONSOLE.AddMessage("Help: Toggles bots roaming.")
	if Cfg.BotRoam then CONSOLE.AddMessage("State: BotRoam is currently on.")
	else CONSOLE.AddMessage("State: BotRoam is currently off.")
	end
end
