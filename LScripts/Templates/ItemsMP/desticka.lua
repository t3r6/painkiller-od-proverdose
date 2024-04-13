function o:OnInitTemplate()
 self._Synchronize = self.Synchronize
    self.Synchronize = nil
end


function o:OnCreateEntity()
self:PO_Create(BodyTypes.FromMesh)
ENTITY.PO_SetMovedByExplosions(self._Entity, false)
ENTITY.EnableCollisions(self._Entity, true)
ENTITY.EnableNetworkSynchronization(self._Entity,true)

local e = FindObj("sepovavelkakoule_001")        
self._shown = false
if not e then self._blocker = nil else self._blocker = e end
end


function o:Tick()
	if not self._blocker then
	 	local e=FindObj("sepovavelkakoule_001")
		if not e or not e.j1 then 
			self.Client_UpdateVisibility(self._Entity,false)
			return
		else
			self._blocker =  e
		end
	else
		local e = self._blocker
		if not e or not e.j1 then 
			self.Client_UpdateVisibility(self._Entity,false)
			return
		end
		local x1,y1,z1 = MDL.TransformPointByJoint(e._Entity,e.j1,0,0,0)
		local x2,y2,z2 = MDL.TransformPointByJoint(e._Entity,e.j2,0,0,0)
		local x3,y3,z3 = MDL.TransformPointByJoint(e._Entity,e.j3,0,0,0)
		local x4,y4,z4 = MDL.TransformPointByJoint(e._Entity,e.j4,0,0,0)

		local dist1 = Dist3D(x1,y1,z1,self.Pos.X,self.Pos.Y,self.Pos.Z)
		local dist2 = Dist3D(x2,y2,z2,self.Pos.X,self.Pos.Y,self.Pos.Z)
		local dist3 = Dist3D(x3,y3,z3,self.Pos.X,self.Pos.Y,self.Pos.Z)
		local dist4 = Dist3D(x4,y4,z4,self.Pos.X,self.Pos.Y,self.Pos.Z)
			if (dist1 < self.blockrange or dist2 < self.blockrange or dist3 < self.blockrange or dist4 < self.blockrange) then
				if self._shown then
					self.Client_UpdateVisibility(self._Entity,false)
					self._shown = false
				end
			else
				if not self._shown then
					self.Client_UpdateVisibility(self._Entity,true)
					self._shown= true
				end
			end
	end


end

function  o:Client_UpdateVisibility(e,vis)
		ENTITY.EnableCollisions(e, vis)
		if vis then
		 	ENTITY.EnableDraw(e,vis,true)
		else
		 	ENTITY.EnableDraw(e,vis,true)
		end
end
Network:RegisterMethod("desticka.Client_UpdateVisibility", NCallOn.ServerAndAllClients, NMode.Reliable, "eB") 

