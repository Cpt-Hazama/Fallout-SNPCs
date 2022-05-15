AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_RODENT
ENT.sModel = "models/fallout/giantrat.mdl"
ENT.iClass = CLASS_RODENT
ENT.fMeleeDistance	= 40
ENT.fMeleeForwardDistance = 150
ENT.m_iCustomIdle = ACT_IDLE_RELAXED
ENT.BoneRagdollMain = "Bip01 Spine"

ENT.m_fMaxYawSpeed = 200
ENT.fFollowDistance = 100
ENT.m_bKnockDownable = true

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/giantrat/"

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_STOMACH] = ACT_FLINCH_CHEST,
	[HITBOX_CHEST] = ACT_FLINCH_CHEST,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

ENT.m_tbSounds = {
	["Attack"] = "giantrat_attack0[1-3].mp3",
	["Attack2"] = "giantrat_attack2_0[1-5].mp3",
	["Alert"] = "giantrat_hiss0[1-5].mp3",
	["ChaseIdle"] = {"giantrat_chasevox0[1-3].mp3","giantrat_pant0[1-7].mp3"},
	["BattleCry"] = "giantrat_battlecry0[1-2].mp3",
	["ChaseVOX"] = "giantrat_chasevox0[1-3].mp3",
	["Hiss"] = "giantrat_hiss0[1-5].mp3",
	["Death"] = "giantrat_injured0[1-5].mp3",
	["Pain"] = "giantrat_injured0[1-5].mp3",
	["Jump"] = "giantrat_jump0[1-5].mp3",
	["Land"] = "giantrat_land0[1-3].mp3",
	["Pant"] = "giantrat_pant0[1-7].mp3",
	["Sniff"] = "giantrat_sniff0[1-5].mp3",
	["Yawn"] = "giantrat_yawn.mp3",
	["Dig"] = "giantrat_idle_dig.mp3",
	["FootLeft"] = "foot/giantrat_foot_l0[1-4].mp3",
	["FootRight"] = "foot/giantrat_foot_r0[1-3].mp3"
}

ENT.BodyCaps = {
	["models/fallout/giantrat_bodycap_head.mdl"] = {
		bones = {"Bip01 Head","Bip01 Hair02","Bip01 Hair01","Bip01 L Ear","Bip01 R Ear","Bip01 Jaw"},
		boneCap = "Bip01 Head",
		att = "bodycap_head",
		bodygroup = 1,
		hitbox = HITBOX_HEAD
	},
	["models/fallout/giantrat_bodycap_footleft.mdl"] = {
		bones = {"Bip01 L Foot","Bip01 L Toe0","Bip01 L Toe01"},
		boneCap = "Bip01 L Foot",
		att = "bodycap_footleft",
		bodygroup = 2,
		hitbox = HITBOX_LEFTLEG
	},
	["models/fallout/giantrat_bodycap_handleft.mdl"] = {
		bones = {"Bip01 L Hand","Bip01 L Finger0","Bip01 L Finger01","Bip01 L Finger1","Bip01 L Finger11","Bip01 L Finger2","Bip01 L Finger21","Bip01 L Finger3","Bip01 L Finger31"},
		boneCap = "Bip01 L Hand",
		att = "bodycap_handleft",
		bodygroup = 3,
		hitbox = HITBOX_LEFTARM
	},
	["models/fallout/giantrat_bodycap_footright.mdl"] = {
		bones = {"Bip01 R Foot","Bip01 R Toe0","Bip01 R Toe01"},
		boneCap = "Bip01 R Foot",
		att = "bodycap_footright",
		bodygroup = 4,
		hitbox = HITBOX_RIGHTLEG
	},
	["models/fallout/giantrat_bodycap_handright.mdl"] = {
		bones = {"Bip01 R Hand","Bip01 R Finger0","Bip01 R Finger01","Bip01 R Finger1","Bip01 R Finger11","Bip01 R Finger2","Bip01 R Finger21","Bip01 R Finger3","Bip01 R Finger31"},
		boneCap = "Bip01 R Hand",
		att = "bodycap_handright",
		bodygroup = 5,
		hitbox = HITBOX_RIGHTARM
	},
	["models/fallout/giantrat_bodycap_tail.mdl"] = {
		bones = {"Bip01 Tail2","Bip01 Tail3","Bip01 Tail4","Bip01 Tail5"},
		boneCap = "Bip01 Tail2",
		att = "bodycap_tail",
		bodygroup = 6,
		hitbox = HITBOX_ADDLIMB
	}
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(20,20,26), Vector(-20,-20,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self.nextPlayIdleChase = 0
	self:slvSetHealth(GetConVarNumber("sk_giantrat_health"))
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG || hitbox == HITBOX_LEFTARM || hitbox == HITBOX_RIGHTARM then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_WALK_HURT)
	end
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return math.AngleDifference(ang.r,90) < math.AngleDifference(ang.r,-90) && ACT_ROLL_RIGHT || ACT_ROLL_LEFT
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
			dmg = GetConVarNumber("sk_giantrat_dmg_slash")
			ang = Angle(-10,10,4)
			force = Vector(150,0,0)
		elseif(atk == "right") then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_giantrat_dmg_slash")
			ang = Angle(-10,-10,-4)
			force = Vector(150,0,0)
		elseif(atk == "forwardpower") then
			dist = 70
			dmg = GetConVarNumber("sk_giantrat_dmg_slash_power")
			ang = Angle(-12,-12,-6)
			force = Vector(250,0,0)
		else
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_giantrat_dmg_slash_power")
			ang = Angle(-10,-8,3)
			force = Vector(250,0,0)
		end
		self:DealMeleeDamage(dist,dmg,ang,force)
		return true
	end
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG) || self:LimbCrippled(HITBOX_LEFTARM) || self:LimbCrippled(HITBOX_RIGHTARM)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		local bCrippled = self:LegsCrippled()
		if dist <= 100 then self:SetRunActivity(self:GetWalkActivity())
		else self:SetRunActivity(bCrippled && ACT_WALK_HURT || ACT_RUN) end
		if(self:CanSee(enemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				if(enemy == self.m_entLastEnemy) then
					self.m_entLastEnemy = nil
					if(math.random(1,3) == 3) then
						self:SLVPlayActivity(ACT_IDLE_ANGRY,true)
						return
					end
				end
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				self.m_entLastEnemy = enemy
				return
			end
			if(!bCrippled && CurTime() >= self.nextJumpAttack) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if(ang.y <= 35 || ang.y >= 325) then
					local fTimeToGoal = self:GetPathTimeToGoal()
					if(self.bDirectChase && fTimeToGoal <= 0.9 && fTimeToGoal >= 0.46 && distPred <= self.fMeleeForwardDistance) then
						self:SLVPlayActivity(ACT_MELEE_ATTACK2)
						self.nextJumpAttack = CurTime() +math.Rand(3,8)
						self.m_entLastEnemy = enemy
						return
					end
				end
			end
		end
		if(CurTime() >= self.nextPlayIdleChase) then
			if(math.random(1,3) == 3) then self:slvPlaySound("ChaseIdle") end
			self.nextPlayIdleChase = CurTime() +math.Rand(3,8)
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
