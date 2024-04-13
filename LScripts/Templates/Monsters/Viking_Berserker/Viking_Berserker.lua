function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity()
	self.enraged = false
end

function o:Breath()
	self:BindFX("Viking_berserker_breath",1,'k_szyja',0,0,0)
end

function o:Watersplash()
	self:BindFX("Viking_berserker_watersplash",1,'dlo_lewa_root',0,2,0)
end

function o:OnPrecache()
    Cache:PrecacheParticleFX("monsterweap_hitground")
    Cache:PrecacheParticleFX("Viking_berserker_watersplash")
    Cache:PrecacheParticleFX("Viking_berserker_breath")
    Cache:PrecacheParticleFX("Viking_rage")
end

function o:IfMissedPlaySound()
	local brain = self._AIBrain
	if brain then
		if brain._lastHitTime < brain._lastMissedTime then
			self:PlaySound("missed")
			if self.s_SubClass.hitGroundJoint then
				local idx  = MDL.GetJointIndex(self._Entity,self.s_SubClass.hitGroundJoint)
				--local x,y,z = self:GetJointPos(self.s_SubClass.hitGroundJoint)
				local x,y,z = MDL.TransformPointByJoint(self._Entity, idx,0,-0.6,0)

				--self.yzdebug1 = x
				--self.yzdebug2 = y+0.2
				--self.yzdebug3 = z
				--self.yzdebug4 = x
				--self.yzdebug5 = y-0.8
				--self.yzdebug6 = z

				local b,d,x1,y1,z1 = WORLD.LineTraceFixedGeom(x,y,z,x,y-1.0,z)
				if b then
					local q = Quaternion:New_FromNormal(nx,ny,nz)
					AddPFX("monsterweap_hitground",0.2, Vector:New(x1,y1,z1),q)
				end
			end
		end
	end
end

function o:CustomOnDeath()
    ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
end

function o:CustomOnDamage()
	if not self.enraged and math.random(100) < 25 then
		self.hited=true
		self.Health = 80
	end
end

o._CustomAiStates = {}
o._CustomAiStates.Rage = {
	name = "Rage",
}


function o._CustomAiStates.Rage:OnInit(brain)
	local actor = brain._Objactor
	self.active = true
	self.timer = 30 
	actor:ForceAnim("attak2", false)
	actor:PlaySound({"$/actor/skeleton_soldier/skeleton_attackscream5"})
	actor.Immortal=true
	
end


function o._CustomAiStates.Rage:OnUpdate(brain)
	local actor = brain._Objactor
	self.timer= self.timer -1 
	if self.timer < 0 then self.active = false
		actor.hited=false
	end
end


function o._CustomAiStates.Rage:OnRelease(brain)
	self.timer=0
	local actor = brain._Objactor
	actor._proc = Templates["Rage.CProcess"]:New(actor)
	actor._ragepart = actor:BindFX("Viking_rage",0.08,'k_szyja',0,0.12,0.3)
	actor.enraged = true
	actor.Immortal=false 
end

function o._CustomAiStates.Rage:Evaluate(brain)
local actor = brain._Objactor
if self.active and self.timer > 0 then return 0.7 end
if actor.hited then return 0.7 end
return 0
end

