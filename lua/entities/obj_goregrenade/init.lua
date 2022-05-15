AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/fallout/goregrenade.mdl")
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then
		phys:Wake()
		phys:SetBuoyancyRatio(0)
	end
	self.delayRemove = CurTime() +8
	self:slvSetHealth(1)
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:OnRemove()
end

function ENT:Think()
	if(CurTime() < self.delayRemove) then return end
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	if(self:Health() <= 0) then return end
	self:slvSetHealth(self:Health() -dmginfo:GetDamage())
	if(self:Health() <= 0) then
		self:SetEntityOwner(dmginfo:GetAttacker())
		self:OnDeath()
	end
end

function ENT:OnDeath()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.ParticleEffect("goregrenade_splash",self:GetPos(),self:GetAngles(),nil,nil,0.25)
	local valid = IsValid(self.entOwner)
	local entRAD = ents.Create("point_radiation")
	entRAD:SetEntityOwner(self)
	entRAD:SetEmissionDistance(200)
	entRAD:SetRAD(6)
	entRAD:SetLife(4)
	entRAD:SetPos(self:GetPos())
	entRAD:Spawn()
	entRAD:Activate()
	sound.Play("npc/ghoulferal/fx_fire_gas_high0" .. math.random(1,2) .. ".mp3", self:GetPos(),75,100)
	util.BlastDmg(self,valid && self.entOwner || self,self:GetPos(),200,GetConVarNumber("sk_ghoulferal_reaver_dmg_grenade"),function(ent)
		if(!valid) then return true end
		local disp = self.entOwner:slvDisposition(ent)
		return disp == D_HT || disp == D_FR
	end,DMG_RADIATION,true)
	self:Remove()
end

function ENT:PhysicsCollide(data, physobj)
	self:OnDeath()
	return true
end

