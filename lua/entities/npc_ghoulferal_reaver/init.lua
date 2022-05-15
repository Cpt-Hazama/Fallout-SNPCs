AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GHOUL
ENT.sModel = "models/fallout/ghoulreaver.mdl"
ENT.CanUseGrenade = true
ENT.CanRegenHealth = true
ENT.skName = "ghoulferal_reaver"
function ENT:GetBodyCaps() end
function ENT:SubInit()
end