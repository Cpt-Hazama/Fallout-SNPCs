AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_MIRELURK,CLASS_MIRELURK)
end
ENT.NPCFaction = NPC_FACTION_MIRELURK
ENT.iClass = CLASS_MIRELURK
-- util.AddNPCClassAlly(CLASS_MIRELURK,"npc_mirelurkhunter")
ENT.sModel = "models/fallout/mirelurk_hunter.mdl"
ENT.fMeleeDistance = 70
ENT.fMeleeForwardDistance = 360
ENT.CollisionBounds = Vector(30,30,95)
ENT.skName = "mirelurk_hunter"

function ENT:_PossShouldFaceMoving(possessor)
	return false
end