AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_BOS,CLASS_PLAYER_ALLY)
end
function ENT:SubInit()
	self:SetSkin(7)
end

function ENT:SetupRelationship(entTgt)
	local faction = self:SLVGetFaction()
	if(faction == FACTION_NONE) then return end
	if(entTgt:IsPlayer()) then
		local faction = entTgt:SLVGetFaction()
		if(faction != FACTION_NONE && faction != self.Faction) then
			self:slvAddEntityRelationship(entTgt,D_HT,100)
			return true
		end
	end
end

ENT.m_tbSounds = {
	["CombatToNormal"] = "genericrob_combattonormal[1-3].mp3",
	["CombatToLost"] = "genericrobot_combattolost[1-4].mp3",

	["AlertIdle"] = "genericrobot_alertidle[1-6].mp3",
	["AlertToCombat"] = "genericrobot_alerttocombat[1-4].mp3",
	["AlertToNormal"] = "genericrobot_alerttonormal[1-3].mp3",

	["Attack"] = "genericrobot_attack[1-8].mp3",
	["Death"] = "genericrobot_death[1-6].mp3",
	["Pain"] = "genericrobot_hit1.mp3",

	["Murder"] = "genericrobot_murder[1-3].mp3",
	["GuardDeactivate"] = "../robot_deactivate.mp3"
}