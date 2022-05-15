AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_SUPERMUTANT,CLASS_MUTANT)
end
util.AddNPCClassAlly(CLASS_MUTANT,"npc_centaur")
ENT.sModel = "models/fallout/centaur.mdl"
ENT.fMeleeDistance = 64
ENT.fMeleeForwardDistance = 250
ENT.possOffset = Vector(-30,0,50)
ENT.fRangeDistance = 500
ENT.bFlinchOnDamage = false
ENT.m_bForceDeathAnim = true
ENT.UseActivityTranslator = false
ENT.CanSpit = true
ENT.m_bAttackPoison = true
ENT.BoneRagdollMain = "NPC Root [Root ]"
ENT.skName = "centaur"
ENT.CollisionBounds = Vector(45,45,64)

ENT.DamageScales = {
	[DMG_PARALYZE] = 0,
	[DMG_NERVEGAS] = 0,
	[DMG_POISON] = 0
}

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/centaur/"

ENT.m_tbSounds = {
	["Attack"] = "centaur_attack_0[1-3].mp3",
	["Idle"] = "centaur_idle_scan.mp3",
	["Death"] = "centaur_death_0[1-2].mp3",
	["Pain"] = "centaur_injured_0[1-2].mp3",
	["Foot"] = "foot/centaur_foot_0[1-6].mp3"
}

function ENT:OnInit()
	self:SetHullType(HULL_WIDE_SHORT)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self.m_tNextRangeAttack = 0
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local skDmg = 16
		local force
		local ang
		local atk = select(2,...)
		if(atk == "left") then
			force = Vector(50,0,0)
			ang = Angle(0,50,0)
		elseif(atk == "leftpower") then
			force = Vector(50,0,0)
			ang = Angle(0,80,0)
		elseif(atk == "right") then
			force = Vector(50,0,0)
			ang = Angle(0,-50,0)
		elseif(atk == "rightpower") then
			force = Vector(180,0,20)
			ang = Angle(0,-80,0)
		end
		local bHit = self:DealMeleeDamage(dist,skDmg,ang,force,DMG_SLASH,nil,true,nil,function(ent,dmgInfo)
			if(self.m_bAttackPoison && ent:IsPlayer()) then
				if(ent.AddEffect) then ent:AddEffect("AnimalPoison",true,0.35,10,3,self) end
			end
		end)
		return true
	end
	if(event == "rattack") then
		local att = self:GetAttachment(self:LookupAttachment("mouth"))
		if(!att) then return true end
		local vTarget
		if(self:SLV_IsPossesed()) then
			vTarget = self:GetPossessor():GetPossessionEyeTrace().HitPos
			local dir = (vTarget -att.Pos):GetNormal()
			vTarget = att.Pos +dir *math.min(att.Pos:Distance(vTarget),1000)
		else vTarget = self:GetPredictedEnemyPosition(0.8) || (att.Pos +self:GetForward() *500) end
		local entSpit = ents.Create("obj_spit")
		entSpit:SetPos(att.Pos)
		entSpit:SetEntityOwner(self)
		entSpit:SetDamage(23)
		entSpit.OnHit = function(entSpit,ent,dist)
			if(ent:IsPlayer()) then if(ent.AddEffect) then ent:AddEffect("AnimalPoison",true,0.2,24,2,self) end end
		end
		entSpit:Spawn()
		entSpit:Activate()
		local eta = entSpit:SetArcVelocity(att.Pos,vTarget,600,self:GetForward(),0.65,VectorRand() *0.0125)
		return true
	end
end

function ENT:AttackMelee(ent)
	self:SetTarget(ent)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,2)
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	self:SLVPlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	-- self:SLVPlayActivity(ACT_GESTURE_RANGE_ATTACK1,false,fcDone)
	self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
	fcDone(true)
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(ACT_MELEE_ATTACK1,true)
				return
			end
			if(self.CanSpit && CurTime() >= self.m_tNextRangeAttack && dist <= self.fRangeDistance) then
				self.m_tNextRangeAttack = CurTime() +math.Rand(3,10)
				-- if(math.random(1,2) == 1) then
					-- self:SLVPlayActivity(ACT_GESTURE_RANGE_ATTACK1,true)
					self:RestartGesture(ACT_GESTURE_RANGE_ATTACK1)
					return
				-- end
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end