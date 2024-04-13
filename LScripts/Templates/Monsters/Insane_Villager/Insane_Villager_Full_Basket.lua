function Insane_Villager_Full_Basket:OnInitTemplate()
    self:SetAIBrain()
    self._AIBrain._lastThrowTime = FRand(-4, 0.5)
end

function Insane_Villager_Full_Basket:OnPrecache()
end


function Insane_Villager_Full_Basket:OnCreateEntity()
	self._bdrop=self:BindFX('drop')
	self.fon=true
end

function o:CustomOnDeath()
MDL.SetMeshVisibility(self._Entity,"torn_handShape", false)
PARTICLE.Die(self._bdrop)
end

function Insane_Villager_Full_Basket:handoff()
MDL.SetMeshVisibility(self._Entity,"torn_handShape", false)
end
function Insane_Villager_Full_Basket:handon()
MDL.SetMeshVisibility(self._Entity,"torn_handShape", true)
end

function Insane_Villager_Full_Basket:foff()
MDL.SetMeshVisibility(self._Entity,"ForksweaponShape", false)
self.fon=false
end
function Insane_Villager_Full_Basket:forkon()
	if not self.fon then
		self.fon = true
		MDL.SetMeshVisibility(self._Entity,"ForksweaponShape", true)
		self:BindFX('fap')
		self:BindFX('fap2')
	end
end

function o:GetThrowItemRotation()
	local q = Quaternion:New()
	q:FromEuler( 0, -self.angle + math.pi/2, math.pi/2)
	return q
end



function o:SetnextThrow()

	if math.random(100) < 70 then
	self.AiParams.throwAnim = "atak2"	
	self.AiParams.ThrowableItem = "BloodyHand.CItem"
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	self.AiParams.throwAngularVelocitySpeed = 20
	else
	self.AiParams.throwAnim = "atak3"	
	self.AiParams.ThrowableItem = "Widle.CItem"
	self.AiParams.throwItemBindToOffset = Vector:New(0,0,0)
	self.AiParams.throwAngularVelocitySpeed = nil
	--	self.AiParams.throwAngle = -1
	end

end

