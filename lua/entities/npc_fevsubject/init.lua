AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_SUPERMUTANT,CLASS_MUTANT)
end
ENT.sModel = "models/fallout/fevsubject.mdl"
ENT.fMeleeDistance = 55
ENT.fMeleeForwardDistance = 320
ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/"
ENT.skName = "fev"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = true
ENT.ForceMultiplier = 1
ENT.m_tbSounds = {
	["FootLeft"] = "supermutant/foot/supermutant_foot_l0[1-3].mp3",
	["FootRight"] = "supermutant/foot/supermutant_foot_r0[1-3].mp3",
	["Idle"] = "supermutant_behemoth/supermutantbehemoth_injured01.mp3"
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

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return ang.r >= 0 && ACT_ROLL_RIGHT || ACT_ROLL_LEFT
end

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(30,30,105),Vector(-30,-30,0))
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	
	self:SetIdleActivity(ACT_DOD_PRIMARYATTACK_PRONE_GREASE)
	self:SetWalkActivity(ACT_DOD_PRIMARYATTACK_C96)
	self:SetRunActivity(ACT_DOD_PRIMARYATTACK_C96)

	self.nextJumpAttack = 0
	self.m_tNextMeleeAttack = 0
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	local atk = select(2,...)
	local atk2 = select(3,...)

	if(event == "2hm") then
		local dmg
		local ang
		local dist = self.fMeleeDistance
		local lefta = string.find(atk,"lefta")
		local righta = !left && string.find(atk,"righta")
		local leftb = string.find(atk,"leftb")
		local rightb = !left && string.find(atk,"rightb")
		local power = string.find(atk,"power")
		local leftpower = string.find(atk,"leftpower")
		local rightpower = string.find(atk,"rightpower")
		local force
		self:DealMeleeDamage(dist,GetConVarNumber("sk_fev_dmg_fist"),Angle(0,0,0),Vector(100,100,0),nil,nil,true)
		return true
	end
	
	if(event == "swing") then
		return true
	end
	
	if(event == "mattack") then
		local dmg
		local ang
		local dist = self.fMeleeDistance
		local lefta = string.find(atk,"lefta")
		local righta = !left && string.find(atk,"righta")
		local leftb = string.find(atk,"leftb")
		local rightb = !left && string.find(atk,"rightb")
		local power = string.find(atk,"power")
		local leftpower = string.find(atk,"leftpower")
		local rightpower = string.find(atk,"rightpower")
		local force
		self:DealMeleeDamage(dist,GetConVarNumber("sk_fev_dmg_fist"),Angle(0,0,0),Vector(100,100,0),nil,nil,true)
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
	-- self:RestartGesture(ACT_GESTURE_MELEE_ATTACK1)
	self:AddGesture(ACT_GESTURE_MELEE_ATTACK1)
	fcDone(true)
end

function ENT:_PossJump(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK2,false,fcDone)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(enemy)) then
			if dist <= 500 then
				local ang = self:GetAngles()
				local yawTgt = (enemy:GetPos() -self:GetPos()):Angle().y
				ang.y = math.ApproachAngle(ang.y,yawTgt,10)
				self:SetAngles(ang)
			end
			if(CurTime() >= self.m_tNextMeleeAttack && dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self.m_tNextMeleeAttack = CurTime() +0.8
				-- self:ChaseEnemy()
				-- self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				-- self:RestartGesture(ACT_GESTURE_MELEE_ATTACK1)
				self:AddGesture(ACT_GESTURE_MELEE_ATTACK1)
				-- print('ran')
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
							self:SLVPlayActivity(ACT_MELEE_ATTACK1)
							return
						end
					end
				end
			end
		end
		-- if dist > self.fMeleeDistance then
			self:ChaseEnemy()
		-- end
	elseif(disp == D_FR) then
		self:Hide()
	end
end
