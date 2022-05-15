AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_BLOATFLY,CLASS_BLOATFLY)
end

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextSpitAttack = 0
	self.moveaway = false
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self:SetSkin(1)
end