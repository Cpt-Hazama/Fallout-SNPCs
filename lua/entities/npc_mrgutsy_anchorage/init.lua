AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_BOS,CLASS_PLAYER_ALLY)
end

function ENT:SubInit()
	self:SetSkin(4)
end