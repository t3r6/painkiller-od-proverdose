function o:OnCreateEntity()
self._bsound1=self:BindSound("actor/mw_bloody_surgeon/surgeon_loop1",4,30,true)
self._bsound2=self:BindSound("actor/mw_bloody_surgeon/surgeon_loop2",4,30,true)

	
end

function o:OnInitTemplate()
    self:SetAIBrain()
	self._AIBrain._lastThrowTime = FRand(-5, 1) 
    
    --self._AIBrain._lastSliceTime = 0
end

function o:startsplat()
	if not self._flameFX then
	local s = self.s_SubClass.ParticlesDefinitions.splat
		if s then	
			 local idx  = MDL.GetJointIndex(self._Entity,s.joint)
		        local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
	        	local q = Clone(Quaternion)
		        q:FromEuler(0,-self.angle+math.pi/2,0)
		    self._flameFX = AddPFX(s.pfx, s.scale, Vector:New(x2,y2,z2), q)
		end
	end
end

function o:bexplode()
	self:BindFX('explode')
end



function o:stopsplat()
	if self._flameFX then
	PARTICLE.Die(self._flameFX)
	self._flameFX = nil
	end
end
function o:Throw()
	if self._AIBrain and self._AIBrain._enemyLastSeenTime > 0 then
		local aiParams = self.AiParams
		local obj = GObjects:Add(TempObjName(),CloneTemplate(aiParams.ThrowableItem))
		self.Joint = MDL.GetJointIndex(self._Entity, aiParams.throwItemBindTo)
	    local x,y,z = MDL.TransformPointByJoint(self._Entity,self.Joint,aiParams.holdJointDisplace.X,aiParams.holdJointDisplace.Y, aiParams.holdJointDisplace.Z)

		obj.ObjOwner = self
		obj.Pos.X = x
		obj.Pos.Y = y
		obj.Pos.Z = z

		local v = Vector:New(Player._groundx - x, (Player._groundy + 1.7) - y, Player._groundz - z)
		v:Normalize()
		
		local angleToPlayer = math.atan2(v.X, v.Z)
		
		local aDist = AngDist(self.angle, angleToPlayer)
		if math.abs(aDist) > 30 * math.pi/180 then
			--Game:Print("z orienacji")
			v = Vector:New(math.sin(self.angle), 0, math.cos(self.angle))
			v:Normalize()
		end

		local force = aiParams.ThrowSpeed * FRand(0.8, 1.2)
        v:MulByFloat(force)
		
		if debugMarek then					
			self.d1 = x
			self.d2 = y
			self.d3 = z
			self.d4 = x + v.X
			self.d5 = y + v.Y
			self.d6 = z + v.Z
		end

		obj.Rot:FromEuler( 0, -self.angle, 0)
		obj._RotAngle = self.angle

		obj:Apply()
		obj:Synchronize()
		obj._enabled = true
		ENTITY.SetVelocity(obj._Entity, v.X, v.Y, v.Z)
		MDL.SetMeshVisibility(self._Entity,"R_discShape", false)	
	end
end

function o:Showdisk()
		MDL.SetMeshVisibility(self._Entity,"R_discShape", true)	
end


--[[
function o:OnThrow(x,y,z)
	--local q = Quaternion:New()
    --Game:Print("yaw "..(yaw*180/math.pi).." pitch "..(pitch*180/math.pi))
    local v = Vector:New(x,y,z)
    v:Normalize()
	local q = Quaternion:New_FromNormalX(v.X, v.Y, v.Z)
	--Game:Print(v.X.." "..v.Y.." "..v.Z)
	--Game:Print(q.X.." "..q.Y.." "..q.Z)
    q:ToEntity(self._objTakenToThrow._Entity)
end
]]--

function o:stopbinds()

		local e = ENTITY.GetPtrByIndex(self._bsound1)
		if e then
			ENTITY.Release(e)
		end
		self._bsound1 = nil

		local f = ENTITY.GetPtrByIndex(self._bsound2)
		if f then
			ENTITY.Release(f)
		end
		self._bsound2 = nil

end

