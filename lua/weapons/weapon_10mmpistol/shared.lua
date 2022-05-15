SWEP.HoldType = "pistol"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 2
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.NPCFireRate = 1
	SWEP.tblSounds = {}
	SWEP.tblSounds["Equip"] = "weapons/10mmpistol/pistol10mm_equip.wav"
	SWEP.tblSounds["Primary"] = "weapons/10mmpistol/pistol10mm_fire_2d.wav"
	SWEP.tblSounds["ReloadA"] = "weapons/10mmpistol/pistol10mm_reloadout.wav"
	SWEP.tblSounds["Reload_In"] = "weapons/10mmpistol/pistol10mm_reloadin.wav"
	SWEP.tblSounds["Reload_Chamber"] = "weapons/10mmpistol/pistol10mm_reloadchamber.wav"
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.itemID = "0000434f"
SWEP.NPC_Holdtype = "1hp"
SWEP.Base = "weapon_slv_fallout_base"
SWEP.Category		= "Fallout"
SWEP.InWater = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/fallout/weapons/w_10mmpistol.mdl"

SWEP.Primary.Recoil = -1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.1
SWEP.Primary.Damage = 18
SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "10mm Ammo"
SWEP.Primary.AmmoSize = 16
SWEP.Primary.AmmoPickup	= 16
SWEP.Primary.NumShots = 1

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.AmmoSize = -1
SWEP.Secondary.Delay = 0.4

SWEP.ReloadDelay = 0.8

function SWEP:SecondaryAttack(ShootPos, ShootDir)
	return false
end

function SWEP:DoReload(bInformClient)
	if !self:CanReload() then return false end
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	self:NextIdle(self:SequenceDuration())
	self:PlayThirdPersonAnim(PLAYER_RELOAD)
	if SERVER then
		self:slvPlaySound("ReloadA")
		timer.Simple(0.4,function()
			if IsValid(self) then
				self:slvPlaySound("Reload_In")
			end
		end)
		timer.Simple(0.77,function()
			if IsValid(self) then
				self:slvPlaySound("Reload_Chamber")
			end
		end)
		if bInformClient then
			umsg.Start("HLR_SWEPDoReload", rp)
			umsg.Entity(self)
			umsg.End()
		end
	end
	if self.Weapon.SingleReload then
		self.Weapon.nextReload = CurTime() +self:SequenceDuration()
		return
	end
	self.Weapon:SetNextSecondaryFire(self.Weapon.nextIdle)
	self.Weapon:SetNextPrimaryFire(self.Weapon.nextIdle)
	
	if self.Owner:IsPlayer() then self:ReloadTime(self.Weapon.ReloadDelay)
	else
		self:SetClip1(self.Primary.DefaultClip)
	end
	if self.Weapon.OnReload then self.Weapon:OnReload() end
	return true
end