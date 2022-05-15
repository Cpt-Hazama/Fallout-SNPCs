AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_NUKA,CLASS_NUKA)
end
function ENT:SubInit()
	self:SetSkin(1)
end
ENT.tblCRelationships = {
	[D_NU] = {"monster_gman","npc_seagull", "npc_antlion_grub", "npc_barnacle", "monster_cockroach", "npc_pigeon", "npc_crow"},
	[D_FR] = {"npc_strider","npc_combinegunship","npc_combinedropship", "npc_helicopter"},
	[D_HT] = {"obj_sentrygun", "npc_clawscanner", "npc_headcrab_poison", "npc_stalker"},
	[D_LI] = {"npc_protectron_nuka"}
}

ENT.m_tbSounds = {
	["NormalToCombat"] = "ms05nukaro_normaltocombat[1-7].mp3",
	["AlertToCombat"] = "ms05nukaro_alerttocombat[1-7].mp3",
	["LostToCombat"] = "ms05nukaro_losttocombat[1-7].mp3",
	["Attack"] = "ms05nukarobots_attack[1-10].mp3",
	["Death"] = "genericrobot_death[1-6].mp3",
	["Pain"] = "genericrobot_hit1.mp3",

	["Murder"] = "genericrobot_murder[1-3].mp3",
	["GuardDeactivate"] = "../robot_deactivate.mp3"
}