o.OnInitTemplate = CItem.StdOnInitTemplate

function camera_a:OnCreateEntity()
    self:PO_Create(BodyTypes.FromMesh)
end
