AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GHOUL
ENT.sModel = "models/fallout/ghoularmored.mdl"
ENT.skName = "ghoulferal_roamer"
function ENT:GetBodyCaps() end
function ENT:SubInit()
end