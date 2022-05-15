AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GECKO
ENT.skName = "gecko_gojira"
ENT.sModel = "models/fallout/gojira.mdl"
ENT.AllowFireAttack = true
ENT.AllowSpitAttack = false
ENT.bIgnitable = false
ENT.CollisionBounds = Vector(78,78,150)
ENT.UseCustomMovement = false
ENT.m_bKnockDownable = false
ENT.m_fMaxYawMoveSpeed = 60
ENT.ViewPunchScale = 3
ENT.BodyCaps = false
ENT.fSoundPitch = 75
ENT.fMeleeDistance	= 110
ENT.fMeleeForwardDistance = 800
ENT.fRangeDistance = 600
ENT.ParticleFlame = "flame_gojira"
ENT.ScaleExp = 10
ENT.ScaleLootChance = 0.01
ENT.FlameAttackChance = 1
ENT.Hull = HULL_LARGE
ENT.HullNav = HULL_LARGE
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE}
ENT.possOffset = Vector(0,0,200)

ENT.DamageScales = {
	[DMG_BURN] = 0.25,
	[DMG_DIRECT] = 0.25
}

function ENT:SubInit()
	self:SetSkin(4)
	self:SetBodygroup(6,1)
	self:SetBodygroup(7,1)
end

function ENT:InitAftermath()
	self:SetDTBool(3,true)
end

function ENT:GenerateInventory()
	self:AddToInventory("0011b9ae")
	if(math.random(1,3) == 1) then self:AddToInventory("0013b2b7") end
	if(math.random(1,5) == 1) then self:AddToInventory("0015E5BE") end
end