AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.iClass = CLASS_ANCHORAGE

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_BOS,CLASS_PLAYER_ALLY)
end
ENT.InitSkin = 4
ENT.WeaponType = 1