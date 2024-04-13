function ScareCrow:OnInitTemplate()
    self:SetAIBrain()
end
function ScareCrow:BindTrails()
self._tr1= self:BindTrail('trail_zombie','joint27','scythe_c','scythe_knife')
self._tr2= self:BindTrail('trail_zombie','l_hand','l_hook')
end

function ScareCrow:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end

function o:OnCreateEntity()
	if not Lev.whirlnum then Lev.whirlnum=0 end
	self._timewhirl=math.random(self._minwhirltime,self._maxwhirltime)
end


function o:OnTick()
	if not self.whirling then 
	self._timewhirl	=self._timewhirl -1
	end
end

function o:imme()
end

function o:spme()
	if Lev.whirlnum<2 then
	        local obj = AddObject("Spawn.CSpawnPoint",nil,self.Pos,nil,true)
		obj.SpawnTemplate = string.format("ScareCrow_wirl.CActor",num)  
	        obj.SpawnFX = "MonsterSpawn.CAction"        
	        obj.StartDelay = 0
	        obj.GroupDelay = -1 -- czeka na smierc potwora
	        obj.GroupCount = 1
	        obj.GroupSize = 1
		obj.NotCountable = true
	        obj:Apply()
	        obj:OnLaunch()
	end
end

function o:omme()
	self._endwhirl=true
end
-----------------
ScareCrow._CustomAiStates = {}

ScareCrow._CustomAiStates.whirl = {
	name = "whirl",
}
function ScareCrow._CustomAiStates.whirl:OnInit(brain)
	local actor = brain._Objactor
	actor._timewhirl=0
	actor._whirling = true
	actor._endwhirl = false
	actor:ForceAnim("attack3",true)
end

function ScareCrow._CustomAiStates.whirl:OnUpdate(brain)
end


function ScareCrow._CustomAiStates.whirl:OnRelease(brain)
	local actor = brain._Objactor
	actor._timewhirl=math.random(actor._minwhirltime,actor._maxwhirltime)
	actor._whirling = false
	actor._endwhirl = false
end

function ScareCrow._CustomAiStates.whirl:Evaluate(brain)
	local actor = brain._Objactor
	if actor._endwhirl then return 0.1 end
	if actor._timewhirl < 1 then
		if math.random (100) < actor.whirlchance and Lev.whirlnum<2 then
			return 0.9
		else
		actor._timewhirl=math.random(actor._minwhirltime,actor._maxwhirltime)
		end
	end
	return 0.1
end
