AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_BOS,CLASS_PLAYER_ALLY)
end
ENT.BoneRagdollMain = "Bip01 Spine"
ENT.sModel = "models/fallout/libertyprime.mdl"
ENT.fMeleeDistance	= 120
ENT.fRangeDistance	= 4000
ENT.m_fFollowDistanceDefensiveAttack = 4000
ENT.fRangeDistanceBomb = 2000
ENT.m_fMaxYawSpeed = 20
ENT.fViewAngle = 320
ENT.idleChance = 22
ENT.skName = "libertyprime"
ENT.bExplodeOnDeath = true
ENT.iBloodType = false
ENT.bFlinchOnDamage = false
ENT.bIgnitable = false
ENT.tblIgnoreDamageTypes = {DMG_DISSOLVE}
ENT.sSoundtrackChance = 10
ENT.sSoundDir = "npc/libertyprime/"
ENT.m_tbSounds = {
	["Attack"] = "genericrobot_attack[1-18].mp3",
	["LPDeath"] = "voc_robotlibertyprime_dlc03_01.mp3",
	["Pain"] = "genericrobot_hit[1-6].mp3"
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(Vector(90, 90, 485), Vector(-90, -90, 0))
	self:slvCapabilitiesAdd(CAP_MOVE_GROUND,CAP_OPEN_DOORS)
	self:slvSetHealth(GetConVarNumber("sk_libertyprime_health"))
	
	self.nextAttackScream = 0
	self.nextBeam = 0
	self.nextThrow = 0
	self:SetSoundLevel(95)
	local cspIdle = CreateSound(self, self.sSoundDir .. "libertyprime_idle_lp.wav")
	cspIdle:SetSoundLevel(95)
	cspIdle:Play()
	self:StopSoundOnDeath(cspIdle)
end

function ENT:InitSandbox()
	if !self:GetSquad() then self:SetSquad(self:GetClass() .. "_sbsquad") end
	if #ents.FindByClass("npc_libertyprime") == 1 && math.random(1,self.sSoundtrackChance) == 1 then
		local cspSoundtrack = CreateSound(self, self.sSoundDir .. "soundtrack.mp3")
		cspSoundtrack:SetSoundLevel(0.2)
		cspSoundtrack:Play()
		self:StopSoundOnDeath(cspSoundtrack)
	end
end

function ENT:SetupRelationship(entTgt)
	local faction = self:SLVGetFaction()
	if(faction == FACTION_NONE) then return end
	if(entTgt:IsPlayer()) then
		local faction = entTgt:SLVGetFaction()
		if(faction != FACTION_NONE && faction != self.Faction) then
			self:slvAddEntityRelationship(entTgt,D_HT,100)
			return true
		end
	end
end

function ENT:_PossJump(entPossessor, fcDone)
	if CurTime() >= self.nextAttackScream then
		local sound = self:slvPlaySound("Attack")
		self.nextAttackScream = CurTime() +10
	end
	fcDone(true)
end

function ENT:Interrupt()
	if self:SLV_IsPossesed() then self:_PossScheduleDone() end
	if self.bInSchedule then
		self.bInSchedule = false
	end
end

function ENT:DoDeath(dmginfo)
	self:SetNPCState(NPC_STATE_DEAD)
	self:SetState(NPC_STATE_DEAD)
	self:SLVPlayActivity(ACT_IDLE);
	self:ScheduleFinished();
	self.nextExp = CurTime() +math.Rand(0,1)
	self.expEnd = CurTime() +math.Rand(4,8)
	self:slvPlaySound("LPDeath");
end

function ENT:FaceEnemy()
	-- self:SetAngles(Angle(0,(self.entEnemy:GetPos() -self:GetPos()):Angle().y,0))
	
end

function ENT:OnThink()
	-- print(GetConVarNumber("sk_libertyprime_dmg_foot"))
	if(self.bDead) then
		if(CurTime() >= self.expEnd) then
			local exps = {}
			for i = 0, self:GetBoneCount() -1 do
				local bonepos, boneang = self:GetBonePosition(i)
				local flDistMin = math.huge
				for k, v in pairs(exps) do
					if i != k then
						local flDist = bonepos:Distance(self:GetBonePosition(k))
						if flDist < flDistMin then flDistMin = flDist end
					end
				end
				if flDistMin > 80 then
					util.CreateExplosion(bonepos,nil,nil,self);
					exps[i] = bonepos
				end
			end
			self:Remove()
		elseif(CurTime() >= self.nextExp) then
			local pos = self:GetBonePosition(math.random(0,self:GetBoneCount() -1));
			util.CreateExplosion(pos,nil,nil,self);
			local tm = math.Rand(0.3,1.75) *math.Min(((self.expEnd -CurTime()) /6),0.25)
			self.nextExp = CurTime() +tm;
		end
		return
	end
	self:UpdateLastEnemyPositions()
	local pp_pitch = self:GetPoseParameter("aim_pitch")
	local pitch = 0
	if IsValid(self.entEnemy) then
		local att = self:GetAttachment(self:LookupAttachment("eye"))
		local fDist = self:OBBDistance(self.entEnemy)
		local bPos = att.Pos

		local _ang = att.Ang
		local ang = (self.entEnemy:GetCenter() -bPos):Angle() -_ang
		pitch = pp_pitch +math.NormalizeAngle(ang.p)
		
		if CurTime() >= self.nextAttackScream then
			if math.random(1,2) == 1 then
				local sound = self:slvPlaySound("Attack")
				self.nextAttackScream = CurTime() +8 +math.Rand(3,8)
			else self.nextAttackScream = CurTime() +math.Rand(3,8) end
		end
		
		if CurTime() >= self.nextBeam then
			self.nextBeam = CurTime() +0.35
			if !self.bInAttack && !self.bInSchedule && fDist <= self.fRangeDistance && fDist > 130 && self:Visible(self.entEnemy) then
				local ang = self:GetAngleToPos(self.entEnemy:GetPos())
				if (ang.y <= 45 || ang.y >= 315) && (ang.p <= 45 || ang.p >= 315) && !self:GunTraceBlocked() then
					self:FireBeam()
				else
					-- self:FaceEnemy()
					self:TurnToEnemy(self.entEnemy)
				end
			end
		end
	elseif self:SLV_IsPossesed() then
		local att = self:GetAttachment(self:LookupAttachment("eye"))
		local bPos = att.Pos
		local tr = self:GetPossessor():GetPossessionEyeTrace()
		
		local _ang = att.Ang
		local ang = (tr.HitPos -bPos):Angle() -_ang
		pitch = pp_pitch +math.NormalizeAngle(ang.p)
	end
	pp_pitch = math.ApproachAngle(pp_pitch, pitch, 3)
	self:SetPoseParameter("aim_pitch", pp_pitch)
	
	self:NextThink(CurTime())
	return true
end

function ENT:GunTraceBlocked()
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("eye")).Pos
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:EventHandle(...)
	local event = select(1,...)
	local subevent = select(2,...)
	-- print(event,subevent)
	if(event == "mattack") then
		local iAtt = self:LookupAttachment("rfoot")
		local att = self:GetAttachment(iAtt)
		-- WorldSound(self.sSoundDir .. "foot/libertyprime_foot_r_near.mp3", att.Pos, 100, 100)
		-- self:CreateSound(self.sSoundDir .. "foot/libertyprime_foot_r_near.mp3")
		sound.Play(self.sSoundDir .. "foot/libertyprime_foot_r_near.mp3",self:GetPos(),100,100)
		util.ScreenShake(att.Pos, 100, 100, 0.5, 1500)
		-- self:DealMeleeDamage(dist,dmg,ang,force,nil,nil,true)
		self:DealMeleeDamage(280,GetConVarNumber("sk_libertyprime_dmg_foot"),Angle(0,0,0),Vector(360,0,0),nil,nil,true)
		local tr = util.TraceLine({start = att.Pos +Vector(0,0,20), endpos = att.Pos -Vector(0,0,30), filter = self})
		if tr.MatType == 68 || tr.MatType == 78 then
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetScale(460)
			util.Effect("ThumperDust", effectdata) 
		end
		return true
	end
	if(event == "lfoot") then
		local iAtt = self:LookupAttachment("lfoot")
		local att = self:GetAttachment(iAtt)
		util.ScreenShake(att.Pos, 100, 100, 0.5, 1500)
		sound.Play(self.sSoundDir .. "foot/libertyprime_foot_l_near.mp3",self:GetPos(),100,100)
		self:DealMeleeDamage(80,GetConVarNumber("sk_libertyprime_dmg_foot"),Angle(0,0,0),Vector(360,0,0),nil,nil,true)
		local tr = util.TraceLine({start = att.Pos +Vector(0,0,20), endpos = att.Pos -Vector(0,0,30), filter = self})
		if tr.MatType == 68 || tr.MatType == 78 then
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetScale(460)
			util.Effect("ThumperDust", effectdata) 
		end
		if(subevent == "trans") then
			sound.Play("npc/libertyprime/foot/libertyprime_foot_l_trans.mp3",self:GetPos(),100,100)
			return true
		end
		return true
	end
	if(event == "rfoot") then
		local iAtt = self:LookupAttachment("rfoot")
		local att = self:GetAttachment(iAtt)
		util.ScreenShake(att.Pos, 100, 100, 0.5, 1500)
		sound.Play(self.sSoundDir .. "foot/libertyprime_foot_r_near.mp3",self:GetPos(),100,100)
		self:DealMeleeDamage(80,GetConVarNumber("sk_libertyprime_dmg_foot"),Angle(0,0,0),Vector(360,0,0),nil,nil,true)
		local tr = util.TraceLine({start = att.Pos +Vector(0,0,20), endpos = att.Pos -Vector(0,0,30), filter = self})
		if tr.MatType == 68 || tr.MatType == 78 then
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetScale(460)
			util.Effect("ThumperDust", effectdata) 
		end
		if(subevent == "trans") then
			sound.Play("npc/libertyprime/foot/libertyprime_foot_r_trans.mp3",self:GetPos(),100,100)
			return true
		end
		return true
	end
	if(event == "rattack") then
		if(subevent == "range") then
			self:SLVPlayActivity(ACT_RANGE_ATTACK1,true)
			return true
		end
		if(subevent == "throw") then
			local pos = self:GetBonePosition(self:LookupBone("Bip01 R Hand"))
			local posTarget
			if self:SLV_IsPossesed() then
				local tr = self:GetPossessor():GetPossessionEyeTrace()
				local _pos = tr.HitPos
				if pos:Distance(tr.HitPos) > 1800 then _pos = pos +(tr.HitPos -pos):GetNormal() *1800 end
				posTarget = _pos
			else posTarget = IsValid(self.entEnemy) && self.entEnemy:GetCenter() || self:GetLastEnemyPosition() || self:GetPos() +self:GetForward() *1000 end
			local att = self:GetAttachment(self:LookupAttachment("bomb"))
			local pos = att.Pos -self:GetForward() *300 +self:GetUp() *140 +self:GetRight() *220
			local entNuke = ents.Create("obj_prime_mininuke")
			entNuke:SetEntityOwner(self)
			entNuke:Spawn()
			entNuke:Activate()
			entNuke:SetPos(pos)
			entNuke:SetAngles(self:GetAngles() +Angle(30,0,0))
			local phys = entNuke:GetPhysicsObject()
			if IsValid(phys) then
				local distZ = pos.z -posTarget.z
				pos.z = 0
				posTarget.z = 0
				local dist = pos:Distance(posTarget)
				
				phys:SetVelocity(self:GetForward() *3000 -self:GetUp() *(2000 -dist *1.2 +distZ *1.3) -self:GetRight() *((2000 -dist) *0.65))
			end
			return true
		end
		if(subevent == "unequip") then
			self:SLVPlayActivity(ACT_DISARM, true, self:SLV_IsPossesed() && self._PossScheduleDone || nil, true)
			self:SetBodygroup(1,0)
			return true
		end
		if(subevent == "unequipped") then
			self.nextThrow = CurTime() +math.Rand(6,12)
			-- self:SetBodygroup(2,0)
			self:SetBodygroup(1,0)
			self.bInSchedule = false
			return true
		end
		return true
	end
	if(event == "takebomb") then
		-- self:SetBodygroup(2,1)
		self:SetBodygroup(1,1)
		-- timer.Simple(2.2,function() if IsValid(self) then self:SetBodygroup(1,0) end end)
		return true
	end
end

function ENT:FireBeam()
	local att = self:GetAttachment(self:LookupAttachment("eye"))
	local posTgt = self:SLV_IsPossesed() && self:GetPossessor():GetPossessionEyeTrace().HitPos || self.entEnemy:GetHeadPos()
	local dir = self:GetConstrictedDirection(att.Pos, 45, 45, posTgt) +Vector(math.Rand(-0.014,0.014),math.Rand(-0.014,0.014),math.Rand(-0.012,0.012))
	local tr = util.TraceLine({start = att.Pos, endpos = att.Pos +dir *32768, filter = self})
	util.BlastDamage(self, self, tr.HitPos, 20, GetConVarNumber("sk_libertyprime_dmg_laser"))
	self:EmitSound(self.sSoundDir .. "libertyprime_laser_fire.mp3", 100, 100)
	
	local entBeam = ents.Create("obj_beam_laser_prime")
	entBeam:SetDestination(tr.HitPos)
	entBeam:SetOwner(self)
	entBeam:Spawn()
	entBeam:Activate()
	
	self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if disp == D_HT then
		if self:CanSee(enemy) then
			local bThrow = CurTime() >= self.nextThrow && dist <= self.fRangeDistanceBomb && dist >= 350
			if bThrow then
				local ang = self:GetAngleToPos(enemy:GetPos(),self:GetAngles())
				if (ang.y <= 45 || ang.y >= 315) && (ang.p <= 45 || ang.p >= 315) then
					self.nextThrow = CurTime() +math.Rand(6,12)
					local numEnemies = self:GetEnemyCount();
					local r = math.Max(30 -(numEnemies *2),20)
					if(enemy:Health() >= 500) then r = r -10 end;
					if math.random(1,r) <= 10 then
						self:EmitSound(self.sSoundDir .. "libertyprime_bomb_equip.mp3", 100, 100)
						self:SLVPlayActivity(ACT_ARM, true)
						self.bInSchedule = true
						return
					end
				end
			end
			local bMelee = dist <= self.fMeleeDistance
			if bMelee then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1, true)
				self.bInAttack = true
				return
			elseif self.bInAttack then self.bInAttack = false end
			if dist <= 1000 && dist > 380 then
				local ang = self:GetAngleToPos(enemy:GetPos(),self:GetAngles())
				if (ang.y <= 45 || ang.y >= 315) && (ang.p <= 45 || ang.p >= 315) && !self:GunTraceBlocked() && self:Visible(self.entEnemy) then
					self:ChaseEnemy()
					return
				end
			end
		end
		self:ChaseEnemy()
	elseif disp == D_FR then
		self:Hide()
	end
end