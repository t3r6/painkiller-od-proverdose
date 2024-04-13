function Geisha:OnInitTemplate()
    self:SetAIBrain()
end


function Geisha:CustomOnDeath()
    ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
end


function o:CustomOnHit()
	if self.Health < self.ABhp and math.random(100) < 50 then
self.AiParams.ThrowableItem = "Vejir.CItem"
self.AiParams.throwItemBindTo = "r_hand"
self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
self.AiParams.throwVelocity = 20
self.AiParams.throwAnim = "attack3"
self.AiParams.throwAmmo = 6666
self.AiParams.throwRangeMin = 2
self.AiParams.throwRangeMax = 60
self.AiParams.minDelayBetweenThrow = 0
self.AiParams.escapeAfterThrowTime = 0		-- 0 - no escape
self.AiParams.throwDistMinus = 0	
self.AiParams.hideMesh = "geisha_fanShape"		
	end
end


function o:OnCreateEntity()
    self._AIBrain._lastThrowTime = self._AIBrain._currentTime + FRand(0,2)
	self._tofd=false
end

function o:OnThrow()
	if self.Animation == "attack3" and self._tofd then
		 self:OnDamage(self.Health+2,self)
	end
end

function o:tdai()
	self._tofd=true
end
