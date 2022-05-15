AddCSLuaFile("shared.lua")

include('shared.lua')
ENT.NPCFaction = NPC_FACTION_DEATHCLAW
ENT.sModel = "models/fallout/deathclaw_alphamale.mdl"
ENT.skName = "deathclaw_alphamale"
ENT.sndConscious = "deathclawgt_consciouslp.wav"

local tbSoundEvents = {
	["Attack"] = "deathclawgt_strike0[1-4].mp3",
	["AttackPower"] = "deathclawgt_poweratk0[1-3].mp3",
	["Death"] = "deathclaw_deathgt0[1-2].mp3",
	["Pain"] = "deathclawgt_pain0[1-2].mp3",
	["Chase"] = "deathclawgt_chase0[1-3].mp3",
	["AttackClaw"] = "deathclawgt_claw_atk0[1-4].mp3",
	["Swing"] = "deathclawgt_swinggt0[1-4].mp3",
	["FootLeft"] = "foot/deathclaw_foot_l0[1-2].mp3",
	["FootRight"] = "foot/deathclaw_foot_r0[1-2].mp3",
	["FootRunLeft"] = "foot/deathclaw_foot_run_l0[1-3].mp3",
	["FootRunRight"] = "foot/deathclaw_foot_run_r.mp3"
}

function ENT:GetSoundEvents() return tbSoundEvents end