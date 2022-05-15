AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_MIRELURK,CLASS_MIRELURK)
end
ENT.NPCFaction = NPC_FACTION_MIRELURK
ENT.iClass = CLASS_MIRELURK
-- util.AddNPCClassAlly(CLASS_MIRELURK,"npc_mirelurk")
ENT.sModel = "models/fallout/mirelurk.mdl"
ENT.fMeleeDistance	= 60
ENT.fMeleeForwardDistance = 320
ENT.m_iCustomIdle = ACT_IDLE_RELAXED
ENT.iBloodType = BLOOD_COLOR_GREEN
ENT.sSoundDir = "npc/mirelurk/"
ENT.skName = "mirelurk"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.Skin = 0
ENT.Bodygroup = 0
ENT.FireType = false
ENT.m_bKnockDownable = true
ENT.UseCustomMovement = false
ENT.ForceMultiplier = 1
ENT.m_tbSounds = {
	["Melee"] = "mirelurk_attack0[1-2].mp3",
	["MeleePower"] = "mirelurk_attackpower01.mp3",
	["MeleePowerRun"] = "mirelurk_attackpowerforward01.mp3",
	["IdleAngry"] = "mirelurk_warning.mp3",
	["Death"] = "mirelurk_death0[1-2].mp3",
	["Pain"] = "mirelurk_injured0[1-2].mp3",
	["Idle"] = "mirelurk_idle0[1-4].mp3",
	["FootLeft"] = "foot/mirelurk_foot_l0[1-2].mp3",
	["FootRight"] = "foot/mirelurk_foot_r0[1-2].mp3"
}

ENT.tblAlertAct = {ACT_IDLE_ANGRY}
ENT.AlertChance = 25
ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST,
	[HITBOX_HEAD] = ACT_FLINCH_HEAD,
	[HITBOX_CHEST] = ACT_FLINCH_CHEST,
	[HITBOX_LEFTARM] = ACT_FLINCH_LEFTARM,
	[HITBOX_RIGHTARM] = ACT_FLINCH_RIGHTARM,
	[HITBOX_LEFTLEG] = ACT_FLINCH_LEFTLEG,
	[HITBOX_RIGHTLEG] = ACT_FLINCH_RIGHTLEG
}
ENT.CollisionBounds = Vector(18,18,72)

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return ang.r >= 0 && ACT_ROLL_RIGHT || ACT_ROLL_LEFT
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:SetSkin(self.Skin)
	self:SetBodygroup(1,self.Bodygroup)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))

	self.nextJumpAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
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
		if(power) then
			force = Vector(260,0,0)
			if(left || right) then
				dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash_power")
				if(left) then ang = Angle(4,34,0)
				else ang = Angle(4,-34,0) end
			else
				dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_strike")
				ang = Angle(-25,0,0)
			end
			local forward = string.find(atk,"forward")
			if(!forward) then dist = self.fMeleeDistance
			else dist = 80 end
		else
			dist = self.fMeleeDistance
			force = Vector(180,0,0)
			dmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
			if(left) then ang = Angle(2,25,0)
			else ang = Angle(2,-25,0) end
		end
		local fcHit
		if(self.FireType) then
			fcHit = function(ent)
				ent:slvIgnite(3,0)
			end
		end
		force = force *self.ForceMultiplier
		self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,nil,nil,fcHit)
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
