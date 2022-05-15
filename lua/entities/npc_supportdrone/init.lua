AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ALIEN,CLASS_ALIEN)
end
ENT.sModel = "models/fallout/drone_support.mdl"
ENT.fMeleeDistance = 55
ENT.fMeleeForwardDistance = 320
ENT.iBloodType = false
ENT.sSoundDir = "npc/drone/"
ENT.skName = "support_drone"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = true
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE}
ENT.m_tbSounds = {
	["MeleeNormal"] = "robotdrone_attack_arm0[1-2].mp3",
	["MeleePower"] = "robotdrone_attack_armpower.mp3"
}

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_CHEST] = ACT_FLINCH_CHEST,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}
ENT.CollisionBounds = Vector(45,35,95)

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return ang.r >= 0 && ACT_ROLL_RIGHT || ACT_ROLL_LEFT
end

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.cspIdleLoop = CreateSound(self, "npc/drone/robotdrone_idle_lp.wav")
	self:StopSoundOnDeath(self.cspIdleLoop)
	self.cspMoveLoop = CreateSound(self, "npc/drone/robotdrone_movement_lpm.wav")
	self:StopSoundOnDeath(self.cspMoveLoop)
	self:SetSoundLevel(80)
	self.cspIdleLoop:Play()

	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:PlayIdleLoop()
	if !self.cspIdleLoop:IsPlaying() then
		self.cspIdleLoop:Stop()
		self.cspMoveLoop:Stop()
		self:EmitSound("npc/drone/robotdrone_movement_end.wav",80,100)
		self.cspIdleLoop = CreateSound(self, "npc/drone/robotdrone_idle_lp.wav")
		self.cspIdleLoop:Play()
		self:StopSoundOnDeath(self.cspIdleLoop)
	end
end

function ENT:PlayMoveLoop()
	if !self.cspMoveLoop:IsPlaying() then
		self.cspMoveLoop:Stop()
		self.cspIdleLoop:Stop()
		self.cspMoveLoop = CreateSound(self, "npc/drone/robotdrone_movement_lpm.wav")
		self.cspMoveLoop:Play()
		self:StopSoundOnDeath(self.cspMoveLoop)
	end
end

function ENT:StopMovementSound()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop:Stop()
	self:EmitSound("npc/drone/robotdrone_movement_end.wav",80,100)
end

function ENT:PlayMovementSound()
	if self:IsMoving() then
		self:PlayMoveLoop()
	else
		self:PlayIdleLoop()
	end
end

function ENT:OnKnockedDown()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop:Stop()
end

function ENT:OnThink()
	self:PlayMovementSound()
	self:UpdateLastEnemyPositions()
	self:MaintainAnimations()
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local skDmg
		local force
		local ang
		local usesound
		local atk = select(2,...)
		if(atk == "left") then
			force = Vector(50,0,0)
			ang = Angle(0,50,0)
			skDmg = GetConVarNumber("sk_support_drone_dmg_slash")
			self:slvPlaySound("MeleeNormal")
		elseif(atk == "powerA") then
			force = Vector(50,0,0)
			ang = Angle(0,80,0)
			skDmg = GetConVarNumber("sk_support_drone_dmg_power")
			self:slvPlaySound("MeleePower")
		elseif(atk == "right") then
			force = Vector(50,0,0)
			ang = Angle(0,-50,0)
			skDmg = GetConVarNumber("sk_support_drone_dmg_slash")
			self:slvPlaySound("MeleeNormal")
		elseif(atk == "powerB") then
			force = Vector(180,0,20)
			ang = Angle(0,-80,0)
			skDmg = GetConVarNumber("sk_support_drone_dmg_power")
			self:slvPlaySound("MeleePower")
		end
		local bHit = self:DealMeleeDamage(dist,skDmg,ang,force,DMG_SLASH,nil,true,nil,fcHit)
		return true
	end
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG) then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
	end
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
