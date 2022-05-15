AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_RADSCORPION,CLASS_RADSCORPION)
end
ENT.sModel = "models/fallout/radscorpion.mdl"
ENT.fMeleeDistance = 55
ENT.fMeleeForwardDistance = 320
ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/radscorpion/"
ENT.skName = "radscorpion"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = true
ENT.ForceMultiplier = 1
ENT.m_tbSounds = {
	["Melee"] = "radscorpion_attack0[1-3].mp3",
	["MeleePower"] = "mirelurk_attacksting0[1-3].mp3",
	["MeleePowerRun"] = "mirelurk_attacktail01.mp3",
	["Death"] = "radscorpion_death0[1-2].mp3",
	["Pain"] = "radscorpion_injured0[1-2].mp3",
	["Idle"] = "radscorpion_idle0[1-2].mp3",
	["FootLeft"] = "foot/radscorpion_foot_l0[1-2].mp3",
	["FootRight"] = "foot/radscorpion_foot_r0[1-2].mp3"
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
ENT.CollisionBounds = Vector(55,55,45)
ENT.GlowType = false
ENT.NukaType = false

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

	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	if self.GlowType == true then
		self:SetSkin(2)
	elseif self.NukaType == true then
		self:SetSkin(1)
	end
	self:GMAInit()
end

function ENT:GMAInit()
	-- self.GMA_Level = math.random(18,30)
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
		local dmg
		local dist
		local ang,force
		local atk = select(2,...)
		local left = string.find(atk,"left")
		local right = !left && string.find(atk,"right")
		local power = string.find(atk,"power")
		local usep = false
		if(power) then
			force = Vector(260,0,0)
			if(left || right) then
				dmg = 44
				if(left) then ang = Angle(4,34,0)
				else ang = Angle(4,-34,0) end
			else
				usep = true
				dmg = 28
				ang = Angle(-25,0,0)
			end
			local forward = string.find(atk,"forward")
			if(!forward) then dist = self.fMeleeDistance
			else dist = 80 usep = true end
		else
			dist = self.fMeleeDistance
			force = Vector(180,0,0)
			dmg = 28
			if(left) then ang = Angle(2,25,0)
			else ang = Angle(2,-25,0) end
		end
		local fcHit
		force = force *self.ForceMultiplier
		if usep == false then
			self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,nil,nil,fcHit)
		else
			self:DealMeleeDamage(dist,dmg,ang,force,DMG_ACID,nil,true,nil,function(ent,dmginfo) self:Poison(ent) end)
		end
		return true
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

function ENT:OnLimbCrippled(hitbox, attacker)
	if(hitbox == HITBOX_LEFTLEG || hitbox == HITBOX_RIGHTLEG) then
		self:SetWalkActivity(ACT_WALK_HURT)
		self:SetRunActivity(ACT_RUN_HURT)
	end
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
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
				if(ang.y <= 35 || ang.y >= 325) then
					local fTimeToGoal = self:GetMoveTimeToTarget(enemy)
					if(self.bDirectChase && fTimeToGoal <= 1.5 && fTimeToGoal >= 0.3 && distPred <= self.fMeleeForwardDistance) then
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
