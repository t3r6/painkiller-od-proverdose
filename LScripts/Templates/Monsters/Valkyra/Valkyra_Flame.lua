
function o:OnPrecache()
	Cache:PrecacheParticleFX("Valkyra_Flame")
	Cache:PrecacheParticleFX("flamewarp")
	Cache:PrecacheParticleFX("masoburn")
	Cache:PrecacheParticleFX("pochodnia_ghost")
end

function Valkyra_Flame:OnCreateEntity()
	self:BindSound("actor/mw_valkyr/valkyra_loop",5,15,true)
	self:BindFX("smoke")
   self._AIBrain._lastThrowTime = FRand(-3, 3)
   
   	l = self.s_SubClass.BillBoard
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,0.5,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill = obj
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(0,1.1,0)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill2 = obj
		end


end

function Valkyra_Flame:OnInitTemplate()
    self:SetAIBrain()

end


function Valkyra_Flame:CustomOnDeath()
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

function Valkyra_Flame:CustomOnDeathAfterRagdoll()
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

function Valkyra_Flame:ShieldBlow(par3, par4)
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



