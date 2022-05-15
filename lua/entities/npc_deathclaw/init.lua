AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

ENT.NPCFaction = NPC_FACTION_DEATHCLAW
ENT.sModel = "models/fallout/deathclaw.mdl"
ENT.iClass = CLASS_DEATHCLAW
ENT.fMeleeDistance	= 115
ENT.fMeleeForwardDistance	= 400
ENT.fRangeDistance = 800
ENT.skName = "deathclaw"
ENT.BoneRagdollMain = "Bip01"
ENT.sndConscious = "deathclaw_conscious_lp.wav"
ENT.m_bKnockDownable = true

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/deathclaw/"
ENT.CollisionBounds = Vector(26,26,110)
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

local tbSoundEvents = {
	["Attack"] = "deathclaw_strike0[1-4].mp3",
	["AttackPower"] = "deathclaw_poweratk0[1-3].mp3",
	["Death"] = "deathclaw_death0[1-2].mp3",
	["Idle"] = "deathclaw_idle0[1-4].mp3",
	["Pain"] = "deathclaw_pain0[1-2].mp3",
	["Chase"] = "deathclaw_chase0[1-3].mp3",
	["AttackClaw"] = "deathclaw_claw_atk0[1-4].mp3",
	["Swing"] = "deathclaw_swing0[1-4].mp3",
	["TeethPick"] = "deathclaw_idle_teethpick.mp3",
	["ClawScrape"] = "deathclaw_idle_clawscrape.mp3",
	["CageExit"] = "deathclaw_cageexit.mp3",
	["CrouchDown"] = "deathclaw_idle_crouchdown.mp3",
	["CrouchUp"] = "deathclaw_idle_crouchup.mp3",
	["FootLeft"] = "foot/deathclaw_foot_l0[1-2].mp3",
	["FootRight"] = "foot/deathclaw_foot_r0[1-2].mp3",
	["FootRunLeft"] = "foot/deathclaw_foot_run_l0[1-3].mp3",
	["FootRunRight"] = "foot/deathclaw_foot_run_r.mp3"
}
function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self.nextPlayIdleChase = 0
	self:slvSetHealth(GetConVarNumber("sk_deathclaw_health"))
	
	local cspLoop = CreateSound(self,self.sSoundDir .. self.sndConscious)
	cspLoop:Play()
	self:StopSoundOnDeath(cspLoop)
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:GetSoundEvents() return tbSoundEvents end

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return math.AngleDifference(ang.r,90) < math.AngleDifference(ang.r,-90) && ACT_ROLL_LEFT || ACT_ROLL_RIGHT
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG) then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local dmg
		local dist
		local ang
		local force
		if(atk == "forwardpower" || atk == "leftpower" || atk == "rightpower") then
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			if(atk == "forwardpower") then
				dist = 60
				ang = Angle(25,0,0)
			else
				dist = self.fMeleeDistance
				if(atk == "leftpower") then ang = Angle(3,35,-5)
				else ang = Angle(3,-35,5) end
			end
			force = Vector(420,0,0)
		else
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			dist = self.fMeleeDistance
			force = Vector(360,0,0)
			if(atk == "lefta") then ang = Angle(3,35,-5)
			elseif(atk == "leftb") then ang = Angle(-26,15,-5)
			elseif(atk == "righta") then ang = Angle(3,-35,5)
			else ang = Angle(26,-15,5) end
		end
		local hit = self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,true)
		if(!hit) then self:EmitEventSound("Swing")
		else self:EmitEventSound("AttackClaw") end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if(bMelee) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
			if(!self:LimbCrippled(HITBOX_LEFTLEG) && !self:LimbCrippled(HITBOX_RIGHTLEG) && CurTime() >= self.nextJumpAttack) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if(ang.y <= 35 || ang.y >= 325) then
					local fTimeToGoal = self:GetPathTimeToGoal()
					if(self.bDirectChase && fTimeToGoal <= 1.4 && fTimeToGoal >= 0.8 && distPred <= self.fMeleeForwardDistance) then
						self:SLVPlayActivity(ACT_MELEE_ATTACK2)
						self.nextJumpAttack = CurTime() +math.Rand(4,12)
						return
					end
				end
			end
		end
		if(CurTime() >= self.nextPlayIdleChase) then
			if(math.random(1,3) == 3) then self:slvPlaySound("Chase") end
			self.nextPlayIdleChase = CurTime() +math.Rand(3,8)
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
