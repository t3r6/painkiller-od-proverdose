function Scene_monster:OnCreateEntity()
self:BindSound("actor/mw_scenemonster/heart_beats",3,10,true)
end

function Scene_monster:OnInitTemplate()
    self:SetAIBrain()
end

function o:BindTrails()
self._tr1= self:BindTrail('trail_kamyk','r_l_bark','l_ForeArm','l_hand')
self._tr2= self:BindTrail('trail_kamyk','r_p_bark','r_ForeArm','r_hand')
end

function o:EndTrails()
	ENTITY.Release(self._tr1)
	self._tr1 = nil
	ENTITY.Release(self._tr2)
	self._tr2 = nil
end


function o:CustomOnDamage(he,x,y,z,obj, damage, type)
 if type == AttackTypes.Demon or type == AttackTypes.Explosion or type == AttackTypes.Rocket or type == AttackTypes.OutOfLevel or type == AttackTypes.Grenade then
        return false
    end
	if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
	Game:Print("JNAME="..jName)
        if jName == "heart"  then
		return false
	end
else
if type == AttackTypes.Flamethrower  then
			return false
		end
end
return true
end
