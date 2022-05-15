include('shared.lua')

language.Add("obj_goregrenade", "Feral Ghoul Reaver")
function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
end
 
function ENT:OnRemove()
end
 