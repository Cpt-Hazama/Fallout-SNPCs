AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ARMY,CLASS_SENTRYBOT)
end
ENT.InitSkin = 1
ENT.WeaponType = 0