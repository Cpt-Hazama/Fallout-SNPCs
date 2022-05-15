AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ENCLAVE,CLASS_SENTRYBOT)
end
ENT.InitSkin = 3
ENT.WeaponType = 1