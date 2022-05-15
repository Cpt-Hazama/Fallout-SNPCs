SWEP.HoldType = "shotgun"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 2
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.NPCFireRate = 1
	SWEP.tblSounds = {}
	SWEP.tblSounds["Primary"] = {"weapons/plasmarifle/plasmarifle_fire_2d01.wav","weapons/plasmarifle/plasmarifle_fire_2d02.wav"}
	SWEP.tblSounds["ReloadA"] = {"weapons/plasmarifle/plasmarifle_reload.wav"}
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.itemID = "00004344"
SWEP.NPC_Holdtype = "2hr"
SWEP.Base = "weapon_slv_fallout_base"
SWEP.Category		= "Fallout"
SWEP.InWater = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_laserrifle.mdl"
SWEP.WorldModel = "models/fallout/weapons/w_plasmarifle.mdl"

SWEP.Primary.Recoil = 0
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 0.8
SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = 36
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Microfusion Cell"
SWEP.Primary.AmmoSize = 36
SWEP.Primary.AmmoPickup	= 36
SWEP.Primary.NumShots = 0

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.AmmoSize = -1
SWEP.Secondary.Delay = 0.4

SWEP.ReloadDelay = 1.6

function SWEP:Attack(ShootPos, ShootDir)
	local ang = self.Owner:GetAimVector():Angle()
	local entPlasma = ents.Create("obj_plasma_particle")
	entPlasma:SetPos(ShootPos || self.Owner:GetShootPos() +ang:Right() *4 +ang:Up() *-4)
	entPlasma:SetEntityOwner(self.Owner)
	entPlasma:Spawn()
	entPlasma:Activate()
	entPlasma:SetDamage(45)
	
	local phys = entPlasma:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter((ShootDir || ang:Forward()) *2000)
	end
end

function SWEP:PrimaryAttack(ShootPos, ShootDir)
	if self.Owner:IsNPC() && CurTime() < self.NextNPCFire then return end
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	if self:GetAmmoPrimary() <= 0 then return end
	if self.Owner:IsPlayer() && self.Owner:KeyDown(IN_SPEED) then return end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if self.Owner:IsPlayer() then
		self:NextIdle(self.Primary.Delay)
	end
	self:PlayThirdPersonAnim()
	if CLIENT then return end
	self:AddClip1(-1)
	self:slvPlaySound("Primary")

	if game.SinglePlayer() then self:Attack(ShootPos, ShootDir)
	else timer.Simple(0, function() if IsValid(self) then self:Attack(ShootPos, ShootDir) end end) end
	if self.Owner:IsNPC() then
		self.NextNPCFire = CurTime() +self.NPCFireRate
	end
end

function SWEP:SecondaryAttack(ShootPos, ShootDir)
	return false
end