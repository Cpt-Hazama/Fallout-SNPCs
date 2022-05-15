AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GHOUL
ENT.skName = "ghoulferal_swamp"
function ENT:SubInit()
	self:SetSkin(3)
end