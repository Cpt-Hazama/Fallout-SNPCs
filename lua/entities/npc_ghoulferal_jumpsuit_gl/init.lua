AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GHOUL
ENT.sModel = "models/fallout/ghoulferal_jumpsuit.mdl"
ENT.CanUseRadiation = true
ENT.CanRegenHealth = true
ENT.skName = "ghoulferal_glowingone"
function ENT:SubInit()
	self:SetSkin(2)
end