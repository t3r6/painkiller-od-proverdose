function InvisibleMan:OnInitTemplate()
    self:SetAIBrain()
	self._AIBrain._lastTimeFreak = -100
end

function InvisibleMan:CustomOnDeath()
    if self._soundSample then
        SOUND3D.Forget(self._soundSample)
        self._soundSample = nil
    end
    if self._shootingSound then
		local e = ENTITY.GetPtrByIndex(self._shootingSound)
		if e then
			ENTITY.Release(e)	-- pozniej fadeout
		end
		self._shootingSound = nil
	end
end
-------------
function InvisibleMan:ShootingSound(start)
	if not start then
		if self._shootingSound then
			local e = ENTITY.GetPtrByIndex(self._shootingSound)		-- potrzebne?
			if e then
				ENTITY.Release(e)
			end
			self._shootingSound = nil
		end
		self:PlaySound({"$/actor/mw_invisible_man/iman-weapon-shoot-end"},16,52)
	else
		local snd
		snd, self._shootingSound = self:BindRandomSound({"$/actor/mw_invisible_man/iman-weapon-shooting"},16,52)
	end
	self._startShooting = start
end


function o:OnCreateEntity()
--	MDL.SetMeshVisibility(self._Entity, "jeans_hole_2sidedShape", false)
	MDL.SetMeshVisibility(self._Entity, "jeans_2sidedShape", false)
	MDL.SetMeshVisibility(self._Entity, "glass_warpShape", false)
--	MDL.SetMeshVisibility(self._Entity, "polySurface3_2sidedShape", false)
	MDL.SetMeshVisibility(self._Entity, "pCylinderShape1", false)
--	self:BindFX("invisible_cigar",0.3,"head",-0.08,-0.08,0.23)

end

function o:CustomOnDeathAfterRagdoll()
	MDL.SetMeshVisibility(self._Entity, "glass_warpShape", false)
	MDL.SetMeshVisibility(self._Entity, "polySurface3_2sidedShape", false)
	MDL.SetMeshVisibility(self._Entity, "polySurfaceShape18", false)
	MDL.SetMeshVisibility(self._Entity, "polySurfaceShape20", false)
	MDL.SetMeshVisibility(self._Entity, "polySurfaceShape21", false)
end

o.CustomOnGib = o.CustomOnDeathAfterRagdoll

function InvisibleMan:OnStartAnim(oldAnim)
	if oldAnim == "attack1" then
		if self._startShooting then
			self:PlaySound({"$/actor/mw_invisible_man/iman-weapon-shoot-end"},16,52)
			self._startShooting = false
			if self._shootingSound then
				local e = ENTITY.GetPtrByIndex(self._shootingSound)
				if e then
					ENTITY.Release(e)	-- pozniej fadeout
				end
				self._shootingSound = nil
			end
			--if debugMarek then Game:Print("przerwany strzaly, to wybrzmiewanie") end
		end
	end
end

