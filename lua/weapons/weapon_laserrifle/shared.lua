SWEP.HoldType = "ar2"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.NPCFireRate = 0.35
	SWEP.tblSounds = {}
	SWEP.tblSounds["Primary"] = "weapons/laserrifle/wpn_rifle_laser_fire_2d.wav"
	SWEP.tblSounds["ReloadA"] = {"weapons/laserrifle/wpn_riflelaser_reloadinout.wav"}
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.itemID = "00004336"
SWEP.NPC_Holdtype = "2hr"
SWEP.Base = "weapon_slv_fallout_base"
SWEP.Category		= "Fallout"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_laserrifle.mdl"
SWEP.WorldModel = "models/fallout/weapons/w_laserrifle.mdl"
SWEP.ViewModelFOV	= 60
SWEP.InWater = false

SWEP.Primary.ClipSize = 24
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Microfusion Cell"
SWEP.Primary.AmmoSize = 24
SWEP.Primary.AmmoPickup	= 24
SWEP.Primary.Delay = 0.4
SWEP.ReloadDelay = 1.3

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.AmmoSize = -1
SWEP.Secondary.Delay = 0.4

function SWEP:CreateBeam(ShootPos, ShootDir)
	local tr
	if self.Owner:IsPlayer() then tr = util.TraceLine(util.GetPlayerTrace(self.Owner))
	else tr = util.TraceLine({start = ShootPos, endpos = ShootPos +ShootDir *32768, filter = self.Owner}) end
	self:slvPlaySound("Primary")
	-- local posShoot = self.Owner:GetShootPos()
	local posShoot = self.Weapon:GetAttachment(self.Weapon:LookupAttachment("muzzle")).Pos
	local entBeam = ents.Create("obj_fallout_laser")
	entBeam:SetPos(posShoot)
	entBeam:SetDestination(tr.HitPos)
	local iRichochet = 3
	local flDist = posShoot:Distance(tr.HitPos)
	while tr.Normal:Dot(tr.HitNormal) *-1 <= 0.5 && iRichochet > 0 do
		local ang = tr.Normal:Angle()  
		ang:RotateAroundAxis(tr.HitNormal,180)   
		local posLast = tr.HitPos
		tr = util.QuickTrace(tr.HitPos, (ang:Forward() *-1) *32768)
		flDist = flDist +posLast:Distance(tr.HitPos)
		if flDist > 5000 then break end
		entBeam:SetDestination(tr.HitPos)
		iRichochet = iRichochet -1
	end
	local iDmg = GetConVarNumber("sk_laserrifle_dmg")
	util.BlastDamage(self, self.Owner, tr.HitPos, 5, iDmg)
	entBeam:Spawn()
	entBeam:SetParent(self.Owner)
	entBeam:SetOwner(self.Owner)
	-- if tr.Entity:IsValid() then
		-- if math.random(1,3) == 1 then
			-- tr.Entity:slvIgnite(10,1)
		-- end
	-- end
end

function SWEP:SecondaryAttack(ShootPos, ShootDir)
	return false
end

function SWEP:PrimaryAttack(ShootPos, ShootDir)
	if self:GetAmmoPrimary() <= 1 then return end
	if self.Owner:IsPlayer() && self.Owner:KeyDown(IN_SPEED) then return end
	if !self:CanPrimaryAttack() then return end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:NextIdle(self:SequenceDuration())
	self:PlayThirdPersonAnim()
	if CLIENT then return end
	self:AddClip1(-1)
	self.Weapon:CreateBeam(ShootPos, ShootDir)
	if self.Owner:IsPlayer() then self.Owner:ViewPunch(Angle(math.Rand(-0.12,-0.6), math.Rand(-0.6,0.6), 0)) end
end