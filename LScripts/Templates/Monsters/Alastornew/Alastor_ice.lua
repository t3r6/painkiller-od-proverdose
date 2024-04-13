function Alastor_ice:OnPrecache()
	Cache:PrecacheDecal(self.HitDecal)
	Cache:PrecacheParticleFX("AlastorenergyFX")
	Cache:PrecacheParticleFX(self.flamerFX)
	Cache:PrecacheParticleFX("but")
end


function Alastor_ice:CheckDamageFromFlame()
	-- dodac min. time between attacks
	local idx  = MDL.GetJointIndex(self._Entity,"k_szyja")
	local idx2  = MDL.GetJointIndex(self._Entity,"k_glowa")
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx)
	local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx2)
	local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
	v2:Normalize()
	
	-- spr. kilka sfer na drodze promienia, czy Player jest w zasiegu plomienia
	local i = 5
	if debugMarek then
		DebugSpheres = {}
	end
	
	local dist = 8
	local size =  3
	
	
	while i < dist do
		local v3 = Clone(v2)
		v3:MulByFloat(i)
		i = i + size
		local x,y,z = x3 + v3.X, y3 + v3.Y, z3 + v3.Z
		
		if debugMarek then
			local a = {}
			a.X = x
			a.Y = y
			a.Z = z
			a.Size = size
			table.insert(DebugSpheres, a)
		end
		local dist = Dist3D(x,y,z, Player._groundx, Player._groundy + 1.5, Player._groundz)
		if dist < size then
				if Player._slowdownSound then
					if not SOUND2D.IsPlaying(Player._slowdownSound) then
						Player._slowdownSound = nil
					end
				end
				Player._poisoned = self.Poison.TimeOut
				Player._poisonedTime = 0
				Player._poison = self.Poison
				Player._DrawColorQuad = true
				Player._ColorOfQuad = Color:New(10, 10, 255)
				Player._QuadAlphaMax = 50
					
			Player:OnDamage(self.flameDamage, self)
			break
		end
	end
end



function Alastor_ice:StartFlame()
	if not self._flameFX then
		local idx  = MDL.GetJointIndex(self._Entity,"k_szyja")
		local idx2  = MDL.GetJointIndex(self._Entity,"k_glowa")
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx)
		local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity, idx2)
		
		local v2 = Vector:New(x3 - x2, y3 - y2, z3 - z2)
		v2:Normalize()
		local q = Clone(Quaternion)
		q:FromNormalX(v2.X, v2.Y, v2.Z)

		if debugMarek then
			self.yaadebug1 = x2
			self.yaadebug2 = y2
			self.yaadebug3 = z2
			self.yaadebug4 = x3
			self.yaadebug5 = y3
			self.yaadebug6 = z3
		end
		
		
		local size = 1  --2.3
		
		Game:Print("PARTICLE size "..size)
		
		self._flameFX = AddPFX(self.flamerFX, size, Vector:New(x3,y3,z3), q)
	end
end

