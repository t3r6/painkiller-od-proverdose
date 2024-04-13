function Chopper_woman:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastRollTime = FRand(-3,0)
end

function Chopper_woman:OnCreateEntity()

	self:BindSound("actor/mw_chopper_woman/rotator2",8,30,true)
	self:BindSound("actor/mw_chopper_woman/motor1",8,30,true)
	self:BindSound("actor/mw_chopper_woman/steam",8,20,true)
	self:BindSound("actor/mw_chopper_woman/motor2",8,30,true)

end

function Chopper_woman:CustomOnDeath()
    ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
end

function o:Whitesmoke()
		PARTICLE.Die(self._komkour1)
		self._komkour1	= self:BindFX("whitesmoke")
end
function o:Darksmoke()
		PARTICLE.Die(self._komkour1)
		self._komkour1	= self:BindFX("darksmoke")
	
end


Chopper_woman._CustomAiStates = {}

Chopper_woman._CustomAiStates.Runattack = {
	name = "Runattack",
}

function Chopper_woman._CustomAiStates.Runattack:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor:Stop()

	self._throwed = true
	self.active = true
	self.mode = 0
	self.damaged = false
	actor:RotateToVector(brain._enemyLastSeenPoint.X, brain._enemyLastSeenPoint.Y, brain._enemyLastSeenPoint.Z, true)
end

function Chopper_woman._CustomAiStates.Runattack:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	if self.mode == 0 then
			actor._disableHits = true
			-- tu trace, czy nie trafi w sciane
			actor:SetAnim(aiParams.rollAnim, true)
			
			self._moveSndPtr = SND.GetSound3DPtr(self._moveSnd)
			SOUND3D.SetVolume(self._moveSndPtr, 0, 0)
			SOUND3D.SetVolume(self._moveSndPtr, 100, 0.1)
			
			actor._moveWithAnimation = true
			self.mode = 1
			
			actor._proc = Templates["PMove.CProcess"]:New(actor, aiParams.rollSpeed * 3.0)
			-- mam skakac przed siebie... a nie w strone wroga
			actor:RotateToVector(brain._enemyLastSeenPoint.X, brain._enemyLastSeenPoint.Y, brain._enemyLastSeenPoint.Z, true)
			actor._proc:SetDir(Vector:New(brain._enemyLastSeenPoint.X - actor._groundx, 0, brain._enemyLastSeenPoint.Z - actor._groundz))
			self._oldPos = Clone(actor.Pos)
			self._distToGet = Dist2D(self._oldPos.X, self._oldPos.Z, brain._enemyLastSeenPoint.X, brain._enemyLastSeenPoint.Z) + 4.0
			if self._distToGet < 8 then
				self._distToGet	= 8
			end
			GObjects:Add(TempObjName(), actor._proc)
			actor.state = "ROLL"
			self.dist = 0
			self.lastPosX = actor._groundx
			self.lastPosZ = actor._groundz

	else
		self.dist = self.dist + Dist2D(actor._groundx, actor._groundz, self.lastPosX, self.lastPosZ)
		self.lastPosX = actor._groundx
		self.lastPosZ = actor._groundz
		--local dist = Dist3D(self._oldPos.X, self._oldPos.Y, self._oldPos.Z, actor._groundx, actor._groundy, actor._groundz)
		if self.dist > self._distToGet then
			if debugMarek then Game:Print("zaieg pokonany") end
			actor._animLoop = false
		end
		if not actor._isAnimating or actor.Animation ~= aiParams.rollAnim then
			self.active = false
			if debugMarek then Game:Print("koniec "..actor.Animation) end
			--[[if actor._proc then
				GObjects:ToKill(actor._proc)
				actor._proc = nil
			end--]]
		else
			if brain.r_closestEnemy and brain._distToNearestEnemy < 2.0 and not self.damaged then
				--actor:SetIdle()
				actor._animLoop = false
				if debugMarek then Game:Print("bang") end
				self.damaged = true
				brain.r_closestEnemy:OnDamage(aiParams.rollDamage)
				PlaySound2D("actor/beast/beast_roll-hit")
				return
			end
			actor:RotateToVector(Player._groundx, Player._groundy, Player._groundz, true)
			actor._proc:SetDir(Vector:New(Player._groundx - actor._groundx, 0, Player._groundz - actor._groundz))
		end
	end
	brain._lastRollTime = brain._currentTime
end

function Chopper_woman._CustomAiStates.Runattack:OnRelease(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor._moveWithAnimation = nil
	brain._lastRollTime = brain._lastRollTime + FRand(0,1)
	self.active = false
    actor._disableHits = nil
    if actor._rollPFX then
		PARTICLE.Die(actor._rollPFX)
		actor._rollPFX = nil
    end

    if actor._moveSnd then
        if debugMarek then Game:Print("snd roll release") end
		SOUND3D.SetVolume(self._moveSndPtr, 0, 0.3)
		ENTITY.SetTimeToDie(actor._moveSnd, 0.3)
		actor._moveSnd = nil
	end
    if actor._proc then
		GObjects:ToKill(actor._proc)
		actor._proc = nil
	end
end

function Chopper_woman._CustomAiStates.Runattack:Evaluate(brain)
	if self.active then
		return 0.69
	else
        if brain.r_closestEnemy then
		    local actor = brain._Objactor
			local aiParams = actor.AiParams
            if brain._lastRollTime + aiParams.minDelayBetweenRoll < brain._currentTime and not actor._rotatingWithAnim then
				if brain._distToNearestEnemy < aiParams.rollRangeMax and brain._distToNearestEnemy > aiParams.rollRangeMin then
					--if math.random(100) < (8 - brain.r_closestEnemy._velocity) * 5 then
					--Game:Print("roll "..brain._distToNearestEnemy)
					return 0.56
					--end
				end
			end
		end
	end
	return 0
end

