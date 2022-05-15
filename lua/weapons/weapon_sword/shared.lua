SWEP.HoldType = "melee"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 1
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = true
	SWEP.tblSounds = {}
	SWEP.tblSounds["Surface"] = {"weapons/wpn_hit_blade01.wav","weapons/wpn_hit_blade02.wav","weapons/wpn_hit_blade03.wav","weapons/wpn_hit_blade04.wav"}
	SWEP.tblSounds["Flesh"] = {"weapons/wpn_hit_bladeflesh01.wav","weapons/wpn_hit_bladeflesh02.wav","weapons/wpn_hit_bladeflesh03.wav"}
	SWEP.tblSounds["Miss"] = {"weapons/wpn_swish_medium01.wav","weapons/wpn_swish_medium02.wav","weapons/wpn_swish_medium03.wav"}
end

SWEP.itemID = "0000083b"
SWEP.NPC_Holdtype = "1hm"
SWEP.Base = "weapon_slv_fallout_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/darkmessiah/weapons/w_sword_silver.mdl"
SWEP.Category		= "Fallout"

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.62

SWEP.Secondary.Ammo = "none"
SWEP.Damage = 24

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() && CurTime() < self.NextNPCFire then return end
	if self.Owner:IsPlayer() && self.Owner:KeyDown(IN_SPEED) then return end
	local iDelay = self.Primary.Delay
	local iDmg = self.Damage
	local iDist = 75
	local iHit, tr = self:DoMeleeDamage(iDist, iDmg)
	local act
	if iHit == 0 then
		act = ACT_VM_MISSCENTER
		if SERVER then self:slvPlaySound("Miss") end
	else
		if SERVER then
			if iHit == 1 then
				self:slvPlaySound("Flesh")
			else
				self:CreateDecal(tr)
				self:slvPlaySound("Surface")
			end
		end
		act = ACT_VM_HITCENTER
	end
	self.Weapon:SendWeaponAnim(act)
	self.Weapon:SetNextSecondaryFire(CurTime() +iDelay)
	self.Weapon:SetNextPrimaryFire(CurTime() +iDelay)
	self:NextIdle(self.Primary.Delay)
	self:PlayThirdPersonAnim()
	if self.Owner:IsNPC() then
		self.NextNPCFire = CurTime() +self.NPCFireRate
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:OnThink()
end

function SWEP:DoMeleeDamage(iDist, iDmg)
	local posStart = self.Owner:GetShootPos()
	local posEnd = posStart +self.Owner:GetAimVector() *iDist
	local tracedata = {}
	tracedata.start = posStart
	tracedata.endpos = posEnd
	tracedata.filter = self.Owner
	local tr = util.TraceLine(tracedata)
	
	local bEntsInViewCone = self:EntsInViewCone(tracedata.endpos, 12)
	local act
	if tr.Hit || bEntsInViewCone then
		if IsValid(tr.Entity) || bEntsInViewCone then
			if CLIENT then return 1, tr end
			return 1, tr, util.BlastDmg(self, self.Owner, tr.HitPos +tr.Normal *6, 12, iDmg, self.Owner, DMG_SLASH)
		end
		return 2, tr
	end
	return 0, tr
end