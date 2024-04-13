function o:OnInitTemplate()    self:SetAIBrain()
end


function o:OnCreateEntity()
	  self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-4, 0.5)
	self:BindFX("ambient1")
	self:BindSound("actor/mw_insanecultist/cultist_loop",3,30,true)
end




function o:CustomOnHit()
	if not self._ABdo and math.random(100) < 30 then
		if self._HealthMax * self.ABHp > self.Health then
			self._ABdo = true
		end
	end
end

function o:CustomOnDamage(he,x,y,z,obj, damage, type)
	 if type == AttackTypes.Demon then
	        return false
	    end
	if self._ABdo then
		return true
	end
	return false
end

function o:chargeself()
self.Health = self._HealthMax
end

o._CustomAiStates = {}

o._CustomAiStates.Regenerate = {
	name = "Regenerate",
}

function o._CustomAiStates.Regenerate:OnInit(brain)
local actor = brain._Objactor
local aiParams = actor.AiParams
	self.active = true
if aiParams.Reganim then
	actor:SetAnim(aiParams.Reganim, false)
else
	self.active = false
	actor._ABdo = false
end
end

function o._CustomAiStates.Regenerate:OnUpdate(brain)
local actor = brain._Objactor
local aiParams = actor.AiParams

	if actor._HealthMax < actor.Health+1 or not actor._isAnimating or actor.Animation ~= aiParams.Reganim then
		actor._ABdo = false
		self.active=false
	end
end

function o._CustomAiStates.Regenerate:OnRelease(brain)
end
function o._CustomAiStates.Regenerate:Evaluate(brain)
local actor = brain._Objactor
	if actor._ABdo and actor._state ~= "ATTACKING" then
		return 0.65
	end
	if self.active then
		return 0.9
	end
	return 0
end
