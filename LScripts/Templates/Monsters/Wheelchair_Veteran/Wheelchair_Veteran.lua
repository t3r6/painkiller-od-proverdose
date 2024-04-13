function Wheelchair_Veteran:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnPrecache()
	Cache:PrecacheParticleFX("Wheelchair_Veteran_Whitesmoke")
	Cache:PrecacheParticleFX("Wheelchair_Veteran_engine")
	Cache:PrecacheParticleFX("RifleHitWall")
end


function o:Deadparticle()
if self._komkour1 then
		PARTICLE.Die(self._komkour1)
		self._komkour1 = nil
end
if self._komkour2 then
		PARTICLE.Die(self._komkour2)
		self._komkour2 = nil
end
self:BindFX("Guardian_clap",0.5,"root",1,0,-1)
self:BindFX("KamyktankFX",0.25,"root",2.5,-0.5,-1)
end


function o:Whitesmoke()
		PARTICLE.Die(self._komkour1)
		PARTICLE.Die(self._komkour2)
		self._komkour1	= self:BindFX("Wheelchair_Veteran_Whitesmoke",1,"ch_chimney",0.2,3.5,0)
		self._komkour2	= self:BindFX("Wheelchair_Veteran_Whitesmoke",1,"ch_chimney",0.2,3.5,0)
end
function o:Darksmoke()

		PARTICLE.Die(self._komkour1)
		PARTICLE.Die(self._komkour2)
		self._komkour1 = self:BindFX("Wheelchair_Veteran_engine",1,"ch_chimney",0.2,3.5,0)
		self._komkour2 =self:BindFX("Wheelchair_Veteran_engine",1,"ch_chimney",0.2,3.5,0)
	
end
function Wheelchair_Veteran:OnCreateEntity()
	self._komkour1 = self:BindFX("Wheelchair_Veteran_engine",1,"ch_chimney",0.2,3.5,0)
	self._komkour2 =self:BindFX("Wheelchair_Veteran_engine",1,"ch_chimney",0.2,3.5,0)
	self:BindFX("Wheelchair_Veteran_engine",0.05,"ch_chimney",-0.21,0.2,0)
	self:BindFX("Wheelchair_Veteran_Whitesmoke",0.02,"ch_dick",0,-0.1,1)
	self:BindSound("actor/mw_wheelchair_veteran/wheelchair_loop",5,30,true)
end

function Wheelchair_Veteran:PlaySoundIfMissed(par1, par2, par3, par4, par5)		-- do aktora?
	local brain = self._AIBrain
	if brain._lastMissedTime > brain._lastHitTime then
		self:PlaySound(par1, par2, par3, par4, par5)
	end
end

function o:OnThrow(x,y,z)
    local v = Vector:New(x,y,z)
    v:Normalize()
	local q = Quaternion:New_FromNormalX(v.X, v.Y, v.Z)
    q:ToEntity(self._objTakenToThrow._Entity)
end


function o:Fajr()
	self:BindFX("RifleHitWall",1,"ch_gun",0,0,2,true,math.pi/2,math.pi,0)
end
