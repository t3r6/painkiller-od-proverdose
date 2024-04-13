function o:OnInitTemplate()
    self:SetAIBrain()
    self._disableHits = true
    self._hitsCounter = 0
    self._AIBrain._lastThrowTime = FRand(-4, -1)
    if IsGermanBuild() then
	self.DeathTimer = 4
	end
end

function o:Shakeg()
	Game._EarthQuakeProc:Add(self.Pos.X,self.Pos.Y,self.Pos.Z, 2, 8, 1 , 1, 1.0)
end

function o:OnCreateEntity()
	self._imflame1=self:BindFX('bottom')
	self._imflame2=self:BindFX('relbow')
	self._imflame3=	self:BindFX('lelbow')
	self._imflame4=	self:BindFX('lwrist')
	self._imflame5=	self:BindFX('rwrist')
	self.rocknumber = 1+math.random(5)
	self:BindSound("actor/mw_guardian/guard_loop",10,50,true)
	self.state = 0
	self._lastTimeThrow = 0
	self.burning=false
	

self.hjoints={}
self.hjoints[1]={"root"}
self.hjoints[2]={"neck"}
self.hjoints[3]={"r_arm","r_forearm","r_hand","l_arm","l_forearm","l_hand"}
self.seljoint = {}	

self.flamejoints={}
self.flamejoints[1]={"spine_1"}
self.flamejoints[2]={"k_szyja"}
self.flamejoints[3]={"l_forearm","r_forearm"}
end


function o:lavafire()
self.AiParams.ThrowableItem = "DemonSpell.CItem"
self.AiParams.throwVelocity = 60

end

function o:rainfire()
self.AiParams.ThrowableItem = "Lava_rain.CItem"
self.AiParams.throwItemBindToOffset = Vector:New(-3, 0, 4)
self.AiParams.throwVelocity = 40
end

function o:finishedthrow()
self.rocknumber = self.rocknumber -1
if self._throwfire then
	PARTICLE.Die(self._throwfire)
	self._throwfire=nil
end
self.throwing=0
end

function o:finishedidle()
self.throwing=0
self.idle1=false
end


function o:startthrow()
	if not self._throwfire then
		self._throwfire=self:BindFX('rain')
	end
end

function o:startfire()
		if not self.burning then
		self.burning=true
		self.seljointflame1 = self:BindFX("magma_attack",0.8,"r_forearm")
		self.seljointflame2 = self:BindFX("magma_attack",0.8,"l_forearm")
		self.seljointflame3 = self:BindFX("magma_attack",0.8,"k_szyja")
		self.seljointflame4 = self:BindFX("magma_attack",0.8,"spine1")
		end
end

function o:endfire()
	Game:Print("ENDFIRE")
	if self.burning then
	self.burning=false
	Game:Print("ENDFIRE2")
	PARTICLE.Die(self.seljointflame1)
	self.seljointflame1=nil
	PARTICLE.Die(self.seljointflame2)
	self.seljointflame2=nil
	PARTICLE.Die(self.seljointflame3)
	self.seljointflame3=nil
	PARTICLE.Die(self.seljointflame4)
	self.seljointflame4=nil
	end
end


Magma_Demon._CustomAiStates = {}
Magma_Demon._CustomAiStates.ThrowRocks = {
	name = "ThrowRocks",
	
}

function o:randshift()
local x = 6- math.random(12)/2
local y = 6- math.random(12)/2
self.AiParams.throwItemBindToOffset = Vector:New(-3+y, 0+x, 4)
end

function Magma_Demon._CustomAiStates.ThrowRocks:OnInit(brain)

	local aaa = math.random(3)
	local actor = brain._Objactor
	if aaa == 3 then --ruce
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add_arms")
		actor.seljointflame1 = actor:BindFX("fireskull",0.6,"r_forearm")
		actor.seljointflame2 = actor:BindFX("fireskull",0.6,"l_forearm")
	elseif aaa == 2 then --hlava
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add_k_szyja")
		actor.seljointflame2 = actor:BindFX("fireskull",0.7,"k_szyja")
	else --telo
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add_body")
		actor.seljointflame2 = actor:BindFX("fireskull",0.9,"spine1")
	end
	actor.seljoint = aaa

	if brain.r_closestEnemy then
		actor:RotateToVector(brain.r_closestEnemy._groundx, 0, brain.r_closestEnemy._groundz)
	end
	PARTICLE.Die(actor._imflame1)
	PARTICLE.Die(actor._imflame2)
	PARTICLE.Die(actor._imflame3)
	PARTICLE.Die(actor._imflame4)
	PARTICLE.Die(actor._imflame5)
	actor.Immortal = false
	actor.throwing=1
		if math.random(100) < 25 then
			actor:SetAnim("attack1",true)
		else
			actor:SetAnim("attack2",true)
		end
	
end


function Magma_Demon._CustomAiStates.ThrowRocks:OnUpdate(brain)
end

function Magma_Demon._CustomAiStates.ThrowRocks:OnRelease(brain)
	self.activetimer = 0
	self.active = false
	local actor = brain._Objactor
	PARTICLE.Die(actor.seljointflame2)
	if actor.seljoint == 3 then --ruce
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add")
		PARTICLE.Die(actor.seljointflame1)
	elseif actor.seljoint == 2 then --hlava
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add")
	else --telo
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add")
	end
	actor.Immortal =true
	actor._imflame1=actor:BindFX('bottom')
	actor._imflame2=actor:BindFX('relbow')
	actor._imflame3=	actor:BindFX('lelbow')
	actor._imflame4=	actor:BindFX('lwrist')
	actor._imflame5=	actor:BindFX('rwrist')

end

function Magma_Demon._CustomAiStates.ThrowRocks:Evaluate(brain)
local actor = brain._Objactor
	if actor.state == 2 then
		if actor.rocknumber < 1 then
			--Game:Print("tr < 1 ")
			actor.throwing = 0
			actor.state = 3
			return 0 
		end
		return 0.6
	end
	return 0
end


	
function o:CustomOnHit()
	if not self.s_SubClass.Hits then return end
	self._hitsCounter = self._hitsCounter + 1
	if self._hitsCounter >= 4 and not self._isRotating then
		self._hitsCounter = 0

		if not self._speeded then
			self._randomizedParams.WalkSpeed = self._randomizedParams.WalkSpeed * 1.1
			self._speeded = true
		end

		local animName = self.s_SubClass.Hits[math.random(1,table.getn(self.s_SubClass.Hits))]
						
		if not self.AIenabled and self._isAnimating then
			self._animationBeforeHit = self.Animation
		end
		if self:ForceAnim(animName, false) then
			self._lastHitAnim = animName
			self._hitDelay = self.minimumTimeBetweenHitAnimation
			if not self._hitDelay then
				self._hitDelay = 4
			end
			if self.AIenabled then
				self:Stop()
			else
				self._hitDelay = 99999	-- az do zakonczenia animacji
			end
		end
	end
end

