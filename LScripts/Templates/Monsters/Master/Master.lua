function Master:OnInitTemplate()
    self:SetAIBrain()
end

function Master:OnCreateEntity()
self._AIBrain._lastThrowTime = self._AIBrain._currentTime + FRand(0,2)
self._AIBrain._lastinvtime = self._AIBrain._currentTime + FRand(0,2)
	self._tofd=false

end

function o:Visme()
	if self._invv then
		MDL.CreateShadowMap(self._Entity, self.shadow)
		ENTITY.EnableDemonic(self._Entity,false,false)
		self._invv = false
		self.AiParams.throwAmmo = self.AiParams.othrowAmmo 
		AddPFX(self.vissmoke,self.vissmokescale,self.Pos)
		PlaySound3D("actor/mw_master/master_appear",self.Pos.X,self.Pos.Y,self.Pos.Z,10,24,self)
	end
end

function o:CustomOnHit()
	if self.Health < self.ABhp and math.random(100) < 50 then
self.AiParams.ThrowableItem = "Klobouk.CItem"
self.AiParams.throwItemBindTo = "r_hand"
self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
self.AiParams.throwVelocity = 20
self.AiParams.throwAnim = "atak3"
self.AiParams.throwAmmo = 6666
self.AiParams.throwRangeMin = 2
self.AiParams.throwRangeMax = 60
self.AiParams.minDelayBetweenThrow = 0
self.AiParams.escapeAfterThrowTime = 0		-- 0 - no escape
self.AiParams.throwDistMinus = 0	
self.AiParams.hideMesh = "master_hatShape"		
	end
end

function o:OnThrow()
	if self.Animation == "atak3" and self._tofd then
		 self:OnDamage(self.Health+2,self)
		MDL.SetMeshVisibility(self._Entity,"master_hatShape",false)
	end
end


function o:OnFinishAnim(animation)
	if animation == "atak3" and self._tofd then
		MDL.SetMeshVisibility(self._Entity,"master_hatShape",false)
		 self:OnDamage(self.Health+2,self)
	end
end

function o:tdai()
	self._tofd=true
end

function o:invme()
self._invsmoke = self:BindFX("handsmoke")
end

function o:invme2()
self._invsmoke2 = AddPFX(self.invsmoke,self.invsmokescale,self.Pos)
end


function o:CustomOnDeath()
	if self._invv then
		MDL.CreateShadowMap(self._Entity, self.shadow)
		ENTITY.EnableDemonic(self._Entity,false,false)
		self._invv = false
	end
if self._invsmoke then
	PARTICLE.Die(self._invsmoke)
end
if self._invsmoke2 then
	PARTICLE.Die(self._invsmoke2)
end
end


o._CustomAiStates = {}
o._CustomAiStates.Invisible = {
	name = "Invisible",
	state = 0,
	
}





function o._CustomAiStates.Invisible:OnInit(brain)
	 self.active=true
	self.state=1
	local actor = brain._Objactor
	actor.AiParams.othrowAmmo = actor.AiParams.throwAmmo 
	actor.AiParams.throwAmmo = 0
	brain._lastinvtime = brain._currentTime
end

function o._CustomAiStates.Invisible:OnUpdate(brain)
	local actor = brain._Objactor
	if self.state == 1 then
		actor:ForceAnim("hide",false)
		self.state = 2
	end
	if self.state == 2 then
		if actor.Animation ~= "hide" then
			ENTITY.EnableDemonic(actor._Entity,true,false)
			MDL.CreateShadowMap(actor._Entity, 0)
			actor._invv = true
			self.active = false

			if actor._invsmoke then
				PARTICLE.Die(actor._invsmoke)
				actor._invsmoke = nil
			end
			if actor._invsmoke2 then
				PARTICLE.Die(actor._invsmoke2)
				actor._invsmoke2 = nil
			end

		end
	end
end

function o._CustomAiStates.Invisible:OnRelease(brain)
	 self.active=false
end

function o._CustomAiStates.Invisible:Evaluate(brain)
	local actor = brain._Objactor
	if actor._tofd then 
		return 0
	end
	if self.active then
		return 0.8
	else
	        if Player then
			local aiParams = actor.AiParams
			local ax,ay,az = ENTITY.GetPosition(Player._Entity)
			local dist = Dist3D(actor.Pos.X, actor.Pos.Y, actor.Pos.Z, ax,ay,az)
		        if brain._lastinvtime + aiParams.minDelayBetweenInv < brain._currentTime and not actor._invv and dist > 5 then
						if math.random(100) < 100  then
							return 0.9
						end

			end
		end
	end
	return 0
end

