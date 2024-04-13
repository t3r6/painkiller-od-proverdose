function ScareCrow_wirl:OnInitTemplate()
    self:SetAIBrain()
    self.angler = 0
end

function ScareCrow_wirl:OnCreateEntity()
	ENTITY.EnableDemonic(self._Entity,true,true)
	self:BindSound("actor/mw_scarecrow/wirl_loop",10,50,true)
	if not Lev.whirlnum then Lev.whirlnum = 0 else
	Lev.whirlnum=Lev.whirlnum+1
	end
end


function o:OnTick()
	local l_joint=  MDL.GetJointIndex(self._Entity, "l_arm") 
	local r_joint=  MDL.GetJointIndex(self._Entity, "r_arm") 
	local t_joint=  MDL.GetJointIndex(self._Entity, "toe") 
	local px,py,pz = MDL.TransformPointByJoint(self._Entity,l_joint)
	local lx,ly,lz = MDL.TransformPointByJoint(self._Entity,r_joint)
	local tx,ty,tz = MDL.TransformPointByJoint(self._Entity,t_joint)
	local side2 = Vector:New(lx-px,ly,lz-pz)	
	side2:Normalize()
	AddPFX('whirlwind',0.7,Vector:New(tx+math.sin(self.angler),ty,tz+math.cos(self.angler)))
	AddPFX('whirlwind',0.7,Vector:New(tx+math.sin(self.angler+30),ty,tz+math.cos(self.angler+30)))
	AddPFX('whirlwind',0.7,Vector:New(tx+math.sin(self.angler+30),ty+1,tz+math.cos(self.angler+30)))
	AddPFX('whirlwind',0.7,Vector:New(tx+math.sin(self.angler+60),ty,tz+math.cos(self.angler+60)))
	AddPFX('whirlwind',0.7,Vector:New(tx+math.sin(self.angler+60),ty+2,tz+math.cos(self.angler+60)))
	AddPFX('whirlwind02',1,Vector:New(tx+math.sin(self.angler+90),ty+4,tz+math.cos(self.angler+90)))
	self.angler=self.angler+90
	self.Timer = self.Timer - 1
	if (self.Timer < 0 ) then 
		self:PlaySound({"$/actor/mw_scarecrow/wirl_out"})
		Lev.whirlnum=Lev.whirlnum -1 
		GObjects:ToKill(self) 
		end
	
	--check damage
	ENTITY.RemoveFromIntersectionSolver(self._Entity)
		local b,d,xcol,ycol,zcol,nx,ny,nz,he,e = WORLD.LineTraceHitPlayerBalls(px+side2.X*self.range,ty,pz+side2.Z*self.range)
		if e then
			local obj = EntityToObject[e]
			if obj and (obj._Class=="CItem" or obj._Class == "CPlayer" ) then
				obj:OnDamage(self.Damage, self)
			end
		end
	ENTITY.AddToIntersectionSolver(self._Entity)
end
