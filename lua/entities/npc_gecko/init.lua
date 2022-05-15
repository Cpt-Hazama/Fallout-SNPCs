AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.NPCFaction = NPC_FACTION_GECKO
ENT.sModel = "models/fallout/gecko.mdl"
ENT.fMeleeDistance	= 40
ENT.fMeleeForwardDistance = 200
ENT.fRangeDistance = 240
ENT.fRangeDistanceSpit = 1200
ENT.m_iCustomIdle = ACT_IDLE_RELAXED
ENT.BoneRagdollMain = "Bip01 Pelvis"
ENT.AllowFireAttack = false
ENT.AllowSpitAttack = false
ENT.CollisionBounds = Vector(26,26,50)
ENT.SurvivalCollisionBounds = Vector(18,18,50)
ENT.ParticleFlame = "flame_gargantua"
ENT.FlameAttackChance = 2
ENT.ViewPunchScale = 1
ENT.Hull = HULL_MEDIUM

ENT.m_fMaxYawSpeed = 20
ENT.fFollowDistance = 100
ENT.m_bKnockDownable = true

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/gecko/"
ENT.skName = "gecko"

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

ENT.m_tbSounds = {
	["AttackChomp"] = "gecko_chomp0[1-3].mp3",
	["AttackClaw"] = "gecko_claw_atk_vox0[1-6].mp3",
	["Claw"] = "gecko_claw_atk0[1-3].mp3",
	["CombatIdle"] = "gecko_combatidle0[1-4].mp3",
	["Death"] = "gecko_death0[1-4].mp3",
	["Jump"] = "gecko_jump0[3-6].mp3",
	["Lick"] = "gecko_lick0[1-5].mp3",
	["MTForward"] = "gecko_mtfwd_vox0[1-6].mp3",
	["Pain"] = "gecko_painvox0[1-2].mp3",
	["Pant"] = "gecko_panting0[1-6].mp3",
	["Scratch"] = "gecko_scratch0[1-2].mp3",
	["Scream"] = "gecko_scream0[1-3].mp3",
	["Snarl"] = "gecko_snarl0[1-4].mp3",
	["Swing"] = "gecko_swing0[1-6].mp3",
	["FootLeft"] = "foot/fs_gecko_l0[1-4].mp3",
	["FootRight"] = "foot/fs_gecko_r0[1-4].mp3"
}

ENT.BodyCaps = {
	["models/fallout/gecko_bodycap_head.mdl"] = {
		bones = {"Bip01 Neck2","Bip01 Head","Bip01 Jaw","Bip01 Gullet","Bip01 L Eye","Bip01 R Eye","Bip01 L Fin01","Bip01 L Fin02","Bip01 L Fin11","Bip01 L Fin12","Bip01 L Fin21","Bip01 L Fin22","Bip01 R Fin01","Bip01 R Fin02","Bip01 R Fin11","Bip01 R Fin12","Bip01 R Fin21","Bip01 R Fin22"},
		boneCap = "Bip01 Head",
		att = "bodycap_head",
		bodygroup = 1,
		hitbox = HITBOX_HEAD
	},
	["models/fallout/gecko_bodycap_legleft.mdl"] = {
		bones = {"Bip01 L Calf","Bip01 L Foot","Bip01 L Toe11","Bip01 L Toe12","Bip01 L Toe21","Bip01 L Toe22","Bip01 L Toe31","Bip01 L Toe32"},
		boneCap = "Bip01 L Calf",
		att = "bodycap_legleft",
		bodygroup = 2,
		hitbox = HITBOX_LEFTLEG
	},
	["models/fallout/gecko_bodycap_armleft.mdl"] = {
		bones = {"Bip01 L Forearm","Bip01 L Hand","Bip01 L Finger11","Bip01 L Finger12","Bip01 L Finger21","Bip01 L Finger22","Bip01 L Finger31","Bip01 L Finger32","Bip01 L Finger41","Bip01 L Finger42","Bip01 L Thumb1","Bip01 L Thumb2"},
		boneCap = "Bip01 L Forearm",
		att = "bodycap_armleft",
		bodygroup = 3,
		hitbox = HITBOX_LEFTARM
	},
	["models/fallout/gecko_bodycap_legright.mdl"] = {
		bones = {"Bip01 R Calf","Bip01 R Foot","Bip01 R Toe11","Bip01 R Toe12","Bip01 R Toe21","Bip01 R Toe22","Bip01 R Toe31","Bip01 R Toe32"},
		boneCap = "Bip01 R Calf",
		att = "bodycap_legright",
		bodygroup = 4,
		hitbox = HITBOX_RIGHTLEG
	},
	["models/fallout/gecko_bodycap_armright.mdl"] = {
		bones = {"Bip01 R Forearm","Bip01 R Hand","Bip01 R Finger11","Bip01 R Finger12","Bip01 R Finger21","Bip01 R Finger22","Bip01 R Finger31","Bip01 R Finger32","Bip01 R Finger41","Bip01 R Finger42","Bip01 R Thumb1","Bip01 R Thumb2"},
		boneCap = "Bip01 R Forearm",
		att = "bodycap_armright",
		bodygroup = 5,
		hitbox = HITBOX_RIGHTARM
	}
}

function ENT:OnInit()
	self:SetHullType(self.Hull)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self.nextRangeAttack = 0
	self.nextPlayIdleChase = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self:SubInit()
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	local t = self.m_nextPossAttack
	if(t && CurTime() < t) then fcDone(true); return end
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	local t = self.m_nextPossAttack
	if(t && CurTime() < t) then fcDone(true); return end
	if(self.AllowSpitAttack) then
		local act = self:GetActivity()
		if(act == ACT_WALK || act == ACT_RUN) then self:RestartGesture(ACT_GESTURE_RANGE_ATTACK2); fcDone(true); self.m_nextPossAttack = CurTime() +2.5 return end
		self:SLVPlayActivity(ACT_RANGE_ATTACK2,false,fcDone)
		return
	end
	if(self.AllowFireAttack) then
		local act = self:GetActivity()
		if(act == ACT_WALK || act == ACT_RUN) then self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1); fcDone(true); self.m_nextPossAttack = CurTime() +2.5 return end
		self:SLVPlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
		return
	end
	fcDone(true)
end

function ENT:_PossJump(entPossessor,fcDone)
	local t = self.m_nextPossAttack
	if(t && CurTime() < t) then fcDone(true); return end
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:SubInit()
end

function ENT:GenerateInventory()
	self:AddToInventory("0011b9ae")
	if(math.random(1,3) == 1) then self:AddToInventory("0013b2b5") end
	if(math.random(1,5) == 1) then self:AddToInventory("0015E5BD") end
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

function ENT:Interrupt()
	if(!self.m_rangeAttack) then return end
	self:EndRangeAttack()
end

function ENT:EndRangeAttack()
	self.bFlinchOnDamage = true
	self:SetRunActivity(self:LegsCrippled() && ACT_WALK_HURT || ACT_RUN)
	self:SetCustomIdleActivity(ACT_IDLE_RELAXED)
	if(IsValid(self.m_particleFlame)) then
		self.m_particleFlame:Remove()
		self.m_particleFlame = nil
	end
	if(self.cspLoop) then
		local snd
		if(self.m_rangeAttack == 1) then snd = "fire_gecko_flame_end.wav"
		else snd = "green_gecko_spit_end.wav" end
		self:EmitSound(self.sSoundDir .. snd,75,100)
		util.StopSound(self.cspLoop)
		self.cspLoop = nil
	end
	self.m_rangeAttack = nil
end

function ENT:DealAttackDamage(dist,dmg,ang,force)
	ang = ang *self.ViewPunchScale
	return self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,true)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local dmg
		local dist
		local ang,force
		local left = string.find(atk,"left")
		local right = !left && string.find(atk,"right")
		local forward = !right && string.find(atk,"forward")
		if(left) then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			ang = Angle(-14,10,-4)
			force = Vector(170,0,0)
		elseif(right) then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			ang = Angle(-4,-19,4)
			force = Vector(170,0,0)
		elseif(forward) then
			dist = 70
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			ang = Angle(20,0,0)
			force = Vector(340,0,0)
		else
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			ang = Angle(16,4,-2)
			force = Vector(300,0,0)
		end
		local hit = self:DealAttackDamage(dist,dmg,ang,force)
		if(!hit) then self:EmitEventSound("Swing")
		else
			local aType = select(3,...)
			if(aType == "Chomp") then self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",75,100)
			else self:EmitEventSound(aType) end
		end
		return true
	end
	if(event == "rattack") then
		local atk = select(2,...)
		if(string.Left(atk,4) == "spit") then
			if(atk == "spitstart") then
				self.cspLoop = CreateSound(self,self.sSoundDir .. "green_gecko_spit_lp.wav")
				self.cspLoop:Play()
				self:StopSoundOnDeath(self.cspLoop)
			else
				local att = self:GetAttachment(self:LookupAttachment("mouth"))
				local vTarget
				if(self:SLV_IsPossesed()) then
					local posTgt = self:GetPossessor():GetPossessionEyeTrace().HitPos
					local dir = (posTgt -att.Pos):GetNormal()
					local d = math.min(att.Pos:Distance(posTgt),1200)
					vTarget = att.Pos +dir *d
				else vTarget = self:GetPredictedEnemyPosition() || (att.Pos +self:GetForward() *500) end
				local entSpit = ents.Create("obj_spit")
				entSpit:SetPos(att.Pos)
				entSpit:SetEntityOwner(self)
				entSpit:SetDamage(GetConVarNumber("sk_gecko_green_dmg_spit"))
				entSpit:Spawn()
				entSpit:Activate()
				local eta = entSpit:SetArcVelocity(att.Pos,vTarget,750,self:GetForward(),0.65,VectorRand() *0.08)
			end
			return true
		elseif(atk == "start") then
			self.cspLoop = CreateSound(self,self.sSoundDir .. "fire_gecko_flame_lp.wav")
			self.cspLoop:Play()
			self:StopSoundOnDeath(self.cspLoop)
			local att = self:GetAttachment(self:LookupAttachment("mouth"))
			self.m_particleFlame = util.ParticleEffect(self.ParticleFlame,att.Pos,att.Ang,self,"mouth",false)
			self:DeleteOnDeath(self.m_particleFlame)
		elseif(atk == "flame") then self:DealFlameDamage()
		else self:EndRangeAttack() end
		return true
	end
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:OnLostEnemy(entEnemy)
	self.m_bNextAngry = nil
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	if(self.m_rangeAttack && IsValid(self.entEnemy)) then
		local ang = self:GetAngles()
		local yawTgt = (self.entEnemy:GetPos() -self:GetPos()):Angle().y
		ang.y = math.ApproachAngle(ang.y,yawTgt,10)
		self:SetAngles(ang)
		self:NextThink(CurTime())
		return true
	end
	if(self.UseCustomMovement) then
		self:NextThink(CurTime())
		return true
	end
end

function ENT:AttackMelee(ent)
	self:SetTarget(ent)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,2)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(!self.m_rangeAttack && self:CanSee(enemy)) then
			local bCrippled = self:LegsCrippled()
			if(self.m_bNextAngry) then
				self.m_bNextAngry = nil
				local bHop = !bCrippled && math.random(1,3) <= 2
				self:SLVPlayActivity(bHop && ACT_HOP || ACT_IDLE_ANGRY,!bHop)
				return
			end
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				self.m_bNextAngry = math.random(1,3) == 3
				return
			end
			if(!bCrippled && CurTime() >= self.nextJumpAttack) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if ang.y <= 35 || ang.y >= 325 then
					local fTimeToGoal = self:GetMoveTimeToTarget(enemy)
					if(self.bDirectChase && fTimeToGoal <= 0.75 && fTimeToGoal >= 0.2 && distPred <= self.fMeleeForwardDistance) then
						self.nextJumpAttack = CurTime() +math.Rand(3,8)
						if(math.random(1,3) >= 2) then
							self:SLVPlayActivity(ACT_MELEE_ATTACK2)
							return
						end
					end
				end
			end
			if(self.AllowFireAttack && CurTime() >= self.nextRangeAttack && dist <= self.fRangeDistance) then
				self.nextRangeAttack = CurTime() +math.Rand(4,10)
				if(math.random(1,self.FlameAttackChance) == 1) then
					if(!bCrippled) then
						self.bFlinchOnDamage = false
						self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
						self.m_rangeAttack = 1
						self:SetRunActivity(ACT_WALK)
					else
						self:SLVPlayActivity(ACT_RANGE_ATTACK1,true)
						return
					end
				end
			end
			if(self.AllowSpitAttack && CurTime() >= self.nextRangeAttack && dist <= self.fRangeDistanceSpit && dist >= 240) then
				self.nextRangeAttack = CurTime() +math.Rand(4,10)
				if(math.random(1,4) <= 3) then
					if(!bCrippled) then
						self.bFlinchOnDamage = false
						self:RestartGesture(ACT_GESTURE_RANGE_ATTACK2)
						self.m_rangeAttack = 2
						self:SetRunActivity(ACT_WALK)
					else
						self:SLVPlayActivity(ACT_RANGE_ATTACK2,true)
						return
					end
				end
			end
		end
		if CurTime() >= self.nextPlayIdleChase then
			if math.random(1,3) == 3 then
				self:slvPlaySound("Pant")
			end
			self.nextPlayIdleChase = CurTime() +math.Rand(3,8)
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
