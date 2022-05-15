AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GHOUL
ENT.sModel = "models/fallout/ghoulferal_vaultarmor.mdl"
ENT.skName = "ghoulferal_vaultsecurity"
function ENT:GetBodyCaps() end
function ENT:SubInit()
	local skin = math.random(0,2)
	if(skin == 2) then skin = 3 end
	self:SetSkin(skin)
end