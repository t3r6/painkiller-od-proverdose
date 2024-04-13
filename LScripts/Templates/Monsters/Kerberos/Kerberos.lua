function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity()
	self._lastDamageStep = -100
	Game.MegaBossHealthMax = self.Health - self.SecondHeadHealth 
	Game.MegaBossHealth = self.Health - self.SecondHeadHealth 
	self._AIBrain._lastThrowTime = FRand(-2, 2)
	self:SpawnDogs(true)
--	self:BindFX("pochodnia",0.1,self.AiParams.weaponBindPos,self.AiParams.weaponBindPosShift.X,self.AiParams.weaponBindPosShift.Y,self.AiParams.weaponBindPosShift.Z)
--	self:BindFX("pochodnia",0.1,self.AiParams.secondWeaponBindPos,self.AiParams.secondWeaponBindPosShift.X,self.AiParams.secondWeaponBindPosShift.Y,self.AiParams.secondWeaponBindPosShift.Z)
--
self._attackmode = 1
self.AiParams.throwAnim = "atak1"
self._eye1=self:BindFX('redeye_left')
self._eye2=self:BindFX('redeye_right')
self._second = false
self._third = false
self.state = "false"
--AddPFX("Snow_Giant_Skycicle_snowblast", 10, self.Pos )
--AddPFX("Snow_Giant_Skycicle_snowblast", 10, self.Pos )
--AddPFX("Snow_Giant_Skycicle_snowblast", 10, self.Pos )
--AddPFX("Snow_Giant_Skycicle_snowblast", 10, self.Pos )
Game.Kerberosface=1
end

function o:OnTick()
	if self.Health <= self.SecondHeadHealth then
		if not self._second then
			self.state="hurt"
			self:SpawnDogs(false)
			Game.MegaBossHealthMax = self.Health - self.ThirdHeadHealth 
			Game.Kerberosface=2
			self:BindFX('Right_head_dead')
			self._attackmode = 2
			self.AiParams.throwAnim = "atak2"
			self.AiParams.ThrowableItem = "BlueBreath.CItem"
			PARTICLE.Die(self._eye1)
			PARTICLE.Die(self._eye2)
			self._eye1=self:BindFX('blueeye_left')
			self._eye2=self:BindFX('blueeye_right')
			self._second = true
			MDL.SetTexture(self._Entity, "cerberos_R_head","cerberos_R_head_death")
			MDL.SetTexture(self._Entity, "cerberos_R_head_add","cerberos_R_head_death_add")
		end
	end
	if self.Health <= self.ThirdHeadHealth then
		if not self._third then
			self.state="hurt"
			self:SpawnDogs(true)
			self._third = true
			self:BindFX('Left_head_dead')
			Game.Kerberosface=3
			Game.MegaBossHealthMax = self.Health
			self._attackmode = 3
			self.AiParams.throwAnim = "atak3"
			self.AiParams.throwItemBindToOffset = Vector:New(0.0, -0.1, 0.6)
			self.AiParams.ThrowableItem = "GreenBreath.CItem"
			PARTICLE.Die(self._eye1)
			PARTICLE.Die(self._eye2)
			self._eye1=self:BindFX('greeneye_left')
			self._eye2=self:BindFX('greeneye_right')
			MDL.SetTexture(self._Entity, "cerberos_L_head","cerberos_L_head_death")
			MDL.SetTexture(self._Entity, "cerberos_L_head_add","cerberos_L_head_death_add")
		end
	end
		
end


function o:CustomOnDamage(he,x,y,z,obj, damage, type,nx,ny,nz)
	if type == AttackTypes.Demon then
	        return true 
	    end
	if he then
        	local t,e,j = PHYSICS.GetHavokBodyInfo(he)
	        local jName = MDL.GetJointName(e,j)
		if self._attackmode == 1 then
	        	if jName == "RightHand" or jName == "RightRing" then
				return false
			end
		end
		if self._attackmode == 2 then
	        	if jName == "LeftHand" or jName == "LeftRing" then
				return false
			end
		end
		if self._attackmode == 3 then
	        	if jName == "Neck" or jName == "Jaw" then
				return false
			end
		end

	end
	return true
end


function o:OnThrow(x,y,z)
	local aiParams = self.AiParams
	local gun = aiParams.weapon
	local v2 = Vector:New(x,y,z)
	v2:Normalize()
	local q = Quaternion:New_FromNormal(v2.X, v2.Y, v2.Z)

    local idx
    
	--[[if self._useSecondWeapon then
		idx = MDL.GetJointIndex(self._Entity, aiParams.secondWeaponBindPos)
	else
        idx = MDL.GetJointIndex(self._Entity, aiParams.weaponBindPos)
    end
	local srcx,srcy,srcz = MDL.TransformPointByJoint(self._Entity, idx, 0,0,0)--]]
	
	local srcx,srcy,srcz = self._objTakenToThrow.Pos.X,self._objTakenToThrow.Pos.Y,self._objTakenToThrow.Pos.Z
	if self._attackmode == 1 then
		self:BindFX('fireattack')
	end

	if self._attackmode == 2 then
		self:BindFX('iceattack')
	end
	
	if self._attackmode == 3 then
		self:BindFX('poisonattack')
	end



	
end


function o:RotateTo(ang, disableRotWithAnim)
	if self._isWalking or disableRotWithAnim or not self:RotateToWithAnim(ang) then
		if not self._rotatingWithAnim then
			self._angleDest = math.mod(ang * math.pi/180, math.pi*2)
			self._isRotating = true
		end
	end
end

function o:Rotate(ang, disableRotWithAnim)
--	    Game:Print(GetCallStackInfo(2))
	if self._isWalking or disableRotWithAnim or not self:RotateWithAnim(ang) then
		if not self._rotatingWithAnim then
			self._angleDest = math.mod(self.angle + ang * math.pi/180, math.pi*2)
			self._isRotating = true
		end
	end
end

function o:RotateToVector(tx,ty,tz, disableRotWithAnim)
    if debugMarek then
        if Dist3D(tx,0,tz,self._groundx,0,self._groundz) < 0.01 then
            self._isRotating = true
            return
        end
    end

    if self._isWalking or disableRotWithAnim or not self:RotateToVectorWithAnim(tx,ty,tz) then
		if not self._rotatingWithAnim then
			self._angleDest = math.atan2(tx - self._groundx, tz - self._groundz)
			self._isRotating = true
		end
    end
end


function o:CustomUpdate()
	if self._attackmode == 1 then
		Game.MegaBossHealth = self.Health  - self.SecondHeadHealth 
	end

	if self._attackmode == 2 then
		Game.MegaBossHealth = self.Health  - self.ThirdHeadHealth 
	end
	
	if self._attackmode == 3 then
		Game.MegaBossHealth = self.Health  
	end
	if self.AIenabled then
        local aiParams = self.AiParams
		local x,y,z = self:GetJointPos('LeftToeBase')
		local dist = Dist3D(x,y,z, Player._groundx, Player._groundy + 1.7, Player._groundz)
		if dist < aiParams.touchFeetRange and self._lastDamageStep + 0.8 < self._AIBrain._currentTime then
			self._lastDamageStep = self._AIBrain._currentTime
			--Game:Print("dotknal gracza p ")
			Player:OnDamage(self.AiParams.touchFeetDamage, self)			-- pozniej min delay dodac
		end
		
		x,y,z = self:GetJointPos('RightToeBase')
		dist = Dist3D(x,y,z, Player._groundx, Player._groundy + 1.7, Player._groundz)
		if dist < aiParams.touchFeetRange and self._lastDamageStep + 0.8 < self._AIBrain._currentTime then
			self._lastDamageStep = self._AIBrain._currentTime
			--Game:Print("dotknal w gracza l ")
			Player:OnDamage(self.AiParams.touchFeetDamage, self)
		end
	end
end

function o:CustomOnDeath()		-- powinno byc delete Game:EnableCollisions
	self._timerToDemon = 10
	self._disableDemonic = true

	local i = MDL.GetJointIndex(self._Entity, "root")
	local x1,y1,z1 = MDL.GetJointPos(self._Entity, i)
	Game.MegaBossHealth = nil
	Game.Kerberosface=0
	Game.MegaBossHealthMax = nil
	local v = Vector:New(x1 - PX, y1 - PY, z1 - PZ)
	v:Normalize()
	local rnd2 = self.impulseAfterDeathY
	local rnd1 = v.X * self.impulseAfterDeathXZ
	local rnd3 = v.Z * self.impulseAfterDeathXZ

	ENTITY.SetVelocity(self._Entity, rnd1, rnd2, rnd3)
end


function Kerberos:SpawnDogs(second)
	--Game:Print("Spawning")
	        local pos = Vector:New(10,9,1096)    
	        local obj = AddObject("Spawn.CSpawnPoint",nil,pos,nil,true)
		obj.SpawnTemplate = string.format("Ragnadog.CActor",num)  
	        obj.SpawnFX = "MonsterSpawn.CAction"        
	        obj.StartDelay = 1
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
	        obj:Apply()
	        obj:OnLaunch()
	         pos = Vector:New(-27,9,1096)    
	        local obj = AddObject("Spawn.CSpawnPoint",nil,pos,nil,true)
		obj.SpawnTemplate = string.format("Ragnadog.CActor",num)  
	        obj.SpawnFX = "MonsterSpawn.CAction"        
	        obj.StartDelay = 1
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
	        obj:Apply()
	        obj:OnLaunch()
		if  second then
	         pos = Vector:New(-10,9,1078)   
 	        local obj = AddObject("Spawn.CSpawnPoint",nil,pos,nil,true)
		obj.SpawnTemplate = string.format("Ragnadog.CActor",num)  
	        obj.SpawnFX = "MonsterSpawn.CAction"        
	        obj.StartDelay = 1
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
	        obj:Apply()
	        obj:OnLaunch()

	         pos = Vector:New(-10,9,1107)    
	        local obj = AddObject("Spawn.CSpawnPoint",nil,pos,nil,true)
		obj.SpawnTemplate = string.format("Ragnadog.CActor",num)  
	        obj.SpawnFX = "MonsterSpawn.CAction"        
	        obj.StartDelay = 1 
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
	        obj:Apply()
	        obj:OnLaunch()
	end
end



Kerberos._CustomAiStates = {}

Kerberos._CustomAiStates.Scream = {
	name = "Scream",
	
}

function Kerberos._CustomAiStates.Scream:OnInit(brain)
	local actor = brain._Objactor
	self.activetimer = 60
	actor:SetAnim('scream',false)
	actor.Immortal=true
end



function Kerberos._CustomAiStates.Scream:OnUpdate(brain)
local actor = brain._Objactor
	if actor.state=="hurt" then
		if self.activetimer then
			self.activetimer = self.activetimer - 1
			if self.activetimer<0 then
				actor.state = "false"
			end
		end
	end

	
end

function Kerberos._CustomAiStates.Scream:OnRelease(brain)
	local actor = brain._Objactor
	actor.Immortal=false
end



function Kerberos._CustomAiStates.Scream:Evaluate(brain)
	local actor = brain._Objactor
	if actor.state == "hurt" then
		return 1
	end
	return 0 
end


