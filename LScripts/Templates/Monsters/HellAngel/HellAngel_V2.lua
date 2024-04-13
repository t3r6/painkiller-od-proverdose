function HellAngel_V2:CustomOnDeath()
    ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
end

function HellAngel_V2:OnCreateEntity()
self._bsound1=self:BindSound("actor/clown/electricity",4,30,true)
end
