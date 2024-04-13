--============================================================================
function vod_pentagram:OnPrecache()
--	Cache:PrecacheParticleFX("checkpoint_fx2")    
	Cache:PrecacheParticleFX("pentagram_fx1") 
end
--============================================================================
function vod_pentagram:OnCreateEntity()
--	self:BindFX("checkpoint_fx2",0.1,"root")
--	self:BindFX("checkpoint_fx1",0.2,"e1")
--	self:BindFX("checkpoint_fx1",0.2,"e2")
--	self:BindFX("checkpoint_fx1",0.2,"e3")
	self:BindFX("pentagram_fx1",0.2,"e1")
	self:BindFX("pentagram_fx1",0.2,"e2")
	self:BindFX("pentagram_fx1",0.2,"e3")
	MDL.SetAnim(self._Entity,"idle",true,2.0)
end
--============================================================================
function vod_pentagram:OnApply(old)
	ENTITY.EnableDraw(self._Entity,not self.Frozen,true)
end
--============================================================================
--============================================================================
function vod_pentagram:OnShow()
	self.Frozen = false
	self:OnApply()
end
--============================================================================
function vod_pentagram:OnHide()
	self.Frozen = true
	self:OnApply()
end




--============================================================================
function vod_pentagram:OnLaunch(leavePrev)


	self.Frozen = false
	self:OnApply()

	if not self.leavePrev then
		for i,v in GObjects.CheckPoints do
			if v ~= self and v.BaseObj ~= "pentakl.CItem" and v.BaseObj ~= "C5L3_Krzyz.CItem" then
				if not v.Frozen then
					v.Frozen = true
					v:OnApply()
				end
			end
		end
	end
end

