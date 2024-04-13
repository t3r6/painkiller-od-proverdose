function Electrician:OnInitTemplate()
    self:SetAIBrain()
end

function Electrician:OnCreateEntity()
self._AIBrain._lastThrowTime = FRand(-4, -1)
--[[	local obj = GObjects:Add(TempObjName(),CloneTemplate("FRef.CItem"))
		    obj.Pos:Set(0,-0.25,0)
		    obj.Rot:FromEuler(math.pi/2,0, 0)
		    obj:Apply()
		    ENTITY.RegisterChild(self._Entity,obj._Entity,true,MDL.GetJointIndex(self._Entity, "weapon_light_joint"))
		    ]]--
self:BindSound("actor/mw_electrician/electrician_loop1",4,20,true)
self:BindSound("actor/mw_electrician/electrician_loop2",4,20,true)
self._dest = false
end

function o:startfx()
		self.dpatr={}
		for i,v in self.s_SubClass.attjoints do
			self.dpatr[i]=self:BindFX('electrician_attack',0.4,i, nil,nil,nil, -1)
		end
end

function o:endfx()
	if self.dpatr then
		for i,v in self.s_SubClass.attjoints do
			PARTICLE.Die(self.dpatr[i])
		end
	self.dpatr=nil
	end
end

function o:Setydest(wh)
	self._ydest=wh
end



function o:CustomOnDeath()
	if self.dpatr then
		for i,v in self.s_SubClass.attjoints do
			PARTICLE.Die(self.dpatr[i])
		end
	self.dpatr=nil
	end
end


function o:GetDest()
	self._dest = true
	local brain = self._AIBrain
	if brain._enemyLastSeenPoint and brain._enemyLastSeenPoint.X then
			self._Destx, self._Desty, self._Destz = brain._enemyLastSeenPoint.X,brain._enemyLastSeenPoint.Y,brain._enemyLastSeenPoint.Z
		else
			self._Destx, self._Desty, self._Destz = brain.r_closestEnemy.Pos.X,brain.r_closestEnemy.Pos.Y,brain.r_closestEnemy.Pos.Z
		end
end

function o:Render()
	if self.Animation == "attack3" and self.Health>0 and self._dest then
		local Joint = MDL.GetJointIndex(self._Entity, "weapon_light_joint")
		local srcx, srcy, srcz = MDL.TransformPointByJoint(self._Entity, Joint, 0.02,-0.25,0)
		local yd = self._Desty + self._ydest
		local  b,d,tx,ty,tz,nx,ny,nz,he,e = WORLD.LineTrace(srcx,srcy,srcz,(self._Destx-srcx)*5+self._Destx,(yd-srcy)*5+yd,(self._Destz-srcz)*5+self._Destz)
	 	R3D.DrawSprite1DOF(srcx,srcy,srcz,(self._Destx-srcx)*5+self._Destx,(yd-srcy)*5+yd,(self._Destz-srcz)*5+self._Destz,1.5,R3D.RGB(255,255,255),"particles/trailelectrician")
                if b then                            
                    local obj = EntityToObject[e]             
                    if obj  and e ~= self._Entity then          
                        if math.random(100) < 10 then                            
		         if obj.OnDamage then obj:OnDamage(self.AiParams.laserdamage,self,AttackTypes.Painkiller,tx,ty,tz,nx,ny,nz) end
                        end
		    end
			if b and e and e ~= self._Entity then
	              		ENTITY.SpawnDecal(e,'electro',tx,ty,tz,nx,ny,nz)
				AddPFX("FX_rexplode1", 0.1,Vector:New(tx,ty,tz))
        		end
		end
	

	end


end
