AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.sSoundDir = "npc/mrgutsy/"
ENT.m_tbSounds = {
	["NormalToAlert"] = "genericrobot_normaltoalert[1-3].mp3",
	["NormalToCombat"] = "genericrob_normaltocombat[1-3].mp3",

	["CombatToNormal"] = "genericrob_combattonormal[1-3].mp3",
	["CombatToLost"] = "genericrobot_combattolost[1-3].mp3",

	["AlertIdle"] = "genericrobot_alertidle[1-6].mp3",
	["AlertToCombat"] = "genericrobot_alerttocombat[1-6].mp3",
	["AlertToNormal"] = "genericrobot_alerttonormal[1-3].mp3",

	["LostIdle"] = "genericrobot_lostidle[1-3].mp3",
	["LostToCombat"] = "genericrobot_losttocombat[1-3].mp3",
	["LostToNormal"] = "genericrobot_losttonormal[1-3].mp3",

	["Attack"] = "genericrobot_attack[1-18].mp3",
	["Death"] = "genericrobot_death[1-6].mp3",
	["Pain"] = "genericrobot_hit[1-6].mp3",
	["Idle"] = "genericidl_idlechatter1.mp3",

	["Murder"] = "genericrobot_murder[1-3].mp3",

	["Deactivate"] = "dialoguecitadel_goodbye_00024150_1.mp3",
	["GuardDeactivate"] = "../robot_deactivate.mp3"
}