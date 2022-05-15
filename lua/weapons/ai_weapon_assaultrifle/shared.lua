SWEP.HoldType = "2ha"
SWEP.Type = "2ha"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 2
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.tblSounds = {}
	SWEP.tblSounds["Equip"] = "weapons/assaultrifle/rifleassault_equip.wav"
	SWEP.tblSounds["Unequip"] = "weapons/assaultrifle/rifleassault_unequip.wav"
	SWEP.tblSounds["Primary"] = "weapons/assaultrifle/rifleassaultg3_fire_3d.wav"
	SWEP.tblSounds["Reload"] = "npc/legion/handgun_reload.wav"
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "ai_weapons_base"
-- SWEP.Category		= "Half-Life 1"
SWEP.InWater = true

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.WorldModel = "models/fallout/weapons/w_assaultrifle.mdl"

SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.014
SWEP.Primary.Delay = 0.1
SWEP.Primary.Damage = "sk_dmg_bullet"
SWEP.Primary.Ammo = "none"
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.AmmoSize = 72
SWEP.Primary.AmmoPickup	= 15
SWEP.PrimaryClip = 28
SWEP.DelayEquip = 0.4
SWEP.ReloadTime = 1

function SWEP:DoReload()
	-- self.Owner:StopMoving()
	-- self.Owner:RestartGesture(ACT_RELOAD)
	self.Owner:PlayLayeredGesture(self.Owner.WeaponReload,2,1)
	if SERVER then
		self:slvPlaySound("Reload")
	end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.ReloadTime)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.ReloadTime)
	self.PrimaryClip = 28
	return true
end

function SWEP:ShootEffects(bSecondary)
	self.Owner:MuzzleFlash()
end