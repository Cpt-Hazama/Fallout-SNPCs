AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_GHOUL,CLASS_GHOUL)
end
ENT.fMeleeDistance	= 60
ENT.fMeleeForwardDistance	= 300
ENT.fRangeDistanceGrenade = 1800
ENT.fRangeDistanceRadiation = 160
ENT.m_fMaxYawMoveSpeed = 20
ENT.fViewAngle = 180
ENT.fHearDistance = 1400
ENT.CanUseRadiation = false
ENT.CanUseGrenade = false
ENT.CanRegenHealth = false
ENT.UseCustomMovement = false
ENT.sModel = "models/fallout/ghoulferal.mdl"
ENT.skName = "ghoulferal"
ENT.BoneRagdollMain = "Bip01"

ENT.m_bKnockDownable = true
ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/ghoulferal/"
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}

ENT.m_tbSounds = {
	["Alert"] = "feralghoul_alert01.mp3",
	["Attack"] = "feralghoul_attack0[1-4].mp3",
	["AttackRadiation"] = "feralghoul_radiate.mp3",
	["AttackThrow"] = "ghoulreaver_throw0[1-2].mp3",
	["Death"] = "feralghoul_death0[1-4].mp3",
	["Pain"] = "feralghoul_injured0[1-4].mp3",
	["Equip"] = "ghoulreaver_equip0[1-3].mp3",
	["Swing"] = "feralghoul_swing0[1-5].mp3",
	["FootLeft"] = "foot/feralghoul_foot_l0[1-2].mp3",
	["FootRight"] = "foot/feralghoul_foot_r0[1-2].mp3",
	["FootRunLeft"] = "foot/feralghoul_foot_run_l0[1-2].mp3",
	["FootRunRight"] = "foot/feralghoul_foot_run_r0[1-2].mp3"
}

local BodyCaps = {
	["models/fallout/ghoulferal_bodycap_head.mdl"] = {
		bones = {"Bip01 Head","Bip01 Head2"},
		boneCap = "Bip01 Head",
		att = "bodycap_head",
		bodygroup = 0,
		hitbox = HITBOX_HEAD
	},
	["models/fallout/ghoulferal_bodycap_leftleg.mdl"] = {
		bones = {"Bip01 L Thigh","Bip01 L Calf","Bip01 L Foot"},
		boneCap = "Bip01 L Calf",
		att = "bodycap_leftleg",
		bodygroup = 1,
		hitbox = HITBOX_LEFTLEG
	},
	["models/fallout/ghoulferal_bodycap_rightleg.mdl"] = {
		bones = {"Bip01 R Calf","Bip01 R Foot"},
		boneCap = "Bip01 R Calf",
		att = "bodycap_rightleg",
		bodygroup = 2,
		hitbox = HITBOX_RIGHTLEG
	},
	["models/fallout/ghoulferal_bodycap_leftarm.mdl"] = {
		bones = {"Bip01 L UpperArm","Bip01 L Forearm","Bip01 L ForeTwist","Bip01 LUpArmTwist"},
		boneCap = "Bip01 L Forearm",
		att = "bodycap_leftarm",
		bodygroup = 3,
		hitbox = HITBOX_LEFTARM
	},
	["models/fallout/ghoulferal_bodycap_rightarm.mdl"] = {
		bones = {"Bip01 R UpperArm","Bip01 R Forearm","Bip01 R ForeTwist","Bip01 RUpArmTwist"},
		boneCap = "Bip01 R Forearm",
		att = "bodycap_rightarm",
		bodygroup = 4,
		hitbox = HITBOX_RIGHTARM
	}
}

function ENT:GetBodyCaps() return BodyCaps end

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(13,13,77),Vector(-13,-13,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self.nextRADAttack = 0
	self.nextHealthRegen = 0
	self.m_nextGrenadeAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	local pat = "glowingone_testc"
	if(self.skName == "ghoulferal_glowingone" || self.skName == "ghoulferal_trooper_glowingone") then
		ParticleEffectAttach(pat,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("bodycap_head"))
		ParticleEffectAttach(pat,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("bodycap_leftleg"))
		ParticleEffectAttach(pat,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("bodycap_rightleg"))
		ParticleEffectAttach(pat,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("bodycap_leftarm"))
		ParticleEffectAttach(pat,PATTACH_POINT_FOLLOW,self,self:LookupAttachment("bodycap_rightarm"))
	end
	self:SubInit()
end

function ENT:SubInit()
	self:SetSkin(math.random(0,1))
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

function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	if(self.CanUseRadiation) then
		self:SLVPlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
		return
	elseif(self.CanUseGrenade) then
		self:SLVPlayActivity(ACT_ARM,true)
		self.bInSchedule = true
		return
	end
	fcDone(true)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:OnIrradiated(RAD)
	local hp = self:Health()
	local hpMax = self:GetMaxHealth()
	if(hp >= hpMax) then return end
	self:slvSetHealth(math.min(hp +math.ceil(RAD *0.5),hpMax))
end

function ENT:GetUpAngle()
	local pos,ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	ang.y = ang.y -90
	return ang
end

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return ang.p >= 0 && ACT_ROLL_LEFT || ACT_ROLL_RIGHT
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local dmg
		local ang
		local dist
		local left = string.find(atk,"left")
		local right = !left && string.find(atk,"right")
		local power = string.find(atk,"power")
		local force
		if(power) then
			dist = 120
			ang = left && Angle(-25,28,-3) || right && Angle(30,0,0) || Angle(-3,-40,3)
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			force = Vector(280,0,0)
		elseif(left) then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			if(atk == "leftA") then ang = Angle(1,30,-3)
			elseif(atk == "leftB") then ang = Angle(30,0,0)
			else ang = Angle(-25,28,-3) end
			force = Vector(120,0,0)
		elseif(right) then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			if(atk == "rightA") then  ang = Angle(1,-30,3)
			elseif(atk == "rightB") then ang = Angle(30,0,0)
			else ang = Angle(-25,-28,3) end
			force = Vector(120,0,0)
		end
		local hit = self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,true)
		if(!hit) then self:EmitEventSound("Swing")
		else self:EmitSound("npc/zombie/claw_strike" .. math.random(1,3) .. ".wav",75,100) end
		return true
	end
	if(event == "glowstart") then
		self.tblGlowEnts = {}
		local numBones = self:GetBoneCount()
		for i = 0, numBones -1 do
			local bonepos, boneang = self:GetBonePosition(i)
			local ent = ents.Create("info_particle_system")
			ent:SetParent(self)
			ent:SetPos(bonepos)
			ent:SetKeyValue("effect_name","glowingone_testA")
			ent:SetKeyValue("start_active","1")
			ent:Spawn()
			ent:Activate()
			self:DeleteOnDeath(ent)
			self.tblGlowEnts[i] = ent
			if(i > 0) then
				local ent = ents.Create("info_particle_system")
				ent:SetParent(self)
				ent:SetPos(bonepos +(self:GetBonePosition(i -1) -bonepos):GetNormal() *bonepos:Distance(self:GetBonePosition(i -1)))
				ent:SetKeyValue("effect_name","glowingone_testA")
				ent:SetKeyValue("start_active","1")
				ent:Spawn()
				ent:Activate()
				self:DeleteOnDeath(ent)
				self.tblGlowEnts[i +numBones] = ent
			end
		end
		return true
	end
	if(event == "glowend") then
		if(!self.tblGlowEnts) then return true end
		for _, ent in pairs(self.tblGlowEnts) do
			if(ent:IsValid()) then ent:Remove() end
		end
		self.tblGlowEnts = nil
		return true
	end
	if(event == "rattack") then
		local atk = select(2,...)
		if(atk == "throw") then
			if(IsValid(self.entGrenade)) then
				self.entGrenade:SetParent()
				self.entGrenade:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
				self.entGrenade:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
				self.entGrenade:PhysicsInit(SOLID_VPHYSICS)
				self.entGrenade:SetMoveType(MOVETYPE_VPHYSICS)
				self.entGrenade:SetSolid(SOLID_VPHYSICS)
				local att = self:GetAttachment(self:LookupAttachment("grenade"))
				local vTarget
				if(self:SLV_IsPossesed()) then
					local posTgt = self:GetPossessor():GetPossessionEyeTrace().HitPos
					local dir = (posTgt -att.Pos):GetNormal()
					local d = math.min(att.Pos:Distance(posTgt),1800)
					vTarget = att.Pos +dir *d
				else vTarget = self:GetPredictedEnemyPosition(1) || (att.Pos +self:GetForward() *500) end
				self.entGrenade:SetPos(att.Pos)
				local phys = self.entGrenade:GetPhysicsObject()
				if(phys:IsValid()) then
					phys:Wake()
					local eta,bObstacle = self.entGrenade:SetArcVelocity(att.Pos,vTarget,1000,self:GetForward(),0.65,VectorRand() *0.0125)
					if(bObstacle || math.random(1,3) == 1) then self.m_nextGrenadeAttack = CurTime() +math.Rand(4,8) end
				end
			end
			return true
		end
		local ent = ents.Create("info_particle_system")
		ent:SetParent(self)
		ent:SetPos(self:GetCenter())
		ent:SetKeyValue("effect_name","radiation_shockwave")
		ent:SetKeyValue("start_active","1")
		ent:Spawn()
		ent:Activate()
		table.insert(self.tblGlowEnts, ent)
		
		local entRAD = ents.Create("point_radiation")
		entRAD:SetEntityOwner(self)
		entRAD:SetPos(self:GetCenter())
		entRAD:SetLife(5)
		entRAD:SetEmissionDistance(600)
		entRAD:SetRAD(16)
		entRAD:Spawn()
		entRAD:Activate()
		
		local entLight = ents.Create("light_dynamic")
		entLight:SetKeyValue("_light","255 194 53 100")
		entLight:SetKeyValue("brightness","8")
		entLight:SetKeyValue("distance","160")
		entLight:SetKeyValue("_cone","0")
		entLight:SetPos(self:GetCenter())
		entLight:SetParent(self)
		entLight:Spawn()
		entLight:Activate()
		entLight:Fire("TurnOn","",0)
		self:DeleteOnDeath(entLight)
		self.entLight = entLight
		self.lightBrightness = 8
		self.nextLightDecr = CurTime() +0.2
		return true
	end
	if(event == "grabgrenade") then
		local entGrenade = ents.Create("obj_goregrenade")
		entGrenade:SetPos(self:GetPos())
		entGrenade:SetParent(self)
		entGrenade:SetEntityOwner(self)
		entGrenade:Spawn()
		entGrenade:Activate()
		entGrenade:Fire("SetParentAttachment","grenade",0)
		self:DeleteOnDeath(entGrenade)
		self.entGrenade = entGrenade
		return true
	end
	if(event == "equipped") then
		if(!self:SLV_IsPossesed()) then
			local fDist = IsValid(self.entEnemy) && self:OBBDistance(self.entEnemy)
			if(!IsValid(self.entEnemy) || CurTime() < self.m_nextGrenadeAttack || fDist > self.fRangeDistanceGrenade || fDist <= 280 || self.entEnemy:Health() <= 0 || !self:CanThrowGrenade()) then
				self:SLVPlayActivity(ACT_DISARM)
				self.bInSchedule = false
				self.m_nextGrenadeAttack = CurTime() +math.Rand(4,8)
				return true
			end
		else
			local pl = self:GetPossessor()
			if(!pl:KeyDown(IN_ATTACK2)) then
				self:SLVPlayActivity(ACT_DISARM,false,self._PossScheduleDone)
				self.bInSchedule = false
				return true
			end
		end
		self:SLVPlayActivity(ACT_RANGE_ATTACK2,true)
		return true
	end
	if(event == "unequip") then
		if(IsValid(self.entGrenade)) then self.entGrenade:Remove() end
		return true
	end
end

function ENT:CanThrowGrenade()
	local tr = util.TraceLine({start = self:GetAttachment(self:LookupAttachment("grenade")).Pos, endpos = self.entEnemy:GetCenter(), filter = {self, self.entGrenade}})
	return !tr.HitWorld && (!IsValid(tr.Entity) || tr.Entity == self.entEnemy)
end

function ENT:Interrupt()
	if(self.tblGlowEnts) then
		for _, ent in pairs(self.tblGlowEnts) do
			if(ent:IsValid()) then ent:Remove() end
		end
		self.tblGlowEnts = nil
		if(IsValid(self.entLight)) then
			self.entLight:Remove()
			self.entLight = nil
			self.lightBrightness = nil
			self.nextLightDecr = nil
		end
	end
	if(self.actReset) then self:SetMovementActivity(self.actReset); self.actReset = nil end
	self.bInSchedule = false
	if(self:SLV_IsPossesed()) then self:_PossScheduleDone() end
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	if(self.CanRegenHealth && CurTime() >= self.nextHealthRegen) then
		local hp = self:Health()
		local rate = GetConVarNumber("sk_" .. self.skName .. "_health_regen_rate")
		local hpMax = self:GetMaxHealth()
		if(hp < hpMax) then self:slvSetHealth(hp +1) end
		self.nextHealthRegen = CurTime() +(1 /rate)
	end
	if(self.nextLightDecr && CurTime() >= self.nextLightDecr) then
		self.nextLightDecr = CurTime() +0.2
		self.lightBrightness = self.lightBrightness -1
		if(self.lightBrightness == 0) then
			self.entLight:Remove()
			self.lightBrightness = nil
			self.nextLightDecr = nil
		else self.entLight:Fire("Brightness", self.bright, 0) end
	end
end

function ENT:AttackMelee(ent)
	self:SetTarget(ent)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,2)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if(self.CanUseRadiation && CurTime() >= self.nextRADAttack && dist <= self.fRangeDistanceRadiation) then
				self.nextRADAttack = CurTime() +math.Rand(8,18)
				self:SLVPlayActivity(ACT_RANGE_ATTACK1,true)
				return
			end
			local bMelee = dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance
			if(bMelee) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
			if(!self:LimbCrippled(HITBOX_LEFTLEG) && !self:LimbCrippled(HITBOX_RIGHTLEG) && CurTime() >= self.nextJumpAttack) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if(ang.y <= 35 || ang.y >= 325) then
					local fTimeToGoal = self:GetMoveTimeToTarget(enemy)
					if(self.bDirectChase && fTimeToGoal <= 0.65 && fTimeToGoal >= 0.55 && distPred <= self.fMeleeForwardDistance) then
						self:SLVPlayActivity(ACT_MELEE_ATTACK2)
						self.nextJumpAttack = CurTime() +math.Rand(4,12)
						return
					end
				end
			end
			if(self.CanUseGrenade && CurTime() >= self.m_nextGrenadeAttack && dist <= self.fRangeDistanceGrenade && dist > 320) then
				self:SLVPlayActivity(ACT_ARM,true)
				self.bInSchedule = true
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end