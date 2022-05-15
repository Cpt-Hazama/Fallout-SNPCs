AddCSLuaFile("shared.lua")

include('shared.lua')
ENT.NPCFaction = NPC_FACTION_DEATHCLAW
ENT.sModel = "models/fallout/deathclaw_baby.mdl"
ENT.skName = "deathclaw_baby"
ENT.sndConscious = "deathclawsm_consciouslp.wav"
ENT.CollisionBounds = Vector(26,26,68)

local tbSoundEvents = {
	["Attack"] = "deathclawsm_strike0[1-4].mp3",
	["AttackPower"] = "deathclawsm_poweratk0[1-3].mp3",
	["Death"] = "deathclawsm_death0[1-2].mp3",
	["Pain"] = "deathclawsm_pain0[1-2].mp3",
	["Chase"] = "deathclawsm_chase0[1-3].mp3",
	["AttackClaw"] = "deathclawsm_clawatk0[1-4].mp3",
	["Swing"] = "deathclawsm_swing0[1-4].mp3",
	["FootLeft"] = "foot/deathclaw_foot_l0[1-2].mp3",
	["FootRight"] = "foot/deathclaw_foot_r0[1-2].mp3",
	["FootRunLeft"] = "foot/deathclaw_foot_run_l0[1-3].mp3",
	["FootRunRight"] = "foot/deathclaw_foot_run_r.mp3"
}

function ENT:GetSoundEvents() return tbSoundEvents end