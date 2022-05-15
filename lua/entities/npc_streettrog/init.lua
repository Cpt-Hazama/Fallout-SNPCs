AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.sModel = "models/fallout/streettrog.mdl"
ENT.sSoundDir = "npc/streettrog/"
ENT.sndIdle = "trog_idle_lp.wav"
ENT.skName = "streettrog"
ENT.sndIdleSoundLevel = 60
ENT.iBloodType = BLOOD_COLOR_RED
ENT.CanUseRadiation = false
ENT.GlowEffects = false

local tbSounds = {
	["Cannibal"] = "trog_cannibal0[1-2].mp3",
	["Death"] = "trog_death0[1-2].mp3",
	["FootWalkLeft"] = "foot/trog_foot_l0[1-3].mp3",
	["FootWalkRight"] = "foot/trog_foot_r0[1-3].mp3",
	["FootRunLeft"] = "foot/trog_footrun_l0[1-3].mp3",
	["FootRunRight"] = "foot/trog_footrun_r0[1-3].mp3"
}
function ENT:GetSoundEvents() return tbSounds end