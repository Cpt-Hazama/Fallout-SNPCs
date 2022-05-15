AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ANT,CLASS_GIANTANT)
end
util.AddNPCClassAlly(CLASS_ANT,"npc_fireant")
ENT.CanUseFire = true

function ENT:SubInit()
	self:SetSkin(1)
end