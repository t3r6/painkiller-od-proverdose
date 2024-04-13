function Butcher:OnCreateEntity()
self._bsound1=self:BindSound("actor/mw_butcher/butcher_loop1",4,30,true)
end

function Butcher:OnInitTemplate()
    self:SetAIBrain()
	self._AIBrain._ready = false
end


function Butcher:PlaySoundAttack()
	if self._snd then
		local e = ENTITY.GetPtrByIndex(self._snd)
		if e then
			ENTITY.Release(self._snd)		-- pozniej fade
		end
		self._snd = nil
	end
	local snd
	snd, self._snd = self:BindRandomSound("attack")
end

function Butcher:BloodFromNeck()
	self:BindFX("neckblood")
end

function Butcher:BindTrails()
self._tr1= self:BindTrail('trail_hook','l_hook','l_roll')
self._tr2= self:BindTrail('trail_hook','r_hook','r_roll')
end

function Butcher:EndTrails()
	if self._tr1 then
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
	end
end



function Butcher:BloodFromShoeR()
	self:BindFX("footblood")
end

function Butcher:BloodFromShoeL()
	self:BindFX("footblood2")
end
function Butcher:CustomOnHit()
	local aiParams = self.AiParams
	if not self._ABdo and self._AIBrain._ready then
		if self._HealthMax * aiParams.ABhp > self.Health and ENTITY.PO_IsOnFloor(self._Entity) then
			self._ABdo = 0
		end
	end
end

function Butcher:stopbinds()
		local e = ENTITY.GetPtrByIndex(self._bsound1)
		if e then
			ENTITY.Release(e)
		end
		self._bsound1 = nil
end

