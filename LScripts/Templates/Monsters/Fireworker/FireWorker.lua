function o:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastTimeRaid = FRand(-4,0)
end

function o:Dieflare()
self._daf=self:BindFX("shotgunHitWall",0.5,'gun',-0.35,-1,0)
end


function o:EFL()
PARTICLE.Die(self._daf)
end

function o:OnCreateEntity()
MDL.SetMeshVisibility(self._Entity, "RocketMeshShape", false)

end


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


function o:SetnextThrow()

	if math.random(100) < 10 then
	self.AiParams.throwAnim = "attack2"	
	self.AiParams.FarAttacks = {"attack2",}
	else
	self.AiParams.throwAnim = "attack1"	
	self.AiParams.FarAttacks = {"attack1",}
	end

end

function o:rockon()
MDL.SetMeshVisibility(self._Entity, "RocketMeshShape", true)
end
function o:rockoff()
MDL.SetMeshVisibility(self._Entity, "RocketMeshShape", false)
end

function o:batoff()
MDL.SetMeshVisibility(self._Entity, "KitBagRocketMeshShape", false)
end
function o:baton()
MDL.SetMeshVisibility(self._Entity, "KitBagRocketMeshShape", true)
end
function o:Throwall()
	local aiParams = self.AiParams
	local idx  = MDL.GetJointIndex(self._Entity,"KitBag")
	local  a=-3
	while a <3 do
		local zzx=math.random(10)/7

	local x,y,z = MDL.TransformPointByJoint(self._Entity, idx, aiParams.rocketbagOffset.X+a,aiParams.rocketbagOffset.Y+zzx, aiParams.rocketbagOffset.Z)
		Game:Print("startpos="..x..","..y..","..z)
	--local x,y,z = MDL.TransformPointByJoint(self._Entity, idx,0,0,0)
	y=y+1
	local obj = GObjects:Add(TempObjName(),CloneTemplate(aiParams.ThrowableItem))
	obj.ObjOwner = self
	obj._joint = idx
	obj.Pos.X = x
	obj.Pos.Y = y
	obj._raid = y
	obj.Pos.Z = z
	obj:Apply()
	obj:Synchronize()
	self._objTakenToThrow = obj
	self:ThrowTaken(nil, nil, nil )

	a=a+1
	end
end
