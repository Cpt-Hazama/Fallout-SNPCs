AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_OUTCAST,CLASS_OUTCAST)
end

function ENT:SubInit()
	self:SetSkin(2)
end

