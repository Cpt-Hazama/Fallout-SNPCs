
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetSolid(SOLID_NONE)
	self.delayRemove = CurTime() +0.19
end

function ENT:Think()
	if CurTime() < self.delayRemove then self:NextThink(CurTime()); return true end
	self.delayRemove = nil
	self:Remove()
end

function ENT:SetDestination(vecPos)
	self:SetNetworkedVector("dest", vecPos)
end