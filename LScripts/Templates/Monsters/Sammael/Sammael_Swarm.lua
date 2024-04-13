function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity(i)
self.flyingMode = true
self.TimeToLive= 10*30
ENTITY.PO_EnableGravity(self._Entity,false)
self._flyWithAngle = true
self:BindFX(self.part,self.partscale,"sarance1")
self:BindFX(self.part,self.partscale,"sarance2")
self:BindFX(self.part,self.partscale,"sarance3")
self:BindFX(self.part,self.partscale,"sarance4")
self:BindFX(self.part,self.partscale,"sarance5")
self:BindFX(self.part,self.partscale,"sarance6")
self:BindFX(self.part,self.partscale,"sarance7")
self:BindFX(self.part,self.partscale,"sarance8")
self:BindFX(self.part,self.partscale,"sarance9")
self:BindFX(self.part,self.partscale,"sarance10")

	self:BindSound("actor/mw_swarm/swarm_loop",13,70,true)

end

function o:CustomOnDeath()
	if Tweak.GlobalData.GermanVersion or Tweak.GlobalData.DisableGibs then
		self.DeathTimer = 0
	end
AddPFX('Butcher_blood_small',1.5,Vector:New(self:GetJointPos("root")))
GObjects:ToKill(self)

end

function o:CustomUpdate()
 if self.TimeToLive then
            self.TimeToLive = self.TimeToLive - 1
            if self.TimeToLive < 0 then
                self.TimeToLive = nil
                local aiParams = self.AiParams
                self.AIenabled = false
		self:ExplodeBarrel()
            end
        end
end




function o:ExplodeBarrel()
    --ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
	if not self._exploded then
        local x,y,z = self:GetJointPos("k_szyja")
		self._exploded = true
		--self.enableGibWhenHPBelow = 0
		local aiParams = self.AiParams
		
		WORLD.Explosion2(x,y,z, aiParams.Explosion.ExplosionStrength,aiParams.Explosion.ExplosionRange,self._Entity,AttackTypes.Suicide,aiParams.Explosion.Damage)
		-- sound
		PlaySound3D("actor/mw_swarm/swarm_at",x,y,z,10,100)
		local r = Quaternion:New_FromNormal(0,1,0)
        self:AddPFX("explode")
		-- light
		AddAction({{"Light:a[1],a[2],a[3],200,200,100, 8, 10 , 1, 0.02,0.1,0.02"}},nil,nil,x,y,z)
		if Game._EarthQuakeProc then
			Game._EarthQuakeProc:Add(x,y,z, 5, 10, 0.15, 0.15, false)
		end

		--MDL.SetMeshVisibility(self._Entity,"BECZKA_MALAShape", false)	
        --local e = AddItem("BarrelSmall.CItem",nil,self.Pos,nil,Quaternion:New_FromEuler( 0, -self.angle, math.pi/2))
        --ENTITY.PO_Enable(e, false)
	    --ENTITY.ExplodeItem(e, "../Data/Items/"..self.deathExplosionItem, self.BarrelExplosion.streng, self.BarrelExplosion.Radius, self.BarrelExplosion.LifetimeAfterExplosion,self.deathExplosionItemScale)
        --ENTITY.Release(e)
        if self.Health > 0 then
			self:OnDamage(self.Health + 2, self)
		end
	end
end

function o:OnFinishAnim(anim)
--	if anim == self.AiParams.collisionAnim then
--		self:Explode()
--	end
end
