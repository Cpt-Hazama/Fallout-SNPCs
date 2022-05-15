AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_RADSCORPION,CLASS_RADSCORPION)
end
ENT.sModel = "models/fallout/radscorpion.mdl"
ENT.GlowType = true