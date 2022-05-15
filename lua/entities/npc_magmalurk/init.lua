AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_MIRELURK,CLASS_MIRELURK)
end
ENT.sModel = "models/fallout/magmalurk.mdl"
ENT.fMeleeDistance	= 80
ENT.fMeleeForwardDistance = 375
ENT.bIgnitable = false
ENT.DisablePropCreateEffect = true
ENT.UseCustomMovement = false
ENT.sSoundDir = "npc/magmalurk/"
ENT.skName = "magmalurk"
ENT.FireType = true
ENT.HidePropSpawnedEffect = true // Prop spawn effect interfers with our RenderOverride function, so skip that
ENT.ForceMultiplier = 4

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	
	self:SetCollisionBounds(Vector(48,48,145), Vector(-48,-48,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	
	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_magmalurk_health"))
	self:SetSoundLevel(95)
	
	self.flames = {}
	for i = 1, 8 do self.flames[i] = {nextEmit = CurTime() +math.Rand(0,14), emitting = false} end
end

function ENT:OnKnockedDown()
	local ragdoll = self:GetRagdollEntity()
	if(IsValid(ragdoll)) then
		for att, dat in pairs(self.flames) do
			if(IsValid(dat.prt)) then
				dat.prt:SetParent(ragdoll)
				dat.prt:Fire("SetParentAttachment", "flame" .. att, 0)
			end
		end
	end
end

function ENT:OnStandUp()
	for att, dat in pairs(self.flames) do
		if(IsValid(dat.prt)) then
			dat.prt:SetParent(self)
			dat.prt:Fire("SetParentAttachment", "flame" .. att, 0)
		end
	end
end

function ENT:Particle(att, delay)
	if self.flames[att].emitting then return end
	local prt = ents.Create("info_particle_system")
	prt:SetKeyValue("start_active", "1")
	prt:SetKeyValue("effect_name", "magmalurk_flame")
	prt:SetParent(self:KnockedDown() && self:GetRagdollEntity() || self)
	prt:Spawn()
	prt:Activate()
	self:DeleteOnDeath(prt)
	prt:Fire("SetParentAttachment", "flame" .. att, 0)
	
	local csp = CreateSound(prt, self.sSoundDir .. "magmalurk_flame_lp.wav")
	csp:SetSoundLevel(95)
	csp:Play()
	self:StopSoundOnDeath(csp)
	self.flames[att].csp = csp
	self.flames[att].nextStop = CurTime() +(delay || math.Rand(0.6,2))
	self.flames[att].prt = prt
	self.flames[att].emitting = true
end
function ENT:OnPlayAlert()
	for i, data in pairs(self.flames) do
		self:Particle(i, 3)
	end
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	for i, data in pairs(self.flames) do
		if !data.emitting then if CurTime() >= data.nextEmit then self:Particle(i, self:GetState() != NPC_STATE_COMBAT && 3 || nil) end
		elseif CurTime() >= data.nextStop then
			local rand
			if self:GetState() == NPC_STATE_COMBAT then rand = math.Rand(0.6,2) else rand = math.Rand(2,14) end
			data.csp:Stop()
			if IsValid(data.prt) then data.prt:Remove() end
			self.flames[i].emitting = false
			self.flames[i].nextEmit = CurTime() +rand
		end
	end
end