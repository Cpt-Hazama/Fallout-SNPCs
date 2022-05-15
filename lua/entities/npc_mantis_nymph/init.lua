AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_CRITTER
ENT.sModel = "models/fallout/mantis_nymph.mdl"
ENT.fMeleeDistance	= 35
ENT.fMeleeForwardDistance = 200
ENT.skName = "mantis_nymph"
function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(16,16,24), Vector(-16,-16,0))

	self:slvCapabilitiesAdd(CAP_MOVE_GROUND)

	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self:SetSoundVolume(60)
end