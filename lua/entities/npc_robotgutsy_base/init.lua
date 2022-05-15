AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.iClass = CLASS_ROBOT
ENT.fRangeDistance	= 300
ENT.fRangeDistancePlasma	= 4000
ENT.fFollowAttackDistance = 4000
ENT.m_fMaxYawSpeed = 10
ENT.fViewAngle = 320

ENT.iBloodType = false
ENT.bFlinchOnDamage = false
ENT.bIgnitable = false
ENT.m_bKnockDownable = true
ENT.idleChance = 22
ENT.sModel = "models/fallout/mistergutsy.mdl"
ENT.BoneRagdollMain = "Bip01 Spine 01"

ENT.DamageScales = {
	[DMG_BURN] = 0.4,
	[DMG_BLAST] = 1.4,
	[DMG_SHOCK] = 2.4,
	[DMG_SONIC] = 2.4,
	[DMG_ENERGYBEAM] = 1.6,
	[DMG_PARALYZE] = 0.2,
	[DMG_NERVEGAS] = 0.2,
	[DMG_POISON] = 0.2,
	[DMG_RADIATION] = 0.2,
	[DMG_SLOWBURN] = 0.4,
	[DMG_DIRECT] = 0
}

function ENT:OnInit()
	self:SetHullType(HULL_MEDIUM_TALL)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(26,26,92), Vector(-26,-26,0))

	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	
	self.nextFlameDmg = 0
	self.nextAttackScream = 0
	self.nextAlertIdle = 0
	self.nextAlertToIdle = 0
	
	self.cspIdleLoop = CreateSound(self, "npc/mrhandy/robotmisterhandy_idle_lp.wav")
	self:StopSoundOnDeath(self.cspIdleLoop)
	self.cspMoveLoop = CreateSound(self, "npc/mrhandy/robotmrhandy_movement_lp.wav")
	self:StopSoundOnDeath(self.cspMoveLoop)
	self:SetSoundLevel(80)
	
	self:SetBodygroup(1,1)
	self:SetBodygroup(2,1)
	
	self:GuardInit()
	if(self.m_bActive) then self.cspIdleLoop:Play() end
	self:slvSetHealth(GetConVarNumber("sk_mistergutsy_health"))
	self:SubInit()
end

function ENT:SubInit()
end

function ENT:PlayIdleLoop()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop:Stop()
	self.cspIdleLoop = CreateSound(self, "npc/mrhandy/robotmisterhandy_idle_lp.wav")
	self.cspIdleLoop:Play()
	self:StopSoundOnDeath(self.cspIdleLoop)
end

function ENT:PlayMoveLoop()
	self.cspMoveLoop:Stop()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop = CreateSound(self, "npc/mrhandy/robotmrhandy_movement_lp.wav")
	self.cspMoveLoop:Play()
	self:StopSoundOnDeath(self.cspMoveLoop)
end

function ENT:StopMovementSound()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop:Stop()
end

function ENT:PlayMovementSound()
	if self:IsMoving() then
		self.bMoveLoopPlaying = true
		self:PlayMoveLoop()
	else
		self:PlayIdleLoop()
		self.bMoveLoopPlaying = false
	end
end

function ENT:OnKnockedDown()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop:Stop()
end

function ENT:OnAreaCleared()
	self:slvPlaySound("AreaClear")
end

function ENT:SelectGetUpActivity()
	return ACT_ROLL_LEFT
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	local pp_yaw = self:GetPoseParameter("aim_yaw")
	local pp_yaw_right = self:GetPoseParameter("aim_yaw_right")
	local pp_pitch_left = self:GetPoseParameter("aim_pitch_left")
	local pp_pitch_right = self:GetPoseParameter("aim_pitch_right")
	local yaw = 0
	local yaw_right = 0
	local pitch_left = 0
	local pitch_right = 0
	local att = self:GetAttachment(self:LookupAttachment("flamethrower_muzzle"))
	if CurTime() >= self.nextFlameDmg then
		local pos = att.Pos
		local ang = att.Ang
		local tblEnts = util.BlastDmg(self, self, pos, 300, 5, function(ent)
			if !self:IsEnemy(ent) then return false end
			local _pos = pos
			local pos = ent:GetPos() +ent:OBBCenter()
			local _ang = ang
			local ang = _ang -(pos -_pos):Angle()
			ang:slvClamp()
			return (ang.p <= 30 || ang.p >= 330) && (ang.y <= 15 || ang.y >= 345)
		end, DMG_BURN, false)
		for ent, dist in pairs(tblEnts) do ent:slvIgnite(10) end
		self.nextFlameDmg = CurTime() +0.125
		local actIdle = self:GetIdleActivity()
		if self:GetActivity() != actIdle then
			self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), actIdle)
		end
	end
	-- fcDone(true)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self.iInAttack = 2
	-- self:SLVPlayActivity(ACT_ARM,false)
	fcDone(true)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1, false, fcDone)
end

function ENT:OnWander()
	if CurTime() < self.nextAlertIdle || math.random(1,6) != 1 then return end
	local iState = self:GetState()
	local sound
	if iState == NPC_STATE_ALERT then sound = self:slvPlaySound("AlertIdle")
	elseif iState == NPC_STATE_LOST then sound = self:slvPlaySound("LostIdle") end
	if sound then
		self.nextAlertIdle = CurTime() +SoundDuration(sound) +math.Rand(6,12)
	end
end

function ENT:OnStateChanged(old, new)
	if(self:KnockedDown()) then return end
	self:GuardStateChanged(old,new)
	if old == NPC_STATE_IDLE then
		if new == NPC_STATE_ALERT then self:slvPlaySound("NormalToAlert")
		elseif new == NPC_STATE_COMBAT then self:slvPlaySound("NormalToCombat") end
	elseif old == NPC_STATE_COMBAT then
		if new == NPC_STATE_IDLE then self:slvPlaySound("CombatToNormal")
		elseif new == NPC_STATE_LOST then self:slvPlaySound("CombatToLost") end
	elseif old == NPC_STATE_ALERT then
		if new == NPC_STATE_COMBAT then self:slvPlaySound("AlertToCombat")
		elseif new == NPC_STATE_IDLE then self:slvPlaySound("AlertToNormal") end
	elseif old == NPC_STATE_LOST then
		if new == NPC_STATE_COMBAT then self:slvPlaySound("LostToCombat")
		elseif new == NPC_STATE_IDLE then self:slvPlaySound("LostToNormal") end
	end
end

function ENT:Interrupt()
	if self:SLV_IsPossesed() then self:_PossScheduleDone() end
	if self.iInAttack == 1 then
		self.iInAttack = nil
		self:SetIdleActivity()
		self:StopParticles()
		self:EmitSound("weapons/flamer/flamer_fire_end.wav", 75, 100)
		self.cspFlamerLoop:Stop()
		self.nextFlameDmg = nil
	elseif self.iInAttack == 2 then
		self.iInAttack = nil
		self:SetIdleActivity()
	end
end

hook.Add("OnNPCKilled", "Gutsy_WitnessMurder", function(npc, killer, inflictor)
	if IsValid(killer) && IsValid(npc) && killer:IsPlayer() then
		local tblGutsies = ents.FindByClass("npc_mrgutsy*")
		table.Add(tblGutsies, ents.FindByClass("npc_mrhandy*"))
		if #tblGutsies > 0 then
			local disp = npc:slvDisposition(killer)
			if disp == D_LI then
				local allies = util.GetNPCClassAllies(CLASS_PLAYER_ALLY)
				if table.HasValue(allies, npc:GetClass()) then
					for _, ent in pairs(tblGutsies) do
						if ent:slvDisposition(killer) == D_LI then
							ent:slvAddEntityRelationship(killer, D_HT, 10)
							ent:AddToMemory(killer)
							local sound = ent:slvPlaySound("Murder")
							if sound then ent.nextSoundPlay = CurTime() +SoundDuration(sound) end
						end
					end
				end
			end
		end
	end
end)

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	self:GuardThink()
	if(!self:IsActive() || self:KnockedDown()) then return end
	if self:IsMoving() then
		if !self.bMoveLoopPlaying then
			self.bMoveLoopPlaying = true
			self:PlayMoveLoop()
		end
	elseif self.bMoveLoopPlaying then
		self:EmitSound("npc/mrhandy/robotmrhandy_movement_end.mp3", 75, 100)
		self:PlayIdleLoop()
		self.bMoveLoopPlaying = false
	end
	local pp_yaw = self:GetPoseParameter("aim_yaw")
	local pp_yaw_right = self:GetPoseParameter("aim_yaw_right")
	local pp_pitch_left = self:GetPoseParameter("aim_pitch_left")
	local pp_pitch_right = self:GetPoseParameter("aim_pitch_right")
	local yaw = 0
	local yaw_right = 0
	local pitch_left = 0
	local pitch_right = 0
	if self.iInAttack == 1 then
		local att = self:GetAttachment(self:LookupAttachment("flamethrower_muzzle"))
		if CurTime() >= self.nextFlameDmg then
			local pos = att.Pos
			local ang = att.Ang
			local tblEnts = util.BlastDmg(self, self, pos, 300, 5, function(ent)
				if !self:IsEnemy(ent) then return false end
				local _pos = pos
				local pos = ent:GetPos() +ent:OBBCenter()
				local _ang = ang
				local ang = _ang -(pos -_pos):Angle()
				ang:slvClamp()
				return (ang.p <= 30 || ang.p >= 330) && (ang.y <= 15 || ang.y >= 345)
			end, DMG_BURN, false)
			for ent, dist in pairs(tblEnts) do ent:slvIgnite(10) end
			self.nextFlameDmg = CurTime() +0.125
			local actIdle = self:GetIdleActivity()
			if self:GetActivity() != actIdle then
				self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), actIdle)
			end
		end
		if !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || !self:Visible(self.entEnemy) || self:GunTraceBlocked("flamethrower") || self:OBBDistance(self.entEnemy) > self.fRangeDistance then
			self.iInAttack = nil
			self:SetIdleActivity()
			self:StopParticles()
			self:EmitSound("weapons/flamer/flamer_fire_end.wav", 75, 100)
			self.cspFlamerLoop:Stop()
			self.nextFlameDmg = nil
		else
			local fDist = self:OBBDistance(self.entEnemy)
			local bPos = att.Pos

			local _ang = self:GetAngles()
			local ang = _ang -(self.entEnemy:GetCenter() -bPos):Angle()
			yaw = math.NormalizeAngle(ang.y -75) *-1
			
			_ang = att.Ang
			ang = (self.entEnemy:GetCenter() -bPos):Angle() -_ang
			pitch_left = pp_pitch_left +math.NormalizeAngle(ang.p)
			
			if CurTime() >= self.nextAttackScream then
				if math.random(1,4) == 1 then
					local sound = self:slvPlaySound("Attack")
					self.nextAttackScream = CurTime() +SoundDuration(sound) +math.Rand(6,16)
				else self.nextAttackScream = CurTime() +math.Rand(6,16) end
			end
		end
	elseif self.iInAttack == 2 then
		local actIdle = self:GetIdleActivity()
		if self:GetActivity() != actIdle then
			self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"), actIdle)
		end
		if !IsValid(self.entEnemy) || self.entEnemy:Health() <= 0 || !self:Visible(self.entEnemy) || self:GunTraceBlocked("plasmagun") || self:OBBDistance(self.entEnemy) > self.fRangeDistancePlasma then
			self.iInAttack = nil
			self:SetIdleActivity()
		else
			local att = self:GetAttachment(self:LookupAttachment("plasmagun_muzzle"))
			local fDist = self:OBBDistance(self.entEnemy)
			local bPos = att.Pos

			local _ang = self:GetAngles()
			local ang = _ang -(self.entEnemy:GetCenter() -bPos):Angle()
			yaw = math.NormalizeAngle(ang.y +75) *-1
			
			_ang = att.Ang
			ang = (self.entEnemy:GetCenter() -bPos):Angle() -_ang
			yaw_right = pp_yaw_right +math.NormalizeAngle(ang.y)
			pitch_right = pp_pitch_right +math.NormalizeAngle(ang.p)
			
			if CurTime() >= self.nextAttackScream then
				if math.random(1,6) == 1 then
					local sound = self:slvPlaySound("Attack")
					if sound then self.nextAttackScream = CurTime() +SoundDuration(sound) +math.Rand(6,16) end
				else self.nextAttackScream = CurTime() +math.Rand(6,16) end
			end
		end
	end
	pp_yaw = math.ApproachAngle(pp_yaw, yaw, 3)
	self:SetPoseParameter("aim_yaw", pp_yaw)
	
	pp_yaw_right = math.ApproachAngle(pp_yaw_right, yaw_right, 3)
	self:SetPoseParameter("aim_yaw_right", pp_yaw_right)
	
	pp_pitch_left = math.ApproachAngle(pp_pitch_left, pitch_left, 3)
	self:SetPoseParameter("aim_pitch_left", pp_pitch_left)
	
	pp_pitch_right = math.ApproachAngle(pp_pitch_right, pitch_right, 3)
	self:SetPoseParameter("aim_pitch_right", pp_pitch_right)
	
	self:NextThink(CurTime())
	return true
end

function ENT:GunTraceBlocked(att)
	att = self:LookupAttachment(att .. "_muzzle")
	local tracedata = {}
	tracedata.start = self:GetAttachment(att).Pos
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "equipped") then
		self:StartEngineTask(GetTaskID("TASK_SET_ACTIVITY"),ACT_IDLE_AIM_RELAXED)
		return true
	elseif(event == "plasma") then
		local att = self:LookupAttachment("plasmagun_muzzle")
		ParticleEffectAttach("plasma_muzzle_flash",PATTACH_POINT_FOLLOW,self,att)
		
		self:EmitSound("weapons/plasmapistol/pistolplasma_fire_3d.mp3",100,100)
		att = self:GetAttachment(att)
		local ang = att.Ang
		local pos = att.Pos
		local entPlasma = ents.Create("obj_plasma_particle")
		entPlasma:SetPos(pos)
		entPlasma:SetEntityOwner(self)
		entPlasma:Spawn()
		entPlasma:Activate()
		
		local phys = entPlasma:GetPhysicsObject()
		if(phys:IsValid()) then
			phys:ApplyForceCenter(ang:Forward() *4000)
		end
		return true
	elseif(event == "rattack") then
		if(self.iInAttack == 2) then
			timer.Simple(0,function()
				if(self:IsValid() && self.iInAttack == 2) then
					self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
				end
			end)
		end
		return true
	elseif(event == "deactivate") then
		self.m_bDeactivated = true
		return true
	end
end

local schdFaceEnemy = ai_schedule_slv.New("Face Enemy")
schdFaceEnemy:EngTask("TASK_FACE_TARGET")
function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(!self:IsActive()) then return end
	if(disp == D_HT) then
		if self.backAway then
			if dist >= 200 then self.backAway = false
			else
				local pos = self:GetPos() +(self:GetPos() -enemy:GetPos()):GetNormal() *120
				self:GoToPos(pos)
				return
			end
		end
		if self:Visible(enemy) then
			local bFlamer = dist <= self.fRangeDistance && !self:GunTraceBlocked("flamethrower")
			if bFlamer then
				if self.iInAttack == 2 then
					self.iInAttack = nil
					self:SetIdleActivity()
				end
				if !self.iInAttack then
					self:SetIdleActivity(ACT_IDLE_AIM_RELAXED)
					self.iInAttack = 1
					ParticleEffectAttach("flamer", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("flamethrower_muzzle"))
					self.cspFlamerLoop = CreateSound(self, "weapons/flamer/flamer_fire_lp.wav")
					self.cspFlamerLoop:Play()
					self:StopSoundOnDeath(self.cspFlamerLoop)
					self.nextFlameDmg = CurTime()
				end
				if dist <= 200 then
					self:StopMoving()
					local ang = self:GetAngles()
					ang.y = ang.y +self:GetPoseParameter("aim_yaw")
					ang = self:GetAngleToPos(enemy:GetPos(), ang)
					if ang.y > 90 then
						self:SetTarget(enemy)
						self:StartSchedule(schdFaceEnemy)
					end
					if dist <= 50 then self.backAway = true end
					return
				end
			elseif dist <= self.fRangeDistancePlasma && !self:GunTraceBlocked("plasmagun") then
				if !self.iInAttack then
					self.iInAttack = 2
					self:SetIdleActivity(ACT_IDLE_AIM_RELAXED)
					self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
				end
				local ang = self:GetAngles()
				ang = self:GetAngleToPos(enemy:GetPos(), ang)
				if ang.y > 90 && ang.y < 270 then
					self:StopMoving()
					self:SetTarget(enemy)
					self:StartSchedule(schdFaceEnemy)
				end
				--self:MoveToPos(self:GetPos() +(self:GetPos() -enemy:GetPos()):GetNormal() *50, true)
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
