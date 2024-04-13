o.OnInitTemplate = CItem.StdOnInitTemplate

function BarrelBlood:OnCreateEntity()
	self:PO_Create(BodyTypes.FromMesh)
end


function BarrelBlood:CustomOnDeath()
   local n = math.random(17,20) -- how many (min,max)
    for i = 1, n do
        local ke = AddItem("Blood.CItem",1,Vector:New(self.Pos.X,self.Pos.Y+1,self.Pos.Z),true)
        local vx = FRand(-3,3) -- velocity x
        local vy = FRand(3,4)  -- velocity y
        local vz = FRand(-3,3) -- velocity z
        ENTITY.SetVelocity(ke,vx,vy,vz)
        local ke = AddItem("VampBlood.CItem",5,Vector:New(self.Pos.X,self.Pos.Y+1,self.Pos.Z),true)
        local vx = FRand(-3,3) -- velocity x
        local vy = FRand(3,4)  -- velocity y
        local vz = FRand(-3,3) -- velocity z
        ENTITY.SetVelocity(ke,vx,vy,vz)
    end

	

end


