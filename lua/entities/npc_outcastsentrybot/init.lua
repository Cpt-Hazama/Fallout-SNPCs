AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_OUTCAST,CLASS_SENTRYBOT)
end
ENT.InitSkin = 2
ENT.WeaponType = 0