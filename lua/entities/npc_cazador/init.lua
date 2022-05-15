AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.sModel = "models/fallout/cazadore.mdl"
ENT.fMeleeDistance	= 40
ENT.fMeleeForwardDistance = 200
ENT.CollisionBounds = Vector(40,40,75)
ENT.tblAlertAct = {ACT_IDLE_RELAXED}
ENT.AlertChance = 25
ENT.DamageScales = {
	[DMG_BURN] = 1.1,
	[DMG_BLAST] = 1.6,
	[DMG_SHOCK] = 1.4,
	[DMG_SONIC] = 2,
	[DMG_PARALYZE] = 0.6,
	[DMG_NERVEGAS] = 0.6,
	[DMG_POISON] = 0.5,
	[DMG_ACID] = 0.65,
	[DMG_DIRECT] = 1.1
}

ENT.m_fMaxYawSpeed = 20
ENT.fFollowDistance = 100
ENT.m_bKnockDownable = false
ENT.skName = "cazador"
ENT.UseActivityTranslator = true

ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/cazadore/"

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_CHEST,
	[HITBOX_STOMACH] = ACT_FLINCH_CHEST,
	[HITBOX_CHEST] = ACT_FLINCH_CHEST,
	[HITBOX_ADDLIMB] = ACT_FLINCH_STOMACH,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_LEFTLEG
}

ENT.m_tbSounds = {
	["Chase"] = "caz_chasevox0[1-4].mp3",
	["BodyFall"] = "cazadore_bodyfall0[1-4].mp3",
	["Death"] = "cazadore_death_sfx0[1-4].mp3",
	["Hit"] = "cazadore_hit_sfx0[1-3].mp3",
	["AttackPower"] = "cazadore_powerattackvox0[1-4].mp3",
	["AttackSting"] = "cazadore_stingmvmt0[1-2].mp3",
	["StingSlash"] = "cazadore_sting_attack0[1-4].mp3",
	["Wing"] = "cazadore_wingflap_back0[1-4].mp3",
	["WingTurn"] = "cazadore_wingturn0[1-3].mp3",
	["Foot"] = {"foot/cazadore_foot0[1-9].mp3","foot/cazadore_foot10.mp3"}
}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.cspLoop = CreateSound(self,self.sSoundDir .. "cazadore_consciouslp.wav")
	self.cspLoop:ChangeVolume(2,0)
	self.m_bLoopPlaying = false
	self:StopSoundOnDeath(self.cspLoop)
	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self:SubInit()
end

function ENT:TranslateActivity(act)
	if(act == ACT_IDLE) then if(self:SLV_IsPossesed()) then return ACT_IDLE_ANGRY end end
	if(act == ACT_WALK) then if(self:SLV_IsPossesed()) then return ACT_WALK_AIM end end
	return act
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:SubInit()
end

function ENT:OnDamaged(dmgTaken,attacker,inflictor,dmginfo)
	if(self:GetActivity(ACT_IDLE_RELAXED)) then
		self:ScheduleFinished()
	end
end

local tbActConscious = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2,ACT_ARM,ACT_DISARM,ACT_FLINCH_CHEST,ACT_FLINCH_LEFTLEG,ACT_FLINCH_STOMACH,ACT_IDLE_ANGRY,ACT_RUN,ACT_WALK_AIM}
function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	local act = self:GetActivity()
	if(table.HasValue(tbActConscious,act)) then
		if(!self.m_bLoopPlaying) then
			self.m_bLoopPlaying = true
			self.cspLoop:Play()
		end
	elseif(self.m_bLoopPlaying) then
		self.m_bLoopPlaying = false
		self.cspLoop:Stop()
	end
end

function ENT:OnStateChanged(old, new)
	if(self:LegsCrippled()) then return end
	if(new == NPC_STATE_ALERT || new == NPC_STATE_COMBAT) then
		self:SLVPlayActivity(ACT_ARM,true)
		self:SetIdleActivity(ACT_IDLE_ANGRY)
		self:SetWalkActivity(ACT_WALK_AIM)
	elseif(old == NPC_STATE_ALERT || old == NPC_STATE_COMBAT) then
		self:SLVPlayActivity(ACT_DISARM)
		self:SetIdleActivity()
		self:SetWalkActivity()
	end
end

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG) then
		self:SetIdleActivity()
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_WALK_HURT)
	end
end

function ENT:Poison(ent)
	if(ent:IsPlayer()) then ent:ConCommand("play fx/fx_poison_stinger.mp3") end
	local tm = "npcpoison" .. self:EntIndex() .. "_" .. ent:EntIndex()
	timer.Create(tm,0.5,15,function()
		if(!ent:IsValid() || !ent:Alive()) then timer.Remove(tm)
		else
			local attacker
			if(self:IsValid()) then attacker = self
			else attacker = ent end
			local dmg = DamageInfo()
			dmg:SetDamageType(DMG_NERVEGAS)
			dmg:SetDamage(3)
			dmg:SetAttacker(attacker)
			dmg:SetInflictor(attacker)
			dmg:SetDamagePosition(ent:GetPos() +ent:OBBCenter())
			ent:TakeDamageInfo(dmg)
		end
	end)
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
			ang = Angle(-15,0,0)
			force = Vector(200,0,0)
		elseif(atk == "right") then
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			ang = Angle(-15,0,0)
			force = Vector(200,0,0)
		elseif(atk == "forwardpower") then
			dist = 70
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			ang = Angle(-20,0,0)
			force = Vector(380,0,0)
		else
			dist = self.fMeleeDistance
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
			ang = Angle(-25,0,0)
			force = Vector(350,0,0)
		end
		local posSelf = self:GetPos()
		local center = posSelf +self:OBBCenter()
		local hit = self:DealMeleeDamage(dist,dmg,ang,force,DMG_ACID,nil,true,nil,function(ent,dmginfo) self:Poison(ent) end)
		if(hit) then self:EmitEventSound("StingSlash")
		else self:EmitSound("npc/zombie/claw_miss" .. math.random(1,2) .. ".wav",75,100) end
		return true
	end
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
			local bCrippled = self:LegsCrippled()
			if(!bCrippled && CurTime() >= self.nextJumpAttack) then
				local ang = self:GetAngleToPos(enemy:GetPos())
				if ang.y <= 35 || ang.y >= 325 then
					local fTimeToGoal = self:GetPathTimeToGoal()
					if(self.bDirectChase && fTimeToGoal <= 2 && fTimeToGoal >= 0.2 && distPred <= self.fMeleeForwardDistance) then
						self.nextJumpAttack = CurTime() +math.Rand(3,8)
						if(math.random(1,3) >= 2) then
							self:SLVPlayActivity(ACT_MELEE_ATTACK2)
							return
						end
					end
				end
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
