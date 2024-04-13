function Tortured:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-4, 0.5)

    self._lastTimeChangeAnim = 0
    self._changeAnimIn = FRand(20.0, 50.0)	-- sec.
end

function Tortured:OnPrecache()
    Cache:PrecacheItem("Tang.CItem")    
    Cache:PrecacheParticleFX("pochodnia_flame3")    
Cache:PrecacheParticleFX("Tortured_blood")    
Cache:PrecacheParticleFX("Tortured_blood2")    
end


function Tortured:CustomOnDeath()
	if self._proc then
		GObjects:ToKill(self._proc)
		self._proc = nil
	end

end



function Tortured:OnCreateEntity()
		self:BindFX("Tortured_blood",0.6,"r_p_bark",-0.2,0,0)
		self:BindFX("Tortured_blood",0.6,"r_l_bark",0.2,0,0)
		self:BindSound("actor/mw_tortured/tortured_loop",2,20,true)
end


function Tortured:OnTick()
	if self._bindedLight then
		local l = Templates[self.s_SubClass.Light.template]
		local rnd = FRand(0.67, 1.0)
		local i = l.Intensity
		LIGHT.SetIntensity(self._bindedLight._Entity, i * rnd)
		local f = l.StartFalloff * rnd
		local radius = l.Range * rnd
		LIGHT.SetFalloff(self._bindedLight._Entity,f,radius)
	end
end

function o:OnThrow(x,y,z)
    local v = Vector:New(x,y,z)
    v:Normalize()
	local q = Quaternion:New_FromNormalX(v.X, v.Y, v.Z)
    q:ToEntity(self._objTakenToThrow._Entity)
    self:BindFX("Tortured_blood2",0.75,"r_l_bark",-0.2,-0.2,0.5)
end
