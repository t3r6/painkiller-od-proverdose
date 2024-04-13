function Valkyra:OnCreateEntity()
	self:BindFX("smoke")
   self._AIBrain._lastThrowTime = FRand(-3, 3)

end

function o:OnPrecache()
	Cache:PrecacheParticleFX("pochodnia_flame3")
	Cache:PrecacheParticleFX("flamewarp")
	Cache:PrecacheParticleFX("masoburn")

end



function Valkyra:OnInitTemplate()
    self:SetAIBrain()

end


function Valkyra:CustomOnDeath()
    ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
 local tdj = self.s_SubClass.DeathJoints
    if tdj then
        local size = self.burnPFXSize
        for i=1,table.getn(tdj) do
            self:BindFX(self.burnPFX, size, tdj[i])
        end
    end
	if not self._gibbed then
		self:BindFX("warp")
	end

end

function Valkyra:CustomOnDeathAfterRagdoll()
    ENTITY.UnregisterAllChildren(self._Entity, ETypes.ParticleFX)
 local tdj = self.s_SubClass.DeathJoints
    if tdj then
        local size = self.burnPFXSize
        for i=1,table.getn(tdj) do
            self:BindFX(self.burnPFX, size, tdj[i])
        end
    end
	if not self._gibbed then
		self:BindFX("warp")
	end

end

function Valkyra:ShieldBlow(par3, par4)
	local br = self._AIBrain
	if br and br.r_closestEnemy and br.r_closestEnemy._Class == "CPlayer" then
		local aiParams = self.AiParams
		local dist = Dist3D(self._groundx, self._groundy, self._groundz, br.r_closestEnemy._groundx, br.r_closestEnemy._groundy, br.r_closestEnemy._groundz)
		local angleAttack = math.atan2(br.r_closestEnemy._groundx - self._groundx, br.r_closestEnemy._groundz - self._groundz)
		local aDist = AngDist(self.angle, angleAttack)
		
		if dist <= aiParams.attackRange and math.abs(aDist) < aiParams.attackRangeAngle*math.pi/180 then
			local cam = aiParams.ShieldBlow
			Game._EarthQuakeProc:Add(br.r_closestEnemy._groundx, br.r_closestEnemy._groundy, br.r_closestEnemy._groundz, cam.cameraShakeTime, self.StompRange, cam.cameraShake * 0.1, cam.cameraShake)
			local x,y,z = CAM.GetAng()
			--x = math.mod(x, 360)
			--y = math.mod(y, 360)
			--z = math.mod(z, 360)
			x = x - cam.cameraMess.X * FRand(0.9, 1.1)
			y = y - cam.cameraMess.Y * FRand(0.9, 1.1)
			z = z - cam.cameraMess.Z * FRand(0.9, 1.1)
			CAM.SetAng(x,y,z)

            PlaySound2D(self._SoundDirectory.."zombie_shieldhit")
		end
	end
end

function o:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Demon then
        return false
    end

    if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "LeftForeArm" or jName == "LeftShield" or jName == "LeftHand" or jName == "RightHand" then
            if type == AttackTypes.Shotgun or type == AttackTypes.MiniGun or type == AttackTypes.Painkiller or type == AttackTypes.Stake then
				self:PlaySound({"$/actor/maso/maso_hit_impact1","$/actor/maso/maso_hit_impact2"},22,52)
            end
			return true
		end
	else
		if type == AttackTypes.Physics then
			return false
		end
		if x and type == AttackTypes.Rocket then
			local x1,y1,z1 = self:GetJointPos("root")
			local dist = Dist3D(x,y,z,x1,y1,z1)
			Game:Print("odleglosc wybuchu od jointa : "..dist.." "..damage)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15
				return false, damage
			end
		end
	end
	return false
end


