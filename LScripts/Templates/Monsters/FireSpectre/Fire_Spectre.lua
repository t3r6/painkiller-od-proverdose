function o:OnInitTemplate()
    self:SetAIBrain()
end
 
function o:OnCreateEntity()

self:BindSound("actor/mw_firespectre/firespectre_loop",4,30,true)

self:BindFX(self.burnPFX, self.burnsize1, "r_p_bark")
self:BindFX(self.burnPFX, self.burnsize1, "r_l_bark")
self:BindFX(self.burnPFX, self.burnsize1, "r_p_lokiec")
self:BindFX(self.burnPFX, self.burnsize1, "r_l_lokiec")
self:BindFX(self.burnPFX, self.burnsize1, "joint24")
self:BindFX(self.burnPFX, self.burnsize1, "joint27")
self:BindFX(self.burnPFX, self.burnsize1, "k_ramiona")
self:BindFX(self.burnPFX, self.burnsize1, "k_szyja")
self:BindFX(self.burnPFX, self.burnsize1, "n_l_kolano")
self:BindFX(self.burnPFX, self.burnsize1, "n_p_kolano")
self:BindFX(self.burnPFX, self.burnsize1, "s_l_kostka")
self:BindFX(self.burnPFX, self.burnsize1, "s_l_srodstopie")
self:BindFX(self.burnPFX, self.burnsize1, "s_p_srodstopie")
self:BindFX(self.burnPFX, self.burnsize1, "k_zebra")
self:BindFX(self.burnPFX, self.burnsize1, "dlo_lewa_root")
self:BindFX(self.burnPFX, self.burnsize1, "rekaw_L1")
self:BindFX(self.burnPFX, self.burnsize1, "rekaw_L2")
self:BindFX(self.burnPFX, self.burnsize1, "dlo_prawa_root")
self:BindFX(self.burnPFX, self.burnsize1, "rekaw_P1")
self:BindFX(self.burnPFX, self.burnsize1, "rekaw_P2")
self:BindFX(self.burnPFX, self.burnsize1, "s_p_kostka")
self:BindFX(self.burnPFX, self.burnsize1, "kabelek01")
self:BindFX(self.burnPFX, self.burnsize1, "kabelek02")
self:BindFX(self.burnPFXbody, self.burnsize2, "root")
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1149",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1148",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1153",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1151",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1158",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1159",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1137",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1177",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1160",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1232",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1234",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1152",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1150",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1183",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1179",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1180",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1181",false)
MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1182",false)
--MDL.SetMeshVisibility(self._Entity,"polySurfaceShape1097",true)
end


function o:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Fire or type == AttackTypes.Fireball or type == AttackTypes.Lava or type == AttackTypes.FlameThrower then
	    if self._HealthMax > self.Health then 
			self.Health=self.Health+5
		end
        return true
    end
	return false
end


function o:CustomUpdate()
	if math.random(100) < 5 and Player then
		local x,y,z = ENTITY.GetPosition(self._Entity)
		local dist = Dist3D(x,y,z, Player._groundx,Player._groundy, Player._groundz)
		if dist < self.AuraRange then
			Player:OnDamage(self.AuraDamage,self.ObjOwner,AttackTypes.Fire)
		end
	end
end

function o:Explosion(x,y,z)
	WORLD.Explosion2(x,y,z, self.DeathExplosionStrength,self.DeathExplosionRange,nil,AttackTypes.Fire,self.DeathExplosionDamage)
	-- sound
	SOUND.Play3D("weapons/machinegun/rocket_hit",x,y,z,20,150)
	local r = Quaternion:New_FromNormal(0,1,0)
	AddObject("FX_rexplode.CActor",1,Vector:New(x,y,z),r,true) 

	-- light
	AddAction({{"Light:a[1],a[2],a[3],200,200,100, 8, 10 , 1, 0.02,0.1,0.02"}},nil,nil,x,y,z)
	if Game._EarthQuakeProc then
		local g = Templates["Grenade.CItem"]
		Game._EarthQuakeProc:Add(x,y,z, 5, g.ExplosionCamDistance, g.ExplosionCamMove, g.ExplosionCamRotate, false)
	end
end

function o:CustomOnDeath()
	if math.random(100) < 25 then
local x,y,z = self._groundx, self._groundy+0.5, self._groundz--self:GetJointPos(self.AiParams.weaponBindPos)
		self:Explosion(x,y,z)
	end
end
