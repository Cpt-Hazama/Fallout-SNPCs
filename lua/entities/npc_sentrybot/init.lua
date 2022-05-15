AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ROBOT,CLASS_SENTRYBOT)
end
ENT.sModel = "models/fallout/sentrybot.mdl"
ENT.InitSkin = 0
ENT.WeaponType = 0
ENT.CollisionBounds = Vector(50,50,85)
ENT.fRangeDistance = 2000
ENT.fRangeRocketDistance = 800
ENT.iBloodType = false
ENT.sSoundDir = "npc/sentrybot/"
ENT.skName = "sentrybot"
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.m_bKnockDownable = true
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE}
ENT.m_tbSounds = {
	["Attack"] = "genericrobot_attack[1-15].mp3",
	["Death"] = "genericrobot_death[1-6].mp3",
	["Pain"] = "genericrobot_hit[1-6].mp3",
	-- ["Idle"] = "genericidl_idlechatter[1-14].mp3", -- Causes sounds to stop playing, but these are just whistling sounds so =/
	["AlertIdle"] = "genericrobot_alertidle[1-3].mp3",
	["LostIdle"] = "genericrobot_lostidle[1-3].mp3",
	["NormalToAlert"] = "genericrobot_normaltoalert[1-3].mp3",
	["NormalToCombat"] = "genericrob_normaltocombat[1-3].mp3",
	["CombatToNormal"] = "genericrob_combattonormal[1-4].mp3",
	["CombatToLost"] = "genericrobot_combattolost[1-3].mp3",
	["AlertToCombat"] = "genericrobot_alerttocombat[1-3].mp3",
	["AlertToNormal"] = "genericrobot_alerttonormal[1-3].mp3",
	["LostToCombat"] = "genericrobot_losttocombat[1-3].mp3",
	["LostToNormal"] = "genericrobot_losttonormal[1-3].mp3"
}

ENT.tblAlertAct = {ACT_IDLE_ANGRY}
ENT.iAlertRandom = 8

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
	
	local max = self.CollisionBounds
	local min = Vector(max.x *-1,max.y *-1,0)
	self:SetCollisionBounds(max,min)
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	
	-- self.cspIdleLoop = CreateSound(self, "npc/sentrybot/sentrybot_idle_lp.mp3")
	self.cspIdleLoop = CreateSound(self, "common/null.wav")
	self:StopSoundOnDeath(self.cspIdleLoop)
	self.cspMoveLoop = CreateSound(self, "npc/sentrybot/sentrybot_movement_lp.wav")
	self:StopSoundOnDeath(self.cspMoveLoop)
	self:SetSoundLevel(80)
	self:GuardInit()
	self.cspIdleLoop:Play()

	self.canattack = false
	self.nextSpitAttack = 0
	self.nextAttackScream = 0
	self.nextAlertIdle = 0
	self.nextAlertToIdle = 0
	self.ammo = 200
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self:SetSkin(self.InitSkin)
	self:SetBodygroup(1,self.WeaponType)
end

function ENT:PlayIdleLoop()
	if !self.cspIdleLoop:IsPlaying() then
		self.cspIdleLoop:Stop()
		self.cspMoveLoop:Stop()
		self:EmitSound("npc/sentrybot/sentrybot_movement_end.mp3",80,100)
		-- self.cspIdleLoop = CreateSound(self, "npc/sentrybot/sentrybot_idle_lp.mp3")
		self.cspIdleLoop = CreateSound(self, "common/null.wav")
		self.cspIdleLoop:Play()
		self:StopSoundOnDeath(self.cspIdleLoop)
	end
end

function ENT:PlayMoveLoop()
	if !self.cspMoveLoop:IsPlaying() then
		self.cspMoveLoop:Stop()
		self.cspIdleLoop:Stop()
		self.cspMoveLoop = CreateSound(self, "npc/sentrybot/sentrybot_movement_lp.wav")
		self.cspMoveLoop:Play()
		self:StopSoundOnDeath(self.cspMoveLoop)
	end
end

function ENT:StopMovementSound()
	self.cspIdleLoop:Stop()
	self.cspMoveLoop:Stop()
	self:EmitSound("npc/sentrybot/sentrybot_movement_end.mp3",80,100)
end

function ENT:PlayMovementSound()
	if self:IsMoving() then
		self:PlayMoveLoop()
	else
		self:PlayIdleLoop()
	end
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

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:GunTraceBlocked()
	local tracedata = {}
	tracedata.start = self:GetAttachment(1).Pos
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	self:GuardThink()
	if !self:SLV_IsPossesed() then
		self:MaintainPoseParameters()
	else
		local ang
		ang = (self:GetAttachment(self.WeaponType+1).Pos -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
		-- if ang >= 90 then ang = ang -360 end
			-- ang = math.Clamp(ang,-45,45)
			self:SetPoseParameter("aim_pitch", ang)
	end
	if(!self:IsActive() || self:KnockedDown()) then return end
	self:PlayMovementSound()
	
	self:NextThink(CurTime())
	return true
end

function ENT:MaintainPoseParameters()
	local ent = self.entEnemy
	local yawTgt = 0
	local pitchTgt = 0
	if(IsValid(ent)) then
		-- local posSrc = self:GetPos() +self:OBBCenter()
		-- local posSrc = (self:GetAttachment(1).Pos -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
		local posSrc = (self:GetAttachment(self.WeaponType+1).Pos)
		local posTgt = ent:GetPos() +ent:OBBCenter()
		local ang = self:GetAngles()
		local angTgt = (posTgt -posSrc):Angle()
		pitchTgt = math.AngleDifference(angTgt.p,ang.p)
		yawTgt = math.AngleDifference(angTgt.y,ang.y)
	end
	local ppYaw = self:GetPoseParameter("aim_yaw")
	self:SetPoseParameter("aim_yaw",math.ApproachAngle(ppYaw,yawTgt,2))
	
	local ppPitch = self:GetPoseParameter("aim_pitch")
	self:SetPoseParameter("aim_pitch",math.ApproachAngle(ppPitch,pitchTgt,2))
end

function ENT:GetSLVDotAngle(ang,ent)
	if ent then
		if ent:IsValid() then
			if (self:GetForward():Dot((ent:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(ang))) then
				return true
			else
				return false
			end
		else
			return false
		end
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "rattack") then
		if !self:SLV_IsPossesed() then
			if self:GetSLVDotAngle(35,self.entEnemy) == true && self.ammo >= 1 then
				local attPosAng = self:GetAttachment(self.WeaponType +1)
				attPosAng.Pos = attPosAng.Pos

				-- local dir = self:GetAngles()
				-- dir.p = -self:GetPoseParameter("aim_pitch")
				-- dir = dir:Forward()
				local dir
				if self.entEnemy:IsValid() && self.entEnemy:IsNPC() && self.entEnemy.m_bInitialized == true then
					dir = ((self.entEnemy:GetCenter()) -(self:GetPos() /*+self:GetUp()*-50 +self:GetRight()*30*/)):GetNormal()
				elseif self.entEnemy:IsValid() && self.entEnemy:IsPlayer() then
					dir = ((self.entEnemy:GetPos() -self.entEnemy:OBBCenter()) -(self:GetPos() +self:GetUp()*-50 +self:GetRight()*30)):GetNormal()
				elseif self.entEnemy:IsValid() && self.entEnemy:IsNPC() then
					dir = ((self.entEnemy:GetPos() -self.entEnemy:OBBCenter()) -(self:GetPos() +self:GetUp()*-50 +self:GetRight()*30)):GetNormal()
				end
				if self.WeaponType == 0 then
					local effectdata = EffectData()
					effectdata:SetStart(attPosAng.Pos)
					effectdata:SetOrigin(attPosAng.Pos)
					effectdata:SetScale(1)
					effectdata:SetAngles(attPosAng.Ang)
					util.Effect("MuzzleEffect", effectdata)
				end
				
				local tblBullet = {}
				tblBullet.Num = 1
				tblBullet.Src = attPosAng.Pos
				tblBullet.Attacker = self
				tblBullet.Dir = dir
				tblBullet.Spread = Vector(0.02,0.02,0.02)
				tblBullet.Tracer = 1
				if self.WeaponType == 1 then
					tblBullet.TracerName = "effect_fo3_laser"
				end
				tblBullet.Force = 6
				tblBullet.Damage = math.random(2,9)
				tblBullet.Callback = function(entAttacker, tblTr, dmg)
					local entVictim = tblTr.Entity
					local iDmg = dmg:GetDamage()
					if tblTr.HitGroup == 1 then
						iDmg = iDmg *10
					elseif tblTr.HitGroup != 0 then
						iDmg = iDmg *0.25
					end
				end
				self:FireBullets(tblBullet)
				self.ammo = self.ammo -tblBullet.Num
				local sound
				if self.WeaponType == 1 then
					sound = "weapons/gatlinglaser/gatlinglaser_fire3d.wav"
				else
					sound = "weapons/minigun/wpn_minigun_fire_loop.wav"
				end
				self:EmitSound(sound, 100, 100 )
			end
		else
			if self.ammo >= 1 then
				local attPosAng = (self:GetAttachment(self.WeaponType+1))
				attPosAng.Pos = attPosAng.Pos

				local dir = self:GetAngles()
				dir.p = -self:GetPoseParameter("aim_pitch")
				dir = dir:Forward()
				if self.WeaponType == 0 then
					local effectdata = EffectData()
					effectdata:SetStart(attPosAng.Pos)
					effectdata:SetOrigin(attPosAng.Pos)
					effectdata:SetScale(1)
					effectdata:SetAngles(attPosAng.Ang)
					util.Effect("MuzzleEffect", effectdata)
				end
				
				local tblBullet = {}
				tblBullet.Num = 1
				tblBullet.Src = attPosAng.Pos
				tblBullet.Attacker = self
				-- tblBullet.Dir = (self:GetAttachment(self.WeaponType+1).Pos -self.entPossessor:GetPossessionEyeTrace().HitPos):Angle().p
				tblBullet.Dir = dir
				tblBullet.Spread = Vector(0.02,0.02,0.02)
				tblBullet.Tracer = 1
				if self.WeaponType == 1 then
					tblBullet.TracerName = "effect_fo3_laser"
				end
				tblBullet.Force = 6
				tblBullet.Damage = math.random(2,9)
				tblBullet.Callback = function(entAttacker, tblTr, dmg)
					local entVictim = tblTr.Entity
					local iDmg = dmg:GetDamage()
					if tblTr.HitGroup == 1 then
						iDmg = iDmg *10
					elseif tblTr.HitGroup != 0 then
						iDmg = iDmg *0.25
					end
				end
				self:FireBullets(tblBullet)
				self.ammo = self.ammo -tblBullet.Num
				local sound
				if self.WeaponType == 1 then
					sound = "weapons/gatlinglaser/gatlinglaser_fire3d.wav"
				else
					sound = "weapons/minigun/wpn_minigun_fire_loop.wav"
				end
				self:EmitSound(sound, 100, 100 )
			end
		end
		return true
	end
	if(event == "firemissile") then // ACT_GESTURE_RANGE_ATTACK_ML
		self:SetBodygroup(2,1)
		local att = self:GetAttachment(3)
		if(!att) then return true end
		local pos = att.Pos
		local ent = self.entEnemy
		local posTgt
		if(IsValid(ent)) then posTgt = ent:GetCenter()
		else posTgt = att.Pos +self:GetForward() *100 end
		local dir = (posTgt -pos):GetNormal()
		local ang = dir:Angle()
		local entMissile = ents.Create("obj_rpg")
		entMissile:SetAngles(ang)
		entMissile:SetPos(pos)
		entMissile:SetEntityOwner(self)
		entMissile:Spawn()
		entMissile:Activate()
		local phys = entMissile:GetPhysicsObject()
		if(phys:IsValid()) then
			phys:SetVelocity(ang:Forward() *400)
		end
		return true
	end
	if(event == "missile") then // ACT_ARM
		self:EmitSound("npc/sentrybot/sentrybot_equipgatling.mp3",75,100)
		return true
	end
	if(event == "disarm") then // ACT_GESTURE_RANGE_ATTACK_ML
		self:SetBodygroup(2,0)
		self:EmitSound("npc/sentrybot/sentrybot_equipgatling.mp3",75,100)
		return true
	end
	if(event == "disarmed") then // ACT_DISARM
		return true
	end
	if(event == "spin") then
		self:EmitSound("weapons/minigun/wpn_minigun_spinup.wav",70,100)
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
	local act = self:GetActivity()
	if(act == ACT_WALK || act == ACT_RUN) then self:RestartGesture(ACT_RANGE_ATTACK1); fcDone(true) return end
	-- self:SLVPlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
	-- fcDone(true)
	return
end

-- function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	-- if CurTime() >= self.nextSpitAttack then
		-- local act = self:GetActivity()
		-- if(act == ACT_WALK || act == ACT_RUN) then self:RestartGesture(ACT_GESTURE_RANGE_ATTACK_ML); fcDone(true) return end
		-- self:SLVPlayActivity(ACT_ARM,false,fcDone)
		-- self.nextSpitAttack = CurTime() +2
		-- fcDone(true)
		-- return
	-- end
-- end

local schdFaceEnemy = ai_schedule_slv.New("Face Enemy")
schdFaceEnemy:EngTask("TASK_FACE_TARGET")
ENT.backAway = false
function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if self:CanSee(enemy) then
			-- if dist <= 50 then self.backAway = true end
			-- if self.backAway then
				-- if dist >= 200 then
					-- self.backAway = false
				-- else
					-- local pos = self:GetPos() +(self:GetPos() -enemy:GetPos()):GetNormal() *120
					-- self:GoToPos(pos)
					-- return
				-- end
			-- end
			if self.ammo >= 1 then
				if dist <= self.fRangeDistance && !self:GunTraceBlocked() then
					if self.canattack == true then return end
					self:RestartGesture(ACT_RANGE_ATTACK1)
				end
			else
				-- self:RestartGesture(ACT_DISARM)
				self:AddGesture(ACT_DISARM)
				timer.Simple(0.5,function() if IsValid(self) then self.ammo = 200 end end)
			end
			if(CurTime() >= self.nextSpitAttack && dist <= self.fRangeRocketDistance) then
				-- self:StopMoving()
				self.canattack = true
				self:ChaseEnemy()
				self.nextSpitAttack = CurTime() +math.Rand(9,30)
				-- self:RestartGesture(ACT_GESTURE_RANGE_ATTACK_ML)
				self:AddGesture(ACT_GESTURE_RANGE_ATTACK_ML)
				-- self:SLVPlayNPCGesture("2hlattackleft",2,1)
				timer.Simple(0.7,function() if IsValid(self) then self.canattack = false end end)
				-- return
			end
		end
		if dist > 400 then
			self:ChaseEnemy()
		elseif dist <= 400 && self:CanSee(enemy) && !self:GunTraceBlocked() then
			self:StopMoving()
			self:SetTarget(enemy)
			self:StartSchedule(schdFaceEnemy)
		end
	elseif(disp == D_FR) then
		self:Hide()
	end
end