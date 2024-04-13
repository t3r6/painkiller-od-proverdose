function o:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
end


function o:OnCreateEntity()
	if math.random(100) < 50 then
		MDL.SetTexture(self._Entity, "radioactive_operator","radioactive_operator_02")
	end
	
	l = self.s_SubClass.BillBoard
		if l then
			local obj = CloneTemplate(l.template)
			obj.Pos:Set(1.5,0.0,-0.1)
			obj:Apply()
			ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, l.joint))
			self._bindedBill = obj
		end
	self:BindSound("actor/mw_radioactive_operator/radio_loop1",1,10,true)
	self:BindSound("actor/mw_radioactive_operator/radio_loop2",0.5,10,true)
	self:BindSound("actor/mw_radioactive_operator/radio_geiger_loop1",10,50,true)
	self:BindSound("actor/mw_radioactive_operator/radio_geiger_loop2",2,10,true)

--	local s = self.s_SubClass.ParticlesDefinitions.smoke
--		if s then
--				self:BindFX("smoke")
--		end
end

function o:prd()
	local p = self.s_SubClass.ParticlesDefinitions.prd
	self:BindFX(p.pfx,p.scale,p.joint)
end


function o:IfMissedPlaySound()
	local brain = self._AIBrain
	if brain then
		if brain._lastHitTime < brain._lastMissedTime then
			self:PlaySound("missed")
		end
	end
end

------------------

function o:Flame()
	if not self._flameFX then
		local s = self.s_SubClass.ParticlesDefinitions.atak
		
        local idx  = MDL.GetJointIndex(self._Entity,s.joint)
	local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, self.AiParams.weaponBindPosShift.X, self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2,0)

	    self._flameFX = AddPFX(s.pfx, s.scale, Vector:New(x2,y2,z2), q)
	else
		if debugMarek then Game:Print("flame started???") end
	end
end

function o:OnTick()
end


function o:CheckDamageFromFlame()
	local angle = self.angle - 0.08
	
	for gg=1,9 do
		local v = Vector:New(math.sin(angle), 0, math.cos(angle))
		angle = angle + 0.08
		v:Normalize()
		if gg == 2  or gg == 4 or gg == 8 then
			v:MulByFloat(self.AiParams.flameRange)
		else
			v:MulByFloat(self.AiParams.flameRange*0.9)
		end

		local s = self.s_SubClass.ParticlesDefinitions.atak
		
		local idx  = MDL.GetJointIndex(self._Entity,s.joint)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)
		if gg < 4 then
		y3 = y2 - 1.2
		elseif gg > 6 then
		y3 = y2 + 0.4
		else
		y3 = y2 - 0.2
		end
		local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(x2,y2,z2, x2+v.X,y3,z2+v.Z)
		if e then
			--Game:Print("flame col")
			local obj = EntityToObject[e]
			if obj and obj.OnDamage and obj._Class == "CPlayer"  then
				if obj ~= self then
					obj:OnDamage(self.AiParams.flameDamage*FRand(0.5,1.0), self)
					break
				end
			end
		end
	end
end    

function o:OnTick()
	if self._flameFX then
		--local idx  = MDL.GetJointIndex(self._Entity,"joint22")
		--Game:Print("PBindPFXToJoint:itck "..idx)
		local s = self.s_SubClass.ParticlesDefinitions.atak
	
		local idx  = MDL.GetJointIndex(self._Entity,s.joint)
		local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity, idx, self.AiParams.weaponBindPosShift.X, self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
		
        local q = Clone(Quaternion)
        q:FromEuler(0,-self.angle+math.pi/2+FRand(-0.04,0.04),0)
		q:ToEntity(self._flameFX)
		ENTITY.SetPosition(self._flameFX,x2,y2,z2) 
	end
end



function o:EndFlame()
	if self._flameFX then
		PARTICLE.Die(self._flameFX)
		self._flameFX = nil
	end
end

function o:CustomOnDeath()
if self._bindedBill then
			GObjects:ToKill(self._bindedBill)
			self._bindedBill = nil
	end
	self:EndFlame()
end


function o:RestoreFromSave()
    if self._AIBrain then
        for i,o in self._AIBrain._goals do
            if AiStates[o.name] then
                InheritFunctionsAndStatics(o,AiStates[o.name])
            else
                if self._CustomAiStates and self._CustomAiStates[o.name] then
                    InheritFunctionsAndStatics(o,self._CustomAiStates[o.name])
                else
					DoFile(path.."Classes/Ai/"..o.name..".state")
					if not AiStates[o.name] then
						MsgBox(self._Name.." rfs%ERROR: no goal "..o.name)
					else
						InheritFunctionsAndStatics(o,AiStates[o.name])
					end
                end
            end            
        end
    end

	if math.random(100) < 50 then
		MDL.SetTexture(self._Entity, "radioactive_operator","radioactive_operator_02")
	end
    self._CurAnimLength = MDL.GetAnimLength(self._Entity, self._CurAnimIndex)
end
