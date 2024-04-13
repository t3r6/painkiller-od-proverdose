function o:OnInitTemplate()
    self:SetAIBrain()
end



function rocketeer:OnCreateEntity()
	self:BindSound("actor/mw_rocketeer/rock_loop1",4,40,true)
	self:BindSound("actor/mw_rocketeer/rock_loop2",4,15,true)

    self:BindFX('rocketeer_smoke')
    self._AIBrain._lastThrowTime = FRand(-5, 1) 

end





