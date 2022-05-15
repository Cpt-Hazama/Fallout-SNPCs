AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_PLAYER,CLASS_PLAYER_ALLY)
end
function ENT:SubInit()
	self:SetSkin(5)
end
ENT.tblCRelationships = {
	[D_NU] = {"monster_gman","npc_seagull", "npc_antlion_grub", "npc_barnacle", "monster_cockroach", "npc_pigeon", "npc_crow"},
	[D_FR] = {"npc_strider","npc_combinegunship","npc_combinedropship", "npc_helicopter"},
	[D_HT] = {"obj_sentrygun", "npc_clawscanner", "npc_headcrab_poison", "npc_stalker"},
	[D_LI] = util.GetNPCClassAllies(CLASS_PLAYER_ALLY)
}

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