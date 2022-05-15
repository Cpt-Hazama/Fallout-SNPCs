AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_ANT,CLASS_GIANTANT)
end
ENT.sModel = "models/fallout/giantant.mdl"
ENT.fMeleeDistance = 50
ENT.fRangeDistance = 180
ENT.bFlinchOnDamage = false
ENT.m_bForceDeathAnim = false
ENT.UseActivityTranslator = false
ENT.CanUseFire = false
ENT.BoneRagdollMain = "NPC Root [Root]"
ENT.skName = "giantant"
ENT.CollisionBounds = Vector(45,45,50)

ENT.DamageScales = {
	[DMG_PARALYZE] = 0,
	[DMG_NERVEGAS] = 0,
	[DMG_POISON] = 0
}

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/giantant/"

ENT.m_tbSounds = {
	["Attack"] = "ant_attack0[1-3].mp3",
	["Idle"] = "ant_idle0[1-3].mp3",
	["Death"] = "ant_death_0[1-2].mp3",
	["Pain"] = "ant_injured_0[1-4].mp3",
	["FootLeft"] = "foot/ant_foot_l0[1-2].mp3",
	["FootRight"] = "foot/ant_foot_r0[1-2].mp3"
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.m_tNextFireAttack = 0
	self.m_particleFlame = nil
	self.nextposfiret = 0
	self:SubInit()
end

function ENT:SubInit()
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:EventHandle(...)
	local event = select(1,...)
	local subevent = select(2,...)
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local skDmg = GetConVarNumber("sk_giantant_dmg_slash")
		local force
		local ang
		local atk = select(2,...)
		if(atk == "forward") then
			force = Vector(0,0,0)
			ang = Angle(0,0,0)
		elseif(atk == "left") then // right // righthead
			force = Vector(0,0,0)
			ang = Angle(0,0,0)
		elseif(atk == "lefthead") then
			force = Vector(0,0,0)
			ang = Angle(0,-0,0)
		elseif(atk == "right") then
			force = Vector(0,0,0)
			ang = Angle(0,-0,0)
		elseif(atk == "righthead") then
			force = Vector(0,0,0)
			ang = Angle(0,-0,0)
		elseif(atk == "power") then
			force = Vector(0,0,20)
			ang = Angle(0,-0,0)
		end
		local bHit = self:DealMeleeDamage(dist,skDmg,ang,force,DMG_SLASH,nil,true,nil,fcHit)
		return true
	end
	if(event == "rattack") then
		if(subevent == "start") then
			self.cspLoop = CreateSound(self,self.sSoundDir .. "flamerant_fire_lp.wav")
			self.cspLoop:Play()
			self:StopSoundOnDeath(self.cspLoop)
			local att = self:GetAttachment(self:LookupAttachment("mouth"))
			self.m_particleFlame = util.ParticleEffect("flame_gargantua",att.Pos,att.Ang,self,"mouth",false)
			self:DeleteOnDeath(self.m_particleFlame)
			return true
		elseif(subevent == "flame") then
			self.cspLoop = CreateSound(self,self.sSoundDir .. "flamerant_fire_lp.wav")
			self.cspLoop:Play()
			self:StopSoundOnDeath(self.cspLoop)
			local att = self:GetAttachment(self:LookupAttachment("mouth"))
			-- self.m_particleFlame = util.ParticleEffect("flame_gargantua",att.Pos,att.Ang,self,"mouth",false)
			local ent = ents.Create("info_particle_system")
			ent:SetKeyValue("effect_name","flame_gargantua")
			ent:SetKeyValue("start_active","1")
			ent:SetPos(self:GetPos())
			ent:SetParent(self)
			ent:Spawn()
			ent:Activate()
			ent:Fire("SetParentAttachment","mouth",0)
			ent:Fire( "Start", "", 0 )
			ent:Fire( "Kill", "", 0.5 )
			self:DeleteOnRemove(ent)
			-- self:DeleteOnDeath(self.m_particleFlame)
			self:DealFlameDamage(200)
			return true
		elseif(subevent == "end") then
			self:EndRangeAttack()
			return true
		else
			self:EndRangeAttack()
			return true
		end
	end
end

function ENT:LegsCrippled()
	return self:LimbCrippled(HITBOX_LEFTLEG) || self:LimbCrippled(HITBOX_RIGHTLEG)
end

function ENT:Interrupt()
	if(!self.m_rangeAttack) then return end
	self:EndRangeAttack()
end

function ENT:EndRangeAttack()
	if(IsValid(self.m_particleFlame)) then
		-- self.m_particleFlame:Stop()
		self.m_particleFlame:Remove()
		self.m_particleFlame = nil
	end
	if(self.cspLoop) then
		local snd = "flamerant_fire_end.wav"
		self:EmitSound(self.sSoundDir .. snd,75,100)
		util.StopSound(self.cspLoop)
		self.cspLoop = nil
	end
	self:StopParticles()
	self.m_rangeAttack = nil
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,true,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	if(self.CanUseFire == true && CurTime() > self.nextposfiret) then
		self:Interrupt()
		self:SLVPlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
			timer.Simple(0.6,function() if IsValid(self) then self:EndRangeAttack() end end)
		-- self:RestartGesture(ACT_RANGE_ATTACK1)
		-- fcDone(true)
		self.nextposfiret = CurTime() +1
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
			if(self.CanUseFire == true && CurTime() >= self.m_tNextFireAttack && dist <= self.fRangeDistance) then
				if(math.random(1,3) == 1) then
					self:SLVPlayActivity(ACT_RANGE_ATTACK1,true)
					self.m_tNextFireAttack = CurTime() +math.Rand(5,7)
					timer.Simple(0.6,function() if IsValid(self) then self:EndRangeAttack() end end)
					return
				end
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end