function Alastornew:OnPrecache()
	Cache:PrecacheDecal(self.HitDecal)
	Cache:PrecacheParticleFX("flame_loony_torch")
	Cache:PrecacheParticleFX("bubble_smoke")
	Cache:PrecacheParticleFX("flame_city")
	Cache:PrecacheParticleFX("AlastornewenergyFX")
	Cache:PrecacheParticleFX(self.flamerFX)
	Cache:PrecacheParticleFX("but")
	Cache:PrecacheActor("Alastor_ice.CActor")
	Cache:PrecacheActor("Alastor_fire.CActor")
	Cache:PrecacheActor("Alastor_throw.CActor")
	Cache:PrecacheActor("Alastor_attack.CActor")

end


function Alastornew:OnInitTemplate()
    self:SetAIBrain()
end


function Alastornew:OnCreateEntity()
--ENTITY.PO_SetCollisionGroup(self._Entity, ECollisionGroups.OnlyWithFixedSpecial)
	self._disableHits = true
	ENTITY.PO_EnableGravity(self._Entity,false)
	ENTITY.PO_SetMovedByExplosions(self._Entity, false)
	self._speedDamping = true
	self.flyup = false
	self._phase = 0
	self.AiParams.wingJointsNo = {}
	for i,v in self.AiParams.wingJoints do
		local idx  = MDL.GetJointIndex(self._Entity,v)
		if idx == -1 then
			Game:Print(v.." not found")
		end
		table.insert(self.AiParams.wingJointsNo, idx)
	end
	self._moveWithAnimationDoNotUpdateAngle = true
	DebugSpheres = {}
	--self.moder = 0

	PHYSICS.ActiveMeshGroupEnable(1, true)
	ENTITY.EnableDeathZoneTest(self._Entity, false)
	AddPFX("bubble_smoke", 15.0, self.Pos)
	
end

function Alastornew:DrawBezierLine(points,parts,mode,size,color,rnd)

    local va = VARRAY.Create()
    for i,o in points do
        VARRAY.AddPoint(va,o.X,o.Y,o.Z)
    end
    local spr = R3D.Spr_Create(size,color,"particles/spaw",mode)
    if not rnd then rnd = 0.05 end
    local px,py,pz
    for i=0,parts do
        px,py,pz = VARRAY.GetBezierPoint(va,i/(parts-1))
        if i ~= 0 then
            px = FRand(px-rnd, px+rnd)
            py = FRand(py-rnd, py+rnd)
            pz = FRand(pz-rnd, pz+rnd)
        end
        R3D.Spr_AddPoint(spr,px,py,pz)
    end
    R3D.Spr_Render(spr)
    VARRAY.Delete(va)
end

function Alastornew:Greenhands()
self:BindFX("Frankenstein_chargebody", 2.5, "d_p_5_1")
self:BindFX("Frankenstein_chargebody", 2.5, "r_p_lokiec")
--self:BindFX("Frankenstein_chargebody", 2.5, "dlo_prawa_root")
self:BindFX("Frankenstein_chargebody", 2.5, "d_l_5_1")
self:BindFX("Frankenstein_chargebody", 2.5, "r_l_lokiec")
--self:BindFX("Frankenstein_chargebody", 2.5, "dlo_leva_root")
end

function Alastornew:SpawnPhantoms()
range = self.spawnrange
ang = 0
local q = Quaternion:New()
local num=1
while ang < math.pi do
	Game:Print("debugangle "..ang)
	a=math.cos(ang)*range
	b=math.sin(ang)*range
	px = self.Pos.X+a
	py = self.Pos.Y
	pz = self.Pos.Z+b
	local zn,idx = WPT.GetClosest(px,py,pz)   		
    	if idx > -1 then
		Game:Print("idxed "..idx)
	        local x,y,z = WPT.GetPosition(zn,idx)    --[[
		points=
			{
			Vector:New(self.Pos.X,self.Pos.Y,self.Pos.Z),
			Vector:New(x,y,z),
			}
		local t = Templates["DriverElectro.CWeapon"]		
		t:DrawBezierLine(points,2,11,FRand(0.08,0.1),R3D.RGB(FRand(65,90),FRand(75,115),FRand(200,250))) ]]--
--		Game:Print("x,y,z "..x..","..y..","..z)
--		Game:Print("x2,y2,z2"..self.Pos.X..",".self.Pos.Y..","..self.Pos.Z)
	        local pos = Vector:New(x,y+2.5,z)    
	        local obj = AddObject("Spawn.CSpawnPoint",nil,pos,nil,true)
		if (num > 5) then num=1 end
		obj.SpawnTemplate = string.format("Monster%02d.CActor",num)  
	        obj.SpawnFX = "MonsterSpawn.CAction"        
--		Game:Print("spawn")
	        obj.StartDelay = FRand(1,4)
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
--	        obj._EnableDemonic = true
	        obj:Apply()
	        obj:OnLaunch()
		--pfx
--		obj._part=AddPFX("AlastorSpawnFX", 0.8, pos)
		obj._part=AddPFX("AlastorkingnewSpawnFX", 1, pos)

		
		num = num + 1
--       table.insert(self._monsters,obj)
	
	end
	ang= ang + math.pi/self.spawnnumber 
end
self._spawned = true	
end


Alastornew._CustomAiStates = {}

Alastornew._CustomAiStates.idleAlastornew = {
	lastTimeAmbientSound = 0,
	lastAmbient = 1.0,
	name = "idleAlastornew",
}
function Alastornew._CustomAiStates.idleAlastornew:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	actor:Stop()
	--Game:Print("idle oninit")
end

function Alastornew._CustomAiStates.idleAlastornew:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	
	if self.lastAmbient + 1.0 < brain._currentTime and actor._phase == 0 then
		local tabl = aiParams.actions
		--Game:Print("losowanie check "..brain._currentTime)
		self.lastAmbient = brain._currentTime
		self._submode = nil
		local mul = 1.0
		if actor._damage then
			mul = 1.2			-- jak dostanie hita to chetniej losuje ataki
		end
		for i,v in tabl do
			if FRand(0.0, 1.0) < v[2] * mul then
				self._submode = v[1]
				break
			end
		end

		if self._submode then
			--Game:Print("losowanie "..self._submode)
			brain._submode = self._submode
			return
		end
		actor._damage = false
	end

	actor._CANWALK = true
end



function Alastornew._CustomAiStates.idleAlastornew:OnRelease(brain)
	local actor = brain._Objactor
	brain._rotate180AfterEndWalking = nil
	actor._CANWALK = false
end

function Alastornew._CustomAiStates.idleAlastornew:Evaluate(brain)
	return 0.01
end

function Alastornew._CustomAiStates.idleAlastornew:OnUpdate(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	
	if self.lastAmbient + 1.0 < brain._currentTime and actor._phase == 0 then
		local tabl = aiParams.actions
		--Game:Print("losowanie check "..brain._currentTime)
		self.lastAmbient = brain._currentTime
		self._submode = nil
		local mul = 1.0
		if actor._damage then
			mul = 1.2			-- jak dostanie hita to chetniej losuje ataki
		end
		for i,v in tabl do
			if FRand(0.0, 1.0) < v[2] * mul then
				self._submode = v[1]
				break
			end
		end

		if self._submode then
			--Game:Print("losowanie "..self._submode)
			brain._submode = self._submode
			return
		end
		actor._damage = false
	end

	actor._CANWALK = true
end

Alastornew._CustomAiStates.spawningAlastornew = {
	lastTimeAmbientSound = 0,
	lastAmbient = 1.0,
	name = "spawningAlastornew",
}

function Alastornew._CustomAiStates.spawningAlastornew:OnInit(brain)
	local actor = brain._Objactor
	local aiParams = actor.AiParams
	self.active = true
	actor.tick = 0
	actor:Stop()
	actor:SetAnim(aiParams.spawnAnimation,true)
end

function Alastornew._CustomAiStates.spawningAlastornew:OnUpdate(brain)
	local actor = brain._Objactor
	if actor._spawned then actor.tick = actor.tick + 1 end
end


function Alastornew._CustomAiStates.spawningAlastornew:OnRelease(brain)
	local actor = brain._Objactor
	brain._rotate180AfterEndWalking = nil
	actor._CANWALK = false
	actor.flyup = true
end

function Alastornew._CustomAiStates.spawningAlastornew:Evaluate(brain)
	local actor = brain._Objactor
	if actor._spawned and actor.tick > 110 then return 0 end
--		local dist = Dist3D(actor._groundx,actor._groundy,actor._groundz, Player._groundx, Player._groundy + 1.5, Player._groundz)	
--		if dist < 50 or self.active then
			return 1
--		end
--	return 0
end
Alastornew._CustomAiStates.flyupAlastor = {		
	name = "flyupAlastor",
	active = false,
	timer = 0,
	flyuptimer = 40,
}

function Alastornew._CustomAiStates.flyupAlastor:OnInit(brain)
	self.active = true
	self.timer = 0
	local actor = brain._Objactor
	actor._groundx,actor._groundy,actor._groundz = ENTITY.PO_GetPawnFloorPos(actor._Entity)
	actor:FlyTo(actor._groundx,actor._groundy+80,actor._groundz,false,"fly_up")
	
end
function Alastornew._CustomAiStates.flyupAlastor:OnUpdate(brain)
	local actor = brain._Objactor
	if self.timer >  self.flyuptimer then 
		self.active = false 
		actor.flyup = false
	else
		self.timer = self.timer + 1
	end	
end
function Alastornew._CustomAiStates.flyupAlastor:OnRelease(brain)
	local actor = brain._Objactor
	actor.flyup = false
	AddPFX("bubble_smoke", 15.0, actor.Pos)
	self.active = nil 
	actor:Stop()
	actor:Delete()
end
function Alastornew._CustomAiStates.flyupAlastor:Evaluate(brain)
	local actor = brain._Objactor
	if actor.flyup  or self.active then
		return 1
	end
	
	return 0
end


function Alastornew:OnApply()
	self:PlayRandomSound2D({"alastor_ambient-stereo1","alastor_ambient-stereo2","alastor_ambient-stereo3",})
	self._flySound = self:BindSound("actor/alastor/alastor_fly-loop",16, 60, true)
end



function Alastornew:CustomOnDamage(he,x,y,z,obj,damage,type,nx,ny,nz)
	return true
end
 

function Alastornew:OnTick(delta)

	if self._selfrotate then
		self.angle = self.angle + self.fallingRotateSpeed * delta
		self._angleDest = self.angle
		ENTITY.SetOrientation(self._Entity,self.angle)
	end
end


function Alastornew:Charge()
	--Game:Print("charge!")
	if self.Health < self._HealthMax then
		for i,v in self._monks do
			if v.Health > 0 then
				self.Health = self.Health + self._HealthMax * 1/80
			end
		end
	end
	if self.Health > self._HealthMax then
		self.Health = self._HealthMax
	end
end


function Alastornew:EnableRotate()		-- zeby w powietrzu mogl sie obracac
	self._canRotate = true
end

function Alastornew:DisableRotate()
	self._canRotate = false
end

