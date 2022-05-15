SWEP.HoldType = "shotgun"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 2
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.NPCFireRate = 1
	SWEP.tblSounds = {}
	SWEP.tblSounds["Equip"] = "weapons/combatshotgun/wpn_shotguncombat_equip.wav"
	SWEP.tblSounds["Primary"] = "weapons/combatshotgun/wpn_shotguncombat_fire_2d.wav"
	SWEP.tblSounds["ReloadA"] = {"weapons/combatshotgun/wpn_shotguncombat_reload.wav"}
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.itemID = "00004327"
SWEP.NPC_Holdtype = "2hr"
SWEP.Base = "weapon_slv_fallout_base"
SWEP.Category		= "Fallout"
SWEP.InWater = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_combatshotgun.mdl"
SWEP.WorldModel = "models/fallout/weapons/w_combatshotgun.mdl"

SWEP.Primary.Recoil = -2.5
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.5
SWEP.Primary.Damage = GetConVarNumber("sk_combatshotgun_dmg")
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Shotgun Shells"
SWEP.Primary.AmmoSize = 12
SWEP.Primary.AmmoPickup	= 12
SWEP.Primary.NumShots = 9

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.AmmoSize = -1
SWEP.Secondary.Delay = 0.4

SWEP.ReloadDelay = 2

function SWEP:SecondaryAttack(ShootPos, ShootDir)
	return false
end