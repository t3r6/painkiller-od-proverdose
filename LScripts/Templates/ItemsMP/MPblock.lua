function o:OnInitTemplate()
    self._Synchronize = self.Synchronize
    self.Synchronize = nil
end

function o:OnCreateEntity()
    self:PO_Create(BodyTypes.FromMesh)
ENTITY.EnableNetworkSynchronization(self._Entity,true,false)

end
--[[
--============================================================================
function BarrelBig_MP:OnRespawn(entity)
    local x,y,z = ENTITY.GetPosition(entity)
    AddObject("FX_ItemRespawn.CActor",1.5,Vector:New(x,y,z),nil,true) 
end
-------------------------------------------------------------------------------
Network:RegisterMethod("BarrelBig_MP.OnRespawn", NCallOn.AllClients, NMode.Reliable, "e")
--]]