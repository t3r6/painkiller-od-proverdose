function o:OnInitTemplate()
 self._Synchronize = self.Synchronize
    self.Synchronize = nil
end

function o:OnCreateEntity()
self.delta=0
MDL.SetRagdollCollisionGroup(self._Entity, ECollisionGroups.Barrier)
ENTITY.PO_SetMovedByExplosions(self._Entity, false)
self.j1 =  MDL.GetJointIndex(self._Entity,"velkakoule1")
self.j2 =  MDL.GetJointIndex(self._Entity,"velkakoule2")
self.j3 =  MDL.GetJointIndex(self._Entity,"velkakoule3")
self.j4 =  MDL.GetJointIndex(self._Entity,"velkakoule4")
self.j0 =  MDL.GetJointIndex(self._Entity,"root")
ENTITY.EnableCollisions(self._Entity, true)


MDL.SetAnim(self._Entity,"idle")
MDL.SetAnimTimeScale(self._Entity, self._CurAnimIndex, self.AnimSpeed)
self.DRange = 19.4
self._bsound1=self:BindSound("DM_Sphere/rolling",20,60,true,self.j1)
self._bsound2=self:BindSound("DM_Sphere/rolling",20,60,true,self.j2)
self._bsound3=self:BindSound("DM_Sphere/rolling",20,60,true,self.j3)
self._bsound4=self:BindSound("DM_Sphere/rolling",20,60,true,self.j4)


ENTITY.EnableNetworkSynchronization(self._Entity,true,true)
end



function o:Tick(delta)
	local  aa = delta/6.36
self.delta = ( self.delta + aa ) - math.floor((self.delta+aa)/(2*math.pi))*(2*math.pi)
local joint = MDL.GetJointIndex(self._Entity, "root")
MDL.ApplyJointRotation(self._Entity, joint, 0,0,-self.delta)
self.Client_UpdatePosition(self._Entity,self.delta)

local x1,y1,z1 = MDL.TransformPointByJoint(self._Entity,self.j1,0,0,0)
local x2,y2,z2 = MDL.TransformPointByJoint(self._Entity,self.j2,0,0,0)
local x3,y3,z3 = MDL.TransformPointByJoint(self._Entity,self.j3,0,0,0)
local x4,y4,z4 = MDL.TransformPointByJoint(self._Entity,self.j4,0,0,0)

			for i,o in Game.Players do
		               if not o._died and o.Health > 0 then
				      local a,b,c = ENTITY.GetPosition(o._Entity)
		                        local dist = Dist3D(x1,y1,z1,a,b,c)
					--Game:Print("Dist="..dist)
		                       if dist < self.DRange then
						o:OnDamage(9999, nil, AttackTypes.OutOfLevel)

					else
						dist = Dist3D(x2,y2,z2,a,b,c)
				                if dist < self.DRange then
						o:OnDamage(9999, nil, AttackTypes.OutOfLevel)
						else
							dist = Dist3D(x3,y3,z3,a,b,c)
				                       if dist < self.DRange then
							o:OnDamage(9999, nil, AttackTypes.OutOfLevel)
							else
								dist = Dist3D(x4,y4,z4,a,b,c)
					                       if dist < self.DRange then
								o:OnDamage(9999, nil, AttackTypes.OutOfLevel)
								end
							end
						end
					end


	
			                        
		              end
		           end
end


function  o:Client_UpdatePosition(e,delta)
	if Game.GMode == GModes.MultiplayerClient then 
		local joint = MDL.GetJointIndex(e, "root")
		MDL.ApplyJointRotation(e, joint, 0,0,-delta)
	end
end
Network:RegisterMethod("sepovavelkakoule.Client_UpdatePosition", NCallOn.ServerAndAllClients, NMode.Reliable, "ef") 


