o.OnInitTemplate = CItem.StdOnInitTemplate

function o:OnCreateEntity()
	self:PO_Create(BodyTypes.FromMesh)
end

function o:CustomOnDeath(x,y,z)
	if not x or not y or not z then
		x = self.Pos.X
		y = self.Pos.Y
		z = self.Pos.Z
	end

	if Player then
			for i,o in Game.Players do
		               if not o._died and o.Health > 0 then
				      local a,b,c = ENTITY.GetPosition(o._Entity)
		                        local dist = Dist3D(x,y,z,a,b,c)
		                       if dist < self.Poison.Range then
	      				o._poisoned = self.Poison.TimeOut
					o._poisonedTime = 0
					o._poison = self.Poison
					o._DrawColorQuad = true
					o._ColorOfQuad = Color:New(10, 10, 255)
					o._QuadAlphaMax = 50
	                        end
		              end
		           end
	end
	for i,v in Actors do
                if not v._died and v.Health > 0 then
                    local a,b,c = ENTITY.GetWorldPosition(v._Entity)
                    local dist = Dist3D(x,y,z,a,b,c)
                    if dist < self.Poison.Range then
			v.SlowMod=0.1	
			v:SlowObject2(v,0.1)
			v:Update()
                    end
                end
        end



end
