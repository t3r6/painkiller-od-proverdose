function o:OnInitTemplate()
    self:SetAIBrain()
    self._disableHits = true
    self._hitsCounter = 0
    self._AIBrain._lastThrowTime = FRand(-4, -1)
end

function o:Shakeg()
Game._EarthQuakeProc:Add(self.Pos.X,self.Pos.Y,self.Pos.Z, 25, 250, 0.1 , 0.1, 0.1)	
end

function o:OnCreateEntity()
	self.specnum = 0
	self._imflame1=self:BindFX('bottom')
	self._imflame2=self:BindFX('relbow')
	self._imflame3=	self:BindFX('lelbow')
	self._imflame4=	self:BindFX('lwrist')
	self._imflame5=	self:BindFX('rwrist')
	self.rocknumber = 1+math.random(5)
	Game.MegaBossHealthMax = self.Health
	Game.MegaBossHealth = self.Health
	self:BindSound("actor/mw_guardian/guard_loop",100,300,true)
	self.state = 0
	self.corner = 1
	Game.Guardian=true
	self.Immortal =true
	self.goodies={"Health.CItem","MegaPack.CItem","ArmorWeak.CItem"}
	self.goodie = nil
	self.goodiepos = Vector:New(0.91124296188354,15.855536460876,1.1757230758667)
	self._sounded = false

self.hjoints={}
self.hjoints[1]={"root"}
self.hjoints[2]={"k_szyja"}
self.hjoints[3]={"r_arm","r_forearm","r_hand","l_arm","l_forearm","l_hand"}
self.seljoint = {}	

self.flamejoints={}
self.flamejoints[1]={"spine_1"}
self.flamejoints[2]={"k_szyja"}
self.flamejoints[3]={"l_forearm","r_forearm"}
end

function o:CustomDelete()
	Game.MegaBossHealth = nil
	Game.MegaBossHealthMax = nil
	Game.Guardian=false
end


function o:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Demon then
        return true 
    end
    if type == AttackTypes.Explosion or type == AttackTypes.Rocket or type == AttackTypes.OutOfLevel or type == AttackTypes.Grenade then
	return false, damage
    end

    if he then
	local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
	if jName == "wheel" then return true end
	for i,v in self.hjoints[self.seljoint] do
		if jName == v then
	            if type == AttackTypes.MiniGun or type == AttackTypes.Rifle then 
					damage = 5
	            end
		    if Game.MegaBossHealth < Game.MegaBossHealthMax/2 and not self._sounded then
			PlaySound2D("belial/Belial_ingame_67",nil,nil,true)
			self._sounded = true
			end
		    return false, damage
		end
	end
    end
return true
end


function o:lavafire()
if self.Health > 1 and Game.MegaBossHealthMax and self.Health < math.random(Game.MegaBossHealthMax) then
	self.AiParams.ThrowableItem = "BiglavaSpawn.CItem"
else
	self.AiParams.ThrowableItem = "Biglava.CItem"
end
self.AiParams.throwItemBindToOffset = Vector:New(-3, 0, 4)
self.AiParams.throwVelocity = 120
self.AiParams.throwDistMinus = 4.0
end

function o:rainfire()
self.AiParams.throwDistMinus = 1.0
self.AiParams.ThrowableItem = "Lava_rain.CItem"
self.AiParams.throwItemBindToOffset = Vector:New(-3, 0, 4)
self.AiParams.throwVelocity = 120
end

function o:finishedthrow()
self.rocknumber = self.rocknumber -1
if self._throwfire then
	PARTICLE.Die(self._throwfire)
	self._throwfire=nil
end
self.throwing=0
end

function o:finishedidle()
self.throwing=0
self.idle1=false
end


function o:CustomUpdate()
	if not self._died then
		local brain = self._AIBrain
		Game.MegaBossHealth = self.Health
	else

		Game.MegaBossHealth = 0
	end
	
end

function  o:Blaf()
local zn,idx = WPT.GetClosest(self._groundx,self._groundy,self._groundz)   		
    	if idx > -1 then
		local kx,ky,kz = WPT.GetPosition(zn,idx)    
		AddPFX("Flameblaf",3,Vector:New(kx,ky,kz))
	end
end

function o:startthrow()
	if not self._throwfire then
		self._throwfire=self:BindFX('rain')
	end
end

Guardian._CustomAiStates = {}
Guardian._CustomAiStates.ThrowRocks = {
	name = "ThrowRocks",
	
}

function o:randshift()
local x = 6- math.random(12)/2
local y = 6- math.random(12)/2
self.AiParams.throwItemBindToOffset = Vector:New(-3+y, 0+x, 4)
end

function Guardian._CustomAiStates.ThrowRocks:OnInit(brain)

	local aaa = math.random(9)
	local actor = brain._Objactor
	if actor.objtake then
		GObjects:ToKill(actor.objtake)
		actor.objtake=nil
	end
	if aaa < 3 then --ruce
		aaa=3
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add_arms")
		actor.seljointflame1 = actor:BindFX("fireskull",1.6,"r_forearm")
		actor.seljointflame2 = actor:BindFX("fireskull",1.6,"l_forearm")
	elseif aaa > 7 then --hlava
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add_head")
		actor.seljointflame2 = actor:BindFX("fireskull",1.7,"k_szyja")
		aaa = 2
	else --telo
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add_body")
		actor.seljointflame2 = actor:BindFX("fireskull",1.9,"spine1")
		aaa = 1
	end
	actor.seljoint = aaa

	if brain.r_closestEnemy then
		actor:RotateToVector(brain.r_closestEnemy._groundx, 0, brain.r_closestEnemy._groundz)
	end
	PARTICLE.Die(actor._imflame1)
	PARTICLE.Die(actor._imflame2)
	PARTICLE.Die(actor._imflame3)
	PARTICLE.Die(actor._imflame4)
	PARTICLE.Die(actor._imflame5)
	actor.Immortal = false
	actor.throwing=1
		if math.random(100) < 25 then
			actor:SetAnim("attack1",true)
		else
			actor:SetAnim("attack2",true)
		end
	
end


function Guardian._CustomAiStates.ThrowRocks:OnUpdate(brain)
end

function Guardian._CustomAiStates.ThrowRocks:OnRelease(brain)
	self.activetimer = 0
	self.active = false
	local actor = brain._Objactor
	PARTICLE.Die(actor.seljointflame2)
	if actor.seljoint == 3 then --ruce
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add")
		PARTICLE.Die(actor.seljointflame1)
	elseif actor.seljoint == 2 then --hlava
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add")
	else --telo
		MDL.SetTexture(actor._Entity,"guardian_add","guardian_add")
	end
	actor.Immortal =true
	actor._imflame1=actor:BindFX('bottom')
	actor._imflame2=actor:BindFX('relbow')
	actor._imflame3=	actor:BindFX('lelbow')
	actor._imflame4=	actor:BindFX('lwrist')
	actor._imflame5=	actor:BindFX('rwrist')

		local tmpobj=GObjects:Add(TempObjName(),CloneTemplate(actor.goodies[math.random(table.getn(actor.goodies))]))
		tmpobj.Pos = actor.goodiepos
		tmpobj:Apply()
		actor.objtake = tmpobj

end

function Guardian._CustomAiStates.ThrowRocks:Evaluate(brain)
local actor = brain._Objactor
	if actor.state == 2 then
		if actor.rocknumber < 1 then
			--Game:Print("tr < 1 ")
			actor.throwing = 0
			actor.state = 3
			return 0 
		end
		return 0.6
	end
	return 0
end


Guardian._CustomAiStates.WalkToCorner = {
	name = "WalkToCorner",
	walking = false,
	corner=1
	
}

function Guardian._CustomAiStates.WalkToCorner:OnInit(brain)
	local actor = brain._Objactor
--	MDL.SetMaterial(actor._Entity, "palskinned_freeze")
	self.walking = true
end



function Guardian._CustomAiStates.WalkToCorner:OnUpdate(brain)
	local actor = brain._Objactor
	actor:WalkTo(actor.corners.Points[actor.corner].X,actor.corners.Points[actor.corner].Y,actor.corners.Points[actor.corner].Z)	
end

function Guardian._CustomAiStates.WalkToCorner:OnRelease(brain)
	local actor = brain._Objactor
	self.walking = false
end



function Guardian._CustomAiStates.WalkToCorner:Evaluate(brain)
	local actor = brain._Objactor
	if actor.state==0 then
		i=actor.corner
		local x=actor.corners.Points[i].X
		local y=actor.corners.Points[i].Y
		local z=actor.corners.Points[i].Z
		if Dist3D(x,y,z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 5 then
			actor.state=1
			return 0
		end
		return 0.5
	end
	return 0
end
	
function o:CustomOnHit()
	if not self.s_SubClass.Hits then return end
	self._hitsCounter = self._hitsCounter + 1
	if self._hitsCounter >= 4 and not self._isRotating then
		self._hitsCounter = 0

		if not self._speeded then
			self._randomizedParams.WalkSpeed = self._randomizedParams.WalkSpeed * 1.1
			self._speeded = true
		end

		local animName = self.s_SubClass.Hits[math.random(1,table.getn(self.s_SubClass.Hits))]
						
		if not self.AIenabled and self._isAnimating then
			self._animationBeforeHit = self.Animation
		end
		if self:ForceAnim(animName, false) then
			self._lastHitAnim = animName
			self._hitDelay = self.minimumTimeBetweenHitAnimation
			if not self._hitDelay then
				self._hitDelay = 4
			end
			if self.AIenabled then
				self:Stop()
			else
				self._hitDelay = 99999	-- az do zakonczenia animacji
			end
		end
	end
end
Guardian._CustomAiStates.WaitInCorner = {
	name = "WaitInCorner",
	
}

function Guardian._CustomAiStates.WaitInCorner:OnInit(brain)
	--Game:Print("WA init")
	self.activetimer = 60
	self.active = true
	local actor = brain._Objactor
	actor:Stop()
	if  brain.r_closestEnemy then
		actor:RotateToVector(brain.r_closestEnemy._groundx, 0, brain.r_closestEnemy._groundz)
	end
	actor:SetAnim('idle_default',true)
end



function Guardian._CustomAiStates.WaitInCorner:OnUpdate(brain)
	local actor = brain._Objactor
	if self.active then
		if self.activetimer then
			self.activetimer = self.activetimer - 1
			if self.activetimer<0 then
				self.active = false
				if actor.state == 1 then
					actor.state = 2
				elseif actor.state == 3 then
					actor.rocknumber = 1+math.random(5)
					actor.state = 0
					local i,max,num = 1,0,0
					local co=actor.corner
					while i<6 do
						if co < i or co > i then
							num = math.random (0,100)
							if num > max then 
								actor.corner=i
								max=num
							end
						end
						i = i+1
					end
				else
					Game:Print("BUG!")
				end
			end
		end
	end
end

function Guardian._CustomAiStates.WaitInCorner:OnRelease(brain)
		local actor = brain._Objactor
		self.active= false
end



function Guardian._CustomAiStates.WaitInCorner:Evaluate(brain)
	local actor = brain._Objactor
	if actor.state == 1 or actor.state == 3 then
		return 0.7	
	end
	return 0
end

Guardian._CustomAiStates.Showof = {
	name = "Showof",
	
}

function Guardian._CustomAiStates.Showof:OnInit(brain)
	self.active = true
	self.walking = true
	local actor = brain._Objactor
	actor:RotateToVector(actor.showoffpoint.X,actor.showoffpoint.Y,actor.showoffpoint.Z)
end



function Guardian._CustomAiStates.Showof:OnUpdate(brain)
	local actor = brain._Objactor
	if self.active then
		if self.walking then
			if Dist3D(actor.showoffpoint.X,actor.showoffpoint.Y,actor.showoffpoint.Z,actor.Pos.X,actor.Pos.Y,actor.Pos.Z) < 5 then
				self.walking = false
			else
				actor:WalkTo(actor.showoffpoint.X,actor.showoffpoint.Y,actor.showoffpoint.Z)
			end
		else
			if not self.showing then
				actor:SetAnim('attack1',false)
				actor._AnimationEvents = nil
				self.showing=true
			else
				if not actor._isAnimating then
					actor.showed=true
				end
			end
		end
	end
end

function Guardian._CustomAiStates.Showof:OnRelease(brain)
		local actor = brain._Objactor
		actor.showed = true
end



function Guardian._CustomAiStates.Showof:Evaluate(brain)
	local actor = brain._Objactor
	if actor.showed then return 0 end
	return 0.9	
end
