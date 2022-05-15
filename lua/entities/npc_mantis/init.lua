AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_CRITTER
ENT.sModel = "models/fallout/mantis.mdl"
ENT.iClass = CLASS_RODENT
ENT.fMeleeDistance	= 45
ENT.fMeleeForwardDistance = 220
ENT.m_fMaxYawSpeed = 200
ENT.fFollowDistance = 100
ENT.m_iCustomIdle = ACT_IDLE_RELAXED
ENT.BoneRagdollMain = "Bip01 Root"

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/mantis/"
ENT.m_bKnockDownable = true
ENT.tblAlertAct = {ACT_IDLE_ANGRY}
ENT.AlertChance = 25
ENT.skName = "mantis"

ENT.m_tbSounds = {
	["Attack"] = "mantis_hiss0[1-6].mp3",
	["Arm"] = "mantis_armattack0[1-6].mp3",
	["Chase"] = "mantis_chase_vox0[1-4].mp3",
	["Death"] = "mantis_death0[1-4].mp3",
	["Land"] = "mantis_land0[1-3].mp3",
	["Hiss"] = "mantis_hiss0[1-6].mp3",
	["Wings"] = "sfx_manitswing0[1-2].mp3",
	["Claw"] = "sfx_manitsclaw0[1-2].mp3",
	["FootLeft"] = "foot/fst_mantis_l0[1-7].mp3",
	["FootRight"] = "foot/fst_mantis_r0[1-6].mp3",
	["FootBig"] = "foot/mantis_foot0[1-7].mp3"
}

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_STOMACH] = ACT_FLINCH_CHEST,
	[HITBOX_CHEST] = ACT_FLINCH_CHEST,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(23,23,35), Vector(-23,-23,0))

	self:slvCapabilitiesAdd(CAP_MOVE_GROUND)

	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self:SetSoundVolume(65)
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:OnDamaged(dmgTaken,attacker,inflictor,dmginfo)
	if(self:GetActivity(ACT_IDLE_ANGRY)) then
		self:ScheduleFinished()
	end
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG) then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_WALK_HURT)
	end
end

function ENT:SelectGetUpActivity()
	return ACT_ROLL_RIGHT
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local dmg
		local dist
		local ang
		local force
		if(atk == "left") then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			ang = Angle(12,6,-2)
			force = Vector(40,0,0)
		elseif(atk == "right") then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			ang = Angle(10,-10,2)
			force = Vector(40,0,0)
		elseif(atk == "forwardpower") then
			dist = 70
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			ang = Angle(18,0,0)
			force = Vector(60,0,0)
		else
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			ang = Angle(16,0,0)
			force = Vector(90,0,0)
		end
		local hit = self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,true)
		if(!hit) then self:EmitSound("npc/zombie/claw_miss" .. math.random(1,2) .. ".wav",45,100)
		else self:EmitEventSound("Claw",120) end
		return true
	end
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG) || self:LimbCrippled(HITBOX_LEFTARM) || self:LimbCrippled(HITBOX_RIGHTARM)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				self.m_bNextAngry = math.random(1,3) == 3
				return
			end
			local bCrippled = self:LegsCrippled()
			if(!bCrippled && CurTime() >= self.nextJumpAttack) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if(ang.y <= 35 || ang.y >= 325) then
					local fTimeToGoal = self:GetPathTimeToGoal()
					if(self.bDirectChase && fTimeToGoal <= 0.75 && fTimeToGoal >= 0.2 && distPred <= self.fMeleeForwardDistance) then
						self.nextJumpAttack = CurTime() +math.Rand(3,8)
						if(math.random(1,3) >= 2) then
							self:SLVPlayActivity(ACT_MELEE_ATTACK2)
							return
						end
					end
				end
			end
			if(!bCrippled && self.m_bNextAngry) then
				self.m_bNextAngry = nil
				self:SLVPlayActivity(ACT_HOP)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
